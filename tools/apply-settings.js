#!/usr/bin/env node
// Adds my Claude Code settings for the BI-Dashboards folder to its .claude/settings.local.json, which only this
// laptop uses and git ignores. Keeps whatever is already there (the plugin I turned on, permissions I granted).
// Run it from inside the BI-Dashboards folder: node <this folder>/apply-settings.js
const fs = require("fs");
const path = require("path");
const { execFileSync } = require("child_process");

function repoRoot() {
  try {
    const root = execFileSync("git", ["rev-parse", "--show-toplevel"], { encoding: "utf8" }).trim();
    if (fs.existsSync(path.join(root, "reports")) && fs.existsSync(path.join(root, "dashboard"))) return root;
  } catch {}
  console.error("Run this from inside the BI-Dashboards folder.");
  process.exit(1);
}

const root = repoRoot();
const tools = __dirname;
const privateRoot = path.dirname(tools);
const mine = JSON.parse(fs.readFileSync(path.join(privateRoot, "settings", "claude-local.json"), "utf8"));

const myTools = [];
for (const dir of [tools, path.relative(root, tools)]) {
  for (const name of ["setup", "branch", "save", "update", "review"]) {
    myTools.push(`Bash(bash ${dir}/${name}.sh)`, `Bash(bash ${dir}/${name}.sh *)`);
  }
}
for (const dir of [privateRoot, path.relative(root, privateRoot)]) {
  myTools.push(`Bash(bash ${dir}/save.sh *)`);
}

const target = path.join(root, ".claude", "settings.local.json");
const current = fs.existsSync(target) ? JSON.parse(fs.readFileSync(target, "utf8")) : {};
const union = (a = [], b = []) => [...new Set([...a, ...b])];

current.claudeMdExcludes = union(current.claudeMdExcludes, mine.claudeMdExcludes);
current.permissions = current.permissions || {};
for (const kind of ["allow", "ask", "deny"]) {
  const wanted = (mine.permissions || {})[kind] || [];
  current.permissions[kind] = union(current.permissions[kind], kind === "allow" ? [...wanted, ...myTools] : wanted);
}

fs.mkdirSync(path.dirname(target), { recursive: true });
fs.writeFileSync(target, JSON.stringify(current, null, 2) + "\n");
console.log(`My Claude Code settings are in ${path.relative(root, target)}. They take effect in the next conversation.`);
