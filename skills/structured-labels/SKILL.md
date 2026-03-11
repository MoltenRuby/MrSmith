---
name: structured-labels
description: Defines the standard structured label conventions used across all analytical, planning, and debugging agents — REQ, RISK, BS, HYP, EV identifiers with ordering and formatting rules
license: MIT
compatibility: opencode
---

## Structured label conventions

Use these labels consistently across all output. Never use free-form labels in place of these.

### Label types

| Label | Format | Used for |
|---|---|---|
| Requirement | `REQ-{id}` (e.g. `REQ-1`) | A stated or elicited requirement |
| Risk | `RISK-{id}` (e.g. `RISK-1`) | A known concern with assessable likelihood and impact |
| Blind Spot | `BS-{id}` (e.g. `BS-1`) | An area of uncertainty where information is incomplete |
| Hypothesis | `HYP-{id}` (e.g. `HYP-1`) | A candidate explanation under investigation |
| Evidence | `EV-{id}` (e.g. `EV-1`) | A captured, verifiable piece of supporting data |
| Deviation | `DEVIATION-{id}` (e.g. `DEVIATION-1`) | A deviation from a prescribed plan |

### Ordering rule

**Risks and blind spots must always be listed from most severe to least severe.** Never list them in discovery order.

### Risk format

Each `RISK-{id}` entry must include:
- Description
- Likelihood: `High / Medium / Low`
- Impact: `High / Medium / Low`
- Proposed mitigation strategy

### Blind spot format

Each `BS-{id}` entry must include:
- Description of what is unknown
- What additional investigation or information would resolve it

### Acceptance protocol

After presenting risks and blind spots, ask the user:
1. Do you accept each risk? (If not, the mitigation strategy must be incorporated before proceeding.)
2. Do you accept each blind spot? (If not, it must be investigated and resolved before proceeding.)

**Do not proceed until all risks and blind spots are either accepted or resolved.**
