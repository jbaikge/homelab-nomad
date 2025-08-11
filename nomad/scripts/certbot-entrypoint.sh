#!/bin/sh

set -e

LIVE_PATH=/etc/letsencrypt/live
DEPLOY_HOOK_PATH=/etc/letsencrypt/renewal-hooks/deploy/update-certs.sh

if [ -z "$DOMAIN" ]; then
    echo DOMAIN environment variable not set
    exit 1
fi

if [ -z "$EMAIL" ]; then
    echo EMAIL environment variable not set
    exit 1
fi

if [ -z "$AWS_ACCESS_KEY_ID" ]; then
    echo AWS_ACCESS_KEY_ID environment variable not set
    exit 1
fi

if [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
    echo AWS_SECRET_ACCESS_KEY environment variable not set
    exit 1
fi

if [ ! -d "$LIVE_PATH/$DOMAIN" ]; then
    echo Issuing new certificate

    certbot \
        -vvv \
        --non-interactive \
        --agree-tos \
        --email "$EMAIL" \
        --dns-route53 \
        --preferred-challenges dns \
        --domain "$DOMAIN" \
        --domain "*.$DOMAIN" \
        certonly

    echo Manually triggering deploy hook

    sh "$DEPLOY_HOOK_PATH"
else
    echo Renewing certificte

    certbot \
        --no-random-sleep-on-renew \
        --deploy-hook "$DEPLOY_HOOK_PATH" \
        renew
fi
