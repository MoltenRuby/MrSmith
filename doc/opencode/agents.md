# OpenCode — Agents

Source: https://opencode.ai/docs/agents/
Fetched: 2026-04-27 (MrSmith-9v8)

## Overview

Agents are specialized AI assistants with custom prompts, models, and tool access.
Two types: **primary** (Tab-switchable, direct interaction) and **subagent** (@-mentionable,
invoked by primary agents or manually).

## File locations

| Scope | Location |
|---|---|
| Global | `~/.config/opencode/agents/<name>.md` |
| Per-project | `.opencode/agents/<name>.md` |

File name becomes the agent name (e.g., `review.md` → `@review`).

## Frontmatter fields

```yaml
---
description: "Short description shown in @ autocomplete"   # REQUIRED
mode: primary | subagent | all                             # default: all
model: provider/model-id                                   # e.g. anthropic/claude-sonnet-4-20250514
temperature: 0.0-1.0
steps: 5                                                   # max agentic iterations
disable: false
hidden: false                                              # hide from @ autocomplete (subagent only)
color: "#FF5733" | primary | secondary | accent | ...
top_p: 0.9
permission:
  edit: allow | ask | deny
  bash:
    "*": ask
    "git status*": allow
  webfetch: deny
  task:
    "*": deny
    "orchestrator-*": allow
    "code-reviewer": ask
  skill:
    "*": allow
    "internal-*": deny
---
```

## Key notes

- `description` is **required**
- `mode: primary` → Tab-switchable; `mode: subagent` → @-mentionable only
- `hidden: true` → only applies to `mode: subagent`; hides from @ autocomplete but still invocable via Task tool
- `tools` field is **deprecated** — use `permission` instead
- Permission rules: last matching rule wins; put `*` first, specific rules after
- `task` permission controls which subagents this agent can invoke via Task tool
- `skill` permission controls which skills this agent can load

## Built-in agents

| Agent | Mode | Description |
|---|---|---|
| build | primary | Default; all tools enabled |
| plan | primary | Read-only; `edit` and `bash` set to `ask` |
| general | subagent | Full tool access; multi-step tasks |
| explore | subagent | Read-only; fast codebase exploration |
| compaction | primary (hidden) | Auto-compacts long context |
| title | primary (hidden) | Auto-generates session titles |
| summary | primary (hidden) | Auto-creates session summaries |

## Model format

`provider/model-id` — e.g., `anthropic/claude-sonnet-4-20250514`, `opencode/gpt-5.1-codex`

If no model specified: primary agents use globally configured model; subagents use the invoking
primary agent's model.
