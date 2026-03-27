#!/bin/bash
# Claude Code SubagentStart hook: Denetim izi için aracı çağırmaları günlüğe kaydet
# Hangi aracıların kullanıldığını ve ne zaman kullanıldığını izle
#
# Giriş şeması (SubagentStart):
# { "agent_id": "agent-abc123", "agent_name": "game-designer", ... }

INPUT=$(cat)

# Aracı adını ayrıştır -- kullanılabilirse jq kullan, aksi takdirde grep'e dön
if command -v jq >/dev/null 2>&1; then
    AGENT_NAME=$(echo "$INPUT" | jq -r '.agent_name // "unknown"' 2>/dev/null)
else
    AGENT_NAME=$(echo "$INPUT" | grep -oE '"agent_name"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/"agent_name"[[:space:]]*:[[:space:]]*"//;s/"$//')
    [ -z "$AGENT_NAME" ] && AGENT_NAME="unknown"
fi

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
SESSION_LOG_DIR="production/session-logs"

mkdir -p "$SESSION_LOG_DIR" 2>/dev/null

echo "$TIMESTAMP | Aracı çağrıldı: $AGENT_NAME" >> "$SESSION_LOG_DIR/agent-audit.log" 2>/dev/null

exit 0
