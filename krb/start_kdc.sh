#!/bin/bash
mkdir -p /var/lib/krb5kdc/
mkdir -p /etc/krb5kdc
# Replace 'user', 'EXAMPLE.COM', and 'password' with appropriate values
kdb5_util create -s -r EXAMPLE.COM -P password
kadmin.local -q "addprinc -pw password user@EXAMPLE.COM"
kadmin.local -q "addprinc -randkey HTTP/172.30.0.5@EXAMPLE.COM"
kadmin.local -q "ktadd -k /etc/krb5.keytab HTTP/172.30.0.5@EXAMPLE.COM"

krb5kdc
kadmind
systemctl restart krb5-kdc krb5-admin-server

tail -f /dev/null
