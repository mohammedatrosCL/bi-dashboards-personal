#!/usr/bin/env bash
# Saves your work: records every change on this branch and sends it to GitHub, where teammates can see it.
# main is never saved to directly: it changes only when a review request is merged.
# Usage, from inside the BI-Dashboards folder: bash <this folder>/save.sh "What changed, in a few words"
set -euo pipefail
tools="$(cd "$(dirname "$0")" && pwd)"
root="$(git rev-parse --show-toplevel 2>/dev/null || true)"
if [ -z "$root" ] || [ ! -d "$root/reports" ] || [ ! -d "$root/dashboard" ]; then
  echo "Run this from inside the BI-Dashboards folder." >&2
  exit 1
fi
cd "$root"

message="${1:?give a few words saying what changed}"
branch="$(git branch --show-current)"
if [ -z "$branch" ] || [ "$branch" = "main" ]; then
  echo "main changes only through review. Switch to the dashboard's branch first: bash $tools/branch.sh <dashboard>" >&2
  exit 1
fi

blocked=""
while IFS= read -r file; do
  [ -n "$file" ] || continue
  if [[ "$file" =~ (^|/)(\.env[^/]*|id_rsa[^/]*|[^/]*\.(pem|key|p12|pfx))$ ]]; then
    blocked+="  $file (looks like a password or key file)"$'\n'
  elif [ -f "$file" ] && [ "$(wc -c < "$file" | tr -d " ")" -gt 5000000 ]; then
    blocked+="  $file (larger than 5 MB)"$'\n'
  fi
done < <(git ls-files --others --exclude-standard)
if [ -n "$blocked" ]; then
  echo "Not saved: these new files shouldn't go to GitHub. Move them out of the project folder, then save again:" >&2
  printf '%s' "$blocked" >&2
  exit 1
fi

if [ -n "$(git status --porcelain)" ]; then
  git add -A
  echo "Saving on $branch:"
  git status --short | sed 's/^/  /'
  git commit -q -m "$message"
else
  echo "Nothing new to save on $branch."
fi

if git push -q -u origin "$branch"; then
  echo "Sent to GitHub: branch $branch."
else
  echo "Saved on this laptop, but not sent to GitHub. Check the internet connection and run this again." >&2
  exit 1
fi
