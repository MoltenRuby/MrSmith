# MrSmith

A version-controlled repository of custom [opencode](https://opencode.ai) artefacts — agents, skills, commands, and rules. Changes made here are applied to the local opencode installation via a sync script.

---

## Repository structure

```
MrSmith/
├── agents/          # Custom agents (.md files, one per agent)
├── skills/          # Reusable skill packs (<name>/SKILL.md)
├── commands/        # Slash-command prompt templates (.md files)
├── AGENTS.md        # Global rules — always-on context for every session
├── sync.sh          # Sync script (see Usage below)
└── README.md
```

### Artefact types

| Type | Directory | Loaded by opencode from |
|---|---|---|
| **Agent** | `agents/<name>.md` | `~/.config/opencode/agents/` |
| **Skill** | `skills/<name>/SKILL.md` | `~/.config/opencode/skills/` |
| **Command** | `commands/<name>.md` | `~/.config/opencode/commands/` |
| **Rule** | `AGENTS.md` (repo root) | `~/.config/opencode/AGENTS.md` |

---

## Adding a new artefact

### Agent

1. Create `agents/<name>.md` with the required frontmatter:
   ```markdown
   ---
   description: "Short description shown in @ autocomplete"
   ---
   Your agent instructions here.
   ```
2. Run `./sync.sh` to install it.

### Skill

1. Create `skills/<name>/SKILL.md` with the required frontmatter:
   ```markdown
   ---
   name: your-skill-name
   description: "When and why to load this skill"
   ---
   Skill content here.
   ```
   The directory name must match the `name` field (`^[a-z0-9]+(-[a-z0-9]+)*$`).
2. Run `./sync.sh` to install it.

### Command

1. Create `commands/<name>.md` with the required frontmatter:
   ```markdown
   ---
   description: "Shown in TUI autocomplete"
   ---
   Your prompt template here. Use $ARGUMENTS for user-supplied input.
   ```
2. Run `./sync.sh` to install it. Invoke it in opencode with `/<name>`.

### Rule (global context)

1. Edit `AGENTS.md` in the repo root.
2. Run `./sync.sh` to apply the change.

---

## Usage

```bash
# From the repo root, apply all artefacts to ~/.config/opencode/
./sync.sh
```

The script performs a **merge**: it copies new and updated files into `~/.config/opencode/` but leaves any files already there that are not tracked in this repo untouched. Files that are identical are skipped.

The script prints a per-file summary and a final count of copied vs. skipped files.

---

## Syncing to a new machine

1. Clone this repository.
2. Run `./sync.sh` to populate `~/.config/opencode/` with all artefacts.
