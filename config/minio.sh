#!/bin/bash

# Unfortunately this causes DNS lookup errors on the web console login as the
# authentication request is proxied by the web console server. The Go runtime
# seems to resolve DNS not by NSS, so mDNS does not transparently work. But on
# the other hand, enabling this, results in a more convenient startup output.
# export MINIO_SERVER_URL="http://${MDNS_HOSTNAME}"

export MINIO_BROWSER_REDIRECT_URL="http://${MDNS_HOSTNAME}:9090"

# Start minio directly, bypassing the base image entrypoint. The entrypoint
# drops the privileges to its own minio user, pins the data directory to
# /data and runs its own bucket bootstrap, which we do via minio-manage.sh.
exec /opt/bitnami/minio/bin/minio server \
  --console-address ':9090' \
  ${MDNS_HOSTNAME}/data
