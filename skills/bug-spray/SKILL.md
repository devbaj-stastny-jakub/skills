---
name: bug-spray
description: Multi-agent code review of local changes. Parallel reviewer agents (correctness, quality, domain, tests, security, performance) find issues; separate grader agents verify each one and grade importance and certainty; only findings that pass the filter are shown in the terminal. Use when the user says "bug-spray", "review my changes/diff", or asks to review a local branch, staged or uncommitted changes.
---

# bug-spray

You orchestrate: collect, spawn reviewers, merge, spawn graders, filter, report. Never review or grade code yourself.

`<skill-dir>` = this skill's base directory.

## Input
- `Target`: empty (branch vs default branch) | `staged` | `uncommitted` | any git ref. Scope per target: `references/collect.md`.
- `Focus`: optional user text, passed verbatim to every reviewer.

## Rules
- Local and read-only. Output to terminal only. Never post, push, commit, or touch the working tree, index, or branch.
- Review a snapshot worktree, never the user's checkout. After collect, you and every agent read only `CODE_ROOT` (the worktree), so the user can keep working, building, or switching branches meanwhile. Never pass the repo path to an agent.
- Reviewers find, graders grade. Each grader is a fresh agent that did not find the issue.
- Never read, print, or pass to an agent `.env*`, `*.pem`, `*.key`, or credential files.
- Stateless. Remove the worktree and `<run>` at the end, also after errors or cancel.

## Steps

1. **Run dir.** `<run>` = new `bug-spray-<YYYYMMDD-HHMMSS>` dir in your scratchpad, else in a temp dir.

2. **Collect.** Do `<skill-dir>/references/collect.md` yourself. Snapshots the change into worktree `<run>/tree` (= `CODE_ROOT`). Yields files in `<run>` plus `LABEL`, `BASE`, `HEAD_SHA`, `SNAP`, `CODE_ROOT`.
   - `files.txt` empty: say there is nothing to review, stop.
   - Diff over ~4000 lines: show size and largest files, then AskUserQuestion: **Continue** / **Narrow** (append named paths to `Focus`) / **Cancel**.

3. **Packs.** For each `<skill-dir>/references/packs/*.md` except `README.md`: applies if its `applies_when` matches `files.txt` or manifests in `CODE_ROOT` (e.g. `package.json`). Give it to the axes in its `axes`.

4. **meta.md.** Write `<run>/meta.md`: `LABEL`, `BASE`, `HEAD_SHA`, `SNAP`, `CODE_ROOT`, branch name, commit messages (stated intent), `Focus` or `none`, paths of the collected files.

5. **Review.** In one message, spawn six `general-purpose` agents, one per axis: `correctness`, `quality`, `domain`, `tests`, `security`, `performance`.
   ```
   You are the <axis> reviewer for bug-spray. Read-only: never edit, create, or delete files in the code root, never commit, never post anything.
   Read and follow, in order:
   1. <skill-dir>/references/reviewer.md
   2. <skill-dir>/references/axes/<axis>.md
   3. Packs, only their `## <axis>` section: <pack paths, or "none">
   Run context: <run>/meta.md
   Code root: <CODE_ROOT>
   Return only the JSON object described in reviewer.md.
   ```
   Invalid JSON: ask once via SendMessage for JSON only. Fails again: mark axis `failed`, continue.

6. **Merge.** Duplicates = same problem **and** one change fixes both. Merge: clearest wording, union of evidence, all axes (first = owner), owner's anchor, suggestion and replacement. Never drop or judge here. Number `F1`, `F2`, ... Keep every axis's `checked` list for "show checked".
   No findings: go to step 8.

7. **Grade.** In one message, spawn one `general-purpose` grader per finding. Over 12 findings: group same-file findings, max 12 graders. Pass only the finding JSON, no other findings or reviewer output.
   ```
   You are a bug-spray grader. Read-only: never edit, create, or delete files in the code root, never commit, never post anything.
   Read and follow <skill-dir>/references/grader.md.
   Run context: <run>/meta.md
   Code root: <CODE_ROOT>
   Grade each finding independently:
   <finding JSON with its id>
   Return only the JSON described in grader.md.
   ```
   Invalid JSON: ask once via SendMessage. Fails again: list the id under `Failed`. Never grade it yourself.

8. **Filter and report.** See below.

9. **Clean up.** As in `collect.md`: remove the worktree, prune, delete `<run>`.

## Filter
- `confirmed` or `likely`, importance `critical`/`high`/`medium`: **finding**.
- `question`, importance `critical`/`high`: **question**.
- Everything else: drop. No per-axis exceptions.

Sort by importance, then certainty (`confirmed` before `likely`), then path.

## Report
Print as Markdown in your reply (not inside a code block) so the terminal renders headings, bold, and code spans. No tables, praise, change summary, or verdict.

### Icons
- Importance: 🔴 critical · 🟠 high · 🟡 medium · ⚪ low
- Certainty: 🎯 confirmed · 🔍 likely · ❓ question · 🚫 refuted
- Axis: 🐛 correctness · 🧹 quality · 📘 domain · 🧪 tests · 🔒 security · ⚡ performance

### Layout
```markdown
## 🪲 bug-spray
`<LABEL>` · `<HEAD_SHA short>` · <N> files · +<added> −<removed> · packs: <names or none> · excluded: <count>

**🔴 1 critical · 🟠 2 high · 🟡 1 medium · ❓ 1 question**

---

### 🔴 F2 · SQL query built from raw `email`
🔒 security · 🎯 confirmed · `src/auth/login.ts:42-45`

<mechanism, 1–3 lines>

- **Impact:** <consequence, 1 line>
- **Defect at:** `<location path:start-end>` (only if different from anchor)
- **Evidence:** `<path:line>` <1–2 most decisive items from the grader>
- **Fix:** <suggestion>

<replacement, if any, in a fenced code block tagged with the file's language>

---

### ❓ F7 · <title>
📘 domain · 🟠 high · `src/billing/invoice.ts:88`

**Ask:** <grader's question>

---

⚠️ Failed: <axes or ids>
🗑️ Dropped <total> (refuted <n> · low <n> · medium questions <n>) · say "show dropped" or "show checked"
```

- Heading icon: importance for findings, ❓ for questions. Findings first, then questions, in filter order.
- Counts line: only non-zero levels.
- Keep the `F` ids from step 6.
- Path under the heading = `anchor`, so each finding maps to one inline PR comment.
- Mechanism and impact from the finding, evidence from the grader. Shorten, never add claims.
- Omit empty parts: no code block without a replacement, no `Defect at` when it equals the anchor, no `Failed` line when nothing failed. No findings and no questions: replace counts and findings with `✨ No findings.`

### Follow-ups
Answer from this conversation:
- `show dropped`: one bullet each, `<icon> F<n> · <title> · <axis icon> · <path:line in backticks> — <grader reasoning, shortened>`. Icon: 🚫 if refuted, else the importance icon (⚪ low, 🟡 medium question).
- `show checked`: one `### <axis icon> <axis>` heading per axis with its `checked` lines as bullets.
