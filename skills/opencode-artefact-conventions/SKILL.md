---
name: opencode-artefact-conventions
description: Stable OpenCode configuration conventions for agents, skills, commands, and rules — frontmatter fields, file placement, naming constraints, and the agent-vs-skill decision framework, to use as a local reference before fetching live docs
license: MIT
compatibility: opencode
---

## OpenCode artefact conventions

Use this as a stable local reference. Always verify against live documentation (`https://opencode.ai/docs/`) for any behaviour you are uncertain about.

---

## File placement

| Artefact | Global path | Per-project path |
|---|---|---|
| Agent | `~/.config/opencode/agents/<name>.md` | `.opencode/agents/<name>.md` |
| Skill | `~/.config/opencode/skills/<name>/SKILL.md` | `.opencode/skills/<name>/SKILL.md` |
| Command | `~/.config/opencode/commands/<name>.md` | `.opencode/commands/<name>.md` |
| Rule | `~/.config/opencode/AGENTS.md` | `AGENTS.md` (project root) |

---

## Agent frontmatter fields

| Field | Required | Values / notes |
|---|---|---|
| `description` | Yes | 1–1024 chars; shown in `@` autocomplete |
| `mode` | No | `primary`, `subagent`, `all` (default: `all`) |
| `model` | No | `provider/model-id`; falls back to global config |
| `temperature` | No | `0.0`–`1.0` |
| `top_p` | No | `0.0`–`1.0` |
| `steps` | No | Max agentic iterations (replaces deprecated `maxSteps`) |
| `tools` | No | Map of tool name → `true`/`false`; supports wildcards |
| `permission` | No | `edit`, `bash`, `webfetch`: `allow`/`ask`/`deny`; bash supports glob patterns |
| `hidden` | No | `true` hides subagent from `@` autocomplete; subagents only |
| `color` | No | Hex (`#FF5733`) or theme token (`primary`, `accent`, etc.) |
| `disable` | No | `true` disables the agent entirely |

### Permission bash pattern rules

- Patterns are globs. Last matching rule wins.
- Put `"*": ask` first, then specific `allow` rules after.
- Example: `"*": ask` + `"git status*": allow`

---

## Skill frontmatter fields

| Field | Required | Values / notes |
|---|---|---|
| `name` | Yes | 1–64 chars; `^[a-z0-9]+(-[a-z0-9]+)*$`; must match directory name |
| `description` | Yes | 1–1024 chars; used by agent to decide when to load |
| `license` | No | SPDX identifier |
| `compatibility` | No | e.g. `opencode` |
| `metadata` | No | String-to-string map of arbitrary key/value pairs |

**File must be named `SKILL.md` in all caps.**

---

## Command frontmatter fields

| Field | Required | Values / notes |
|---|---|---|
| `description` | Yes | Shown in TUI autocomplete |
| `template` | Yes (JSON) / body (Markdown) | The prompt sent to the LLM |
| `agent` | No | Which agent executes the command |
| `model` | No | Override model for this command |
| `subtask` | No | `true` forces subagent invocation |

**Prompt placeholders:** `$ARGUMENTS`, `$1`…`$N`, `` !`shell command` ``, `@filename`

---

## Decision framework: agent vs skill vs command vs rule

| Feature | Use when | Not for |
|---|---|---|
| **Agent** | Needs its own model, temperature, tool set, permissions, or Tab/@ identity | Simple reusable instructions |
| **Skill** | Reusable instructions loadable on-demand by multiple agents | Always-on behaviour; behaviour requiring a different model |
| **Command** | Repeatable prompt template, optionally with args or shell injection, run via `/name` | Persistent context |
| **Rule** (`AGENTS.md`) | Always-on context for every session — project conventions, code standards | On-demand behaviour |

---

## Naming constraints

- Agent file name → agent name (e.g. `review.md` → `@review`)
- Skill directory name → skill name; must match `name` in frontmatter
- Skill name regex: `^[a-z0-9]+(-[a-z0-9]+)*$` (lowercase, hyphen-separated, no leading/trailing hyphens, no consecutive hyphens)
- Command file name → `/command-name`
