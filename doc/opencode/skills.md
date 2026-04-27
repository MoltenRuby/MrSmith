# OpenCode — Agent Skills

Source: https://opencode.ai/docs/skills/
Fetched: 2026-04-27 (MrSmith-9v8)

## Overview

Skills are reusable instructions loaded on-demand via the native `skill` tool. Each skill is a
`SKILL.md` file inside a named directory.

## File locations (searched in order)

| Scope | Location |
|---|---|
| Project (OpenCode) | `.opencode/skills/<name>/SKILL.md` |
| Global (OpenCode) | `~/.config/opencode/skills/<name>/SKILL.md` |
| Project (Claude compat) | `.claude/skills/<name>/SKILL.md` |
| Global (Claude compat) | `~/.claude/skills/<name>/SKILL.md` |
| Project (agent compat) | `.agents/skills/<name>/SKILL.md` |
| Global (agent compat) | `~/.agents/skills/<name>/SKILL.md` |

OpenCode walks up from CWD to git worktree root, loading skills from all matching paths.

## Frontmatter fields

```yaml
---
name: skill-name          # required; 1-64 chars; lowercase alphanumeric + hyphens
                          # must match parent directory name
description: "..."        # required; 1-1024 chars
license: MIT              # optional
compatibility: opencode   # optional
metadata:                 # optional; string-to-string map
  key: value
---
```

## Naming rules

- Lowercase alphanumeric with single hyphen separators
- No leading/trailing hyphens; no consecutive `--`
- Regex: `^[a-z0-9]+(-[a-z0-9]+)*$`
- Must match the directory name containing `SKILL.md`

## How agents use skills

Skills are listed in the `skill` tool description:
```xml
<available_skills>
  <skill>
    <name>git-release</name>
    <description>Create consistent releases and changelogs</description>
  </skill>
</available_skills>
```

Agent loads a skill by calling: `skill({ name: "git-release" })`

## Permissions

```json
{
  "permission": {
    "skill": {
      "*": "allow",
      "internal-*": "deny",
      "experimental-*": "ask"
    }
  }
}
```

Per-agent override in frontmatter:
```yaml
permission:
  skill:
    "documents-*": "allow"
```

## Troubleshooting

1. `SKILL.md` must be spelled in all caps
2. Frontmatter must include `name` and `description`
3. Skill names must be unique across all locations
4. Skills with `deny` permission are hidden from agents
