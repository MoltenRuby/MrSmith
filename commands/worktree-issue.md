---
description: Bootstrap a Beads issue in a sibling git worktree
agent: build
---
You are running the Beads worktree bootstrap workflow.

Input:
- `$ARGUMENTS` must be an issue ID like `MrSmith-zqd`.

Workflow:
1. If `$ARGUMENTS` is empty:
   - Run `bd ready --json`
   - Ask the user to choose one issue ID, then stop.

2. Set `ISSUE_ID` to `$ARGUMENTS`.

3. Run:
   - `bd show "$ISSUE_ID" --json`
   If the issue does not exist, report the error and stop.

4. Claim the issue:
   - `bd update "$ISSUE_ID" --claim --json`

5. Derive `SLUG` from the issue title:
   - lowercase
   - replace spaces and non-alphanumeric characters with `-`
   - collapse repeated `-`
   - trim leading/trailing `-`

6. Compute:
   - `WORKTREE_ROOT="../MrSmith-worktrees"`
   - `BRANCH_NAME="worktree/$ISSUE_ID-$SLUG"`
   - `WORKTREE_PATH="$WORKTREE_ROOT/$ISSUE_ID-$SLUG"`

7. Ensure root exists:
   - `mkdir -p "$WORKTREE_ROOT"`

8. Create or reuse worktree:
   - If `"$WORKTREE_PATH"` already exists, report that it is being reused.
   - Otherwise run:
     - `git worktree add -b "$BRANCH_NAME" "$WORKTREE_PATH"`

9. In `"$WORKTREE_PATH"`:
   - Set `BEADS_DIR` to the primary repository Beads directory:
     `BEADS_DIR="$(git rev-parse --show-toplevel)/.beads"`
   - Run Beads commands with this environment variable, for example:
     `BEADS_DIR="$BEADS_DIR" bd show "$ISSUE_ID" --json`
   - If that fails because the directory is missing, report the error and stop.

10. Output exactly:
   - Issue ID and title
   - Worktree path
   - Branch name
   - Whether the worktree was created or reused
   - Next 3 concrete implementation steps
    - Session-close reminders:
      - `bd dolt push`
      - include issue ID in commit message
      - `git push`
      - keep using `BEADS_DIR="$BEADS_DIR"` for Beads commands in this worktree session

Rules:
- Use `bd` for issue tracking (no markdown TODOs).
- Use `--json` for `bd` commands when available.
- If new work is discovered, create linked items with:
  `--deps discovered-from:$ISSUE_ID`.
