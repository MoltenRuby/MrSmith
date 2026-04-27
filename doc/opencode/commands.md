# OpenCode — Commands

Source: https://opencode.ai/docs/commands/
Fetched: 2026-04-27 (MrSmith-9v8)

## Overview

Custom commands are prompt templates runnable via `/command-name` in the TUI.

## File locations

| Scope | Location |
|---|---|
| Global | `~/.config/opencode/commands/<name>.md` |
| Per-project | `.opencode/commands/<name>.md` |

File name becomes the command name (e.g., `test.md` → `/test`).

## Frontmatter fields

```yaml
---
description: "Shown in TUI when typing the command"   # optional but recommended
agent: build                                           # optional; which agent runs it
model: anthropic/claude-3-5-sonnet-20241022            # optional; model override
subtask: false                                         # optional; force subagent invocation
---
```

## Prompt template features

### Arguments
- `$ARGUMENTS` — all arguments as a string
- `$1`, `$2`, `$3` — positional arguments

### Shell output injection
```
!`git log --oneline -10`
```
Runs the command and injects output into the prompt.

### File references
```
@src/components/Button.tsx
```
Includes file content in the prompt.

## No VS Code equivalent

Commands are OpenCode-specific. VS Code uses **prompt files** (`.github/prompts/*.prompt.md`)
for similar functionality, but with different syntax and no shell injection.
