---
name: feature-doc-schemas
description: Canonical schemas for requirements.md, analysis.md, and doc/index.md — exact structure, section headings, and field formats required by the feature documentation workflow
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

---

## Rules

- Never assign an ID already in use.
- Never create files outside `doc/`.
- Do not write code in any documentation file.
- If information is insufficient for a section, write "TBD".
