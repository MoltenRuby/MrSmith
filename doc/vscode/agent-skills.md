# VS Code Copilot — Agent Skills

Source: https://code.visualstudio.com/docs/copilot/customization/agent-skills
Fetched: 2026-04-27 (MrSmith-ayt)

## What are agent skills?

Agent Skills are folders containing a `SKILL.md` file (and optional scripts/resources) that
Copilot loads on-demand when relevant. They follow the open [agentskills.io](https://agentskills.io)
standard and work across VS Code, GitHub Copilot CLI, and GitHub Copilot cloud agent.

## File locations

| Scope | Locations |
|---|---|
| Project (workspace) | `.github/skills/<name>/SKILL.md` |
| Project (Claude compat) | `.claude/skills/<name>/SKILL.md` |
| Project (agent compat) | `.agents/skills/<name>/SKILL.md` |
| User profile | `~/.copilot/skills/`, `~/.claude/skills/`, `~/.agents/skills/` |

Additional locations configurable via: `chat.agentSkillsLocations`

## SKILL.md frontmatter

```yaml
---
name: skill-name          # required; lowercase alphanumeric + hyphens; max 64 chars
                          # must match parent directory name
description: "..."        # required; max 1024 chars; describe WHAT and WHEN
argument-hint: "[hint]"   # optional; shown in chat input when invoked as slash command
user-invocable: true      # show as slash command (default true)
disable-model-invocation: false  # prevent auto-loading by agent (default false)
license: MIT              # optional
compatibility: opencode   # optional
metadata:                 # optional; string-to-string map
  key: value
---
```

## Compatibility with OpenCode

The `SKILL.md` format is **identical** between VS Code and OpenCode:
- Same required fields: `name`, `description`
- Same optional fields: `license`, `compatibility`, `metadata`
- Same naming rules: lowercase alphanumeric + hyphens, matches directory name

**OpenCode also reads `.agents/skills/`** — this path is the best cross-compatible location.

## Skills vs custom instructions

| Feature | Agent Skills | Custom Instructions |
|---|---|---|
| Purpose | Specialized capabilities + workflows | Coding standards and guidelines |
| Portability | VS Code, Copilot CLI, cloud agent | VS Code and GitHub.com only |
| Content | Instructions + scripts + resources | Instructions only |
| Scope | On-demand (loaded when relevant) | Always applied |
| Standard | Open standard (agentskills.io) | VS Code-specific |

## How Copilot uses skills (3-level loading)

1. **Discovery**: reads `name` + `description` from frontmatter
2. **Instructions loading**: loads `SKILL.md` body when relevant (or via `/skill-name`)
3. **Resource access**: loads referenced files only when the instructions reference them

## Slash command usage

Type `/skill-name` in chat to invoke a skill directly.
Add context after: `/webapp-testing for the login page`

## Invocation control

| Configuration | Slash command | Auto-loaded |
|---|---|---|
| Default | Yes | Yes |
| `user-invocable: false` | No | Yes |
| `disable-model-invocation: true` | Yes | No |
| Both set | No | No |
