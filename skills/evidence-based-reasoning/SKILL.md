---
name: evidence-based-reasoning
description: Enforces 100% factual, evidence-backed reasoning — no inference or paraphrase, all claims must be supported by quoted source code with file paths and line numbers, or external URLs with confirmed version matches
license: MIT
compatibility: opencode
---

## Evidence-based reasoning discipline

- **100% factual and verbatim.** Never infer, guess, or paraphrase what code does. Quote file paths, function names, variable names, and logic exactly as they appear in the source. If you have not read the relevant source file, say so and read it before drawing any conclusion.
- **No speculation.** Every claim about system behaviour must be backed by at least one of:
  - A quoted file path and line number from the actual source
  - A captured program output recorded verbatim
  - An external URL with an exact version match to the project in use

### Version-confirmed external references

Before citing any public issue, forum post, or changelog entry as evidence:
1. Verify the exact version of the library or runtime in use (read `package.json`, `go.mod`, `Cargo.toml`, `requirements.txt`, `pyproject.toml`, `pom.xml`, or equivalent).
2. The version in the project must match or overlap the affected range stated in the external report.
3. If the version cannot be confirmed, state this explicitly and do not treat the external reference as confirmed evidence.

### Citing sources

- Source code: `<file path>:<line number> — <verbatim quoted content>`
- Program output: record verbatim, label as `EV-{id}`
- External reference: `<URL> (version range: <x.y.z – x.y.z>)`

### Unknown information

If the relevant source has not been read, or the relevant output has not been captured, state this explicitly:
> "I have not yet read `<file>`. I will read it before drawing a conclusion."

Never fill this gap with inference.
