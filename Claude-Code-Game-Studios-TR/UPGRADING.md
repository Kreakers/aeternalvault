# Claude Code Game Studios Yükseltilmesi

Bu rehber, mevcut oyun projesi deponuzu şablonun bir sürümünden diğerine yükseltmeyi kapsamaktadır.

**Mevcut sürümünüzü bulun** git günlüğünüzde:
```bash
git log --oneline | grep -i "release\|setup"
```
Veya `README.md` içindeki sürüm rozetini kontrol edin.

---

## İçindekiler

- [Yükseltme Stratejileri](#yükseltme-stratejileri)
- [v0.2.0 → v0.3.0](#v020--v030)
- [v0.1.0 → v0.2.0](#v010--v020)

---

## Yükseltme Stratejileri

Şablon güncellemelerini almak için üç yol vardır. Deponuzun nasıl kurulduğuna göre seçin.

### Strateji A — Git Remote Merge (önerilen)

En iyisi: şablonu klonladıysanız ve onun üzerine kendi commit'leriniz varsa.

```bash
# Şablonu uzak depo olarak ekleyin (tek seferlik kurulum)
git remote add template https://github.com/Donchitos/Claude-Code-Game-Studios.git

# Yeni sürümü indirin
git fetch template main

# Dalınıza birleştirin
git merge template/main --allow-unrelated-histories
```

Git, yalnızca şablon *ve* siz tarafından değiştirilen dosyalardaki çakışmaları işaretler. Her birini çözün — oyun içeriğiniz girecek, yapısal iyileştirmeler de beraberinde gelecek. Ardından birleştirmeyi commit edin.

**İpucu:** En olası çakışma dosyaları `CLAUDE.md` ve `.claude/docs/technical-preferences.md` dosyalarıdır, çünkü bunları motor ve proje ayarlarınızla doldurdunuz. İçeriğinizi tutun; yapısal değişiklikleri kabul edin.

---

### Strateji B — Belirli commit'leri kişisel seçim yapın

En iyisi: yalnızca bir belirli özellik istiyorsanız (ör. yalnızca yeni beceri, tam güncelleme değil).

```bash
git remote add template https://github.com/Donchitos/Claude-Code-Game-Studios.git
git fetch template main

# İstediğiniz belirli commit'i(leri) kişisel seçim yapın
git cherry-pick <commit-sha>
```

Her sürüm için commit SHA'ları aşağıdaki sürüm bölümlerinde listelenmiştir.

---

### Strateji C — Manuel dosya kopyalama

En iyisi: şablonu git kullanarak kurmadıysanız (sadece bir zip indirdiyseniz).

1. Yeni sürümü deponuzun yanına indirin veya klonlayın.
2. **"Güvenle üzerine yazılabilir"** altında listelenen dosyaları doğrudan kopyalayın.
3. **"Dikkatli birleştirin"** altındaki dosyalar için her iki sürümü yan yana açın
   ve içeriğinizi tutarken yapısal değişiklikleri manuel olarak birleştirin.

---

## v0.2.0 → v0.3.0

**Yayımlanma:** 2026-03-09
**Commit aralığı:** `e289ce9..HEAD`
**Ana temalar:** `/design-system` GDD yazarlığı, `/map-systems` yeniden adlandırması, özel durum satırı

### Kırılan Değişiklikler

#### `/design-systems` ismi `/map-systems` olarak değiştirildi

`/design-systems` becerisi, netlik açısından `/map-systems` olarak yeniden adlandırıldı
(ayrıştırma = *haritalama*, *tasarlama* değil).

**Gerekli eylem:** `design-systems` çağrısını yapan herhangi bir dokümantasyon, not veya script güncelleyin.
Yeni çağrı `/map-systems` olur.

### Değişiklikler

| Kategori | Değişiklikler |
|----------|---------|
| **Yeni beceriler** | `/design-system` (rehberli GDD yazarlığı, bölüm-başına-bölüm) |
| **Yeniden adlandırılan beceriler** | `/design-systems` → `/map-systems` (kırılan yeniden adlandırma) |
| **Yeni dosyalar** | `.claude/statusline.sh`, `.claude/settings.json` durum satırı konfigürasyonu |
| **Beceri güncellemeleri** | `/gate-check` — PASS üzerine `production/stage.txt` yazılır, yeni aşama tanımları |
| **Beceri güncellemeleri** | `brainstorm`, `start`, `design-review`, `project-stage-detect`, `setup-engine` — çapraz referans düzeltmeleri |
| **Hata düzeltmeleri** | `log-agent.sh`, `validate-commit.sh` — kancası yürütme düzeltildi |
| **Dokümanlar** | `UPGRADING.md` eklendi, `README.md` güncellendi, `WORKFLOW-GUIDE.md` güncellendi |

---

### Dosyalar: Güvenle Üzerine Yazılabilir

**Eklenecek yeni dosyalar:**
```
.claude/skills/design-system/SKILL.md
.claude/statusline.sh
```

**Üzerine yazılacak mevcut dosyalar (kullanıcı içeriği yok):**
```
.claude/skills/map-systems/SKILL.md      ← önceden design-systems/SKILL.md
.claude/skills/gate-check/SKILL.md
.claude/skills/brainstorm/SKILL.md
.claude/skills/start/SKILL.md
.claude/skills/design-review/SKILL.md
.claude/skills/project-stage-detect/SKILL.md
.claude/skills/setup-engine/SKILL.md
.claude/hooks/log-agent.sh
.claude/hooks/validate-commit.sh
README.md
docs/WORKFLOW-GUIDE.md
UPGRADING.md
```

**Silme (yeniden adlandırmayla değiştirildi):**
```
.claude/skills/design-systems/   ← tüm dizin; map-systems/ ile değiştirildi
```

---

### Dosyalar: Dikkatli Birleştirin

#### `.claude/settings.json`

Yeni sürüm, `.claude/statusline.sh` öğesine işaret eden bir `statusLine` konfigürasyon bloğu ekler. `settings.json` özelleştirmediyseniz, üzerine yazma güvenlidir. Aksi takdirde, bu bloğu manuel olarak ekleyin:

```json
"statusLine": {
  "script": ".claude/statusline.sh"
}
```

---

### Yeni Özellikler

#### Özel Durum Satırı

`.claude/statusline.sh`, terminal durum satırında 7 aşamalı bir üretim boru hattı kırıntısı görüntüler:

```
ctx: 42% | claude-sonnet-4-6 | Systems Design
```

Üretim/Cilalama/Yayın aşamalarında, `production/session-state/active.md` içinden etkin Epic/Özellik/Görev'i de gösterir
eğer bir `<!-- STATUS -->` bloğu varsa:

```
ctx: 42% | claude-sonnet-4-6 | Production | Combat System > Melee Combat > Hitboxes
```

Mevcut aşama proje yapıtlarından otomatik olarak algılanır veya
`production/stage.txt` dosyasına bir aşama adı yazarak sabitlenebilir.

#### `/gate-check` Aşama İlerlemesi

Gate PASS kararı onaylandığında, `/gate-check` artık yeni aşama
adını `production/stage.txt` dosyasına yazılır. Bu, tüm gelecek oturumlar için durum satırını hemen günceller
manuel dosya düzenlemeleri gerektirmeden.

---

### Yükseltme Sonrası

1. **Eski beceri dizinini silin:**
   ```bash
   rm -rf .claude/skills/design-systems/
   ```

2. **Durum satırını test edin** Claude Code oturumu başlatarak —
   terminal alt bilgisinde aşama kırıntısını görmelisiniz.

3. **Kanca yürütmesini doğrulayın** hala çalışıyor:
   ```bash
   bash .claude/hooks/log-agent.sh '{}' '{}'
   bash .claude/hooks/validate-commit.sh '{}' '{}'
   ```

---

## v0.1.0 → v0.2.0

**Yayımlanma:** 2026-02-21
**Commit aralığı:** `ad540fe..e289ce9`
**Ana temalar:** İçerik Direnci, AskUserQuestion entegrasyonu, `/map-systems` becerisi

### Değişiklikler

| Kategori | Değişiklikler |
|----------|---------|
| **Yeni beceriler** | `/start` (onboarding), `/map-systems` (sistemler ayrışması), `/design-system` (rehberli GDD yazarlığı) |
| **Yeni kancalar** | `session-start.sh` (kurtarma), `detect-gaps.sh` (boşluk algılama) |
| **Yeni şablonlar** | `systems-index.md`, 3 işbirlikçi-protokol şablonu |
| **İçerik yönetimi** | Büyük yeniden yazma — dosya destekli durum stratejisi eklendi |
| **Ajan güncellemeleri** | 14 tasarım/yaratıcı ajan — AskUserQuestion entegrasyonu |
| **Beceri güncellemeleri** | Tüm 7 `team-*` beceriler + `brainstorm` — aşama geçişlerinde AskUserQuestion |
| **CLAUDE.md** | ~159 satırdan ~60 satıra indirildi; 10 yerine 5 doc içe aktarması |
| **Kanca güncellemeleri** | Tüm 8 kanca — Windows uyumluluğu düzeltmeleri, yeni özellikler |
| **Silinen dokümanlar** | `docs/IMPROVEMENTS-PROPOSAL.md`, `docs/MULTI-STAGE-DOCUMENT-WORKFLOW.md` |

---

### Dosyalar: Güvenle Üzerine Yazılabilir

Bunlar saf altyapıdır — bunları özelleştirmediyseniz. Proje içeriğinize hiçbir risk olmadan yeni sürümleri doğrudan kopyalayın.

**Eklenecek yeni dosyalar:**
```
.claude/skills/start/SKILL.md
.claude/skills/map-systems/SKILL.md
.claude/skills/design-system/SKILL.md
.claude/docs/templates/systems-index.md
.claude/docs/templates/collaborative-protocols/design-agent-protocol.md
.claude/docs/templates/collaborative-protocols/implementation-agent-protocol.md
.claude/docs/templates/collaborative-protocols/leadership-agent-protocol.md
.claude/hooks/detect-gaps.sh
.claude/hooks/session-start.sh
production/session-state/.gitkeep
docs/examples/README.md
.github/ISSUE_TEMPLATE/bug_report.md
.github/ISSUE_TEMPLATE/feature_request.md
.github/PULL_REQUEST_TEMPLATE.md
```

**Üzerine yazılacak mevcut dosyalar (kullanıcı içeriği yok):**
```
.claude/skills/brainstorm/SKILL.md
.claude/skills/design-review/SKILL.md
.claude/skills/gate-check/SKILL.md
.claude/skills/project-stage-detect/SKILL.md
.claude/skills/setup-engine/SKILL.md
.claude/skills/team-audio/SKILL.md
.claude/skills/team-combat/SKILL.md
.claude/skills/team-level/SKILL.md
.claude/skills/team-narrative/SKILL.md
.claude/skills/team-polish/SKILL.md
.claude/skills/team-release/SKILL.md
.claude/skills/team-ui/SKILL.md
.claude/hooks/log-agent.sh
.claude/hooks/pre-compact.sh
.claude/hooks/session-stop.sh
.claude/hooks/validate-assets.sh
.claude/hooks/validate-commit.sh
.claude/hooks/validate-push.sh
.claude/rules/design-docs.md
.claude/docs/hooks-reference.md
.claude/docs/skills-reference.md
.claude/docs/quick-start.md
.claude/docs/directory-structure.md
.claude/docs/context-management.md
docs/COLLABORATIVE-DESIGN-PRINCIPLE.md
docs/WORKFLOW-GUIDE.md
README.md
```

**Üzerine yazılacak ajan dosyaları** (bunlara özel istemler yazınızsa):
```
.claude/agents/art-director.md
.claude/agents/audio-director.md
.claude/agents/creative-director.md
.claude/agents/economy-designer.md
.claude/agents/game-designer.md
.claude/agents/level-designer.md
.claude/agents/live-ops-designer.md
.claude/agents/narrative-director.md
.claude/agents/producer.md
.claude/agents/systems-designer.md
.claude/agents/technical-director.md
.claude/agents/ux-designer.md
.claude/agents/world-builder.md
.claude/agents/writer.md
```

Eğer ajan istemlerini *özelleştirdiyseniz*, aşağıda "Dikkatli birleştirin" bölümüne bakın.

---

### Dosyalar: Dikkatli Birleştirin

Bu dosyalar hem şablon yapısını hem de projenize özel içeriği içerir.
Bunları **silmeyin** — değişiklikleri manuel olarak birleştirin.

#### `CLAUDE.md`

Şablon sürümü ~159 satırdan ~60 satıra indirildi. Temel yapısal değişiklik: 5 doc içe aktarması kaldırıldı, çünkü Claude Code tarafından zaten otomatik olarak yükleniyor (agent-roster, skills-reference, hooks-reference, rules-reference, review-workflow).

**Sürümünüzden tutacak şeyler:**
- `## Technology Stack` bölümü (motor/dil seçimleriniz)
- Yaptığınız herhangi bir projeye özel ekleme

**Yeni sürümden benimseyecek şeyler:**
- Daha ince içe aktarma listesi (mevcutsa redundant 5 `@` içe aktarmayı bırakın)
- Güncellenmiş işbirliği protokolü formülasyonu

#### `.claude/docs/technical-preferences.md`

`/setup-engine` çalıştırdıysanız, bu dosya motor konfigürasyonunuz, adlandırma kurallarınız ve performans bütçeleriniz vardır. Hepsini tutun. Şablon sürümü yalnızca boş yer tutucudur.

#### `.claude/docs/templates/game-concept.md`

Minor yapısal güncelleme — `/map-systems` öğesine işaret eden bir `## Next Steps` bölümü eklendi. Bu bölümü güncellenmiş rehberliği istiyorsanız kopyasına ekleyin, ancak gerekli değildir.

#### `.claude/settings.json`

Yeni sürümün istediğiniz herhangi bir izin kuralı ekleyip eklemediğini kontrol edin. Değişiklik önemsizdi (şema güncellemesi). `settings.json` özelleştirmediyseniz, üzerine yazma güvenlidir.

#### Özelleştirilmiş ajan dosyaları

Herhangi bir ajan `.md` dosyasına projeye özel bilgi veya özel davranış eklediyseniz, yeni AskUserQuestion entegrasyonu bölümlerini eklemek yerine diff yapın ve manuel olarak ekleyin. Her ajaندaki değişiklik, sistem isteminin sonunda standartlaştırılmış bir işbirlikçi protokol bloğudur.

---

### Dosyalar: Sil

Bu dosyalar v0.2.0'da kaldırıldı. Deponuzda mevcutsa, bunları güvenle silebilirsiniz — bunlar daha iyi organize edilmiş alternatifleriyle değiştirilmiştir.

```
docs/IMPROVEMENTS-PROPOSAL.md      → WORKFLOW-GUIDE.md tarafından değiştirildi
docs/MULTI-STAGE-DOCUMENT-WORKFLOW.md → içerik context-management.md'ye birleştirildi
```

---

### Yükseltme Sonrası

1. **`/project-stage-detect` çalıştırın** sistemin yeni algılama mantığıyla projenizi doğru şekilde okuduğunu doğrulamak için.

2. **`/start` çalıştırın** bir kez eğer kullanmadıysanız — artık aşamanızı doğru tanıyor ve zaten yaptığınız onboarding adımlarını atlıyor.

3. **`production/session-state/` mevcut olup gitignore'da mı kontrol edin:**
   ```bash
   ls production/session-state/
   cat .gitignore | grep session-state
   ```

4. **Kanca yürütmesini test edin** — Windows'ta iseniz, yeni kancaların Git Bash'te hatasız çalıştığını doğrulayın:
   ```bash
   bash .claude/hooks/detect-gaps.sh '{}' '{}'
   bash .claude/hooks/session-start.sh '{}' '{}'
   ```

---

*Her gelecek sürüm bu dosyada kendi bölümüne sahip olacak.*
