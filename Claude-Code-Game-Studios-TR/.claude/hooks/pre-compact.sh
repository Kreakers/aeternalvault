#!/bin/bash
# Claude Code PreCompact hook: Bağlam sıkıştırmasından önce oturum durumunu çöp at
# Bu çıkış sıkıştırma hemen öncesinde konuşmada görünür, kritik durum
# özet işleminden sağ çıkmasını sağlar.

echo "=== SIKIŞTıRMA ÖNCESİ OTURUM DURUMU ==="
echo "Zaman Damgası: $(date)"

# --- Aktif oturum durumu dosyası ---
STATE_FILE="production/session-state/active.md"
if [ -f "$STATE_FILE" ]; then
    echo ""
    echo "## Aktif Oturum Durumu (from $STATE_FILE)"
    STATE_LINES=$(wc -l < "$STATE_FILE" 2>/dev/null | tr -d ' ')
    if [ "$STATE_LINES" -gt 100 ] 2>/dev/null; then
        head -n 100 "$STATE_FILE"
        echo "... (kesildi — $STATE_LINES toplam satır, ilk 100 gösteriliyor)"
    else
        cat "$STATE_FILE"
    fi
else
    echo ""
    echo "## Aktif oturum durumu dosyası bulunamadı"
    echo "Daha iyi kurtarma için production/session-state/active.md dosyasını korumayı düşün."
fi

# --- Bu oturumda değiştirilen dosyalar (hazırlanmamış + hazırlanmış + izlenmeyen) ---
echo ""
echo "## Değiştirilen Dosyalar (git çalışma ağacı)"

CHANGED=$(git diff --name-only 2>/dev/null)
STAGED=$(git diff --staged --name-only 2>/dev/null)
UNTRACKED=$(git ls-files --others --exclude-standard 2>/dev/null)

if [ -n "$CHANGED" ]; then
    echo "Hazırlanmamış değişiklikler:"
    echo "$CHANGED" | while read -r f; do echo "  - $f"; done
fi
if [ -n "$STAGED" ]; then
    echo "Hazırlanmış değişiklikler:"
    echo "$STAGED" | while read -r f; do echo "  - $f"; done
fi
if [ -n "$UNTRACKED" ]; then
    echo "Yeni izlenmeyen dosyalar:"
    echo "$UNTRACKED" | while read -r f; do echo "  - $f"; done
fi
if [ -z "$CHANGED" ] && [ -z "$STAGED" ] && [ -z "$UNTRACKED" ]; then
    echo "  (işlenmemiş değişiklik yok)"
fi

# --- İş içinde tasarım belgeleri ---
echo ""
echo "## Tasarım Belgeleri — İş İçinde"

WIP_FOUND=false
for f in design/gdd/*.md; do
    [ -f "$f" ] || continue
    INCOMPLETE=$(grep -n -E "TODO|WIP|PLACEHOLDER|\[TO BE|\[TBD\]" "$f" 2>/dev/null)
    if [ -n "$INCOMPLETE" ]; then
        WIP_FOUND=true
        echo "  $f:"
        echo "$INCOMPLETE" | while read -r line; do echo "    $line"; done
    fi
done

if [ "$WIP_FOUND" = false ]; then
    echo "  (tasarım belgelerinde WIP işaretleri bulunamadı)"
fi

# --- Sıkıştırma olayını günlüğe kaydet ---
SESSION_LOG_DIR="production/session-logs"
mkdir -p "$SESSION_LOG_DIR" 2>/dev/null
echo "Bağlam sıkıştırması $(date) tarihinde gerçekleşti." \
    >> "$SESSION_LOG_DIR/compaction-log.txt" 2>/dev/null

echo ""
echo "## Kurtarma Talimatları"
echo "Sıkıştırmadan sonra tam çalışma bağlamını kurtarmak için $STATE_FILE dosyasını oku."
echo "Ardından aktif olarak çalışılan yukarıda listelenen dosyaları okuyun."
echo "=== OTURUM DURUMU SONU ==="

exit 0
