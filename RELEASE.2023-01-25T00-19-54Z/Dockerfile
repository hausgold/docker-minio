FROM minio/minio:RELEASE.2023-01-25T00-19-54Z
LABEL org.opencontainers.image.authors="containers@hausgold.de"

# You can change this environment variable on run's with -e
ENV MDNS_HOSTNAME=minio.local

# Keep the settings low for default
ENV MINIO_ROOT_USER='minioadmin'
ENV MINIO_ROOT_PASSWORD='minioadmin'

# Install the CentOS 8 BaseOS and OKay's Additional RPM
# repositories for avahi/avahi-tools
COPY config/extra.repo /etc/yum.repos.d/extra.repo

# Install system packages
RUN microdnf install \
  hostname dbus avahi nss-mdns haproxy supervisor && \
  microdnf clean all && \
  curl https://dl.min.io/client/mc/release/linux-amd64/mc \
    --create-dirs -o /usr/local/bin/mc

# Copy custom scripts
COPY config/*.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/*

# Configure haproxy
COPY config/haproxy.conf /etc/haproxy/haproxy.cfg

# Configure supervisord
COPY config/supervisor/* /etc/supervisord.d/

# Clear the default entrypoint, as it is the mc command
ENTRYPOINT []

# Define the command to run per default
CMD ["/usr/bin/supervisord", "-nc", "/etc/supervisord.conf"]
