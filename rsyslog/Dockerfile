# Use the official Ubuntu image as a base
FROM ubuntu:latest

# Update package list and install rsyslog
RUN apt-get update && apt-get install -y rsyslog

# Copy the custom rsyslog configuration file
COPY rsyslog.conf /etc/rsyslog.conf

# Expose the syslog port
EXPOSE 514/tcp
EXPOSE 514/udp

# Start rsyslog in the foreground
CMD ["rsyslogd", "-n"]
