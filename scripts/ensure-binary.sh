#!/bin/bash
# Ensure mermaid-ascii binary is available in the plugin's bin/ directory.
# Downloads pre-built binary from GitHub Releases, falls back to go install.

set -euo pipefail

PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"
PLUGIN_BIN="${PLUGIN_ROOT}/bin"
BINARY="${PLUGIN_BIN}/mermaid-ascii"

# Already installed
if [ -x "$BINARY" ]; then
  exit 0
fi

mkdir -p "$PLUGIN_BIN"

# Detect platform
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)
case "$ARCH" in
  x86_64)  ARCH="amd64" ;;
  aarch64) ARCH="arm64" ;;
  arm64)   ARCH="arm64" ;;
  *)
    echo "Unsupported architecture: $ARCH" >&2
    exit 1
    ;;
esac

ASSET_NAME="mermaid-ascii_${OS}_${ARCH}"

# Detect plugin repo owner/name from git remote or fallback
REPO="ahonn/claude-mermaid-ascii"
RELEASE_TAG="latest-bin"
DOWNLOAD_URL="https://github.com/${REPO}/releases/download/${RELEASE_TAG}/${ASSET_NAME}"

# Strategy 1: Download pre-built binary
if command -v curl &>/dev/null; then
  if curl -fsSL -o "$BINARY" "$DOWNLOAD_URL" 2>/dev/null; then
    chmod +x "$BINARY"
    echo "Downloaded mermaid-ascii to ${BINARY}" >&2
    exit 0
  fi
fi

# Strategy 2: go install fallback
if command -v go &>/dev/null; then
  echo "Downloading pre-built binary failed, trying go install..." >&2
  GOBIN="$PLUGIN_BIN" go install github.com/pgavlin/mermaid-ascii@latest 2>&1
  if [ -x "$BINARY" ]; then
    echo "Installed mermaid-ascii via go install to ${BINARY}" >&2
    exit 0
  fi
fi

echo "Failed to install mermaid-ascii. Please run the build-binary workflow or install Go 1.25+." >&2
exit 1
