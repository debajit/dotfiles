---
name: review-thorough
description: Run a production-style code review for a branch, PR, commit, or diff. Use when the user wants a deeper review focused on correctness, regressions, edge cases, API contract changes, type safety, migration risk, rollout risk, performance, and missing or weak tests.
allowed-tools: Read, Grep, Glob, Bash(git diff *), Bash(git show *), Bash(git status), Bash(git log *), Bash(git blame *)
---

# Review Thorough

Use this skill for a deep, production-style review.

The goal is to assess whether a change is safe, correct, and ready to
merge, not just to find one or two obvious issues.

## Default Intent

When the user asks for a thorough review:

- Review the current branch against the main integration branch unless
  the user specifies another target.
- Treat the review like a production PR review.
- Summarize the change first only if that helps frame the findings.

If the target is ambiguous, infer it from local git state when
possible.

## Priority

Focus on:

- Correctness
- Regressions
- Edge cases and failure modes
- API contract changes
- Type safety
- Migration risk
- Rollout risk
- Performance problems caused by the change
- Missing or weak tests

Do not nitpick style unless it materially affects readability,
maintainability, or consistency with established codebase patterns.

## Workflow

1. Identify the review target.
2. Inspect the diff before reading broad surrounding context.
3. Read all changed files in full.
4. Read the most relevant adjacent tests, callers, interfaces, or
   schemas.
5. Trace behavior changes, failure paths, and operational risk.
6. Check whether tests cover the changed behavior and likely edge
   cases.
7. Order findings by severity.

For large diffs, triage first and spend most time on the areas that
change behavior, state transitions, data contracts, persistence, or
error handling.

## Output Format

First summarize what the change does, if useful.

Then list findings ordered by severity.

For each finding, include:

- Severity
- Short title
- Why it is a real problem
- Concrete scenario or trigger
- File and line reference when available

If there are no major issues, say so explicitly and note any medium-risk
areas worth double-checking.

## Comment Quality Bar

Only raise technically defensible concerns.

Do not:

- Speculate without a concrete failure mode
- Raise generic comments like "maybe add more tests"
- Nitpick style when it does not change maintainability or correctness

## Prompt Pattern

Use prompts like:

- Review my current branch against main as if this were a production
  PR. First summarize what the change does, then list findings ordered
  by severity with file references. Focus on correctness, regressions,
  edge cases, API contract changes, type safety, migration risk,
  rollout risk, performance, and missing or weak tests. Include
  technically defensible review comments, not style nitpicks, unless
  maintainability is materially affected.
