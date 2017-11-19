#!/bin/bash

set -e

echo ">> DOCKER-ENTRYPOINT: GENERATING SSL CERT";

cd /opt/ssl/;
openssl genrsa -des3 -passout pass:x -out server.pass.key 4096;
openssl rsa -passin pass:x -in server.pass.key -out server.key;
rm server.pass.key;
openssl req -new -key server.key -out server.csr -subj "/C=IN/ST=TamilNadu/L=Chennai/O=service.appname.io/OU=service.appname.io/CN=localhost";
openssl x509 -req -sha256 -days 3650 -in server.csr -signkey server.key -out server.crt;

# Changing back to working directory
cd /tmp;

echo ">> DOCKER-ENTRYPOINT: GENERATING SSL CERT ... DONE";
echo ">> DOCKER-ENTRYPOINT: EXECUTING CMD";

exec "$@"
