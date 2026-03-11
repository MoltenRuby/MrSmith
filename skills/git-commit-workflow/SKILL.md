---
name: git-commit-workflow
description: Standard Git workflow conventions for commits, branches, and pull requests — commit message format, branch naming, squash rules, and PR hygiene to follow when delivering implemented changes
license: MIT
compatibility: opencode
---

## Git commit workflow

Apply these conventions when committing or preparing changes for review.

### Commit message format

Use the Conventional Commits format:

```
<type>(<scope>): <short summary>

[optional body]

[optional footer]
```

**Types:**

| Type | Use when |
|---|---|
| `feat` | A new feature or capability |
| `fix` | A bug fix |
| `refactor` | Code restructuring with no behaviour change |
| `test` | Adding or updating tests only |
| `docs` | Documentation only |
| `chore` | Build, tooling, dependency changes |
| `perf` | Performance improvement |

**Rules:**
- Summary line: imperative mood, no full stop, max 72 characters
- Body: wrap at 72 characters, explain *why* not *what*
- Footer: reference issues (`Closes #123`) or breaking changes (`BREAKING CHANGE: <description>`)

### Branch naming

```
<type>/<short-kebab-description>
```

Examples: `feat/user-auth`, `fix/null-pointer-login`, `refactor/extract-db-layer`

### Before committing

1. Run the project's linter and formatter. Fix all errors. Do not suppress warnings without justification.
2. Run the full test suite. All tests must pass. Do not commit with known failures.
3. Review the diff. Remove all debug instrumentation, commented-out code, and `TODO` comments that were not in the original scope.
4. Stage only the files relevant to this change. Do not bundle unrelated modifications.

### Squash rules

- Squash fixup commits (e.g. "fix typo", "forgot to add file") before opening a PR.
- Preserve separate commits for logically distinct changes that a reviewer would want to examine independently.
- Never squash across phase boundaries defined in the implementation plan.

### Pull request hygiene

- Title: follows the same Conventional Commits format as the commit summary.
- Description must include: what changed, why, and how to verify it.
- Link the relevant issue or plan step.
- Do not merge your own PR without review unless explicitly authorised.
- Resolve all review comments before merging. Do not dismiss reviews unilaterally.

### Safety rules

- Never force-push to `main` or `master`.
- Never use `--no-verify` to skip hooks without explicit user instruction.
- Never amend a commit that has already been pushed to a shared remote.
