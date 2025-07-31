#!/usr/bin/env bash

set -ex

WORK_DIR=$(mktemp --directory)
trap '{ rm -r -- "$WORK_DIR"; }' EXIT

ROOT_DIR=$(realpath $(dirname "$0")/..)
SECRETS_FILE="${ROOT_DIR}/nixos/secrets.decrypted.yml"
ISO_TEMPLATE_FILE="${ROOT_DIR}/nixos/iso.template.nix"

for FILE in "$SECRETS_FILE" "$ISO_TEMPLATE_FILE"; do
    if [ ! -f "$FILE" ]; then
        echo Required file not found: $FILE
        exit 1
    fi
done

SECRET_KEYS=($(yq --raw-output '. | keys[]' "$SECRETS_FILE"))
SED_ARGS=()
for KEY in "${SECRET_KEYS[@]}"; do
    VALUE=$(yq --raw-output .$KEY "$SECRETS_FILE")
    SED_ARGS+=("-e" "s#\${${KEY}}#$VALUE#")
done

ISO_CONFIG_FILE="${WORK_DIR}/iso.nix"
sed "${SED_ARGS[@]}" "$ISO_TEMPLATE_FILE" > "$ISO_CONFIG_FILE"

NIX_PATH="nixos-config=${ISO_CONFIG_FILE}:nixpkgs=channel:nixos-25.05"
ISO_PATH=$(nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage)

realpath $ISO_PATH/iso/*.iso
