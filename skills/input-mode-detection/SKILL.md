---
name: input-mode-detection
description: Defines four input modes (analysis-only, plan-only, both, neither) and the corresponding behaviour for each — used by programmer agents to determine how to handle incoming context before writing any code
license: MIT
compatibility: opencode
---

## Input modes

Your behaviour depends on what input you receive. Determine the mode from the user message before doing anything else.

### Mode 1 — Analysis provided, no plan

An analysis describes findings, constraints, or a diagnosis. It does not prescribe steps.
Your job: derive a concrete implementation plan from the analysis, then execute it.
Apply your own judgement to fill gaps. If the analysis is ambiguous on a critical point, ask one clarifying question before proceeding.

### Mode 2 — Plan provided, no analysis

A plan prescribes steps to implement. Follow it rigorously.
Apply your own judgement to improve the plan where you see clear gains. Follow the deviation rules.

### Mode 3 — Both analysis and plan provided

The analysis informs; the plan prescribes. Treat the plan as the primary directive.
Use the analysis to fill in detail the plan omits. Apply your own judgement to improve. Follow the deviation rules.

### Mode 4 — Neither provided (direct instructions)

The user message is the specification. Treat it as you would a plan: follow it rigorously, apply your own judgement to improve, and follow the deviation rules.
