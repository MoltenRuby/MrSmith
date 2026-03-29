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
- Prefer the native `grep` tool over shell `grep` for content search; prefer `glob` over shell `find`

---

## Test Design

### No tautological tests

A tautological test asserts the implementation rather than the behaviour. It has no diagnostic value
and breaks when code is restructured even if behaviour is unchanged.

Forbidden patterns:

- Asserting a mock was called when the call is an internal detail, not an observable output or
  boundary side-effect (e.g. `mock.assert_called_once_with(...)`, `expect(spy).toHaveBeenCalledWith(...)`)
- Asserting return values that merely echo constructor arguments with no transformation
- Tests whose only assertion is the absence of an exception thrown by a mock

Required: every test must assert observable behaviour — a return value, a visible state change, an
event emitted, or a boundary call that constitutes the feature's contract.

### Mocks only at architectural boundaries

Mocks, stubs, and spies are legitimate **only** at architectural boundaries — points where code
crosses out of the process or into infrastructure it does not own.

Mock here (approved boundaries):

- **I/O** — file system reads/writes, stdin/stdout/stderr
- **CLI** — subprocess invocations, shell commands
- **Network / web service calls** — HTTP clients, gRPC stubs, WebSocket connections
- **Databases / data access** — SQL, NoSQL, ORM sessions, query builders
- **Message queues / event buses** — Kafka, RabbitMQ, SQS, pub/sub producers/consumers
- **Clock / time** — `datetime.now()`, `Date.now()`, `time.time()`, system timers
- **Randomness** — `random`, `uuid`, `crypto.randomBytes`, any non-deterministic value source
- **External services** — payment gateways, email senders, SMS providers, third-party APIs

Do not mock:

- Domain services, use cases, application services
- In-process repositories backed by in-memory data structures — use a real in-memory fake instead
- Pure functions and value objects
- Internal collaborators within the same module or package

### Fakes over mocks

When a dependency is an interface or abstract type, provide a concrete in-memory fake that satisfies
the contract. Fakes are first-class code: tested, interface-enforcing, and enabling fast integration
tests without mocks.

### No monkey-patching of internal collaborators

Do not use patching/monkey-patching (e.g. `unittest.mock.patch`, `jest.spyOn`, `sinon.stub`) to
replace non-boundary collaborators. This creates invisible coupling between tests and implementation.

---

---

## Agent Autonomy & Permissions

All agents inherit centralized permission defaults from `.opencode/opencode.json`:

### Safe operations (auto-allow)

Agents execute these without prompting:

- **Issue tracking**: `bd *`
- **Git**: read ops (`status`, `log`, `diff`, `show`, `branch`, `fetch`, `blame`, `grep`, `stash`, `tag`, `ls-files`, `describe`, `shortlog`, `rev-parse`, `reflog`); write ops (`commit`, `add`, `merge`, `rebase`)
- **Package managers**: `npm install`, `npm run`, `npm test`, `npm build`; `yarn *`; `pip install`; `cargo build`, `cargo test`, `cargo check`
- **Build**: `make *`
- **File navigation**: `ls`, `pwd`, `which`, `find`, `grep`
- **HTTP**: `curl -X GET`, `curl -X HEAD`, `curl -X OPTIONS`, `curl -s`, `curl -i`, `curl -I`, `curl -L`, `curl -H`, `curl -A`, `curl -b`, `curl -u`, `curl --*` (read-only; no POST/PUT/DELETE/PATCH)
- **File operations**: `mkdir -p`, `cp -f`, `mv -f` (non-destructive)

### Gated operations (ask-first)

All other bash commands require user approval. This includes:

- Destructive operations: `rm`, `rm -rf`
- Remote git writes: `git push`, `git push --force`
- System commands with side effects

### Per-agent overrides

Individual agents may override these defaults in their frontmatter `permission` field. For example, `plan` agent may deny `edit` globally while `build` allows it.

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
- ✅ For feature execution loops, use `doc/.transient/beads.md` as the control pointer
- ✅ `doc/.transient/beads.md` must contain exactly one non-empty ID (task or epic)
- ✅ If the ID is a task, it must be ready/unblocked before implementation begins
- ✅ If the ID is an epic, pick ready child tasks by priority first (`0` highest), then stable ID
- ✅ Do not move to next bead until current bead passes required tests and spec audit
- ✅ If implementation is blocked by a recurring/high-iteration issue, invoke `@debug-analyst` for root-cause analysis
- ✅ If the resulting fix is trivial, proceed without additional user intervention
- ✅ If resolution requires a pivot in strategy, plan, or technology, stop and ask the user for guidance
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
