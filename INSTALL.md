# Installing the MIS Reporting Skill

This skill is a folder of Markdown files. Installing it means copying that
folder to the location your agent client reads skills from.

**Copy the complete `skills/mis-report` directory, not only `SKILL.md`.**
`SKILL.md` routes to the other ten files; without them the skill is a stub.

---

## Directory mapping

| Client | Scope | Destination |
|---|---|---|
| **Claude Code** | User (all projects) | `${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills/mis-report` |
| **Claude Code** | Project | `<project>/.claude/skills/mis-report` |
| **Codex** | User (all projects) | `$HOME/.agents/skills/mis-report` |
| **Codex** | Project | `<project>/.agents/skills/mis-report` |

On Windows, `$HOME` is `%USERPROFILE%` — e.g.
`C:\Users\<you>\.claude\skills\mis-report`.

---

## Files to copy

All eleven, from `skills/mis-report/`:

```
SKILL.md
data-model.md
calculations-powerbi.md
calculations-tableau.md
comparison-metrics.md
number-formatting.md
visual-design.md
filters-interactivity.md
report-architecture.md
performance-governance.md
review-checklist.md
```

---

## Manual install

### macOS / Linux

```bash
git clone https://github.com/gendsonmoreira/mis-reporting-skill.git
mkdir -p "${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills"
cp -R mis-reporting-skill/skills/mis-report \
      "${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills/"
```

For Codex, replace the destination with `$HOME/.agents/skills/`.

### Windows (PowerShell)

```powershell
git clone https://github.com/gendsonmoreira/mis-reporting-skill.git
$dest = Join-Path $env:USERPROFILE ".claude\skills"
New-Item -ItemType Directory -Force $dest | Out-Null
Copy-Item -Recurse -Force `
  ".\mis-reporting-skill\skills\mis-report" $dest
```

### Updating

Re-run the copy with overwrite. To remove, delete the `mis-report` folder from
the destination.

---

## Verifying the install

1. Confirm eleven `.md` files are present in the destination folder.
2. Confirm `SKILL.md` starts with YAML frontmatter containing
   `name: mis-report`.
3. Start a new session in your client and run:

   ```
   /mis-report build a YoY revenue measure for Power BI
   ```

   The skill should load and return a `CALCULATE` / `SAMEPERIODLASTYEAR`
   pattern with a `DIVIDE` guard — and should ask about your fiscal calendar.

If the slash command is not recognised, the client has not picked up the folder:
check the path against the table above and restart the client.

---

## Installing as a plugin

A plugin manifest is provided in [`.claude-plugin/`](.claude-plugin/) for
marketplace-style installation. Use **either** the plugin install **or** the
standalone copy for a given client, not both — two copies of the same skill
produce duplicate matches.

---

## Developing on this repo

`skills/mis-report/` is the canonical source. The `.claude/skills/mis-report/`
and `.agents/skills/mis-report/` folders in this repository are **generated
mirrors** — do not edit them directly.

After changing anything under `skills/mis-report/`:

```powershell
.\scripts\sync-skill.ps1        # Windows
```

```bash
./scripts/sync-skill.sh         # macOS / Linux
```
