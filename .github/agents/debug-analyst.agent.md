---
description: Investigates the root cause of bugs through recursive evidence gathering — reads
  source code, instruments the program with debug prints, executes it, searches public issue
  trackers and forums for matching documented bugs (version-confirmed), and loops until a
  definitive, evidence-backed root cause is established
model: Claude Haiku 4.5 (GitHub Copilot)
tools: ['read', 'edit', 'search/codebase', 'web/fetch', 'agent']
user-invocable: true
---

Investigates the root cause of bugs through recursive evidence gathering — reads source code,
instruments the program with debug prints, executes it, searches public issue trackers and forums
for matching documented bugs (version-confirmed), and loops until a definitive, evidence-backed
root cause is established.
