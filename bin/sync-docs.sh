#!/usr/bin/env bash
# Sync the Fujin Shuttle docs from a flyokai/flyokai checkout into this repo's docs/ tree.
#
# Usage (local dev):
#   FLYOKAI_SOURCE_DIR=/www/sw6610/flyokai bin/sync-docs.sh
#
# Usage (CI): the workflow clones flyokai/flyokai to /tmp/flyokai-source and
# exports FLYOKAI_SOURCE_DIR=/tmp/flyokai-source before invoking this script.
#
# This is the **only** way content lands under docs/. Do not hand-edit docs/*.md;
# the next sync overwrites them. Edit upstream in flyokai/flyokai's
# fujin-shuttle-docs/docs/ directory instead.

set -euo pipefail

SRC="${FLYOKAI_SOURCE_DIR:?Set FLYOKAI_SOURCE_DIR to a flyokai/flyokai checkout root}"
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC_DOCS="$SRC/fujin-shuttle-docs/docs"
DEST="$REPO_ROOT/docs"

[[ -d "$SRC_DOCS" ]] || { echo "Error: $SRC_DOCS not found" >&2; exit 1; }

# Wipe and recreate so deleted upstream pages disappear from the site.
rm -rf "$DEST"
mkdir -p "$DEST"

# The Fujin Shuttle docs are self-contained — pages cross-link with
# sibling-relative paths that resolve as-is on the site, so no rewriting is
# needed. Copy them verbatim.
cp -R "$SRC_DOCS/." "$DEST/"

# Non-md files mkdocs copies verbatim — the CNAME marks the custom domain.
echo "fujin.flyokai.com" > "$DEST/CNAME"

echo "Synced from: $SRC_DOCS"
echo "Files in $DEST:"
ls "$DEST"
