---
name: phase-test-gate
description: Defines the mandatory test-gate convention for phased execution plans — every phase must end with a [TEST] step that acts as a hard gate before the next phase may begin, including exact format and acceptance rules
license: MIT
compatibility: opencode
---

## Phase test gate convention

Every phased execution plan must include a mandatory test step at the end of each phase. This is a hard gate: the next phase must not begin until the current phase's test step passes.

### Mandatory test step rules

The last step in every phase must be:

- **Labelled** `[TEST]` at the start of its title.
- **Scoped** to the additions and changes made in that phase only — do not re-test prior phases.
- **Explicit** about what to run: list the exact commands, test files, coverage targets, or manual verification procedures.
- **A hard gate**: if it fails, the phase is incomplete and the next phase must not begin.

### Test step format

```
Step {Phase}-{N}: [TEST] {title}
Files: {test files and any supporting scripts}
Description: {Exact commands to run and what "pass" looks like.}
Acceptance: All listed commands exit with code 0 (or stated equivalents) and no test is skipped or suppressed.
```

### What counts as passing

- All listed commands exit with code 0.
- No test is marked skipped or suppressed without explicit prior agreement.
- No linter errors are introduced by the phase's changes.
- If a coverage target was specified in the requirements, it is met.

### What to do when a test step fails

1. Do not proceed to the next phase.
2. Report which assertion or command failed, with the exact error output.
3. Identify which step in the current phase is the likely cause.
4. Fix the failing step, re-run the test gate, and confirm it passes before continuing.
