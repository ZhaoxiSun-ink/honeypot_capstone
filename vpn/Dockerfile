FROM kylemanna/openvpn
COPY start_vpn.sh /
RUN chmod +x start_vpn.sh
RUN apk update --no-cache
#RUN apk add --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community/ --allow-untrusted --no-cache systemd
RUN apk add rsyslog --no-cache
EXPOSE 1194

