# Use Ubuntu as the base image
FROM ubuntu:20.04

# Set environment variables
ENV DEBIAN_FRONTEND noninteractive

# Install required packages
RUN apt-get update && \
    apt-get install -y openssh-server ldap-utils libnss-ldap libpam-ldap nscd rsyslog && \
    apt-get clean

# Configure NSS
RUN echo 'passwd:         compat ldap' >> /etc/nsswitch.conf && \
    echo 'group:          compat ldap' >> /etc/nsswitch.conf && \
    echo 'shadow:         compat ldap' >> /etc/nsswitch.conf

# Configure PAM
RUN echo 'auth    sufficient      pam_ldap.so' >> /etc/pam.d/common-auth && \
    echo 'account sufficient      pam_ldap.so' >> /etc/pam.d/common-account && \
    echo 'session required        pam_mkhomedir.so skel=/etc/skel umask=0022' >> /etc/pam.d/common-session
RUN sed -i 's/pam_unix.so obscure sha512/pam_unix.so obscure sha512 use_authtok nullok/' /etc/pam.d/common-password
# Configure OpenSSH server
RUN mkdir /var/run/sshd && \
    sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/#AuthorizedKeysFile/AuthorizedKeysFile/' /etc/ssh/sshd_config && \
    sed -i 's/#LogLevel INFO/LogLevel DEBUG/' /etc/ssh/sshd_config && \
    sed -i 's/#SyslogFacility AUTH/SyslogFacility AUTH/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
#RUN echo "uri ldap://172.30.0.3:389">>/etc/ldap.conf
#RUN echo "binddn ou=users,dc=example,dc=com">> /etc/ldap.conf
#RUN sed -i 's/base dc=example,dc=net/base ou=users,dc=example,dc=com/g' /etc/ldap.conf
#RUN echo "bindpw admin_password" >> /etc/ldap.conf
COPY ldap.conf /etc/ldap.conf
COPY sshd_config /etc/ssh/sshd_config
# Expose SSH port
EXPOSE 22
COPY start_ssh.sh / 
# Start the SSH server
CMD ["/usr/sbin/sshd", "-D"]
