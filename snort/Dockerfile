FROM linton/docker-snort
RUN apt update && apt install -y rsyslog
COPY local.rules /etc/snort/rules/local.rules
COPY start_snort.sh /
CMD ["snort", "-i", "eth0", "-c", "/etc/snort/etc/snort.conf", "-A", "console"]
#build docker image
#docker build -t test_snort .
#run it
#docker run --net=host my_snort_image
