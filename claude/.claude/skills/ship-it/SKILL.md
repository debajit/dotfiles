---
name: ship-it
description: Execute the final commit-and-push workflow after review. Use when the user has approved the commit message and wants to commit the intended staged files and push the current branch upstream.
allowed-tools: Read, Grep, Glob, Bash(git status), Bash(git diff *), Bash(git branch *), Bash(git commit *), Bash(git push *), Bash(git remote *), Bash(git reset *)
---

# Ship It

Use this skill to execute the final shipping step after the user has
reviewed the intended change set and commit message.

The goal is to commit only the intended staged changes, push the current
branch upstream, and clearly report the result.

## Default Intent

When the user asks to ship after approval:

- Verify the target repository and current branch.
- Verify the currently staged files match the intended change set.
- Verify the commit message has been approved or explicitly provided.
- Commit only the staged intended changes.
- Push the current branch upstream.
- Report the outcome clearly.

## Preconditions

Before committing, confirm all of these:

- The user explicitly asked to commit and push.
- The staged change set is the intended one.
- There are no unrelated staged files.
- A commit message is available and approved.

If any of these are not true, stop and say what is missing.

## Workflow

1. Inspect `git status --short`.
2. Confirm the staged set is the intended scope.
3. Confirm or restate the commit message.
4. Commit the staged changes.
5. Push the current branch upstream.
6. Report the commit hash, branch, and push result.
7. If the remote output includes a pull request URL, surface it.

## Output Format

Before mutating state, briefly state what will be committed.

After execution, report:

- Repository path
- Branch name
- Commit hash
- Commit message
- Push destination
- PR URL if one is provided by the remote

## Safety Rules

Do not:

- Commit unrelated staged files
- Push if the user has not approved the commit message
- Push if the staged set is ambiguous
- Claim success without reporting the actual git results

## Prompt Pattern

Use prompts like:

- Ship this now using the approved commit message. Commit only the
  intended staged files and push the current branch upstream.
- Commit and push the currently staged shipping set. Stop if unrelated
  staged files are present.
