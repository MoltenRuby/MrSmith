# OpenCode — Rules (AGENTS.md)

Source: https://opencode.ai/docs/rules/
Fetched: 2026-04-27 (MrSmith-9v8)

## Overview

`AGENTS.md` provides always-on custom instructions injected into every session context.

## File locations and precedence

1. **Local** — traverses up from CWD: `AGENTS.md`, then `CLAUDE.md` (first match wins)
2. **Global** — `~/.config/opencode/AGENTS.md`
3. **Claude Code** — `~/.claude/CLAUDE.md` (unless disabled)

`AGENTS.md` takes precedence over `CLAUDE.md` at the same level.

## Cross-tool compatibility

`AGENTS.md` at repo root is recognized by **both OpenCode and VS Code Copilot**.

VS Code also reads:
- `.github/copilot-instructions.md`
- `CLAUDE.md` (fallback)

## Additional instruction files

Configure in `opencode.json`:
```json
{
  "instructions": [
    "CONTRIBUTING.md",
    "docs/guidelines.md",
    ".cursor/rules/*.md",
    "packages/*/AGENTS.md"
  ]
}
```

Remote URLs also supported (5 second timeout).

## Disabling Claude Code compatibility

```bash
export OPENCODE_DISABLE_CLAUDE_CODE=1         # Disable all .claude support
export OPENCODE_DISABLE_CLAUDE_CODE_PROMPT=1  # Disable only ~/.claude/CLAUDE.md
export OPENCODE_DISABLE_CLAUDE_CODE_SKILLS=1  # Disable only .claude/skills
```
