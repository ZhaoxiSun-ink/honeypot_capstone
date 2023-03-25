#!/bin/bash -e

# set -x (bash debug) if log level is trace
# https://github.com/osixia/docker-light-baseimage/blob/stable/image/tool/log-helper
log-helper level eq trace && set -x

# Reduce maximum number of number of open file descriptors to 1024
# otherwise slapd consumes two orders of magnitude more of RAM
# see https://github.com/docker/docker/issues/8231
ulimit -n $LDAP_NOFILE

# Call hostname to determine the fully qualified domain name. We want OpenLDAP to listen
# to the named host for the ldap:// and ldaps:// protocols.
FQDN="$(/bin/hostname --fqdn)"
HOST_PARAM="ldap://$FQDN:$LDAP_PORT ldaps://$FQDN:$LDAPS_PORT"
echo "avant"
exec /usr/sbin/slapd -h "$HOST_PARAM ldapi:///" -u openldap -g openldap -d "$LDAP_LOG_LEVEL" &
echo "run"
while ! netstat -tln | grep  '389'; do
  sleep 1
done
echo "port1"
ldapdelete -x -D "cn=admin,dc=example,dc=com" -w admin_password -H ldap://172.30.0.3 ||true
echo "entre1"
ldapdelete -x -D "dc=example,dc=com" -w admin_password -H ldap://172.30.0.3 ||true
echo "port1"
ldapsearch -x -H ldap://172.30.0.3 -b "ou=users,dc=example,dc=com" -D "cn=admin,dc=example,dc=com" -w admin_password ||true
echo "port"
ldapadd -x -D "cn=admin,dc=example,dc=com" -w admin_password -H ldap://172.30.0.3 -f create_parent.ldif ||true
echo "entre"
ldapadd -x -D "cn=admin,dc=example,dc=com" -w admin_password -H ldap://172.30.0.3 -f add_user.ldif ||true
echo "fin"
ldapsearch -x -D "cn=admin,dc=example,dc=com" -w admin_password -H ldap://172.30.0.3 -b "ou=users,dc=example,dc=com" ||true
echo "test1"
ldapsearch -x -H ldap://172.30.0.3 -b "ou=users,dc=example,dc=com" -D "cn=admin,dc=example,dc=com" -w admin_password ||true
echo "test2"

rsyslogd -n
tail -f /dev/null
