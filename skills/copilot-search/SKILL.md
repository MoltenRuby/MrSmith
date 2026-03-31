---
name: copilot-search
description: >-
  Use when you need to find code or documentation by concept or meaning and
  don't know which file contains it. More efficient than grep for exploratory
  or natural-language queries. Prefer over ccc when no index is available.
license: MIT
compatibility: opencode
---

# copilot-search — Semantic Code & Documentation Search

Uses GitHub Copilot CLI to perform a semantic search across the project when
you need to locate code or documentation by concept rather than by exact text.

## When to use this skill

Load this skill when:

- You need to find where something is implemented but don't know the file path.
- A `grep` or `glob` pattern would require prior knowledge you don't have.
- The query is conceptual — e.g. "where is the retry logic for API calls?"
  rather than a known symbol name or string.
- You want file paths returned with a brief explanation of relevance.

## How to search

```bash
~/.config/opencode/skills/copilot-search/scripts/search.sh "<query>"
```

`<query>` is a natural-language description of what you are looking for.

### Examples

```bash
~/.config/opencode/skills/copilot-search/scripts/search.sh "HTTP error handling middleware"
~/.config/opencode/skills/copilot-search/scripts/search.sh "database schema or table definitions"
~/.config/opencode/skills/copilot-search/scripts/search.sh "user authentication and token validation"
```

## Working with results

The output lists file paths with a one-line explanation per file.

1. Use the `Read` tool to open each returned file and examine the relevant section.
2. If results are too broad, refine with more specific terms.
3. If results are too narrow, try synonyms or a higher-level concept.

## When not to use this skill

- You already know the file path — use `Read` directly.
- Searching for an exact symbol or string — `Grep` is faster and more precise.
- The `ccc` skill is available with a fresh index — prefer `ccc search` for
  structured, repeatable results.

## Prerequisite

The `copilot` CLI must be installed and authenticated. If the command is not
found, fall back to `Grep` or the `ccc` skill.
