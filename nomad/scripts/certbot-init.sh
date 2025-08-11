#!/bin/sh

set -e

DOMAIN=$1

if [ -z "$DOMAIN" ]; then
    echo Usage: $0 domain.tld
    exit 1
fi

openssl req \
        -nodes \
        -x509 \
        -sha256 \
        -newkey rsa:4096 \
        -keyout /tmp/${DOMAIN}.key \
        -out /tmp/${DOMAIN}.crt \
        -days 365 \        -subj "/C=US/ST=Virginia/L=Fredericksburg/O=Hardwood Cloud/CN=${DOMAIN}" \        -addext "subjectAltName=DNS:*.${DOMAIN}"

KEY_ONELINE=$(cat /tmp/${DOMAIN}.key | tr '\n' '\r' | sed 's/\r/\\n/g')
CERTIFICATE_ONELINE=$(cat /tmp/${DOMAIN}.crt | tr '\n' '\r' | sed 's/\r/\\n/g')

cat <<EOF > /tmp/${DOMAIN}.hcl
path = "certs/traefik"

items {
  KEY = "$KEY_ONELINE"
  CERTIFICATE = "$CERTIFICATE_ONELINE"
}
EOF

nomad var put -in hcl @/tmp/${DOMAIN}.hcl
