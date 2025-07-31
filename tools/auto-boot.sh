#!/usr/bin/env bash

set -ex

if [ -z "$2" ]; then
    echo This tool assumes Ventoy is already set up on the USB drive
    echo
    echo Usage: $0 /dev/sdX /path/to/image.iso
    exit 1
fi

DISK=$1
ISO_PARTITION=${DISK}1
ISO_PATH=$2
IMAGE_FILE=$(basename "$ISO_PATH")

if [ ! -b $ISO_PARTITION ]; then
    echo ISO partition not available: $ISO_PARTITION
    exit 1
fi

if [ ! -f "$ISO_PATH" ]; then
    echo ISO file not available: $ISO_PATH
    exit 1
fi

WORK_DIR=$(mktemp --directory)

ISO_MOUNT_DIR="${WORK_DIR}/ventoy-iso"
VENTOY_CONFIG_DIR="${ISO_MOUNT_DIR}/ventoy"
VENTOY_CONFIG_PATH="${VENTOY_CONFIG_DIR}/ventoy.json"

mkdir -p "$ISO_MOUNT_DIR"
mount $ISO_PARTITION "$ISO_MOUNT_DIR"

cp -v "$ISO_PATH" "$ISO_MOUNT_DIR"

mkdir -p "$VENTOY_CONFIG_DIR"
cat <<EOF > $VENTOY_CONFIG_PATH
{
  "control": [
    { "VTOY_MENU_TIMEOUT": "5" },
    { "VTOY_DEFAULT_IMAGE": "/$IMAGE_FILE" },
    { "VTOY_SECONDARY_TIMEOUT": "5" }
  ]
}
EOF

umount $ISO_MOUNT_DIR
