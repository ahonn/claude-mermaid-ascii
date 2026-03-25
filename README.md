# claude-mermaid-ascii

A [Claude Code](https://docs.anthropic.com/en/docs/claude-code) plugin that renders Mermaid diagrams as ASCII/Unicode art directly in your terminal.

Powered by [`pgavlin/mermaid-ascii`](https://github.com/pgavlin/mermaid-ascii).

## Features

- `/render-mermaid` skill — render any Mermaid diagram on demand
- Auto-render hook — automatically preview `.mmd`/`.mermaid` files after Write/Edit
- Supports all 22 Mermaid diagram types (flowchart, sequence, class, state, ER, gantt, pie, mindmap, timeline, gitgraph, journey, quadrant, xychart, C4, requirement, block, sankey, packet, kanban, architecture, zenuml)
- Pre-built binaries for macOS and Linux (arm64/amd64), with `go install` fallback

## Install

In Claude Code, run:

```
/plugin install claude-mermaid-ascii
```

> If the marketplace hasn't been added yet:
>
> ```
> /plugin marketplace add ahonn/claude-mermaid-ascii
> ```

The `mermaid-ascii` binary is downloaded automatically on first use — no manual setup required.

## Usage

### Skill: `/render-mermaid`

Invoke the skill with inline Mermaid code:

```
/render-mermaid
graph TD
    A[Start] --> B{Decision}
    B -->|Yes| C[OK]
    B -->|No| D[End]
```

Or pass a `.mmd` / `.mermaid` file path:

```
/render-mermaid diagram.mmd
```

You can also ask Claude naturally — e.g. "draw a flowchart of this module" or "visualize this as a diagram" — and Claude will invoke the skill automatically.

### Auto-render Hook

When Claude writes or edits a `.mmd` / `.mermaid` file, a `PostToolUse` hook automatically renders the diagram in the output. No manual invocation needed.

### Input Rules

- **No semicolons** — use multi-line syntax instead of `graph LR; A --> B`
- **Chain syntax works** — `A --> B --> C` on one line is fine

### CLI Flags

The underlying `mermaid-ascii` binary supports these flags:

| Flag     | Default        | Effect                              |
| -------- | -------------- | ----------------------------------- |
| `-a`     | off            | ASCII-only (no Unicode box-drawing) |
| `-w <n>` | terminal width | Target output width in characters   |
| `-p <n>` | 1              | Text-to-border padding              |
| `-x <n>` | 5              | Horizontal node spacing             |
| `-y <n>` | 5              | Vertical node spacing               |

## How It Works

```
┌─────────────────────────────────────────────────────────────┐
│                    claude-mermaid-ascii                      │
│                                                             │
│  ┌──────────────────────┐    ┌───────────────────────────┐  │
│  │  /render-mermaid      │    │  PostToolUse Hook         │  │
│  │  (user-invocable)     │    │  (Write|Edit on .mmd)     │  │
│  └──────────┬───────────┘    └─────────────┬─────────────┘  │
│             │                              │                │
│             ▼                              ▼                │
│  ┌──────────────────────────────────────────────────────┐   │
│  │              ensure-binary.sh                         │   │
│  │  GitHub Releases (curl) → go install (fallback)       │   │
│  └──────────────────────┬───────────────────────────────┘   │
│                         ▼                                   │
│  ┌──────────────────────────────────────────────────────┐   │
│  │              bin/mermaid-ascii                         │   │
│  │  pgavlin/mermaid-ascii Go binary (auto-downloaded)    │   │
│  └──────────────────────┬───────────────────────────────┘   │
│                         ▼                                   │
│                   ASCII output                              │
└─────────────────────────────────────────────────────────────┘
```

1. **Binary acquisition** — `ensure-binary.sh` downloads a pre-built binary from [GitHub Releases](https://github.com/ahonn/claude-mermaid-ascii/releases). Falls back to `go install github.com/pgavlin/mermaid-ascii@latest` if the download fails.
2. **Skill path** — `/render-mermaid` writes Mermaid code to a temp file, runs `mermaid-ascii`, outputs to a file, then reads and displays it (output goes to file to avoid UI collapsing).
3. **Hook path** — Editing a `.mmd`/`.mermaid` file triggers `render.sh` via `PostToolUse` hook, rendering the diagram inline.

## Plugin Structure

```
claude-mermaid-ascii/
├── .claude-plugin/
│   ├── plugin.json            # Plugin manifest (name, version, author)
│   └── marketplace.json       # Marketplace distribution config
├── skills/
│   └── render-mermaid/
│       └── SKILL.md           # Skill definition with allowed-tools and CLI docs
├── hooks/
│   └── hooks.json             # PostToolUse hook → render.sh on Write|Edit
├── scripts/
│   ├── ensure-binary.sh       # Binary installer (curl from Releases → go install)
│   └── render.sh              # Hook handler: auto-renders .mmd/.mermaid files
├── bin/
│   └── mermaid-ascii          # Go binary (gitignored, auto-downloaded)
└── .github/workflows/
    └── build-binary.yml       # CI: cross-compile for darwin/linux × arm64/amd64
```

## Requirements

- Claude Code
- macOS or Linux (arm64 or amd64)
- No other dependencies — binary is auto-downloaded

## License

MIT
