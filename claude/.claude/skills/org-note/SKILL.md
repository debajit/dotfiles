---
name: org-note
description: Create or update a note in Org Mode in the personal knowledge base at ~/Archive/Knowledge/Notes/
---

# Org-Note: Create or Update an Org-Mode Note

You are helping the user manage their personal knowledge base.

## Notes directory

`~/Archive/Knowledge/Notes/`

## User's request

<command-args/>

## Instructions

1. **Understand the request.** The user may provide:
   - Just a topic/title (e.g., "tmux pane resizing") — create or find a note on that topic
   - A title and content (e.g., "tmux pane resizing - use C-b : resize-pane") — add that content
   - A URL or reference to capture
   - Freeform text to file under an appropriate topic

2. **Search for an existing note.** Notes use Org Roam and are prefixed with a timestamp (e.g., `20250710010608-driving.org`). Search with a broad glob pattern like `**/*driving*.org` or grep for `#+title:` containing the topic. Match on the filename stem (after the timestamp) and `#+TITLE:` / `#+title:` header. Prefer fuzzy/partial matches. If multiple candidates exist, pick the best one and tell the user. **Always search before creating.**

3. **If a matching note exists:** append the new content under the
   most appropriate existing heading, or create a new heading if none
   fits. Use today's date as a subheading only if the content is
   time-sensitive (e.g., a log entry, a meeting note). Keep additions
   concise, match the existing style of the file, and wrap Org prose to
   72 columns using Org-mode fill behavior.

4. **If no matching note exists:** create a new file named `Title.org`
   (title-cased, spaces allowed, no timestamp prefix) with this
   structure:
   ```org
   #+TITLE: Title

   * <appropriate first heading>

   <content>
   ```

5. **Org-mode formatting conventions** (match the existing notes style):
   - File header: `#+TITLE: Title` (space after colon, title-cased)
   - Headings: `*`, `**`, `***` etc.
   - Links: `[[url][description]]`
   - Bold: `*bold*`, italic: `/italic/`
   - Code: `~code~` for commands, flags, program and package names,
     and config options (e.g. `~paccache -rk2~`, `~CleanAfter~`)
   - Verbatim: `=verbatim=` for file paths and other literal text
     (e.g. `=/etc/paru.conf=`, `=[options]=`). Use `=` for anything
     that itself contains `~`, such as `=~/.cache=`.
   - Lists: `-` for unordered, `1)` for ordered
   - Wrap Org prose to 72 columns using Org-mode fill behavior, as if
     you had run `org-fill-paragraph` in Emacs. Preserve Org link
     syntax like `[[url][description]]`, but wrap lines the way Org
     would when displaying and filling the visible link text. Reflow
     paragraphs and list item continuations to match that behavior.
     Keep links, source blocks, and other syntax-sensitive constructs
     intact if wrapping them would reduce clarity or break Org
     formatting.

6. **Report** what you did: the file path, whether it was created or updated, and the section modified.
