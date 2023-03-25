#!/bin/sh
#tail -f /dev/null
OVPN_DATA="ovpn-data-example"
echo "coucou"
if [ ! -d "/etc/openvpn/ovpn-data-example" ]; then
  echo "Setting up OpenVPN server configuration..."
  ovpn_genconfig -u udp://VPN.SERVERNAME.COM
  echo "Initializing OpenVPN server PKI..."
  echo -e "password\npassword\nyes" | ovpn_initpki nopass
  echo "Generating client certificate..."
  printf "password\npassword\n" | easyrsa --batch build-client-full CLIENTNAME3 nopass
  echo "Exporting client configuration..."
  ovpn_getclient CLIENTNAME3 > CLIENTNAME3.ovpn
fi

echo "Starting OpenVPN server..."
exec ovpn_run
echo "fini"
iptables -t nat -A POSTROUTING -o tun0 -j MASQUERADE
iptables -A FORWARD -i tun0 -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth0 -o tun0 -j ACCEPT

rsyslogd -n
tail -f /dev/null
