#!/usr/bin/env bash
# Sets up this laptop for the BI dashboards, or checks that it still is. Safe to run again at any time.
# Usage, from inside the BI-Dashboards folder: bash <this folder>/setup.sh            everything needed to work on the replica
#        bash <this folder>/setup.sh practice   the practice database too
set -uo pipefail
tools="$(cd "$(dirname "$0")" && pwd)"
root="$(git rev-parse --show-toplevel 2>/dev/null || true)"
if [ -z "$root" ] || [ ! -d "$root/reports" ] || [ ! -d "$root/dashboard" ]; then
  echo "Run this from inside the BI-Dashboards folder." >&2
  exit 1
fi
cd "$root"

problems=0
ok() { printf '  ✓ %s\n' "$1"; }
todo() { printf '  ! %s\n' "$1"; problems=$((problems + 1)); }

echo "Setting up the BI dashboards on this laptop"

if ! command -v node >/dev/null 2>&1; then
  echo "  ✗ Node.js is not installed. Install Node.js 22 LTS from https://nodejs.org (the macOS installer), then run setup again."
  exit 1
fi
if [ "$(node -p 'process.versions.node.split(".")[0]')" -lt 22 ]; then
  echo "  ✗ Node.js $(node -v) is too old. Install Node.js 22 LTS from https://nodejs.org, then run setup again."
  exit 1
fi
ok "Node.js $(node -v)"

name="$(git config user.name || true)"
email="$(git config user.email || true)"
if [ -n "$name" ] && [ -n "$email" ]; then
  ok "Git knows you as $name <$email>"
else
  todo "Git doesn't know your name yet: git config --global user.name \"Your Name\" and git config --global user.email \"you@cleanlife.sa\""
fi

lock_hash="$(git hash-object package-lock.json)"
if [ -d node_modules ] && [ "$(cat node_modules/.setup-lock-hash 2>/dev/null)" = "$lock_hash" ]; then
  ok "Packages up to date"
else
  echo "  … installing packages (a minute or two the first time)"
  if npm install --no-audit --no-fund --loglevel=error; then
    echo "$lock_hash" > node_modules/.setup-lock-hash
    ok "Packages installed"
  else
    todo "Installing the packages failed: see the messages above"
  fi
fi
if [ "${1:-}" = "practice" ]; then
  if npm install --prefix dev --no-audit --no-fund --loglevel=error; then
    ok "Practice database installed (start it with: npm start --prefix dev)"
  else
    todo "Installing the practice database failed: see the messages above"
  fi
fi

for repo in booking_api NewDashboard; do
  target="refs/$repo"
  if [ -d "$target/.git" ]; then
    if git -C "$target" pull -q --ff-only 2>/dev/null; then
      ok "Development's $repo code is up to date in $target"
    else
      todo "Couldn't update $target: check your access to CleanLifeCom/$repo on GitHub"
    fi
  elif [ -e "$target" ]; then
    todo "$target exists but isn't a copy of $repo: move it out of refs/ and run setup again"
  else
    echo "  … downloading development's $repo code (a read-only copy for Claude Code)"
    if git clone -q --depth 1 --no-checkout "https://github.com/CleanLifeCom/$repo.git" "$target" \
      && git -C "$target" sparse-checkout set --no-cone '/*' '!CLAUDE.md' '!AGENTS.md' '!.claude/' '!.cursor/' \
      && git -C "$target" checkout -q; then
      ok "Development's $repo code downloaded to $target"
    else
      todo "Couldn't download $repo: ask development for read access to CleanLifeCom/$repo on GitHub"
    fi
  fi
done

if reach="$(bash scripts/replica-reachable.sh)"; then
  ok "This laptop can reach the replica"
else
  todo "$reach Until then, the practice database works."
fi
if [ -f certs/ApsaraDB-CA-Chain.pem ]; then
  ok "The replica's certificate is here, so the connection is verified"
else
  echo "  · No certs/ApsaraDB-CA-Chain.pem: the connection is encrypted, but the replica's certificate isn't verified"
fi

echo
if [ "$problems" -eq 0 ]; then
  echo "Ready. To start, in VS Code: Terminal → Run Task… → \"Start dashboards: live data, edit mode\"."
  echo "To only look at the dashboards: double-click \"Start Dashboards.command\" in this folder."
else
  echo "$problems thing(s) to fix above, then run setup again."
  exit 1
fi
