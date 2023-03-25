#!/bin/bash
snort -i br-ede3ee6144db -c /etc/snort/etc/snort.conf -A console &
rsyslogd  -n ||true
