#!/bin/bash
# Claude Code SessionStart hook: Oturum başında proje bağlamını yükle
# Claude'un oturum başladığında gördüğü bağlam bilgisini çıkart
#
# Giriş şeması (SessionStart): stdin girişi yok

echo "=== Claude Code Oyun Stüdyoları — Oturum Bağlamı ==="

# Mevcut dal
BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
if [ -n "$BRANCH" ]; then
    echo "Dal: $BRANCH"

    # Son taahhütler
    echo ""
    echo "Son taahhütler:"
    git log --oneline -5 2>/dev/null | while read -r line; do
        echo "  $line"
    done
fi

# Mevcut sprint (en son sprint dosyasını bul)
LATEST_SPRINT=$(ls -t production/sprints/sprint-*.md 2>/dev/null | head -1)
if [ -n "$LATEST_SPRINT" ]; then
    echo ""
    echo "Aktif sprint: $(basename "$LATEST_SPRINT" .md)"
fi

# Mevcut kilometre taşı
LATEST_MILESTONE=$(ls -t production/milestones/*.md 2>/dev/null | head -1)
if [ -n "$LATEST_MILESTONE" ]; then
    echo "Aktif kilometre taşı: $(basename "$LATEST_MILESTONE" .md)"
fi

# Açık hata sayısı
BUG_COUNT=0
for dir in tests/playtest production; do
    if [ -d "$dir" ]; then
        count=$(find "$dir" -name "BUG-*.md" 2>/dev/null | wc -l)
        BUG_COUNT=$((BUG_COUNT + count))
    fi
done
if [ "$BUG_COUNT" -gt 0 ]; then
    echo "Açık hatalar: $BUG_COUNT"
fi

# Kod sağlığı hızlı kontrolü
if [ -d "src" ]; then
    TODO_COUNT=$(grep -r "TODO" src/ 2>/dev/null | wc -l)
    FIXME_COUNT=$(grep -r "FIXME" src/ 2>/dev/null | wc -l)
    if [ "$TODO_COUNT" -gt 0 ] || [ "$FIXME_COUNT" -gt 0 ]; then
        echo ""
        echo "Kod sağlığı: src/ içinde ${TODO_COUNT} TODO, ${FIXME_COUNT} FIXME"
    fi
fi

# --- Aktif oturum durumu kurtarması ---
STATE_FILE="production/session-state/active.md"
if [ -f "$STATE_FILE" ]; then
    echo ""
    echo "=== AKTIF OTURUM DURUMU ALGILANDI ==="
    echo "Önceki oturum durumu bıraktı: $STATE_FILE"
    echo "Bağlamı kurtarmak ve kestiğiniz yerde devam etmek için bu dosyayı okuyun."
    echo ""
    echo "Hızlı özet:"
    head -20 "$STATE_FILE" 2>/dev/null
    TOTAL_LINES=$(wc -l < "$STATE_FILE" 2>/dev/null)
    if [ "$TOTAL_LINES" -gt 20 ]; then
        echo "  ... ($TOTAL_LINES toplam satır — devam etmek için tam dosyayı okuyun)"
    fi
    echo "=== OTURUM DURUMU ÖNİZLEME SONU ==="
fi

echo "==================================="
exit 0
