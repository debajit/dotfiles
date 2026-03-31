---
name: ship-prepare
description: Prepare a commit-and-push workflow without mutating history. Use when the user wants to stage intended changes, inspect git status, detect unrelated staged files, and propose a commit message for review before committing.
allowed-tools: Read, Grep, Glob, Bash(git status), Bash(git diff *), Bash(git log *), Bash(git branch *), Bash(git add *), Bash(git reset *)
---

# Ship Prepare

Use this skill to prepare a safe shipping step before any commit or push.

The goal is to make the intended change set explicit, identify risky or
unrelated staged files, and propose a commit message the user can review.

## Default Intent

When the user asks to prepare a commit and push workflow:

- Inspect the repository state first.
- Figure out which changes are intended for this task.
- Stage only the intended files when the user explicitly asked for
  staging, or when the intended scope is already unambiguous.
- Detect unrelated staged changes before moving forward.
- Propose a commit message and stop before any commit or push.

If the target repository or intended change set is ambiguous, ask one
precise question before staging or proposing a message.

## Priority

Prioritize:

- Preventing accidental commits of unrelated files
- Showing the exact staged set
- Flagging risky repository state, such as mixed staged and unstaged
  work that looks unrelated
- Proposing a clean, specific commit message that matches local branch
  conventions

Do not commit. Do not push. Do not create a PR.

## Workflow

1. Identify the target repository and current branch.
2. Inspect `git status --short`.
3. Inspect staged and unstaged diffs as needed to understand scope.
4. If the user asked to stage changes, stage only the intended files.
5. Check for unrelated staged files and call them out clearly.
6. Propose a commit message.
7. Show the exact next step for the user to approve or execute.

## Output Format

Return a concise preparation summary with:

- Repository path
- Current branch
- Staged files
- Unstaged relevant files, if any
- Unrelated staged files, if any
- Proposed commit message
- Clear next step

If the repository is not ready to ship, say why and what must be fixed
first.

## Safety Rules

Do not:

- Commit
- Push
- Create a pull request
- Quietly include unrelated staged files
- Assume a ticket prefix if local conventions require one and it cannot
  be derived

## Prompt Pattern

Use prompts like:

- Prepare this repo for shipping. Stage only the intended files, show me
  the exact staged set, and propose a commit message. Do not commit or
  push.
- Check whether this repo is ready to ship. Call out unrelated staged
  files and propose the commit message I should approve.
