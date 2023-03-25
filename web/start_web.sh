#! /bin/bash
systemctl restart rsyslog
echo "172.30.0.3 kdc.example.com">>/etc/hosts
wget kdc.example.com
npm start
tail -f /dev/null
