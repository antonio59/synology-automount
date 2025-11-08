#!/bin/bash

# Synology NAS Auto-Mount Script for Tailscale
# This script automatically mounts your Synology NAS when Tailscale is connected

# Wait for Tailscale to be fully connected
sleep 5

# Check if Tailscale is connected
if ! /Applications/Tailscale.app/Contents/MacOS/Tailscale status &>/dev/null; then
    echo "Tailscale is not connected. Exiting."
    exit 0
fi

# Configuration
NAS_IP="YOUR_TAILSCALE_IP"
SHARE_NAME="volume1"  # Change this to your actual share name
MOUNT_POINT="/Volumes/${SHARE_NAME}"
USERNAME="${USER}"  # Change this if your NAS username is different

# Check if already mounted
if mount | grep -q "${MOUNT_POINT}"; then
    echo "NAS is already mounted at ${MOUNT_POINT}"
    exit 0
fi

# Create mount point if it doesn't exist
mkdir -p "${MOUNT_POINT}"

# Mount the NAS using SMB
echo "Mounting Synology NAS at ${MOUNT_POINT}..."
mount_smbfs "//${USERNAME}@${NAS_IP}/${SHARE_NAME}" "${MOUNT_POINT}"

if [ $? -eq 0 ]; then
    echo "Successfully mounted NAS at ${MOUNT_POINT}"
else
    echo "Failed to mount NAS"
    exit 1
fi
