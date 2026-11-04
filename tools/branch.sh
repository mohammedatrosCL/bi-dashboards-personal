#!/usr/bin/env bash
# Starts or continues work on a dashboard, or on a shared change, in its own branch. The first time, the
# branch starts from the latest main. Work not saved yet on main comes along; on another branch it must be
# saved first.
# Usage, from inside the BI-Dashboards folder: bash <this folder>/branch.sh pricing
set -euo pipefail
tools="$(cd "$(dirname "$0")" && pwd)"
root="$(git rev-parse --show-toplevel 2>/dev/null || true)"
if [ -z "$root" ] || [ ! -d "$root/reports" ] || [ ! -d "$root/dashboard" ]; then
  echo "Run this from inside the BI-Dashboards folder." >&2
  exit 1
fi
cd "$root"

name="${1:?give the dashboard, for example: bash $tools/branch.sh pricing}"
if ! [[ "$name" =~ ^[a-z][a-z0-9-]*$ ]] || [ "$name" = "main" ]; then
  echo "A branch name uses lower-case letters, digits and '-', and isn't main." >&2
  exit 1
fi

current="$(git branch --show-current)"
if [ "$current" = "$name" ]; then
  echo "Already working on $name."
  exit 0
fi
if [ -n "$(git status --porcelain)" ] && [ "$current" != "main" ]; then
  echo "There is unsaved work on $current. Save it first: bash $tools/save.sh \"what changed\"" >&2
  exit 1
fi

git fetch -q origin
if git show-ref --verify --quiet "refs/heads/$name"; then
  git switch -q "$name"
  echo "Back on $name."
elif git show-ref --verify --quiet "refs/remotes/origin/$name"; then
  git switch -q --track -c "$name" "origin/$name"
  echo "Working on $name, as last saved on GitHub."
else
  git switch -q -c "$name" origin/main
  echo "Started $name from the latest main."
fi
