#!/bin/bash
# Claude Code PostToolUse hook: Write/Edit'ten sonra varlık dosyalarını doğrula
# assets/ dizininde dosyalar için adlandırma kurallarını kontrol eder
# Exit 0 = başarı (bloklamayan, PostToolUse engelleyemez)
#
# Giriş şeması (Write/Edit için PostToolUse):
# { "tool_name": "Write", "tool_input": { "file_path": "assets/data/foo.json", "content": "..." } }

INPUT=$(cat)

# Dosya yolunu ayrıştır -- kullanılabilirse jq kullan, aksi takdirde grep'e dön
if command -v jq >/dev/null 2>&1; then
    FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
else
    FILE_PATH=$(echo "$INPUT" | grep -oE '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/"file_path"[[:space:]]*:[[:space:]]*"//;s/"$//')
fi

# Yol ayırıcılarını normalleştir (Windows ters eğik çizgi ileriye eğik çizgi)
FILE_PATH=$(echo "$FILE_PATH" | sed 's|\\|/|g')

# Yalnızca assets/ içindeki dosyaları kontrol et
if ! echo "$FILE_PATH" | grep -qE '(^|/)assets/'; then
    exit 0
fi

FILENAME=$(basename "$FILE_PATH")
WARNINGS=""

# Adlandırma kuralını kontrol et (sadece alt çizgi ile küçük harf) -- grep -E kullanır grep -P yerine
if echo "$FILENAME" | grep -qE '[A-Z[:space:]-]'; then
    WARNINGS="$WARNINGS\nADLANDIRMA: $FILE_PATH küçük harf ve alt çizgiler olmalı (aldığınız: $FILENAME)"
fi

# Veri dosyaları için JSON geçerliliğini kontrol et
if echo "$FILE_PATH" | grep -qE '(^|/)assets/data/.*\.json$'; then
    if [ -f "$FILE_PATH" ]; then
        # Çalışan bir Python komutunu bul
        PYTHON_CMD=""
        for cmd in python python3 py; do
            if command -v "$cmd" >/dev/null 2>&1; then
                PYTHON_CMD="$cmd"
                break
            fi
        done

        if [ -n "$PYTHON_CMD" ]; then
            if ! "$PYTHON_CMD" -m json.tool "$FILE_PATH" > /dev/null 2>&1; then
                WARNINGS="$WARNINGS\nBİÇİM: $FILE_PATH geçerli JSON değil"
            fi
        fi
    fi
fi

if [ -n "$WARNINGS" ]; then
    echo -e "=== Varlık Doğrulaması ===$WARNINGS\n========================" >&2
fi

exit 0
