---
name: commit
description: Inspect repo state, infer the intended change set, stage only when safe, propose a commit message using repo-local rules, ask for confirmation, and create the local commit without pushing.
allowed-tools: Read, Grep, Glob, Bash(git status), Bash(git diff *), Bash(git log *), Bash(git branch *), Bash(git add *), Bash(git reset *), Bash(git commit *)
---

# Commit

Use this skill to create a safe local commit.

The goal is to figure out what should be committed, make the planned commit
set explicit, propose the right commit message for this repository, ask for
confirmation, and then run the local `git commit`.

This skill owns the local commit workflow only. It must not push. Use
`/commit-and-push` for the publish step.

## Default Intent

When the user asks to commit:

- Inspect the repository state first.
- Infer the intended change set from the task context plus staged and
  unstaged git state.
- Bucket files into `will commit`, `excluded`, and `suspicious`.
- Auto-stage only when the intended set is unambiguous.
- Generate a commit message from repo-local rules.
- Show the exact planned commit and ask for explicit confirmation before
  mutating local history.
- Create the local commit after approval.

If the intended change set is ambiguous, ask one precise question before
staging or committing.

## Priority

Prioritize:

- Preventing accidental inclusion of unrelated files
- Making the exact commit set explicit before confirmation
- Detecting suspicious mixed staged and unstaged work
- Following repo-local commit conventions before falling back to defaults
- Requiring explicit confirmation before running `git commit`

Do not push. Do not create a pull request.

## Commit Message Rules

Use this precedence order when generating the commit message:

1. Explicit user instruction
2. Repo-local documented rules or templates
3. Strong recent-history conventions in the current repository
4. Conventional Commits as the default fallback

Default fallback format:

```text
<type>[optional scope]: <description>
```

Support repo-local overrides such as:

- allowed types
- allowed scopes
- header length limits
- subject casing or tense rules
- body requirements
- footer requirements

Special-case rule for skill updates:

- When the intended change set updates one or more skills and the repository
  convention is to use `skills: ...`, treat `skills:` as the preferred
  repo-local prefix instead of forcing a Conventional Commit header.

Do not invent repo-local message rules without evidence.

## Auto-Staging Rules

Auto-stage the intended files only when all of the following are true:

- the intended file set is obvious from the task and current git state
- there are no suspicious unrelated staged files
- there are no untracked or modified files that materially compete with the
  inferred scope
- the commit can be explained clearly before confirmation

Do not auto-stage when:

- unrelated changes are already staged
- the repository contains mixed unrelated work
- untracked files may or may not belong in the commit
- the correct scope depends on a user choice

In those cases, show the buckets and ask one precise question.

## Workflow

1. Identify the target repository and current branch.
2. Inspect `git status --short`.
3. Inspect staged and unstaged diffs as needed to understand scope.
4. Infer the intended change set from the user request and repository state.
5. Bucket files into:
   - `will commit`
   - `excluded`
   - `suspicious`
6. If the intended set is unambiguous, stage only the `will commit` files.
7. If ambiguity remains, ask one precise question and stop.
8. Generate the proposed commit message using the commit message rules.
9. Show the exact planned commit, including buckets, staging action, and the
   proposed message.
10. Ask for explicit confirmation before running `git commit`.
11. After confirmation, run the local commit.
12. Report the commit hash, final message, and that no push has occurred.

## Output Format

Before confirmation, return a concise commit summary with:

- Repository path
- Current branch
- `will commit`
- `excluded`
- `suspicious`
- Whether auto-staging occurred
- Proposed commit message
- Clear confirmation request

If the repository is not ready to commit, say why and what must be fixed
first.

After a successful commit, report:

- Repository path
- Branch
- Commit hash
- Final commit message
- Confirmation that no push has occurred

## Safety Rules

Do not:

- Commit without explicit confirmation
- Push
- Create a pull request
- Auto-stage ambiguous files
- Quietly include suspicious or unrelated staged files
- Invent repo-local commit rules without evidence
- Omit the `skills: ` prefix when that is the established rule for skill
  changes

## Prompt Pattern

Use prompts like:

- Commit this change safely. Figure out what belongs in the commit, show me
  `will commit`, `excluded`, and `suspicious`, propose the commit message,
  and ask before committing.
- Make the local commit for this task. Stage only what is clearly part of
  the task, stop if the scope is ambiguous, and do not push.
- Commit this skill update. Use the repository's `skills: ...` commit style
  if it applies, show the planned commit, and ask for confirmation before
  creating the local commit.
