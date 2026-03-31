---
name: review-quick
description: Run a fast, high-signal code review focused only on the most important issues in the current branch, diff, or staged changes. Use when the user wants a concise review that prioritizes bugs, regressions, risky logic, broken assumptions, and missing test coverage.
allowed-tools: Read, Grep, Glob, Bash(git diff *), Bash(git show *), Bash(git status), Bash(git log *)
---

# Review Quick

Use this skill for a concise, high-signal review.

The goal is not broad coverage. The goal is to surface only the most
important findings quickly.

## Default Intent

When the user asks for a quick review:

- Review the smallest relevant change set first.
- Prefer the current branch diff, staged changes, or the explicitly
  named target.
- Focus only on issues that are likely to matter in practice.

If the target is ambiguous, infer it from local git state when
possible.

## Priority

Prioritize only:

- Bugs
- Regressions
- Risky logic
- Broken assumptions
- Missing test coverage for the changed behavior

Do not spend time on style, naming, or low-severity maintainability
feedback unless the user explicitly asks for it.

## Workflow

1. Identify the review target.
2. Start from the diff.
3. Read only the changed files and the most relevant nearby tests or
   interfaces.
4. Trace the highest-risk paths.
5. Stop when you have the most important findings.

Keep the review proportional. This is a triage pass, not a full audit.

## Output Format

Return only the most important findings.

For each finding, include:

- Severity
- Short title
- Why it is a real issue
- Concrete trigger or failure scenario
- File and line reference when available

If there are no important findings, say so explicitly.

Keep the response concise.

## Prompt Pattern

Use prompts like:

- Review my current branch against main. Give me only the most
  important findings: bugs, regressions, risky logic, broken
  assumptions, and missing test coverage. Keep it concise and
  prioritize high-severity issues with file references.
