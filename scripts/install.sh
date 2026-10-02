#!/usr/bin/env bash
# Symlink skills from this repo into ~/.claude/skills.
# Usage: ./scripts/install.sh [skill-name ...]
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
src_dir="$repo_root/skills"
dest_dir="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"

mkdir -p "$dest_dir"

if [ "$#" -gt 0 ]; then
  names=("$@")
else
  names=()
  for dir in "$src_dir"/*/; do
    [ -d "$dir" ] && names+=("$(basename "$dir")")
  done
fi

if [ "${#names[@]}" -eq 0 ]; then
  echo "No skills found in $src_dir"
  exit 0
fi

for name in "${names[@]}"; do
  src="$src_dir/$name"
  dest="$dest_dir/$name"

  if [ ! -f "$src/SKILL.md" ]; then
    echo "skip  $name (no SKILL.md)"
    continue
  fi

  if [ -L "$dest" ]; then
    ln -sfn "$src" "$dest"
    echo "relink $name"
  elif [ -e "$dest" ]; then
    echo "skip  $name ($dest exists and is not a symlink)"
  else
    ln -s "$src" "$dest"
    echo "link  $name"
  fi
done
