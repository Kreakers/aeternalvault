#!/bin/bash
# Claude Code PreToolUse hook: git push komutlarını doğrula
# Korumalı dallara itişlerde uyarı verir
# Exit 0 = izin ver, Exit 2 = engelle
#
# Giriş şeması (Bash için PreToolUse):
# { "tool_name": "Bash", "tool_input": { "command": "git push origin main" } }

INPUT=$(cat)

# Komutu ayrıştır -- kullanılabilirse jq kullan, aksi takdirde grep'e dön
if command -v jq >/dev/null 2>&1; then
    COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')
else
    COMMAND=$(echo "$INPUT" | grep -oE '"command"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/"command"[[:space:]]*:[[:space:]]*"//;s/"$//')
fi

# Yalnızca git push komutlarını işle
if ! echo "$COMMAND" | grep -qE '^git[[:space:]]+push'; then
    exit 0
fi

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
MATCHED_BRANCH=""

# Korumalı dala itilip itilmediğini kontrol et
for branch in develop main master; do
    if [ "$CURRENT_BRANCH" = "$branch" ]; then
        MATCHED_BRANCH="$branch"
        break
    fi
    # Ayrıca açık olarak korumalı dala itilip itilmediğini kontrol et (dal adını güvenlik için tırnak içine al)
    if echo "$COMMAND" | grep -qE "[[:space:]]${branch}([[:space:]]|$)"; then
        MATCHED_BRANCH="$branch"
        break
    fi
done

if [ -n "$MATCHED_BRANCH" ]; then
    echo "Korumalı dal '$MATCHED_BRANCH' için itme algılandı." >&2
    echo "Hatırlatma: Derleme geçerliliğini, birim testlerini geçerliliğini ve S1/S2 hataları olmadığını sağla." >&2
    # İtme'yi izin ver ama uyar -- engel etmek için aşağıdaki yorum açın:
    # echo "ENGELLENDİ: $CURRENT_BRANCH'ye itişlemeden önce testler çalıştır" >&2
    # exit 2
fi

exit 0
