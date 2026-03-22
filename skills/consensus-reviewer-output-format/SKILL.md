---
name: consensus-reviewer-output-format
description: Standard output format for consensus reviewer agents — Verdict/Reasons/Suggested changes structure with AGREE/DISAGREE verdicts
license: MIT
compatibility: opencode
---

## Output format

Respond with exactly this structure:

```
Verdict: AGREE | DISAGREE

Reasons:
- <reason 1>
- <reason 2>
...

Suggested changes (if DISAGREE):
- <concrete change to the feature design>
...
```

Do not write code. Do not repeat the feature file back. Be concise and specific.
