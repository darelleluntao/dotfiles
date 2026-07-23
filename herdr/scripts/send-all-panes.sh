#!/usr/bin/env bash
set -euo pipefail

WS=$(
  herdr pane list 2>/dev/null |
  python3 -c "
import json, sys
data = json.load(sys.stdin)
for p in data['result']['panes']:
    if p.get('focused'):
        print(p['workspace_id'])
        break
" 2>/dev/null
)

[ -z "${WS:-}" ] && WS=$(herdr workspace list 2>/dev/null | python3 -c "import json,sys;print(list(json.load(sys.stdin).get('result',{}).get('workspaces',[]))[0]['id'])" 2>/dev/null)

if [ -z "${WS:-}" ]; then
  osascript -e 'display notification "Could not determine workspace" with title "herdr send-all"'
  exit 1
fi

INPUT=$(osascript -e "Tell application \"System Events\" to display dialog \"Send to all panes in ${WS}:\" default answer \"\" with title \"herdr send-all\"" -e 'text returned of result' 2>/dev/null) || exit 0

[ -z "$INPUT" ] && exit 0

PANE_IDS=$(
  herdr pane list --workspace "$WS" 2>/dev/null |
  python3 -c "
import json, sys
for p in json.load(sys.stdin)['result']['panes']:
    print(p['pane_id'])
" 2>/dev/null
)

COUNT=0
while IFS= read -r pid; do
  [ -z "$pid" ] && continue
  herdr pane send-text "$pid" "$INPUT" 2>/dev/null || true
  herdr pane send-keys "$pid" enter 2>/dev/null || true
  COUNT=$((COUNT + 1))
done <<< "$PANE_IDS"

osascript -e "display notification \"Sent to ${COUNT} pane(s)\" with title \"herdr send-all\""
