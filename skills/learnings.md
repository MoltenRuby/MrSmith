When running the desing agent, he told me everything was completed. Yet, when I got to the dev agent, he told me some documents were missing. The design agent should guide the user through the whol process.
We need to revise the design agent instructionsé

I can’t proceed to implementation yet because the required stage-gate inputs are missing from the repository.
I started as requested (“1” → continue), ran session priming (bd prime --json), validated the current control file (doc/.transient/beads.md = LoadedGunn-pcf), and checked the feature docs folder.
Blocker (Stage 0 hard stop)
For feature 002.ephemeris-database-design, these required files are not present:
- doc/002.ephemeris-database-design/story-map.md  ← required by Stage 0
- strategic-design.md
- feature-map.md
- architecture-rules.md
- test-plan.md
- SOP.md
- consensus.md
- decisions.md
- specifications.md
- acceptance test artefacts/DSL stubs
Per the orchestrator workflow, I must stop at Stage 0 if story-map.md is absent/invalid and ask you to run @design-story-mapper.
What I updated
To keep stage state compliant while blocked, I synced:
- doc/index.md feature 002 current stage → Stage 1 — Documentation
What I need from you
Please confirm one of the following:
1. Run @design-story-mapper for feature 002 and generate story-map.md (recommended), then tell me to continue.
2. If those artefacts already exist under different paths/names, share the exact paths so I can validate and proceed.
3. If you want me to generate the missing docs via the designated agents (design-story-mapper, design-document-feature, etc.), say “generate them now” and I’ll run the full stage chain strictly in order.