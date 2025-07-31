#!/usr/bin/env bash

set -ex

DIR=$(realpath $(dirname "$0")/..)

for FILE in $DIR/**/*.decrypted.yml; do
    sops encrypt --output "${FILE/.decrypted.yml/.encrypted.yml}" "$FILE"
done
