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
  - `doc/index.md` row update

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
5. Proceed to Stage 2

### Complex feature
1. Run `@design-story-mapper`
2. Run `@design-document-feature`
3. Run `@design-ddd-strategic`
4. Run `@design-feature-mapper`
5. Run `@planner` (epic/tasks/dependencies + `beads.md`)
6. Proceed to Stage 2

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
