#!/bin/bash
# Hook: detect-gaps.sh
# Event: SessionStart
# Amaç: Kod/prototiplerin var olduğu ancak belgeleme eksik olduğunu algıla
# Platformlar arası: Windows Git Bash uyumlu (grep -E kullanır, -P değil)

# Hata ayıklama için çıkış (ama oturumu başarısız kılma)
set +e

echo "=== Belgeleme Boşlukları İçin Kontrol Ediliyor ==="

# --- Check 0: Yeni proje algılaması (/start önerir) ---
FRESH_PROJECT=true

# Motorun yapılandırılıp yapılandırılmadığını kontrol et
if [ -f ".claude/docs/technical-preferences.md" ]; then
  ENGINE_LINE=$(grep -E "^\- \*\*Engine\*\*:" .claude/docs/technical-preferences.md 2>/dev/null)
  if [ -n "$ENGINE_LINE" ] && ! echo "$ENGINE_LINE" | grep -q "TO BE CONFIGURED" 2>/dev/null; then
    FRESH_PROJECT=false
  fi
fi

# Oyun konsepti var mı kontrol et
if [ -f "design/gdd/game-concept.md" ]; then
  FRESH_PROJECT=false
fi

# Kaynak kodu var mı kontrol et
if [ -d "src" ]; then
  SRC_CHECK=$(find src -type f \( -name "*.gd" -o -name "*.cs" -o -name "*.cpp" -o -name "*.c" -o -name "*.h" -o -name "*.hpp" -o -name "*.rs" -o -name "*.py" -o -name "*.js" -o -name "*.ts" \) 2>/dev/null | head -1)
  if [ -n "$SRC_CHECK" ]; then
    FRESH_PROJECT=false
  fi
fi

if [ "$FRESH_PROJECT" = true ]; then
  echo ""
  echo "YENİ PROJE: Motor yapılandırılmamış, oyun konsepti yok, kaynak kodu yok."
  echo "   Bu yeni bir başlangıç gibi görünüyor! Şunu çalıştır: /start"
  echo ""
  echo "Kapsamlı bir proje analizi almak için şunu çalıştır: /project-stage-detect"
  echo "==================================="
  exit 0
fi

# --- Check 1: Kapsamlı kod tabanı ama seyrek tasarım belgeleri ---
if [ -d "src" ]; then
  # Kaynak dosyalarını say (platformlar arası, Windows yollarını işler)
  SRC_FILES=$(find src -type f \( -name "*.gd" -o -name "*.cs" -o -name "*.cpp" -o -name "*.c" -o -name "*.h" -o -name "*.hpp" -o -name "*.rs" -o -name "*.py" -o -name "*.js" -o -name "*.ts" \) 2>/dev/null | wc -l)
else
  SRC_FILES=0
fi

if [ -d "design/gdd" ]; then
  DESIGN_FILES=$(find design/gdd -type f -name "*.md" 2>/dev/null | wc -l)
else
  DESIGN_FILES=0
fi

# wc çıktısından beyaz boşluğu normalleştir
SRC_FILES=$(echo "$SRC_FILES" | tr -d ' ')
DESIGN_FILES=$(echo "$DESIGN_FILES" | tr -d ' ')

if [ "$SRC_FILES" -gt 50 ] && [ "$DESIGN_FILES" -lt 5 ]; then
  echo "⚠️  BOŞLUK: Kapsamlı kod tabanı ($SRC_FILES kaynak dosyası) ama seyrek tasarım belgeleri ($DESIGN_FILES dosyası)"
  echo "    Önerilen eylem: /reverse-document design src/[sistem]"
  echo "    Veya çalıştır: /project-stage-detect tam analiz almak için"
fi

# --- Check 2: Belgesiz prototipleri ---
if [ -d "prototypes" ]; then
  PROTOTYPE_DIRS=$(find prototypes -mindepth 1 -maxdepth 1 -type d 2>/dev/null)
  UNDOCUMENTED_PROTOS=()

  if [ -n "$PROTOTYPE_DIRS" ]; then
    while IFS= read -r proto_dir; do
      # Windows için yol ayırıcılarını normalleştir
      proto_dir=$(echo "$proto_dir" | sed 's|\\|/|g')

      # README.md veya CONCEPT.md için kontrol et
      if [ ! -f "${proto_dir}/README.md" ] && [ ! -f "${proto_dir}/CONCEPT.md" ]; then
        proto_name=$(basename "$proto_dir")
        UNDOCUMENTED_PROTOS+=("$proto_name")
      fi
    done <<< "$PROTOTYPE_DIRS"

    if [ ${#UNDOCUMENTED_PROTOS[@]} -gt 0 ]; then
      echo "⚠️  BOŞLUK: ${#UNDOCUMENTED_PROTOS[@]} belgesiz prototip(ler) bulundu:"
      for proto in "${UNDOCUMENTED_PROTOS[@]}"; do
        echo "    - prototypes/$proto/ (README veya CONCEPT belgesi yok)"
      done
      echo "    Önerilen eylem: /reverse-document concept prototypes/[ad]"
    fi
  fi
fi

# --- Check 3: Mimari belgeler olmayan temel sistemler ---
if [ -d "src/core" ] || [ -d "src/engine" ]; then
  if [ ! -d "docs/architecture" ]; then
    echo "⚠️  BOŞLUK: Temel motor/sistemler var ama docs/architecture/ dizini yok"
    echo "    Önerilen eylem: docs/architecture/ oluştur ve /architecture-decision çalıştır"
  else
    ADR_COUNT=$(find docs/architecture -type f -name "*.md" 2>/dev/null | wc -l)
    ADR_COUNT=$(echo "$ADR_COUNT" | tr -d ' ')

    if [ "$ADR_COUNT" -lt 3 ]; then
      echo "⚠️  BOŞLUK: Temel sistemler var ama sadece $ADR_COUNT ADR belgelendi"
      echo "    Önerilen eylem: /reverse-document architecture src/core/[sistem]"
    fi
  fi
fi

# --- Check 4: Tasarım belgeler olmayan oynanış sistemleri ---
if [ -d "src/gameplay" ]; then
  # 5+ dosyası olan ana oynanış alt dizinlerini bul
  GAMEPLAY_SYSTEMS=$(find src/gameplay -mindepth 1 -maxdepth 1 -type d 2>/dev/null)

  if [ -n "$GAMEPLAY_SYSTEMS" ]; then
    while IFS= read -r system_dir; do
      system_dir=$(echo "$system_dir" | sed 's|\\|/|g')
      system_name=$(basename "$system_dir")
      file_count=$(find "$system_dir" -type f 2>/dev/null | wc -l)
      file_count=$(echo "$file_count" | tr -d ' ')

      # Sistem 5+ dosyaya sahipse, karşılık gelen tasarım belgesini kontrol et
      if [ "$file_count" -ge 5 ]; then
        # Tasarım belgesini ara (varyasyonlara izin ver: combat-system.md, combat.md)
        design_doc_1="design/gdd/${system_name}-system.md"
        design_doc_2="design/gdd/${system_name}.md"

        if [ ! -f "$design_doc_1" ] && [ ! -f "$design_doc_2" ]; then
          echo "⚠️  BOŞLUK: 'src/gameplay/$system_name/' oynanış sistemi ($file_count dosyası) tasarım belgesi yok"
          echo "    Beklenen: design/gdd/${system_name}-system.md veya design/gdd/${system_name}.md"
          echo "    Önerilen eylem: /reverse-document design src/gameplay/$system_name"
        fi
      fi
    done <<< "$GAMEPLAY_SYSTEMS"
  fi
fi

# --- Check 5: Üretim planlama ---
if [ "$SRC_FILES" -gt 100 ]; then
  # Kapsamlı kod içeren projeler için üretim planlama kontrol et
  if [ ! -d "production/sprints" ] && [ ! -d "production/milestones" ]; then
    echo "⚠️  BOŞLUK: Büyük kod tabanı ($SRC_FILES dosyası) ama üretim planlama bulunamadı"
    echo "    Önerilen eylem: /sprint-plan veya production/ dizini oluştur"
  fi
fi

# --- Özet ---
echo ""
echo "Kapsamlı bir proje analizi almak için şunu çalıştır: /project-stage-detect"
echo "==================================="

exit 0
