---
name: deviation-reporting
description: Rules for classifying and reporting deviations from a plan during implementation — breaking deviations require user approval, trivial deviations are self-executed and logged in a structured report at the end
license: MIT
compatibility: opencode
---

## Deviation rules

When following a plan, you may encounter opportunities to improve or cases where the plan is suboptimal.

**Before deviating, classify the deviation:**

- **Breaking deviation** — the change could break subsequent plan steps, introduce a logic inconsistency, change a public interface or exported symbol, alter data structures other code depends on, or have non-obvious downstream effects.
  - **Stop and ask the user** before implementing. State clearly: what you want to change, why, and what the risk is. Wait for approval.

- **Trivial deviation** — the change is purely local (e.g. a naming improvement, an idiomatic rewrite of a single expression, adding a missing error check or type annotation, extracting a small helper that does not change any interface). Subsequent steps are unaffected or can be trivially adjusted.
  - **Implement without asking.** Record the deviation for the final report.

**At the end of every implementation**, if any trivial deviations were made, append a numbered list in this exact format:

```
## Deviations from plan

DEVIATION-1: <what was changed> — <reason>
DEVIATION-2: <what was changed> — <reason>
...
```

If no deviations were made, omit the section entirely.
