#!/bin/bash
# Claude Code Stop hook: Claude bittiğinde oturum özeti günlüğe kaydet
# Denetim izi ve sprint izlemesi için neler üzerine çalışıldığını kaydeder

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
SESSION_LOG_DIR="production/session-logs"

mkdir -p "$SESSION_LOG_DIR" 2>/dev/null

# Bu oturumdan son git faaliyeti (8 saate kadar kontrol et, uzun oturumlar için)
RECENT_COMMITS=$(git log --oneline --since="8 hours ago" 2>/dev/null)
MODIFIED_FILES=$(git diff --name-only 2>/dev/null)

# --- Normal kapatma sırasında aktif oturum durumunu temizle ---
STATE_FILE="production/session-state/active.md"
if [ -f "$STATE_FILE" ]; then
    # Kaldırmadan önce oturum günlüğüne arşivle
    {
        echo "## Arşivlenen Oturum Durumu: $TIMESTAMP"
        cat "$STATE_FILE"
        echo "---"
        echo ""
    } >> "$SESSION_LOG_DIR/session-log.md" 2>/dev/null
    rm "$STATE_FILE" 2>/dev/null
fi

if [ -n "$RECENT_COMMITS" ] || [ -n "$MODIFIED_FILES" ]; then
    {
        echo "## Oturum Sonu: $TIMESTAMP"
        if [ -n "$RECENT_COMMITS" ]; then
            echo "### Taahhütler"
            echo "$RECENT_COMMITS"
        fi
        if [ -n "$MODIFIED_FILES" ]; then
            echo "### İşlenmemiş Değişiklikler"
            echo "$MODIFIED_FILES"
        fi
        echo "---"
        echo ""
    } >> "$SESSION_LOG_DIR/session-log.md" 2>/dev/null
fi

exit 0
