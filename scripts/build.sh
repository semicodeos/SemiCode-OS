#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Source and export config so auto/config can access the variables
set -a
# shellcheck disable=SC1091  # config path is resolved at runtime
source "${PROJECT_ROOT}/etc/semicode-amd64.conf"
set +a

echo "========================================="
echo " SemiCode OS ${SEMICODE_VERSION} (${SEMICODE_CODENAME})"
echo " Architecture: ${SEMICODE_ARCH}"
echo " Base: Ubuntu ${SEMICODE_PARENT_DISTRO}"
echo "========================================="

# Check for root
if [ "$(id -u)" -ne 0 ]; then
    echo "Error: This script must be run as root (or via Docker with --privileged)."
    exit 1
fi

# Check for live-build
if ! command -v lb &> /dev/null; then
    echo "Error: live-build is not installed. Run: apt install live-build"
    exit 1
fi

# Create build workspace
BUILD_DIR="${PROJECT_ROOT}/tmp/build-${SEMICODE_ARCH}"
OUTPUT_DIR="${PROJECT_ROOT}/${SEMICODE_OUTPUT_DIR}"
mkdir -p "${BUILD_DIR}" "${OUTPUT_DIR}"

echo "[1/5] Setting up build workspace..."
cd "${BUILD_DIR}"

# Symlink auto/ scripts
rm -rf auto
mkdir -p auto
for f in config build clean; do
    cp "${PROJECT_ROOT}/etc/auto/${f}" "auto/${f}"
    chmod +x "auto/${f}"
done

echo "[2/5] Running lb config..."
lb config

echo "[3/5] Copying package lists, hooks, and includes..."
# Copy package lists
mkdir -p config/package-lists
cp "${PROJECT_ROOT}"/etc/config/package-lists/*.list.chroot config/package-lists/ 2>/dev/null || true

# Copy hooks
mkdir -p config/hooks/live
cp "${PROJECT_ROOT}"/etc/config/hooks/live/*.hook.chroot config/hooks/live/ 2>/dev/null || true
chmod +x config/hooks/live/*.hook.chroot 2>/dev/null || true

# Copy includes.chroot overlay
if [ -d "${PROJECT_ROOT}/etc/config/includes.chroot" ]; then
    cp -r "${PROJECT_ROOT}/etc/config/includes.chroot" config/
fi

# Copy includes.binary overlay
if [ -d "${PROJECT_ROOT}/etc/config/includes.binary" ]; then
    cp -r "${PROJECT_ROOT}/etc/config/includes.binary" config/
fi

echo "[4/5] Running lb build (this will take a while)..."
lb build

echo "[5/5] Copying ISO to output directory..."
ISO_FILE=$(find . -maxdepth 1 -name '*.iso' -print -quit)
if [ -n "$ISO_FILE" ]; then
    FINAL_NAME="semicode-os-${SEMICODE_VERSION}-${SEMICODE_ARCH}.iso"
    cp "$ISO_FILE" "${OUTPUT_DIR}/${FINAL_NAME}"
    echo ""
    echo "Build complete!"
    echo "ISO: ${OUTPUT_DIR}/${FINAL_NAME}"
    echo "Size: $(du -h "${OUTPUT_DIR}/${FINAL_NAME}" | cut -f1)"
else
    echo "Error: No ISO file produced by live-build."
    exit 1
fi
