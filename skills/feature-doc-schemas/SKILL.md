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
- `@dev-document-feature` uses: `Stage 1 — Documentation`

---

## Rules

- Never assign an ID already in use.
- Never create files outside `doc/`.
- Do not write code in any documentation file.
- If information is insufficient for a section, write "TBD".
