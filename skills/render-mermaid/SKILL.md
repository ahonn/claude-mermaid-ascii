---
name: render-mermaid
description: >
  Renders Mermaid diagram definitions as ASCII/Unicode art in the terminal
  using mermaid-ascii. Use when the user asks to visualize, render, preview,
  or display a Mermaid diagram in the terminal.
argument-hint: [mermaid code or .mmd file path]
user-invocable: true
allowed-tools: Bash(${CLAUDE_PLUGIN_ROOT}/*), Bash(mermaid-ascii *), Read, Write
---

# Render Mermaid Diagram

Render Mermaid diagram definitions as ASCII/Unicode art directly in the terminal.

## Instructions

You have access to `mermaid-ascii` via the plugin's bundled binary. Follow these steps:

### Step 1: Ensure binary is available

Run the ensure-binary script. This is a no-op if the binary already exists:

```bash
${CLAUDE_PLUGIN_ROOT}/scripts/ensure-binary.sh
```

If the script fails, inform the user and suggest manual installation:
- `go install github.com/pgavlin/mermaid-ascii@latest` (requires Go 1.25+)

### Step 2: Determine input

The user provides `$ARGUMENTS` which is one of:

1. **A file path** (ends with `.mmd` or `.mermaid`) — use it directly
2. **Inline Mermaid code** — write it to a temp file first

For inline code, write to a temp file:

```bash
TMPFILE=$(mktemp /tmp/mermaid-XXXXXX.mmd)
```

Use the Write tool to write the Mermaid code to `$TMPFILE`.

### Step 3: Render

```bash
${CLAUDE_PLUGIN_ROOT}/bin/mermaid-ascii -f <file>
```

If the plugin binary is not available, fall back to:

```bash
mermaid-ascii -f <file>
```

### Step 4: Clean up

If a temp file was created, remove it:

```bash
rm -f "$TMPFILE"
```

## CLI Flags

You may use these flags when rendering if the user requests specific formatting:

| Flag | Description | Default |
|------|-------------|---------|
| `-a` | ASCII-only (no Unicode box-drawing characters) | off |
| `-p <n>` | Padding between text and border | 1 |
| `-x <n>` | Horizontal space between nodes | 5 |
| `-y <n>` | Vertical space between nodes | 5 |

## Supported Diagram Types

See [supported-diagrams.md](./supported-diagrams.md) for the full list of supported diagram types with syntax examples.
