---
name: render-mermaid
description: >
  Render Mermaid diagrams as ASCII/Unicode art in the terminal using mermaid-ascii.
  Use when the user asks to visualize, render, preview, display, draw, or show
  a Mermaid diagram as text or ASCII art. Also use when Claude has just written
  Mermaid code and the user wants to see the rendered output.
  Supports all 22 Mermaid diagram types: flowchart, sequence, class, state, ER,
  gantt, pie, mindmap, timeline, gitgraph, journey, quadrant, xychart, C4,
  requirement, block, sankey, packet, kanban, architecture, zenuml.
argument-hint: [mermaid code or .mmd file path]
user-invocable: true
allowed-tools: Bash(${CLAUDE_PLUGIN_ROOT}/*), Bash(${CLAUDE_PLUGIN_DATA}/*), Read
---

## Setup

Ensure binary exists (no-op if already installed):

```bash
${CLAUDE_PLUGIN_ROOT}/scripts/ensure-binary.sh
```

## Render

Run in a single Bash call — write input, render to output file, clean up input:

```bash
TMPFILE=$(mktemp /tmp/mermaid.XXXXXX.mmd)
OUTFILE=$(mktemp /tmp/mermaid-out.XXXXXX)
cat > "$TMPFILE" << 'MERMAID'
<mermaid code, one statement per line>
MERMAID
"${CLAUDE_PLUGIN_DATA}/bin/mermaid-ascii" -f "$TMPFILE" > "$OUTFILE" 2>&1
rm -f "$TMPFILE"
echo "$OUTFILE"
```

If `$ARGUMENTS` is a file path (.mmd/.mermaid), use it directly instead of creating `$TMPFILE`.

**Bash must only output the `$OUTFILE` path** — all render output goes to the file to avoid UI collapsing.

## Display

Read `$OUTFILE` with the Read tool, then present the content in a fenced code block.

## Input rules

- **No semicolons**: `graph LR; A --> B` does NOT work. Always use multi-line:
  ```
  graph LR
      A --> B
  ```
- **Chain syntax works**: `A --> B --> C` on one line is fine

## CLI flags

| Flag | Default | Effect |
|------|---------|--------|
| `-a` | off | ASCII-only (no Unicode box-drawing) |
| `-w <n>` | terminal width | Target output width in characters |
| `-p <n>` | 1 | Text-to-border padding |
| `-x <n>` | 5 | Horizontal node spacing |
| `-y <n>` | 5 | Vertical node spacing |
