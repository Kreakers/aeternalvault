#!/bin/bash
# Claude Code PreToolUse hook: git taahhüt komutlarını doğrula
# stdin'de tool_input.command ile JSON alır
# Exit 0 = izin ver, Exit 2 = engelle (stderr Claude'e gösterilir)
#
# Giriş şeması (Bash için PreToolUse):
# { "tool_name": "Bash", "tool_input": { "command": "git commit -m ..." } }

INPUT=$(cat)

# Komutu ayrıştır -- kullanılabilirse jq kullan, aksi takdirde grep'e dön
if command -v jq >/dev/null 2>&1; then
    COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')
else
    COMMAND=$(echo "$INPUT" | grep -oE '"command"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/"command"[[:space:]]*:[[:space:]]*"//;s/"$//')
fi

# Yalnızca git taahhüt komutlarını işle
if ! echo "$COMMAND" | grep -qE '^git[[:space:]]+commit'; then
    exit 0
fi

# Hazırlanan dosyaları al
STAGED=$(git diff --cached --name-only 2>/dev/null)
if [ -z "$STAGED" ]; then
    exit 0
fi

WARNINGS=""

# Tasarım belgelerini gerekli bölümler için kontrol et
DESIGN_FILES=$(echo "$STAGED" | grep -E '^design/gdd/')
if [ -n "$DESIGN_FILES" ]; then
    while IFS= read -r file; do
        if [[ "$file" == *.md ]] && [ -f "$file" ]; then
            for section in "Overview" "Player Fantasy" "Detailed" "Formulas" "Edge Cases" "Dependencies" "Tuning Knobs" "Acceptance Criteria"; do
                if ! grep -qi "$section" "$file"; then
                    WARNINGS="$WARNINGS\nTASARIM: $file eksik gerekli bölüm: $section"
                fi
            done
        fi
    done <<< "$DESIGN_FILES"
fi

# JSON veri dosyalarını doğrula -- geçersiz JSON'i engelle
DATA_FILES=$(echo "$STAGED" | grep -E '^assets/data/.*\.json$')
if [ -n "$DATA_FILES" ]; then
    # Çalışan bir Python komutunu bul
    PYTHON_CMD=""
    for cmd in python python3 py; do
        if command -v "$cmd" >/dev/null 2>&1; then
            PYTHON_CMD="$cmd"
            break
        fi
    done

    while IFS= read -r file; do
        if [ -f "$file" ]; then
            if [ -n "$PYTHON_CMD" ]; then
                if ! "$PYTHON_CMD" -m json.tool "$file" > /dev/null 2>&1; then
                    echo "ENGELLENDİ: $file geçerli JSON değil" >&2
                    exit 2
                fi
            else
                echo "UYARI: JSON doğrulayamıyor (python bulunamadı): $file" >&2
            fi
        fi
    done <<< "$DATA_FILES"
fi

# Oynanış kodunda sabit kodlanmış oynanış değerlerini kontrol et
# Platform uyumluluğu için grep -E (POSIX extended) kullanır, grep -P (Perl) yerine
CODE_FILES=$(echo "$STAGED" | grep -E '^src/gameplay/')
if [ -n "$CODE_FILES" ]; then
    while IFS= read -r file; do
        if [ -f "$file" ]; then
            if grep -nE '(damage|health|speed|rate|chance|cost|duration)[[:space:]]*[:=][[:space:]]*[0-9]+' "$file" 2>/dev/null; then
                WARNINGS="$WARNINGS\nKOD: $file sabit kodlanmış oynanış değerleri içerebilir. Veri dosyalarını kullan."
            fi
        fi
    done <<< "$CODE_FILES"
fi

# Sorumlu olmayan TODO/FIXME'yi kontrol et -- grep -E kullanır grep -P yerine
SRC_FILES=$(echo "$STAGED" | grep -E '^src/')
if [ -n "$SRC_FILES" ]; then
    while IFS= read -r file; do
        if [ -f "$file" ]; then
            if grep -nE '(TODO|FIXME|HACK)[^(]' "$file" 2>/dev/null; then
                WARNINGS="$WARNINGS\nSTİL: $file sahip etiketi olmayan TODO/FIXME'ye sahip. TODO(ad) biçimini kullan."
            fi
        fi
    done <<< "$SRC_FILES"
fi

# Uyarıları yazdır (bloklamayan) ve taahhüte izin ver
if [ -n "$WARNINGS" ]; then
    echo -e "=== Taahhüt Doğrulaması Uyarıları ===$WARNINGS\n================================" >&2
fi

exit 0
