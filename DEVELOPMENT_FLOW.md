# Changes to be made in the flow

Replace transiant files by beads issue. The developer must read the file doc/.transient/beads.md (this file should contain the beads id to work on - single issue or epic)

In the developper flow, we need to add the following steps:

In the concensus loop, all tests must pass, otherwise the tests must be fixed and the loop must be restarted. Once tests passes, we can move to the next beads

There should be an outer loop. Once beads have been implemented, we need to audit that they have been implemented in accordance with the requested features and documents.


# Changes to be made in the design flow
We need to discuss about the test plan.
Create small test for business logic that does not rely on I/O, clock, external services
Create some medium test for integration with a single I/O, clock, external services
Create at most 1 large test for integration with multiple I/O clock, external services

Separate the business logic from I/O or side effect logic for testing and creating a plugin architecture.
In the design we must then talk about architecture rules and test plan. -> we need to create two stantardized md file for that
We must also talk about the projects to be tested and compiled and which operations to perform to ensure a we test meaninful unit during beads implementation's loop.

We need to talk about constraints of the implementation -> constraints.md

We need to make sure we have all the right tools before implementing (last desing stage). Do we need to create specialized subagents for tasks during the implementation. Do we need to create
rules or skills? We need to design them so that we can add extra permission to that the implementation phase can be performed by an AI agent without any interruptions.

Following agents should use github copilot claude haiku 4.5 model. 
debug alayst, @story-mapper,  @design-* and planner have the 4.5 haiku model.

In agents.md we need to add a instruction to use the debug analyst whenever we are facing an implementation issue that is recurring or taks too much iteratio to solve. He should find the root cause analysis.
If the fix is trivial, the dev should proceed without user intervation. Sometimes, a pivot in strategy or plan or technology is required. In these case, ask the user for guidance.


# Feature Development Flow in MrSmith

This is the canonical beads-driven workflow implemented by the agents in this repository.

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
- **Agent:** `@design-story-mapper`
- **Purpose:** Identify actors, activities, tasks, and release tiers.
- **Output:** `doc/<id>.<title>/story-map.md` (optional).

---

## Stage 1 — Documentation & Design

### Stage 1a — Feature Documentation
- **Agent:** `@design-document-feature`
- **Outputs:**
  - `doc/<id>.<title>/requirements.md`
  - `doc/<id>.<title>/analysis.md`
  - `doc/<id>.<title>/architecture-rules.md`
  - `doc/<id>.<title>/test-plan.md`
  - `doc/<id>.<title>/constraints.md`
  - `doc/index.md` row update

#### Architecture rules contract (mandatory)
- Separate pure business logic from side-effect adapters.
- Keep I/O, clock/time, and external service calls outside business logic.
- Define plugin extension points and plugin interface contracts explicitly.
- Document dependency direction rules (allowed and forbidden).
- State testability implications of the chosen boundaries.

#### Test plan contract (mandatory)
- Test plan must define exactly three categories:
  - Small tests (pure business logic only; no I/O, no clock/time, no external service calls)
  - Medium tests (integration tests with exactly one boundary dependency)
  - Large tests (multi-boundary integration)
- Large tests are capped at **at most one** scenario per feature unless user explicitly overrides.
- Test plan must define execution order (small → medium → large) and pass criteria.

#### Constraints contract (mandatory)
- `constraints.md` must be produced during design stage and kept current.
- It must cover at least: functional, technical, operational, security/compliance, and delivery constraints.
- Constraints must be referenced during beads planning and per-bead implementation decisions.
- If a constraint blocks an implementation approach, planner/developer must record and select an alternative
  that remains within approved constraints.

### Stage 1b — Strategic Design Validation
- **Agent:** `@design-ddd-strategic`
- **Output:** `doc/<id>.<title>/strategic-design.md`
- **Focus:** bounded context, ubiquitous language, context map.

### Stage 1c — Feature Mapping
- **Agent:** `@design-feature-mapper`
- **Output:** `doc/<id>.<title>/feature-map.md`
- **Focus:** concrete examples that make behaviour testable.

### Stage 1d — Beads Planning (Last step of Phase 1)
- **Agent:** `@planner`
- **Inputs:**
  - `requirements.md`
  - `analysis.md`
  - `strategic-design.md`
  - `feature-map.md` (if present)
- **Responsibilities:**
  1. Reuse an existing feature epic when one exists.
  2. If no epic exists, create one to regroup implementation work.
  3. Create task beads in logical implementation order.
  4. Create dependency links between those tasks.
   5. Write `doc/.transient/beads.md` with exactly one ID:
      - epic ID for multi-task work, or
      - task ID for single-task work.

### Stage 1e — Implementation Readiness Gate (After planning, before consensus)
- **Orchestrator:** `@developer`
- **Inputs:**
  - `architecture-rules.md`
  - `test-plan.md`
  - `constraints.md`
  - planned beads chain from `doc/.transient/beads.md`
- **Responsibilities:**
  1. Confirm required tools for planned implementation are available.
  2. Confirm whether specialized subagents are needed for any bead.
  3. Confirm whether additional skills/rules are needed.
  4. Confirm required permissions are configured to avoid implementation interruption.
  5. Record readiness status and blockers before Stage 2 starts.

---

### Stage 2 — Consensus Loop (Up to 3 iterations)
- **Orchestrator:** `@developer`
- **Review chain (strict sequence):**
  1. `@dev-architect`
  2. `@dev-ddd`
  3. `@dev-tdd`
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
- Value must be either:
  - one task ID, or
  - one epic ID.

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
5. Run `@dev-audit-spec` against feature docs and requirements.
6. Move to next bead only after tests pass and audit passes.

#### Required compile/test operations source of truth
- The design-stage `test-plan.md` must include a **Project validation operations** table with:
  - project/component name,
  - build/compile command,
  - required test command(s),
  - scope notes.
- During per-bead implementation, `@developer` must execute/verify these operations as the hard gate.
- If a project does not require compile/build, the table must explicitly use `N/A`.

---

## 🎯 Key Principles Embedded in the Flow

1. **Specification-first:** acceptance tests are written before implementation completes.
2. **Outside-in:** DSL boundary first, domain logic behind it.
3. **Beads as execution queue:** implementation order is encoded in dependencies.
4. **Single control pointer:** one active task/epic in `doc/.transient/beads.md`.
5. **Hard test gates:** no progression while tests fail.
6. **Audit before advancement:** each bead is audited before moving forward.
7. **Consensus before coding:** design is reviewed by six lenses before implementation.

---

## 📁 Artifact Structure

```
doc/
├── index.md
├── <id>.<title>/
│   ├── requirements.md
│   ├── analysis.md
│   ├── architecture-rules.md
│   ├── test-plan.md
│   ├── constraints.md
│   ├── story-map.md                # optional
│   ├── strategic-design.md
│   ├── feature-map.md
│   ├── consensus.md
│   ├── decisions.md
│   ├── specifications.md
│   └── [acceptance tests + DSL stubs]
└── .transient/
    └── beads.md                    # exactly one task/epic ID
```

---

## 🚀 Starting a New Feature

### Simple feature
1. Run `@design-document-feature`
2. Run `@design-ddd-strategic`
3. Run `@design-feature-mapper`
4. Run `@planner` (epic/tasks/dependencies + `beads.md`)
5. Run Stage 1e readiness gate
6. Proceed to Stage 2

### Complex feature
1. Run `@design-story-mapper`
2. Run `@design-document-feature`
3. Run `@design-ddd-strategic`
4. Run `@design-feature-mapper`
5. Run `@planner` (epic/tasks/dependencies + `beads.md`)
6. Run Stage 1e readiness gate
7. Proceed to Stage 2

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

## Summary

This workflow is consensus-driven, test-gated, and beads-executed:
- design and decisions are documented first,
- execution order is encoded in beads dependencies,
- each bead must pass tests and audit before the next bead starts.
