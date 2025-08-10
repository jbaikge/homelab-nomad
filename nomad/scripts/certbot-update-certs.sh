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
DOMAIN_PATH="$LIVE_PATH/$DOMAIN"
KEY_PATH="$DOMAIN_PATH/privkey.pem"
CERTIFICATE_PATH="$DOMAIN_PATH/fullchain.pem"

if [ ! -d "$DOMAIN_PATH" ]; then
    echo $DOMAIN_PATH does not exist
    exit 1
fi

if [ ! -f "$KEY_PATH" ]; then
    echo $KEY_PATH does not exist
    exit 1
fi

if [ ! -f "$CERTIFICATE_PATH" ]; then
    echo $CERTIFICATE_PATH does not exist
    exit 1
fi

KEY=$(cat "$KEY_PATH")
CERTIFICATE=$(cat "$CERTIFICATE_PATH")

nomad var put -force certs/$DOMAIN \
    CERT_KEY="$KEY" \
    CERT_CERTIFICATE="$CERTIFICATE"

echo Updated $DOMAIN certificates
