#!/usr/bin/env bash
# Gets the latest: brings in what was merged into main (and anything saved to this branch from another
# laptop), then refreshes the packages and development's code. Unsaved work must be saved first.
# Usage, from inside the BI-Dashboards folder: bash <this folder>/update.sh
set -euo pipefail
tools="$(cd "$(dirname "$0")" && pwd)"
root="$(git rev-parse --show-toplevel 2>/dev/null || true)"
if [ -z "$root" ] || [ ! -d "$root/reports" ] || [ ! -d "$root/dashboard" ]; then
  echo "Run this from inside the BI-Dashboards folder." >&2
  exit 1
fi
cd "$root"

if [ -n "$(git status --porcelain)" ]; then
  echo "There is unsaved work. Save it first (bash $tools/save.sh \"what changed\"), then update." >&2
  exit 1
fi

branch="$(git branch --show-current)"
before="$(git rev-parse HEAD)"
lock_before="$(git hash-object package-lock.json)"
git fetch -q origin

bring_in() {
  if ! git merge -q --no-edit "$1"; then
    echo "The latest $1 and the work on $branch change the same lines in:" >&2
    git diff --name-only --diff-filter=U | sed 's/^/  /' >&2
    echo "Resolve them, then save. To back out instead: git merge --abort" >&2
    exit 2
  fi
}
if [ "$branch" = "main" ]; then
  git merge -q --ff-only origin/main
else
  if git show-ref --verify --quiet "refs/remotes/origin/$branch"; then bring_in "origin/$branch"; fi
  bring_in origin/main
fi

if [ "$before" = "$(git rev-parse HEAD)" ]; then
  echo "Already up to date."
else
  echo "Brought in:"
  git log --oneline --no-merges "$before..HEAD" | sed 's/^/  /'
fi

if [ ! -d node_modules ] || [ "$lock_before" != "$(git hash-object package-lock.json)" ]; then
  echo "The packages changed: installing them. Restart the servers afterwards if they are running."
  npm install --no-audit --no-fund --loglevel=error
  git hash-object package-lock.json > node_modules/.setup-lock-hash
fi

for repo in booking_api NewDashboard; do
  if [ -d "refs/$repo/.git" ] && ! git -C "refs/$repo" pull -q --ff-only 2>/dev/null; then
    echo "Couldn't refresh refs/$repo (development's code); the copy there is older." >&2
  fi
done
echo "Development's code in refs/ is current."
