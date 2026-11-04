# My BI dashboards workspace (private)

Mohammed's own things for the BI dashboards, kept out of the shared `CleanLifeCom/BI-Dashboards`
repository:

```
method/     my way of working: a Claude Code plugin with my skills (start, propose rules, approve, build,
            and the plain-words helpers: set up, save, get the latest, send for review, check, ask the data)
tools/      the scripts those skills run from inside the BI-Dashboards folder (setup, branch, save, update,
            review), and apply-settings.js, which adds my Claude Code settings to that folder
settings/   my Claude Code settings for the BI-Dashboards folder
notes/      my notes per dashboard (where today's version lives in development's code, what is still open)
history/    the build log, the Sunday checklist and the "how it was built" notes taken off the pages
guide-ar.md my guide to working in plain words
save.sh     saves this repository and sends it to GitHub
```

## On a new laptop

1. Clone this repository next to the BI-Dashboards folder, so the two folders sit side by side.
2. In VS Code, in the BI-Dashboards folder, type `/plugins` in the Claude Code panel. On **Marketplaces**,
   add this folder's full path. On **Plugins**, install **mohammed** with **Install locally**.
3. In the BI-Dashboards folder's terminal: `node ../bi-dashboards-personal/tools/apply-settings.js`
4. Start a new conversation and say «جهّز جهازي».

## Saving

My skills save this repository themselves when they change my notes or the log. By hand:
`bash save.sh "what changed"`.
