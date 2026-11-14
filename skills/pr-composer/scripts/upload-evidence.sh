#!/usr/bin/env bash
# Usage: upload-evidence.sh <folder> <file>...
#
# GitHub has no API for PR image attachments, so screenshots are committed to an
# orphan branch on the remote and embedded by URL. Built with plumbing on a
# throwaway index: the working tree, index and current branch stay untouched.
# Prints one Markdown line per file, pinned to the commit SHA so later uploads
# never change what an older PR shows. Private repos render them for anyone with
# read access.
set -euo pipefail

branch="${PR_EVIDENCE_BRANCH:-pr-evidence}"
remote="${PR_EVIDENCE_REMOTE:-origin}"

if [ $# -lt 2 ]; then
  echo "usage: $0 <folder> <file>..." >&2
  exit 2
fi

sanitize() { printf '%s' "$1" | tr -c 'A-Za-z0-9._-' '-'; }

folder="$(sanitize "$1")"
shift

for file in "$@"; do
  [ -f "$file" ] || { echo "not a file: $file" >&2; exit 1; }
done

remote_url="$(git remote get-url "$remote")"
slug="$(printf '%s' "$remote_url" | sed -E 's#^.*github\.com[:/]##; s#\.git$##')"
case "$slug" in
  */*) ;;
  *) echo "remote $remote is not a GitHub repository: $remote_url" >&2; exit 1 ;;
esac

stamp="$(date +%Y%m%d-%H%M%S)"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT
export GIT_INDEX_FILE="$tmp_dir/index"

paths=()
for file in "$@"; do
  paths+=("$folder/$stamp-$(sanitize "$(basename "$file")")")
done

commit=""
for attempt in 1 2 3; do
  rm -f "$GIT_INDEX_FILE"
  parent=""
  if git ls-remote --exit-code "$remote" "refs/heads/$branch" >/dev/null 2>&1; then
    git fetch -q "$remote" "refs/heads/$branch"
    parent="$(git rev-parse FETCH_HEAD)"
    git read-tree "$parent"
  else
    git read-tree --empty
  fi

  i=0
  for file in "$@"; do
    blob="$(git hash-object -w "$file")"
    git update-index --add --cacheinfo "100644,$blob,${paths[$i]}"
    i=$((i + 1))
  done

  tree="$(git write-tree)"
  if [ -n "$parent" ]; then
    commit="$(git commit-tree "$tree" -p "$parent" -m "evidence: $folder")"
  else
    commit="$(git commit-tree "$tree" -m "evidence: $folder")"
  fi

  # A concurrent upload makes this push non-fast-forward; rebuild on the new tip.
  if git push -q "$remote" "$commit:refs/heads/$branch" 2>"$tmp_dir/push.err"; then
    break
  fi
  commit=""
  echo "push attempt $attempt failed: $(tail -n 1 "$tmp_dir/push.err")" >&2
done

if [ -z "$commit" ]; then
  echo "could not push to $remote/$branch" >&2
  exit 1
fi

for path in "${paths[@]}"; do
  url="https://github.com/$slug/raw/$commit/$path"
  name="$(basename "$path")"
  case "$(printf '%s' "$name" | tr 'A-Z' 'a-z')" in
    *.png|*.jpg|*.jpeg|*.gif|*.webp|*.svg) echo "![$name]($url)" ;;
    *) echo "[$name]($url)" ;;
  esac
done
