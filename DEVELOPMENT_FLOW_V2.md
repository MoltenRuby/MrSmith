# Feature Development Flow in MrSmith — Version 2

This is the canonical beads-driven workflow implemented by the agents in this repository. This document represents the **current state** after implementing the design-flow hardening epic (MrSmith-umk).

**Version 2 changes from Version 1:**
- Mandatory three-tier test plan strategy (small/medium/large)
- Mandatory architecture-rules and constraints artefacts
- Explicit Stage 1e Implementation Readiness Gate
- Required project validation operations in test-plan.md
- Agent model migrations to claude-haiku-4.5
- Debug-analyst escalation policy in AGENTS.md

---

## 🔄 Full Development Pipeline

```
[Stage 0]          [Stage 1a]          [Stage 1b]            [Stage 1c]
User Request ────→ Story Mapping ────→ Documentation ──────→ Strategic Design ──────→
Feature Mapping
@design-story-     (optional)          @design-document-      @design-ddd-            
@design-feature-
mapper                                 feature                 strategic               
mapper

                                              [Stage 1d]
                                              Beads Planning
                                              @planner
                                              - create/reuse epic
                                              - create ordered task beads
                                              - link dependencies
                                              - write doc/.transient/beads.md

                                              [Stage 1e]
                                              Implementation Readiness Gate
                                              @developer
                                              - tools/subagents/skills/rules/permissions check

                    [Stage 2 Loop]      [Stage 3]             [Stage 4]
                     Consensus Review ─→ Decisions ──────────→ ATDD
                     (6 reviewers)        Recording             (Scenarios → DSL → Tests)

                                                       [Stage 5 Loop]
                                                       Beads-driven Implementation +
                                                       Audit
                                                       @developer + @programmer-* +
                                                       @dev-audit-spec
```

---

## 📋 Detailed Stage Breakdown

### Stage 0 — Story Mapping (Optional, User-Driven)
- **Agent:** `@design-story-mapper` (model: `github-copilot/claude-haiku-4.5`)
- **Purpose:** Identify actors, activities, tasks, and release tiers.
- **Output:** `doc/<id>.<title>/story-map.md` (optional).

---

## Stage 1 — Documentation & Design

### Stage 1a — Feature Documentation
- **Agent:** `@design-document-feature` (model: `github-copilot/claude-haiku-4.5`)
- **Outputs:**
  - `doc/<id>.<title>/requirements.md`
  - `doc/<id>.<title>/analysis.md`
  - `doc/<id>.<title>/architecture-rules.md` ← **NEW (mandatory)**
  - `doc/<id>.<title>/test-plan.md` ← **NEW (mandatory)**
  - `doc/<id>.<title>/constraints.md` ← **NEW (mandatory)**
  - `doc/index.md` row update

#### Architecture rules contract (mandatory)
- Separate pure business logic from side-effect adapters.
- Keep I/O, clock/time, and external service calls outside business logic.
- Define plugin extension points and plugin interface contracts explicitly.
- Document dependency direction rules (allowed and forbidden).
- State testability implications of the chosen boundaries.

#### Test plan contract (mandatory)
- Test plan must define exactly three tiers:
  - **Small tests:** pure business logic only; no I/O, no clock/time, no external service calls
  - **Medium tests:** integration tests with exactly one boundary dependency (I/O or clock or external service)
  - **Large tests:** multi-boundary integration (capped at **at most one** scenario per feature unless user explicitly overrides)
- Test plan must define execution order (small → medium → large) and pass criteria.
- Test plan must include a **Project validation operations** table with:
  - project/component name
  - build/compile command (or `N/A`)
  - required test command(s)
  - scope notes

#### Constraints contract (mandatory)
- `constraints.md` must be produced during design stage and kept current.
- Must cover at least: functional, technical, operational, security/compliance, and delivery constraints.
- Constraints must be referenced during beads planning and per-bead implementation decisions.
- If a constraint blocks an implementation approach, planner/developer must record and select an alternative that remains within approved constraints.

### Stage 1b — Strategic Design Validation
- **Agent:** `@design-ddd-strategic` (model: `github-copilot/claude-haiku-4.5`)
- **Output:** `doc/<id>.<title>/strategic-design.md`
- **Focus:** bounded context, ubiquitous language, context map.
- **Mandatory workshop addition:** Architecture boundary rules (before writing file):
  1. Which parts are pure business logic (I/O-free)?
  2. Which adapters own side effects and through which interfaces?
  3. What plugin extension points and contracts?
  4. What dependency directions allowed/forbidden?

### Stage 1c — Feature Mapping
- **Agent:** `@design-feature-mapper` (model: `github-copilot/claude-haiku-4.5`)
- **Output:** `doc/<id>.<title>/feature-map.md`
- **Focus:** concrete examples that make behaviour testable.

### Stage 1d — Beads Planning
- **Agent:** `@planner` (model: `github-copilot/claude-haiku-4.5`)
- **Mandatory inputs:**
  1. `requirements.md`
  2. `analysis.md`
  3. `strategic-design.md`
  4. `feature-map.md` (if present)
  5. `constraints.md` (required) ← **NEW**
- **Responsibilities:**
  1. Reuse an existing feature epic when one exists.
  2. If no epic exists, create one to regroup implementation work.
  3. Create task beads in logical implementation order.
  4. Create dependency links between tasks.
  5. Write `doc/.transient/beads.md` with exactly one ID (epic ID for multi-task, task ID for single-task).
- **Constraint-aware planning:** If `constraints.md` rules out an implementation path, do not create tasks for that path.

### Stage 1e — Implementation Readiness Gate (NEW)
- **Orchestrator:** `@developer`
- **Mandatory checks before proceeding to Stage 2:**
  1. Confirm required tools for planned implementation are available.
  2. Confirm whether specialized subagents are needed for any bead.
  3. Confirm whether additional skills/rules are needed.
  4. Confirm required permissions are configured to avoid implementation interruption.
  5. Record readiness status and blockers.
- **If any readiness blocker exists:** present blockers to user and stop until resolved.

---

### Stage 2 — Consensus Loop (Up to 3 iterations)
- **Orchestrator:** `@developer`
- **Review chain (strict sequence):**
  1. `@dev-architect`
  2. `@dev-ddd`
  3. `@dev-tdd` (with new design-flow test-plan conformance checks)
  4. `@dev-doomsayer`
  5. `@dev-operations`
  6. `@dev-solid`
- **Output:** `doc/<id>.<title>/consensus.md`
- **Success criteria:** at least 5/6 reviewers agree.
- **Failure mode:** fix design issues and retry; max 3 iterations unless user overrides.
- **Hard gate:** all required tests must pass at the end of each consensus iteration.
- **If tests fail:** fix tests and restart the current consensus loop iteration.

---

### Stage 3 — Decision Recording
- **Agent:** `@dev-decisions`
- **Output:** `doc/<id>.<title>/decisions.md`
- **Content:** architectural decision records (what, why, rejected alternatives).

---

### Stage 4 — ATDD (Acceptance Test Driven Development)
- **Agent:** `@dev-atdd`
- **Sub-steps with user gates:**
  - **4a:** Scenario specification → `specifications.md`
  - **4b:** DSL signatures proposal (approval gate)
  - **4c:** Runnable acceptance tests + DSL stubs
- **Constraint:** DSL signatures are fixed after approval.

---

### Stage 5 — Beads-driven Implementation & Audit Loop
- **Orchestrator:** `@developer`
- **Implementers:** `@programmer-ts`, `@programmer-python`, or `@programmer`
- **Audit:** `@dev-audit-spec`
- **Control file:** `doc/.transient/beads.md`

#### `doc/.transient/beads.md` contract
- Exactly one non-empty line.
- Value must be either: one task ID or one epic ID.

#### Bead selection rules
1. If the ID is a **task**:
   - the task must be ready/unblocked before implementation starts.
2. If the ID is an **epic**:
   - select ready/unblocked child tasks only,
   - pick highest priority first (`0` highest),
   - break ties with stable issue ID ordering.

#### Outer loop (per bead)
For each selected bead:
1. Implement against approved acceptance tests and DSL stubs.
2. Run implementation review chain.
3. Enforce hard test gate:
   - all required tests pass,
   - no skipped/suppressed tests.
4. If tests fail in the reviewer processing for that bead:
   - fix tests,
   - restart the **current reviewer loop** for that bead.
5. **Execute required compile/test operations** from `test-plan.md`:
   - Read the feature's `test-plan.md` and locate the `Project validation operations` table.
   - Every listed build/compile command must be executed unless marked `N/A`.
   - Every listed test command must be executed.
   - If any command fails, fix and rerun according to the current bead reviewer loop rules.
   - Do not mark bead complete until all required operations succeed.
6. Run `@dev-audit-spec` against feature docs and requirements.
7. Move to next bead only after tests pass and audit passes.

---

## 🎯 Key Principles Embedded in the Flow

1. **Specification-first:** acceptance tests are written before implementation completes.
2. **Outside-in:** DSL boundary first, domain logic behind it.
3. **Beads as execution queue:** implementation order is encoded in dependencies.
4. **Single control pointer:** one active task/epic in `doc/.transient/beads.md`.
5. **Hard test gates:** no progression while tests fail.
6. **Audit before advancement:** each bead is audited before moving forward.
7. **Consensus before coding:** design is reviewed by six lenses before implementation.
8. **Business logic isolation:** pure logic separated from side effects for deterministic testing. ← **NEW**
9. **Three-tier test strategy:** small (pure), medium (single boundary), large (multi-boundary, capped). ← **NEW**
10. **Constraint-aware planning:** implementation paths ruled out by constraints are not created. ← **NEW**

---

## 📁 Artifact Structure

```
doc/
├── index.md
├── <id>.<title>/
│   ├── requirements.md
│   ├── analysis.md
│   ├── architecture-rules.md               # NEW: mandatory in Stage 1a
│   ├── test-plan.md                        # NEW: mandatory in Stage 1a
│   │   └── [Project validation operations] # NEW table in test-plan
│   ├── constraints.md                      # NEW: mandatory in Stage 1a
│   ├── story-map.md                        # optional
│   ├── strategic-design.md
│   ├── feature-map.md
│   ├── consensus.md
│   ├── decisions.md
│   ├── specifications.md
│   └── [acceptance tests + DSL stubs]
└── .transient/
    └── beads.md                            # exactly one task/epic ID
```

---

## 🚀 Starting a New Feature

### Simple feature
1. Run `@design-document-feature` → produces architecture-rules, test-plan, constraints
2. Run `@design-ddd-strategic` (with mandatory architecture boundary questions)
3. Run `@design-feature-mapper`
4. Run `@planner` (epic/tasks/dependencies + `beads.md`)
5. Run Stage 1e readiness gate
6. Proceed to Stage 2 (consensus)

### Complex feature
1. Run `@design-story-mapper`
2. Run `@design-document-feature` → produces architecture-rules, test-plan, constraints
3. Run `@design-ddd-strategic` (with mandatory architecture boundary questions)
4. Run `@design-feature-mapper`
5. Run `@planner` (epic/tasks/dependencies + `beads.md`)
6. Run Stage 1e readiness gate
7. Proceed to Stage 2 (consensus)

Then `@developer` orchestrates Stage 2 through Stage 5.

---

## 💾 Quality Gates & Deployment

At session end (mandatory):
1. File remaining work as `bd` issues
2. Run linting (Markdown, YAML frontmatter, Bash)
3. Update `bd` status
4. Push to remote:
   ```bash
   git pull --rebase
   bd dolt push
   git push
   git status  # MUST show "up to date with origin"
   ```

---

## 🔧 Agent Configuration Changes (V2)

The following agents now use model: `github-copilot/claude-haiku-4.5`
- `debug-analyst` (formerly no model specified)
- `design-story-mapper` (was: `github-copilot/claude-sonnet-4.6`)
- `design-document-feature` (was: `github-copilot/claude-sonnet-4.6`)
- `design-ddd-strategic` (was: `github-copilot/claude-sonnet-4.6`)
- `design-feature-mapper` (was: `github-copilot/claude-sonnet-4.6`)
- `planner` (was: `anthropic/claude-sonnet-4-6`)

---

## 📜 AGENTS.md Debug-Analyst Policy (V2 NEW)

The following rules are now mandatory in `AGENTS.md`:
- If implementation is blocked by a recurring/high-iteration issue, invoke `@debug-analyst` for root-cause analysis.
- If the resulting fix is trivial, proceed without additional user intervention.
- If resolution requires a pivot in strategy, plan, or technology, stop and ask the user for guidance.

---

## Summary

This workflow is **consensus-driven, test-gated, constraint-aware, and beads-executed:**
- design and decisions are documented first with mandatory architecture, test, and constraint artefacts,
- execution order is encoded in beads dependencies,
- test strategy is formalized with three tiers enforcing business-logic isolation,
- implementation readiness is verified before consensus begins,
- each bead must pass tests, validate compile/test operations, and audit before the next bead starts.

---

## Change Log — V2 (MrSmith-umk)

| Bead | Description | Output |
|---|---|---|
| MrSmith-umk.4 | Canonical artefact schemas | architecture-rules.md, test-plan.md, constraints.md schemas in feature-doc-schemas skill |
| MrSmith-umk.1 | Architecture separation rules | Mandatory boundary separation guidance in design flow and design-ddd-strategic workshop |
| MrSmith-umk.2 | Test plan strategy | Three-tier (small/medium/large) test strategy with constraints in flow and dev-tdd reviewer |
| MrSmith-umk.3 | Compile/test operations | Project validation operations table schema in test-plan, developer hard-gate enforcement |
| MrSmith-umk.5 | Constraints governance | Constraints contract, required planner input, constraint-aware planning rules |
| MrSmith-umk.7 | Readiness gate | Stage 1e explicit gate in flow and developer orchestrator with checklist |
| MrSmith-umk.6 | Model migration | All 6 design/debug/planner agents migrated to claude-haiku-4.5 |
| MrSmith-umk.8 | Debug escalation policy | AGENTS.md rules for debug-analyst, trivial-fix autonomy, pivot guidance |
| MrSmith-3mu | Flow artifact alignment | Analyst/developer agents updated with new artefact references |

---

Generated: 2026-03-29
Epic: MrSmith-umk (closed)
Version: 2 (current)
