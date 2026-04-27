---
name: feature-doc-schemas
description: Canonical schemas for requirements.md, analysis.md, SOP.md, acceptance-criteria.md, and doc/index.md — exact structure, section headings, and field formats required by the feature documentation workflow
license: MIT
compatibility: opencode
---

## requirements.md schema

Write `doc/<id>.<title>/requirements.md` using this exact structure:

```
# Requirements: <Human-readable title>

## Status
New | In Progress | Updated

## Requirements

### REQ-1: <requirement title>
**Summary:** <one sentence>
**Acceptance criteria:**
- <criterion 1>
- <criterion 2>

### REQ-2: ...

## Open questions
<List any unresolved questions about scope or constraints. Remove this section if none.>
```

---

## analysis.md schema

Write `doc/<id>.<title>/analysis.md` using this exact structure:

```
# Analysis: <Human-readable title>

## Summary
<One paragraph describing what this feature does and why it exists.>

## Technical approach
<Describe the key technical approach, components involved, and major decisions. Do not write code. 2–5 paragraphs.>

## Components involved
- <component 1>: <role>
- <component 2>: <role>

## Open questions
<List any unresolved technical questions. Remove this section if none.>
```

---

## architecture-rules.md schema

Write `doc/<id>.<title>/architecture-rules.md` using this exact structure:

```
# Architecture Rules: <Human-readable title>

## Purpose
<One sentence describing why these architecture rules exist for this feature.>

## Boundary separation rules
- Business logic:
  - <Rule describing what pure business logic can contain>
  - <Rule describing what pure business logic cannot depend on>
- Side-effect adapters:
  - <Rule describing adapter responsibility for I/O, clock, external services>
  - <Rule describing how adapters expose capabilities to business logic>

## Plugin architecture rules
- <Rule describing extension points>
- <Rule describing plugin interface contracts>
- <Rule describing plugin registration/discovery constraints>

## Dependency direction rules
- Allowed:
  - <Allowed dependency direction>
- Forbidden:
  - <Forbidden dependency direction>

## Verification checklist
- [ ] Business logic has no direct I/O calls.
- [ ] Business logic has no direct clock/time calls.
- [ ] Business logic has no direct external service calls.
- [ ] Side-effect adapters are isolated behind clear interfaces/ports.
- [ ] Plugin extension points and contracts are documented.
```

---

## test-plan.md schema

Write `doc/<id>.<title>/test-plan.md` using this exact structure:

```
# Test Plan: <Human-readable title>

## Scope
<One paragraph describing what behaviour this plan validates.>

## Small tests (pure business logic)
**Goal:** <What pure logic is validated>
**Constraints:**
- No I/O
- No clock/time dependency
- No external services
**Target units:**
- <unit 1>

## Medium tests (single boundary integration)
**Goal:** <What single-boundary integration is validated>
**Constraints:**
- Exactly one boundary dependency per test (I/O or clock or external service)
**Target integrations:**
- <integration 1>

## Large tests (multi-boundary integration)
**Goal:** <What end-to-end slice is validated>
**Constraints:**
- At most 1 large test scenario for this feature
- May combine multiple boundary dependencies
**Target integration scenario:**
- <scenario 1>

## Execution order
1. Run small tests
2. Run medium tests
3. Run large tests

## Pass criteria
- <criterion 1>
- <criterion 2>

## Project validation operations (implementation loop)
| Project/Component | Build/Compile command | Test command(s) | Notes |
|---|---|---|---|
| <project or component> | <command or N/A> | <comma-separated commands> | <scope/intent> |
```

---

## constraints.md schema

Write `doc/<id>.<title>/constraints.md` using this exact structure:

```
# Constraints: <Human-readable title>

## Functional constraints
- <Constraint>

## Technical constraints
- <Constraint>

## Operational constraints
- <Constraint>

## Security and compliance constraints
- <Constraint>

## Delivery constraints
- <Constraint>

## Open questions
- <Question>
```

---

## SOP.md schema

Write `doc/<id>.<title>/SOP.md` using this exact structure:

```
# Environment Standard Operating Procedures (SOP)

**Feature:** `<feature-id>.<title>`
**Status:** draft

## Services required

| Service | Type | Container name pattern | Internal port | External port |
|---------|------|----------------------|---------------|---------------|
| <service name> | <e.g. PostgreSQL, Redis> | <feature-id>-<service>-<tier> | <port> | TBD |

## Environment variables

| Variable | Service | Purpose | Required |
|----------|---------|---------|----------|
| `<FEATURE_ID>_<SERVICE>_<SETTING>` | <service> | <purpose> | yes/no |

## Deployment targets

- Development: `docker-compose.<feature-id>.yml` (TBD)
- Testing: TBD
- Production: TBD

## Tool restrictions

Agents working on this feature MUST NOT run database CLI tools (psql, mysql, redis-cli) directly
on the host. Use `docker exec` or container-based clients only.

## Validation checklist

- [ ] All service names follow `<feature-id>-<service>-<tier>` pattern
- [ ] All environment variables follow `<FEATURE_ID>_*` prefix
- [ ] Secrets are NOT committed to Git
```

**Schema rules:**

- `Status` must be `draft` on creation. Only mark `active` after the full Docker Compose stack is
  operational.
- Services table is required. If no services are known at design time, add one row with all values
  as TBD.
- Deployment targets section is required. Use TBD for unknown targets.
- Tool restrictions section is required verbatim.
- Validation checklist is required verbatim.

---

## acceptance-criteria.md schema

Write `doc/<id>.<title>/acceptance-criteria.md` using this exact structure:

```
# Acceptance Criteria: <Human-readable title>

## Business Criteria

**Feature is complete when:**
- <outcome 1 — concrete, measurable>
- <outcome 2 — concrete, measurable>

**In-scope:**
- <behaviour 1>
- <behaviour 2>

**Out-of-scope:**
- <explicitly excluded behaviour 1>
- <explicitly excluded behaviour 2>

## Environment Requirements

**Services required:**
- <service 1> (from SOP.md)
- <service 2>

**Deployment targets:**
- Development: <Docker Compose file reference>
- Testing: <testing environment reference>
- Production: <if applicable>

**Setup time estimate:** <X minutes>

**Validation:**
- [ ] All services from SOP.md validation checklist pass
- [ ] Network connectivity verified
- [ ] Credentials/secrets loaded

## Technical Criteria

**Performance:**
- <measurable performance criterion 1>

**Reliability:**
- <reliability criterion 1 — error handling, retries, etc.>

**Security:**
- <security criterion 1 — from constraints.md>

**Scalability/Capacity:**
- <criterion if applicable>

**Other technical requirements:**
- <criterion>

## Test Scenarios

| # | Scenario | Given | When | Then | Priority | Notes |
|---|----------|-------|------|------|----------|-------|
| 1 | <concrete example from feature-map> | <precondition> | <action> | <expected outcome> | must-have | <rationale or reference> |
| 2 | ... | ... | ... | ... | ... | ... |

**Scenario sourcing:**
- All scenarios are derived from concrete examples in `feature-map.md`
- Each scenario includes specific values (not placeholders)
- Priority levels: must-have, should-have, nice-to-have

## Tool & Library Requirements

**Testing framework:**
- <pytest, vitest, jest, etc.>

**Test fixtures:**
- <fixture 1 from SOP — e.g., database container setup>
- <fixture 2>

**Mocking strategy:**
- <from architecture-rules.md — which boundaries are mocked>

**CI/CD requirements:**
- <build/test commands to validate>
- <required environment for pipeline>

## Validation Checklist

Before declaring acceptance criteria complete:

- [ ] All REQ-* from `requirements.md` covered by scenarios
- [ ] All concrete examples from `feature-map.md` have test scenarios
- [ ] All SOP.md environment setup requirements are testable
- [ ] All technical criteria from test-plan.md are included
- [ ] All security/compliance constraints from constraints.md are included
- [ ] Scenarios use concrete values (no placeholders)
- [ ] Each scenario is independently readable
- [ ] Reviewers agree on criteria completeness before consensus stage

---
```

---

## doc/index.md schema

If `doc/index.md` does not exist, create it with this structure first:

```
# Feature Index

| ID | Feature | Status | Summary | Consensus | Open questions | Last updated | Current stage |
|---|---|---|---|---|---|---|---|
```

The row format for each feature entry is:

```
| <id> | [<title>](doc/<id>.<title>/) | <status> | <one-line summary> | PENDING | 0 | <today's date> | <stage label> |
```

The stage label is determined by the calling agent:
- `@analyst` uses: `Stage 1b — Strategic Design Validation`
- `@design-document-feature` uses: `Stage 1 — Documentation`
- `@design-acceptance-criteria` uses: `Stage 1f — Acceptance Criteria`

---

## Rules

- Never assign an ID already in use.
- Never create files outside `doc/`.
- Do not write code in any documentation file.
- If information is insufficient for a section, write "TBD".
