#!/usr/bin/env bash
set -euo pipefail

WS=$(herdr pane list 2>/dev/null | python3 -c "
import json, sys
for p in json.load(sys.stdin)['result']['panes']:
    if p.get('focused'):
        print(p['workspace_id'])
        break
") || exit 1

[ -z "${WS:-}" ] && exit 1

while IFS= read -r pid; do
  [ -z "$pid" ] && continue
  LABEL=$(echo "$pid" | cut -d: -f2 | tr '[:lower:]' '[:upper:]')
  herdr pane rename "$pid" "$LABEL" 2>/dev/null || true
done < <(herdr pane list --workspace "$WS" 2>/dev/null | python3 -c "
import json, sys
for p in json.load(sys.stdin)['result']['panes']:
    print(p['pane_id'])
")

echo "panes labeled"
