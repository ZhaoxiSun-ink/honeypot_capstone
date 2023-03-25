#!/bin/bash
/usr/sbin/sshd -D &
rm /var/run/rsyslogd*.pid
rsyslogd -i /var/run/rsyslogd.pid -n|| true

