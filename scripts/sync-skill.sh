#!/usr/bin/env bash
#
# Sync the canonical skill folder into the .claude and .agents mirrors.
#
# skills/mis-report/ is the single source of truth. This script replaces the
# contents of .claude/skills/mis-report/ and .agents/skills/mis-report/ with a
# copy of it. Run after editing anything under skills/mis-report/.
#
# Usage: ./scripts/sync-skill.sh

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL_NAME="mis-report"
SOURCE="$REPO_ROOT/skills/$SKILL_NAME"

if [ ! -d "$SOURCE" ]; then
    echo "Canonical skill folder not found: $SOURCE" >&2
    exit 1
fi

for TARGET in \
    "$REPO_ROOT/.claude/skills/$SKILL_NAME" \
    "$REPO_ROOT/.agents/skills/$SKILL_NAME"
do
    rm -rf "$TARGET"
    mkdir -p "$(dirname "$TARGET")"
    cp -R "$SOURCE" "$TARGET"

    COUNT=$(find "$TARGET" -maxdepth 1 -name '*.md' -type f | wc -l | tr -d ' ')
    echo "Synced $COUNT file(s) -> $TARGET"
done

echo "Done. Canonical source: $SOURCE"
