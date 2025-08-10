#!/bin/sh

set -e

if [ -z "$DOMAIN" ]; then
    echo DOMAIN environment variable not set
    exit 1
fi

if [ -z "$NOMAD_TOKEN" ]; then
    echo NOMAD_TOKEN environment variable not set
    exit 1
fi

if [ -z "$NOMAD_ADDR" ]; then
    echo NOMAD_ADDR environment variable not set
    exit 1
fi

LIVE_PATH=/etc/letsencrypt/live
KEY=$(cat "$LIVE_PATH/$DOMAIN/privkey.pem")
CERTIFICATE=$(cat "$LIVE_PATH/$DOMAIN/fullchain.pem")

echo "Updating certificates in Nomad variables"

nomad var put -force certs/$DOMAIN \
    CERT_KEY="$KEY" \
    CERT_CERTIFICATE="$CERTIFICATE"

echo "Updated"
