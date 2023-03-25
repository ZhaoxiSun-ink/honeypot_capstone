# Kerberos server (KDC)
FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y krb5-kdc krb5-admin-server systemctl

COPY kdc.conf /etc/krb5kdc/kdc.conf
COPY kadm5.acl /etc/krb5kdc/kadm5.acl
COPY krb5.conf /etc/krb5.conf
COPY common/ /etc
RUN mkdir -p /var/log/kerberos
COPY start_kdc.sh /start_kdc.sh
RUN chmod +x /start_kdc.sh

EXPOSE 88 749

#CMD ["sh", "-c","/start_kdc.sh & systemctl restart krb5-kdc krb5-admin-server"]
