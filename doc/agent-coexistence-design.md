# Agent Coexistence Design Decision

**Task**: MrSmith-zz2  
**Date**: 2026-04-27  
**Status**: Decision

---

## Context

This repo (`MrSmith`) stores OpenCode artefacts (agents, skills, commands). The goal is to also
serve VS Code Copilot custom agents and skills from the same checkout, without duplication or
conflict.

---

## Key findings from documentation

### Skills — identical format, shared path available

From `doc/vscode/agent-skills.md`:

> "The `SKILL.md` format is **identical** between VS Code and OpenCode: same required fields
> (`name`, `description`), same optional fields (`license`, `compatibility`, `metadata`), same
> naming rules."

> "**OpenCode also reads `.agents/skills/`** — this path is the best cross-compatible location."

VS Code reads skills from (among others): `.github/skills/<name>/SKILL.md`,
`.claude/skills/<name>/SKILL.md`, `.agents/skills/<name>/SKILL.md`.

OpenCode reads skills from: `.opencode/agents/` (project-scoped) and `~/.config/opencode/` (global).

**Conclusion**: Skills can be **shared with zero modification** by placing them in `.agents/skills/`
(VS Code reads it natively; `sync.sh` copies to `~/.config/opencode/skills/` for OpenCode).

### Agents — incompatible frontmatter

From `doc/vscode/custom-agents.md`:

| Aspect | OpenCode | VS Code |
|---|---|---|
| File extension | `.md` | `.agent.md` (or `.md` in `.github/agents/`) |
| `tools` format | map (`{ write: false }`) | array of strings (`['edit', 'search']`) |
| `mode` field | `primary` / `subagent` / `all` | `user-invocable` + `disable-model-invocation` |
| `permission` field | Bash glob patterns | Not supported |
| `temperature` | Supported | Not supported |
| `model` format | `provider/model-id` | `Model Name (vendor)` |

**Conclusion**: Agent frontmatter is **incompatible**. Sharing a single file is not viable without
a transformation step. Separate files are required.

---

## Design Decision

### Folder structure

```
agents/                        # OpenCode agents (source of truth)
  <name>.md                    # OpenCode frontmatter

.github/agents/                # VS Code agents (generated/maintained separately)
  <name>.agent.md              # VS Code frontmatter

skills/<name>/SKILL.md         # OpenCode skills (source of truth)
.agents/skills/<name>/SKILL.md # Symlinks → skills/<name>/SKILL.md (VS Code reads here)
```

### Frontmatter strategy

| Artefact | Strategy |
|---|---|
| **Skills** | Single source in `skills/`. Symlink `.agents/skills/<name>` → `skills/<name>`. No frontmatter changes needed. |
| **Agents** | Maintain two separate files: `agents/<name>.md` (OpenCode) and `.github/agents/<name>.agent.md` (VS Code). `sync.sh` deploys OpenCode files; VS Code reads `.github/agents/` directly from the workspace. |

### Rationale

- **Skills**: The `SKILL.md` format is an open standard (`agentskills.io`) shared by both platforms.
  Symlinks eliminate duplication with zero risk of divergence.
- **Agents**: Frontmatter schemas are fundamentally different (tool format, model format, permission
  model). A transformation script would be fragile and hard to maintain. Separate files are explicit
  and auditable. The VS Code agent files can be kept minimal (description + tools only) while the
  OpenCode files carry the full permission and model configuration.

### What `sync.sh` must do (next task: MrSmith-j3p)

1. Copy `agents/*.md` → `~/.config/opencode/agents/` (existing behaviour)
2. Copy `skills/` → `~/.config/opencode/skills/` (existing behaviour)
3. Create/update symlinks: `.agents/skills/<name>` → `../../skills/<name>` for each skill dir
4. **Not** copy `.github/agents/` — VS Code reads that path directly from the workspace

---

## Risks

RISK-1: Symlink portability — symlinks may not work on Windows or in some CI environments.
Mitigation: document the assumption (Linux/macOS dev environment); add a `sync.sh` fallback that
copies instead of symlinks if `ln -s` fails.

RISK-2: Agent drift — OpenCode and VS Code agent files describe the same persona but diverge over
time. Mitigation: add a lint step (or `sync.sh` check) that verifies both files exist for each
agent and that `description` fields match.

RISK-3: `.github/agents/` naming collision — VS Code reads all `.md` files in `.github/agents/`,
not just `.agent.md`. If any OpenCode agent file is accidentally placed there it will be picked up
with wrong frontmatter. Mitigation: enforce `.agent.md` extension for VS Code files; add a
`sync.sh` guard that rejects `.md` files without `.agent.md` extension in that directory.

---

## Blind spots

BS-1: Claude `.claude/agents/` format — VS Code also supports `.claude/agents/*.md` with Claude
frontmatter (`name`, `description`, `tools` as comma-separated string). This format is closer to
OpenCode's but still not identical. Not addressed here; can be revisited if Claude-format agents
are needed.

BS-2: User-profile VS Code agents (`~/.copilot/agents/`) — out of scope for this repo; not
addressed.
