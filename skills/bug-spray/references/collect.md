# Collect (orchestrator)

Do it yourself, no agents. Never change the user's working tree, index, or branch. Snapshot the change into a separate worktree; from then on everything reads the worktree, never the user's checkout.

## Values
- `REPO`: `git rev-parse --show-toplevel`. Used only for the snapshot.
- `HEAD_SHA`: current `HEAD`.
- `BASE`, `LABEL`: from the scope table.
- `SNAP`: snapshot commit.
- `CODE_ROOT`: `<run>/tree`, the snapshot worktree.

## Scope
`<DEF>` = remote default branch, else first existing of `origin/main`, `origin/master`, `main`, `master`.

| Target | `BASE` | Snapshot of | `LABEL` |
|---|---|---|---|
| empty | merge-base `<DEF>` `HEAD` | working tree + untracked | `<DEF>...HEAD + working tree + untracked` |
| `<ref>` | merge-base `<ref>` `HEAD` | working tree + untracked | `<ref>...HEAD + working tree + untracked` |
| `uncommitted` | `HEAD` | working tree + untracked | `uncommitted + untracked` |
| `staged` | `HEAD` | index | `staged` |

## Snapshot
Run in `REPO`. A private index copy keeps the user's index untouched:

```sh
cp "$(git rev-parse --path-format=absolute --git-path index)" <run>/index   # before export
export GIT_INDEX_FILE=<run>/index
git add -A          # skip for `staged`
TREE=$(git write-tree)
unset GIT_INDEX_FILE
SNAP=$(git -c user.name=bug-spray -c user.email=bug-spray@localhost commit-tree "$TREE" -p HEAD -m "bug-spray snapshot")
git worktree add --detach <run>/tree "$SNAP"
```

`SNAP` is a dangling commit: no branch or ref points to it, git gc removes it later.

## Files in `<run>`
Build all from `BASE` vs `SNAP` (untracked files are in the snapshot, so they show as new):
- `diff.patch`: `git diff --no-color --no-ext-diff -U5 BASE SNAP`, standard `a/` `b/` prefixes. Exact new-side line numbers.
- `files.txt`: `git diff --numstat BASE SNAP`.
- `excluded.txt`: names of filtered files.
- `commits.txt`: `BASE..HEAD` messages, no merges. Empty for `uncommitted` and `staged`.
- `context.md`: paths only, relative to `CODE_ROOT`. Write `none found` for an empty section.
  - **Repo rules**: `CLAUDE.md`, `AGENTS.md`, `.cursorrules` in each changed file's dir and every parent up to root; all files under `.claude/rules/` and `.cursor/rules/`.
  - **Domain docs**: `CONTEXT.md`, `CONTEXT-MAP.md`, `GLOSSARY.md`, `ARCHITECTURE.md`; `.md` files under any `adr/`, `adrs/`, `decisions/`.

## Exclude
Leave out of `diff.patch` and `files.txt`; list names in `excluded.txt`:
- Locks: `*.lock`, `package-lock.json`, `pnpm-lock.yaml`, `yarn.lock`, `go.sum`
- Build/vendored: `dist/`, `vendor/`, `node_modules/`, `generated/`, `*.generated.*`, `*.min.js`, `*.min.css`, `*.map`
- Snapshots: `*.snap`, `__snapshots__/`
- Secrets: `.env`, `.env.*`, `*.pem`, `*.key`. Name only, never open.

## Clean up
```sh
git -C "$REPO" worktree remove --force <run>/tree
git -C "$REPO" worktree prune
```
Then delete `<run>`.
