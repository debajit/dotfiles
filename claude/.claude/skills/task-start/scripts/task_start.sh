#!/usr/bin/env bash
set -euo pipefail

print_path_only="false"
if [[ "${1:-}" == "--print-path-only" ]]; then
  print_path_only="true"
  shift
fi

raw_input="${*:-}"
if [[ -z "$raw_input" ]]; then
  echo "Error: expected input like 'OPS-123 update schema'." >&2
  exit 1
fi

trimmed_input="$(printf '%s' "$raw_input" | sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//')"
if [[ -z "$trimmed_input" ]]; then
  echo "Error: expected a task key and optional summary." >&2
  exit 1
fi

task_key="${trimmed_input%%[[:space:]]*}"
summary=""
if [[ "$trimmed_input" != "$task_key" ]]; then
  summary="${trimmed_input#"$task_key"}"
  summary="$(printf '%s' "$summary" | sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//')"
fi

if [[ ! "$task_key" =~ ^[A-Z][A-Z0-9]+-[0-9]+$ ]]; then
  echo "Error: task key must look like OPS-123." >&2
  exit 1
fi

repo_root="$(git rev-parse --show-toplevel 2>/dev/null || true)"
if [[ -z "$repo_root" ]]; then
  echo "Error: current directory is not inside a git repository." >&2
  exit 1
fi

slug=""
if [[ -n "$summary" ]]; then
  slug="$(printf '%s' "$summary"     | tr '[:upper:]' '[:lower:]'     | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//; s/-+/-/g')"
fi

if [[ -n "$slug" ]]; then
  slug="$(printf '%s' "$slug" | cut -c1-60 | sed -E 's/-+$//')"
fi

if [[ -n "$slug" ]]; then
  proposed_task_ref="${task_key}-${slug}"
else
  proposed_task_ref="$task_key"
fi

if ! git check-ref-format --branch "$proposed_task_ref" >/dev/null 2>&1; then
  echo "Error: generated branch name is not a valid git ref: $proposed_task_ref" >&2
  exit 1
fi

worktrees_root="$repo_root/worktrees"
if [[ -e "$worktrees_root" && ! -d "$worktrees_root" ]]; then
  echo "Error: expected worktrees root to be a directory: $worktrees_root" >&2
  exit 1
fi
mkdir -p "$worktrees_root"

matching_specs=()
while IFS= read -r spec_path; do
  if grep -Eq "^task_key:[[:space:]]*$task_key$" "$spec_path"; then
    matching_specs+=("$spec_path")
  fi
done < <(find "$worktrees_root" -path '*/.sisyphus/plans/*/spec.md' -type f 2>/dev/null | sort)

if (( ${#matching_specs[@]} > 1 )); then
  echo "Error: multiple task specs found for task key $task_key:" >&2
  printf ' - %s
' "${matching_specs[@]}" >&2
  exit 1
fi

status="created"
drift_detected="false"
if (( ${#matching_specs[@]} == 1 )); then
  existing_spec="${matching_specs[0]}"
  existing_plan_dir="$(dirname "$existing_spec")"
  existing_task_ref="$(basename "$existing_plan_dir")"
  worktree_path="${existing_spec%%/.sisyphus/plans/*}"
  spec_path="$existing_spec"
  task_ref="$existing_task_ref"

  if [[ ! -d "$worktree_path" ]]; then
    echo "Error: task spec exists but worktree path is missing: $worktree_path" >&2
    echo "Repair or remove the stale task workspace before reusing $task_key." >&2
    exit 1
  fi

  if ! git -C "$worktree_path" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "Error: task spec exists but worktree is not a valid git checkout: $worktree_path" >&2
    echo "Repair the workspace before reusing $task_key." >&2
    exit 1
  fi

  registered_worktree="$(git worktree list --porcelain | awk '
    /^worktree / { print substr($0, 10) }
  ' | grep -Fx "$worktree_path" || true)"
  if [[ -z "$registered_worktree" ]]; then
    echo "Error: task spec exists but worktree path is not a registered linked worktree: $worktree_path" >&2
    echo "Repair or remove the stale task workspace before reusing $task_key." >&2
    exit 1
  fi

  branch_name="$(git -C "$worktree_path" branch --show-current 2>/dev/null || true)"
  if [[ -z "$branch_name" ]]; then
    echo "Error: existing task workspace has no current branch: $worktree_path" >&2
    echo "Repair the workspace before reusing $task_key." >&2
    exit 1
  fi

  if [[ "$worktree_path" != "$worktrees_root"/* ]]; then
    echo "Error: existing task workspace is outside the managed worktrees root: $worktree_path" >&2
    exit 1
  fi

  status="reused"
else
  task_ref="$proposed_task_ref"
  branch_name="$task_ref"
  worktree_path="$worktrees_root/$task_ref"
  spec_dir="$worktree_path/.sisyphus/plans/$task_ref"
  spec_path="$spec_dir/spec.md"

  if [[ -e "$worktree_path" ]]; then
    echo "Error: target worktree path already exists: $worktree_path" >&2
    exit 1
  fi

  existing_branch_ref="$(git show-ref --verify --quiet "refs/heads/$branch_name" && printf '%s' yes || true)"
  if [[ -n "$existing_branch_ref" ]]; then
    branch_worktree_path="$(git worktree list --porcelain | awk -v branch="refs/heads/$branch_name" '
      BEGIN { current_worktree = "" }
      /^worktree / { current_worktree = substr($0, 10) }
      /^branch / {
        if ($2 == branch) {
          print current_worktree
          exit
        }
      }
    ')"
    if [[ -n "$branch_worktree_path" ]]; then
      echo "Error: branch $branch_name is already checked out in worktree: $branch_worktree_path" >&2
      exit 1
    fi
    echo "Error: branch $branch_name already exists. Start the task with a different summary or clean up the old branch first." >&2
    exit 1
  fi

  git worktree add -b "$branch_name" "$worktree_path"
  mkdir -p "$spec_dir"

  cat > "$spec_path" <<SPEC
---
task_key: $task_key
task_ref: $task_ref
slug: ${slug:-}
status: active
---

# Spec

## Task

$trimmed_input

## Context

- Created by /task-start.

## Goals

- Clarify the desired outcome.
- Capture the implementation or investigation plan.

## Constraints

- Add constraints, assumptions, or non-goals here.

## Open Questions

- Add any unresolved questions here.

## Artifacts

- Keep task artifacts for this work under this directory.
SPEC
fi

if [[ "$print_path_only" == "true" ]]; then
  printf '%s\n' "$worktree_path"
  exit 0
fi

printf 'status=%s
' "$status"
printf 'task_key=%s
' "$task_key"
printf 'task_ref=%s
' "$task_ref"
printf 'branch_name=%s
' "$branch_name"
printf 'worktree_path=%s
' "$worktree_path"
printf 'spec_path=%s
' "$spec_path"
printf 'drift_detected=%s
' "$drift_detected"
