# Agent Instructions

This project uses **bd** (beads) for issue tracking.

**At the start of every new session or after context compaction, run:**
```bash
bd prime
```

---

## Build, Sync & Quality

This repository contains opencode artefacts (agents, skills, commands). No traditional build.

### Sync to OpenCode

```bash
./sync.sh
```

Copies all artefacts to `~/.config/opencode/`. Merge — existing files not tracked here are left untouched.

### Linting

- **Markdown**: Use `markdownlint` if configured
- **Agent YAML frontmatter**: Validate required fields (`description` required, `name` for skills)
- **Bash scripts**: Run through `shellcheck`

### Testing

No automated tests for this artefact repo. Test by syncing to opencode, running agents with sample tasks, verifying output.

---

## Code Style Guidelines

### Artefact File Conventions

| Type | Location | Naming |
|------|----------|--------|
| Agent | `agents/<name>.md` | kebab-case → `@<name>` |
| Skill | `skills/<name>/SKILL.md` | dir matches `name` in frontmatter |
| Command | `commands/<name>.md` | kebab-case → `/<name>` |
| Rule | `AGENTS.md` (root) | fixed name |

### Agent Frontmatter (required: `description`)

```yaml
---
description: "Short description shown in @ autocomplete"
mode: primary|subagent|all
model: provider/model-id
temperature: 0.0-1.0
permission:
  bash:
    "*": ask
    "git status*": allow
---
```

### Skill Frontmatter (required: `name`, `description`)

```yaml
---
name: skill-name
description: "When and why to load this skill"
license: MIT
compatibility: opencode
---
```
File must be named `SKILL.md` (uppercase).

### Markdown Style

- ATX-style headers (`#`, `##`, `###`)
- Code blocks with language identifiers
- Tables for structured data
- Frontmatter in YAML fenced with `---`
- Max line length: 100 characters
- Backticks for code/filenames: `src/app.ts`
- *Italics*, not _underscore_

---

## Language Guidelines (for code projects)

### TypeScript / JavaScript

- `strict: true` baseline
- Avoid `any`; use `unknown` and narrow explicitly
- Prefer `type` for unions; `interface` for object shapes
- Use `readonly` modifiers
- Handle errors explicitly (typed returns or Result types)
- Test: Vitest (default) or Jest

### Python

- PEP 8, PEP 20; Python 3.10+ features
- Type annotations on all public interfaces
- Docstrings: Google or NumPy style
- Handle errors explicitly; never silently swallow
- Test: pytest (default)

### General

- Correct first, then clear, then fast
- Read existing files before writing
- Match naming/patterns already present
- No new dependencies without stating reason

---

## Issue Tracking with bd

**Use bd for ALL issue tracking. NO markdown TODOs or external trackers.**

### Quick Commands

```bash
bd ready --json              # Find available work
bd create "Issue" -t bug|feature|task -p 0-4 --json
bd update <id> --claim       # Claim atomically
bd close <id> --reason "Done" --suggest-next
bd dolt push                 # Push to remote
```

### Priorities

- `0` - Critical, `1` - High, `2` - Medium, `3` - Low, `4` - Backlog

### Rules

- ✅ Use bd for ALL task tracking
- ✅ Always `--json` for programmatic use
- ✅ Link discovered work with `--deps discovered-from:<id>`
- ✅ Include issue ID in commits: `git commit -m "Fix thing (MrSmith-0e0)"`
- ❌ No `bd edit` — use `bd update` with flags
- ❌ No markdown TODO lists

---

## Non-Interactive Shell Commands

Always use non-interactive flags:

```bash
cp -f source dest      # NOT: cp source dest
mv -f source dest     # NOT: mv source dest
rm -f file            # NOT: rm file
rm -rf directory      # NOT: rm -r directory
```

---

## Landing the Plane

**MANDATORY at session end:**

1. File issues for remaining work
2. Run quality gates (lint, tests)
3. Update issue status
4. **Push to remote:**
   ```bash
   git pull --rebase
   bd dolt push
   git push
   git status  # MUST show "up to date with origin"
   ```
5. Clean up stashes and branches
6. Verify all changes committed AND pushed

**CRITICAL**: Work is NOT complete until `git push` succeeds.
