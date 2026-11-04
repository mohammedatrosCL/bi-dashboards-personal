# My BI dashboards workspace (private)

Mohammed's own things for the BI dashboards, kept out of the shared `CleanLifeCom/BI-Dashboards`
repository:

```
method/    my way of building dashboards: a Claude Code plugin with four skills (start, propose rules, approve, build)
notes/     my notes per dashboard (where today's version lives in development's code, what is still open)
history/   the build log, the Sunday checklist and the "how it was built" notes taken off the pages
save.sh    saves this repository and sends it to GitHub
```

## Turn my way of working on (once per laptop)

1. Clone this repository next to the BI-Dashboards folder, so the two folders sit side by side.
2. In VS Code, in the BI-Dashboards folder, type `/plugins` in the Claude Code panel.
3. On **Marketplaces**, add this folder's full path. On **Plugins**, install **mohammed** with **Install
   locally**.
4. Start a new conversation. «ابدأ لوحة…», «اقترح القواعد», «اعتمد القواعد» and «ابنِ اللوحة» now work, for me
   only.

## Saving

Claude Code saves this repository itself when my skills change the notes or the log. By hand:
`bash save.sh "what changed"`.
