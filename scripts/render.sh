#!/bin/bash
# PostToolUse hook handler: renders .mmd/.mermaid files after Write/Edit.
# Reads JSON from stdin, extracts file_path, renders if applicable.

set -euo pipefail

PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# Only process .mmd/.mermaid files
case "$FILE_PATH" in
  *.mmd|*.mermaid) ;;
  *) exit 0 ;;
esac

# Check file exists
[ -f "$FILE_PATH" ] || exit 0

# Resolve binary: plugin-internal first, then PATH
MERMAID_ASCII="${PLUGIN_ROOT}/bin/mermaid-ascii"
if [ ! -x "$MERMAID_ASCII" ]; then
  # Try to download/install
  "${PLUGIN_ROOT}/scripts/ensure-binary.sh" 2>&1
fi

if [ ! -x "$MERMAID_ASCII" ]; then
  # Fallback to PATH
  if command -v mermaid-ascii &>/dev/null; then
    MERMAID_ASCII="mermaid-ascii"
  else
    echo "mermaid-ascii is not installed. Run the build-binary workflow or install manually." >&2
    exit 0
  fi
fi

echo "--- Rendered diagram: $FILE_PATH ---"
"$MERMAID_ASCII" -f "$FILE_PATH"
echo "---"

exit 0
