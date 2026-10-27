FROM bitnamilegacy/minio:2023.1.25-debian-11-r2
LABEL org.opencontainers.image.authors="containers@hausgold.de"

# You can change this environment variable on run's with -e
ENV MDNS_HOSTNAME=minio.local

# Keep the settings low for default
ENV MINIO_ROOT_USER='minioadmin'
ENV MINIO_ROOT_PASSWORD='minioadmin'

# The mDNS stack (dbus, avahi) and haproxy require root privileges, so we
# drop the unprivileged user of the base image
USER root

# Install the archived Debian 11 (bullseye) package repositories, as the
# regular mirrors no longer serve the package pools of this release
COPY config/sources.list /etc/apt/sources.list

# Install system packages
RUN apt-get update -yqqq && \
  apt-get install -y --no-install-recommends \
    hostname dbus avahi-daemon avahi-utils libnss-mdns haproxy supervisor && \
  rm -rf /var/lib/apt/lists/*

# Copy custom scripts
COPY config/*.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/*

# Configure haproxy
COPY config/haproxy.conf /etc/haproxy/haproxy.cfg

# Configure supervisord
COPY config/supervisor/* /etc/supervisor/conf.d/

# Clear the default entrypoint, as it is the MinIO setup wrapper of the base
# image which we do not use (see config/minio.sh)
ENTRYPOINT []

# Define the command to run per default
CMD ["/usr/bin/supervisord", "-nc", "/etc/supervisor/supervisord.conf"]
