#!/bin/bash
set -euo pipefail

# Build custom FCOS ISO with your uCore autorebase config embedded
# This will create an ISO that automatically installs and rebases to YOUR uCore images

BUTANE_FILE="${1:-examples/ucore-autorebase.butane}"
STREAM="${2:-testing}"  # Use 'stable' or 'testing'
OUTPUT_ISO="ucore-${STREAM}-installer.iso"

echo "🔧 Building custom Fedora CoreOS ${STREAM} ISO..."
echo "📄 Using butane config: ${BUTANE_FILE}"

# Check if butane file exists
if [[ ! -f "${BUTANE_FILE}" ]]; then
    echo "❌ Error: Butane file not found: ${BUTANE_FILE}"
    exit 1
fi

# Generate ignition file
echo "📝 Generating ignition configuration..."
butane --pretty --strict "${BUTANE_FILE}" > config.ign
echo "✓ Ignition file generated"

# Download FCOS ISO
echo "⬇️  Downloading Fedora CoreOS ${STREAM} ISO..."
podman run --rm -v .:/data:z \
  quay.io/coreos/coreos-installer:release \
  download -s "${STREAM}" -p metal -f iso
echo "✓ ISO downloaded"

# Find the downloaded ISO
DOWNLOADED_ISO=$(ls fedora-coreos-*-live.x86_64.iso 2>/dev/null | head -n1)
if [[ -z "${DOWNLOADED_ISO}" ]]; then
    echo "❌ Error: Could not find downloaded ISO"
    exit 1
fi

# Embed ignition config
echo "🔨 Embedding ignition config into ISO..."
podman run --rm -v .:/data:z \
  quay.io/coreos/coreos-installer:release \
  iso ignition embed -i /data/config.ign -o "/data/${OUTPUT_ISO}" "/data/${DOWNLOADED_ISO}"
echo "✓ Custom ISO created: ${OUTPUT_ISO}"

# Cleanup
echo "🧹 Cleaning up..."
rm -f config.ign "${DOWNLOADED_ISO}"

echo ""
echo "✅ Success! Your custom ISO is ready: ${OUTPUT_ISO}"
echo ""
echo "📦 This ISO will auto-rebase to: ghcr.io/jstamagal/ucore:${STREAM}"
echo ""
echo "Next steps:"
echo "  1. Write to USB: sudo dd if=${OUTPUT_ISO} of=/dev/sdX bs=4M status=progress && sync"
echo "  2. Boot your laptop from USB"
echo "  3. Wait for 3 automatic reboots:"
echo "     • Boot 1: Installs FCOS + WiFi drivers"
echo "     • Boot 2: Rebases to your uCore (unsigned)"
echo "     • Boot 3: Rebases to signed image, ready to use!"
echo ""
