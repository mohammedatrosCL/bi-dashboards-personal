#!/usr/bin/env bash
# Saves this private repository and sends it to GitHub.
# Usage: bash save.sh "What changed, in a few words"
set -euo pipefail
cd "$(dirname "$0")"

message="${1:?give a few words saying what changed}"
branch="$(git branch --show-current)"
git fetch -q origin 2>/dev/null || true
if git show-ref --verify --quiet "refs/remotes/origin/$branch"; then
  git merge -q --ff-only "origin/$branch" 2>/dev/null || true
fi

if [ -n "$(git status --porcelain)" ]; then
  git add -A
  git commit -q -m "$message"
  echo "Saved: $message"
else
  echo "Nothing new to save."
fi

if git push -q -u origin "$branch"; then
  echo "Sent to GitHub."
else
  echo "Saved on this laptop, but not sent to GitHub. Check the internet connection and run this again." >&2
  exit 1
fi
