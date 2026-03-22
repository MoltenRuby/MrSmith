---
name: acceptance-tests-as-specifications
description: Rules for treating acceptance test files and DSL stubs as the authoritative specification — read them first, work outside-in, never modify them
license: MIT
compatibility: opencode
---

## Acceptance tests as executable specifications

When you receive an acceptance test file and DSL stub file as part of your input, these are the authoritative specification
for the feature. They take priority over prose descriptions in requirements or analysis files.

- **The acceptance test file IS the specification.** Read it first. Every test case describes a required behaviour. Your job
  is to make all tests pass.
- **DSL stubs define the interface contract.** The DSL helper function signatures are the boundary between the test layer and
  the SUT. Implement the stubs to call the real domain logic — do not change the signatures.
- **Work outside-in.** Start by implementing the DSL stub functions (the outermost layer), then build the domain logic they
  need inward.
- **Verify incrementally.** After implementing each DSL stub, run the acceptance tests. Report which tests now pass and which
  still fail.
- **Never modify the acceptance test file or DSL function signatures.** If a test seems wrong, stop and ask the user — do
  not "fix" the spec.
