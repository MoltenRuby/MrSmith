# Agent Instructions

This project uses **bd** (beads) for issue tracking.

**At the start of every new session or after context compaction, run:**
```bash
bd prime
```

## Quick Reference

```bash
bd ready              # Find available work
bd show <id>          # View issue details
bd update <id> --claim  # Claim work atomically
bd close <id>         # Complete work
bd dolt push          # Push beads data to remote
bd hooks install      # Install git hooks (run once after bd init)
```

## Setup (first time or new clone)

```bash
bd init               # Interactive (humans)
bd init --quiet       # Non-interactive (agents)
bd hooks install      # Install pre-commit / post-merge hooks
```

## Non-Interactive Shell Commands

**ALWAYS use non-interactive flags** with file operations to avoid hanging on confirmation prompts.

Shell commands like `cp`, `mv`, and `rm` may be aliased to include `-i` (interactive) mode on some systems, causing the agent to hang indefinitely waiting for y/n input.

**Use these forms instead:**
```bash
# Force overwrite without prompting
cp -f source dest           # NOT: cp source dest
mv -f source dest           # NOT: mv source dest
rm -f file                  # NOT: rm file

# For recursive operations
rm -rf directory            # NOT: rm -r directory
cp -rf source dest          # NOT: cp -r source dest
```

**Other commands that may prompt:**
- `scp` - use `-o BatchMode=yes` for non-interactive
- `ssh` - use `-o BatchMode=yes` to fail instead of prompting
- `apt-get` - use `-y` flag
- `brew` - use `HOMEBREW_NO_AUTO_UPDATE=1` env var

<!-- BEGIN BEADS INTEGRATION profile:full hash:d4f96305 -->
## Issue Tracking with bd (beads)

**IMPORTANT**: This project uses **bd (beads)** for ALL issue tracking. Do NOT use markdown TODOs, task lists, or other tracking methods.

### Why bd?

- Dependency-aware: Track blockers and relationships between issues
- Git-friendly: Dolt-powered version control with native sync
- Agent-optimized: JSON output, ready work detection, discovered-from links
- Prevents duplicate tracking systems and confusion

### Quick Start

**Check for ready work:**

```bash
bd ready --json
```

**Before creating an issue, check for duplicates:**

```bash
bd search "<keyword>" --json
```

**Create new issues:**

```bash
bd create "Issue title" --description="Detailed context" -t bug|feature|task -p 0-4 --json
bd create "Issue title" --description="What this issue is about" -p 1 --deps discovered-from:bd-123 --json

# Use stdin for descriptions with special characters (backticks, !, nested quotes)
echo 'Description with `backticks` and "quotes"' | bd create "Title" --description=- --json
```

**Claim and update:**

```bash
bd update <id> --claim --json
bd update bd-42 --priority 1 --json
```

**Complete work:**

```bash
bd close bd-42 --reason "Completed" --json
bd close bd-42 --suggest-next --json   # Also shows newly unblocked issues
```

### Issue Types

- `bug` - Something broken
- `feature` - New functionality
- `task` - Work item (tests, docs, refactoring)
- `epic` - Large feature with subtasks
- `chore` - Maintenance (dependencies, tooling)

### Priorities

- `0` - Critical (security, data loss, broken builds)
- `1` - High (major features, important bugs)
- `2` - Medium (default, nice-to-have)
- `3` - Low (polish, optimization)
- `4` - Backlog (future ideas)

### Workflow for AI Agents

1. **Check ready work**: `bd ready` shows unblocked issues
2. **Claim your task atomically**: `bd update <id> --claim`
3. **Work on it**: Implement, test, document
4. **Discover new work?** Create linked issue:
   - `bd create "Found bug" --description="Details about what was found" -p 1 --deps discovered-from:<parent-id>`
5. **Complete**: `bd close <id> --reason "Done" --suggest-next`

### Enriching issues as work progresses

As you learn more about a task, record it on the issue — do not rely on memory or inline comments.

**Update the current issue with new knowledge:**
```bash
bd update <id> --notes "discovered that X affects Y"     # set notes (replaces)
bd update <id> --append-notes "also: Z edge case found"  # append to existing notes
bd update <id> --design "approach: use pattern A not B"  # record design decisions
bd update <id> --acceptance "must handle empty input"    # refine acceptance criteria
```

**Store design content from files or stdin (for long text or special characters):**
```bash
echo 'Use `interface{}` not `any` for Go 1.17 compat' | bd update <id> --design-file -
```

**Capture knowledge that spans multiple sessions or issues:**
```bash
bd remember "always run tests with -race flag"           # project-level insight
bd remember "auth uses JWT, not sessions" --key auth     # with explicit key
bd memories <keyword>                                    # retrieve stored memories
```
Memories are injected automatically at `bd prime` time — they survive context compaction and account rotation.

**File discovered work as a linked issue:**
```bash
# Dependency types: discovered-from, caused-by, validates, supersedes, blocks, related
bd create "Found: X breaks under Y" -p 1 --deps discovered-from:<parent-id> --json
bd create "Tests for feature X" -p 2 --deps validates:<feature-id> --json
```

### Auto-Sync

bd automatically syncs via Dolt:

- Each write auto-commits to Dolt history
- Use `bd dolt push`/`bd dolt pull` for remote sync
- No manual export/import needed!

### Important Rules

- ✅ Use bd for ALL task tracking
- ✅ Always use `--json` flag for programmatic use
- ✅ Link discovered work with `discovered-from`
- ✅ Check `bd ready` before asking "what should I work on?"
- ✅ Include the issue ID in commit messages: `git commit -m "Fix thing (MrSmith-0e0)"`
- ❌ Do NOT use `bd edit` — it opens an interactive editor agents cannot use; use `bd update` with flags instead
- ❌ Do NOT create markdown TODO lists
- ❌ Do NOT use external issue trackers
- ❌ Do NOT duplicate tracking systems

For more details, see README.md and docs/QUICKSTART.md.

<!-- END BEADS INTEGRATION -->

## Troubleshooting

If bd behaves unexpectedly (hooks missing, database stale, sync errors):

```bash
bd doctor --agent --json    # self-diagnosable output with exact remediation commands
bd doctor --fix             # automatically fix detected issues
```

## Landing the Plane (Session Completion)

**When ending a work session**, you MUST complete ALL steps below. Work is NOT complete until `git push` succeeds.

**MANDATORY WORKFLOW:**

1. **File issues for remaining work** - Create issues for anything that needs follow-up
2. **Run quality gates** (if code changed) - Tests, linters, builds
3. **Update issue status** - Close finished work, update in-progress items
4. **PUSH TO REMOTE** - This is MANDATORY:
   ```bash
   git pull --rebase
   bd dolt push
   git push
   git status  # MUST show "up to date with origin"
   ```
5. **Clean up** - Clear stashes, prune remote branches
6. **Verify** - All changes committed AND pushed
7. **Hand off** - Provide context for next session

**CRITICAL RULES:**
- Work is NOT complete until `git push` succeeds
- NEVER stop before pushing - that leaves work stranded locally
- NEVER say "ready to push when you are" - YOU must push
- If push fails, resolve and retry until it succeeds
