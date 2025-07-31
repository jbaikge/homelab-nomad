#!/usr/bin/env bash

set -e

DIR=$(dirname "$0")

for FILE in $DIR/*.encrypted.yml; do
    sops decrypt --output "${FILE/.encrypted.yml/.decrypted.yml}" "$FILE"
done
