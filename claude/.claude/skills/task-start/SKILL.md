---
name: task-start
description: Start or resume a task workspace by creating a git worktree and a task spec directory under specs/<task_ref>/ with an initial spec.md.
allowed-tools: Bash(bash "$HOME"/.claude/skills/task-start/scripts/task_start.sh *)
---

# Task Start

Use this skill to start or resume a task workspace for a ticket-like task
reference such as `OPS-123`.

The goal is to create a predictable git worktree under `worktrees/<task_ref>`
and a task-scoped spec directory under `specs/<task_ref>/`
inside that worktree. All process artifacts for the task can live in that
spec directory alongside `spec.md`.

## Expected input

The user should invoke this skill with a task key followed by a short natural
language summary.

Examples:

- `/task-start OPS-123 update schema`
- `/task-start OPS-226 add phonebook key metadata`

Interpret the input as:

- first token: stable task key, such as `OPS-123`
- remaining text: human-readable summary used to derive the slug

Derive:

- `task_key`: stable identity, for example `OPS-123`
- `slug`: lowercase hyphenated summary, for example `update-schema`
- `task_ref`: `${task_key}-${slug}` when a summary is present, otherwise just
  `${task_key}`

## Core behavior

When invoked:

1. Run the helper script with the full raw argument string.
2. The helper script must:
   - validate that the current directory is inside a git worktree
   - resolve the repository root
   - look for an existing task by scanning `worktrees/*/specs/*/spec.md`
     for matching `task_key` frontmatter
   - reuse the existing task workspace if the task key already exists
   - otherwise create a new branch and linked worktree at
     `worktrees/<task_ref>`
   - create `specs/<task_ref>/spec.md` inside the worktree
   - write frontmatter including `task_key`, `task_ref`, and `slug`
3. Report whether the task workspace was created or reused.
4. Always return the canonical task key, task ref, worktree path, and spec
   path.
5. Do not claim the helper changed the caller's working directory unless the
   host explicitly confirms it did. The helper runs as a child process and
   cannot `cd` the parent shell by itself.

## Idempotency rules

- The stable identity is `task_key`, not the human summary.
- If the same task key is started again later with a different summary,
  reuse the existing task workspace and its existing `task_ref`.
- Do not create a second worktree for the same `task_key` unless the user
  explicitly asks for a separate parallel workspace.

## Spec file contract

The initial `spec.md` should contain YAML frontmatter with at least:

- `task_key`
- `task_ref`
- `slug`
- `status: active`

The spec directory may also contain related task artifacts such as:

- `report.md`
- `research.md`
- `notes.md`
- `qa.md`

Keep all task process artifacts in `specs/<task_ref>/`.

## Output requirements

Return a concise summary that includes:

- whether the workspace was created or reused
- `task_key`
- `task_ref`
- worktree path
- spec path
- current branch
- a short next step telling the user to `cd` into the worktree if needed

If the user specifically wants one-command shell ergonomics, explain that the
portable solution is a shell wrapper or function that calls the helper and then
executes `cd` in the current shell. The helper supports this via:

```bash
bash "$HOME"/.claude/skills/task-start/scripts/task_start.sh --print-path-only "$ARGUMENTS"
```

Example zsh/bash wrapper:

```bash
task-start() {
  local worktree_path
  worktree_path="$(bash "$HOME"/.claude/skills/task-start/scripts/task_start.sh --print-path-only "$*")" || return
  cd "$worktree_path"
}
```

## Safety rules

Do not:

- guess the task key if the first token is missing or malformed
- create multiple worktrees for the same task key silently
- overwrite an existing spec file when reusing an existing task
- create the worktree outside the repository root's `worktrees/` directory

## Execution

Run:

```bash
bash "$HOME"/.claude/skills/task-start/scripts/task_start.sh "$ARGUMENTS"
```

Then summarize the result for the user.
