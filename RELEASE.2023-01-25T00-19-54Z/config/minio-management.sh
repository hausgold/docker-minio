#!/bin/bash

# Wait for the MinIO service to be available
code=0
for i in {1..10}; do
  timeout 1 bash -c 'cat </dev/null >/dev/tcp/127.0.0.1/9000' \
    && code=0 || code=$?; [ $code = 0 ] && break || sleep 3
done

if [ $code != 0 ]; then
  echo -en '\e[33;1m[ERROR] MinIO is not running, '
  echo -e 'so we skip further configurations.\e[0m'
  exit 1
fi

# Configure the MinIO client/cli
mc alias set s3 'http://127.0.0.1:9000' \
  "${MINIO_ROOT_USER}" "${MINIO_ROOT_PASSWORD}"





# mc mb --region --region=${BUCKET_REGION} s3/${BUCKET_NAME}


# mc anonymous set download s3/mybucket








