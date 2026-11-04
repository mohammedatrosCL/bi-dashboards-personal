#!/usr/bin/env bash
# Opens GitHub's page for a review request (pull request) from this branch into main, already filled in.
# The work must be saved first. On that page, check it and click "Create pull request".
# Usage, from inside the BI-Dashboards folder: bash <this folder>/review.sh "Title" "What changed, the checks, and what to look at"
set -euo pipefail
tools="$(cd "$(dirname "$0")" && pwd)"
root="$(git rev-parse --show-toplevel 2>/dev/null || true)"
if [ -z "$root" ] || [ ! -d "$root/reports" ] || [ ! -d "$root/dashboard" ]; then
  echo "Run this from inside the BI-Dashboards folder." >&2
  exit 1
fi
cd "$root"

title="${1:?give a title for the review request}"
body="${2:-}"
branch="$(git branch --show-current)"
if [ -z "$branch" ] || [ "$branch" = "main" ]; then
  echo "On main there is nothing to review. Switch to the dashboard's branch: bash $tools/branch.sh <dashboard>" >&2
  exit 1
fi
if [ -n "$(git status --porcelain)" ]; then
  echo "There is unsaved work. Save it first: bash $tools/save.sh \"what changed\"" >&2
  exit 1
fi
git fetch -q origin
if ! git show-ref --verify --quiet "refs/remotes/origin/$branch" || [ -n "$(git log --oneline "origin/$branch..HEAD")" ]; then
  echo "The latest work isn't on GitHub yet. Save it first: bash $tools/save.sh \"what changed\"" >&2
  exit 1
fi

if [ -f .github/pull_request_template.md ]; then
  body="${body:+$body$'\n\n'}$(cat .github/pull_request_template.md)"
fi

repo="$(git remote get-url origin | sed -E 's#\.git$##; s#^.*github\.com[:/]##')"
url="$(node -e '
  const [repo, branch, title, body] = process.argv.slice(1);
  const query = ["expand=1", `title=${encodeURIComponent(title)}`, `body=${encodeURIComponent(body)}`].join("&");
  console.log(`https://github.com/${repo}/compare/main...${encodeURIComponent(branch)}?${query}`);
' "$repo" "$branch" "$title" "$body")"

if command -v open >/dev/null 2>&1; then
  open "$url" >/dev/null 2>&1 || true
elif command -v xdg-open >/dev/null 2>&1; then
  xdg-open "$url" >/dev/null 2>&1 || true
fi
echo "Review request page: $url"
echo "Check it there and click \"Create pull request\". If a request for $branch is already open, GitHub shows it instead."
