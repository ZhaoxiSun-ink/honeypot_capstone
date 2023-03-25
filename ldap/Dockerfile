# Use the osixia/openldap image as the base
FROM osixia/openldap:1.5.0
RUN apt update
RUN apt install -y rsyslog
COPY add_user.ldif .
COPY create_parent.ldif .
COPY start_ldap.sh /
RUN apt-get update
RUN apt-get install net-tools
COPY process.sh /container/service/slapd/process.sh
# Set environment variables for LDAP configuration
ENV LDAP_ORGANISATION="Your Organisation" \
    LDAP_DOMAIN="example.com" \
    LDAP_BASE_DN="dc=example,dc=com" \
    LDAP_ADMIN_PASSWORD="admin_password" \
    LDAP_CONFIG_PASSWORD="config_password" \
    LDAP_READONLY_USER="false"

# Expose LDAP and LDAPS ports
EXPOSE 389 636

# Add your custom LDAP schema and data here
# COPY your-custom-ldif-file.ldif /container/service/slapd/assets/config/bootstrap/ldif/custom/
