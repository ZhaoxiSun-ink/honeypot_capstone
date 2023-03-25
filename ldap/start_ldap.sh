#!/bin/bash
# Start the LDAP server in the background
/usr/sbin/slapd -h "ldap:/// ldaps:///" -g openldap -u openldap -F /etc/ldap/slapd.d &

# Wait for the LDAP server to start up and listen on the appropriate ports
while ! netstat -tln | grep -q -E '(^| )389($| )'; do
  sleep 1
done

ldapadd -x -D "cn=admin,dc=example,dc=com" -w admin_password -H ldap://172.30.0.3 -f create_parent.ldif
ldapadd -x -D "cn=admin,dc=example,dc=com" -w admin_password -H ldap://172.30.0.3 -f add_user.ldif
