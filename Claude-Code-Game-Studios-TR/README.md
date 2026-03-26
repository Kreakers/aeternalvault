<p align="center">
  <h1 align="center">Claude Code Game Studios</h1>
  <p align="center">
    Tek bir Claude Code oturumunu tam kapsamlı bir oyun geliştirme stüdyosuna dönüştürün.
    <br />
    48 ajan. 37 iş akışı. Tek bir koordineli yapay zeka ekibi.
  </p>
</p>

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="MIT Lisansı"></a>
  <a href=".claude/agents"><img src="https://img.shields.io/badge/agents-48-blueviolet" alt="48 Ajan"></a>
  <a href=".claude/skills"><img src="https://img.shields.io/badge/skills-37-green" alt="37 Beceri"></a>
  <a href=".claude/hooks"><img src="https://img.shields.io/badge/hooks-8-orange" alt="8 Hook"></a>
  <a href=".claude/rules"><img src="https://img.shields.io/badge/rules-11-red" alt="11 Kural"></a>
  <a href="https://docs.anthropic.com/en/docs/claude-code"><img src="https://img.shields.io/badge/built%20for-Claude%20Code-f5f5f5?logo=anthropic" alt="Claude Code için geliştirildi"></a>
  <a href="https://ko-fi.com/donchitos"><img src="https://img.shields.io/badge/Ko--fi-Support%20this%20project-ff5e5b?logo=ko-fi&logoColor=white" alt="Ko-fi"></a>
</p>

---

## Neden Var?

Yapay zeka ile solo oyun geliştirmek güçlüdür — ancak tek bir sohbet oturumunun hiçbir yapısı yoktur. Sizi sabit kodlanmış sihirli sayılar kullanmaktan, tasarım belgelerini atlamaktan ya da spagetti kod yazmaktan alıkoyan kimse yoktur. QA geçişi, tasarım incelemesi ya da "bu gerçekten oyunun vizyonuna uyuyor mu?" diye soran biri yok.

**Claude Code Game Studios**, yapay zeka oturumunuza gerçek bir stüdyonun yapısını vererek bu sorunu çözer. Tek bir genel amaçlı asistan yerine, stüdyo hiyerarşisinde organize edilmiş 48 özelleşmiş ajan elde edersiniz — vizyonu koruyan yöneticiler, kendi alanlarına sahip departman liderleri ve uygulamalı işleri yapan uzmanlar. Her ajanın tanımlanmış sorumlulukları, yükseltme yolları ve kalite kapıları vardır.

Sonuç: Tüm kararları siz almaya devam edersiniz, ancak artık doğru soruları soran, hataları erken yakalayan ve projenizi ilk beyin fırtınasından lansmana kadar düzenli tutan bir ekibiniz var.

---

## İçindekiler

- [Neler Dahil](#neler-dahil)
- [Stüdyo Hiyerarşisi](#stüdyo-hiyerarşisi)
- [Eğik Çizgi Komutları](#eğik-çizgi-komutları)
- [Başlarken](#başlarken)
- [Yükseltme](#yükseltme)
- [Proje Yapısı](#proje-yapısı)
- [Nasıl Çalışır](#nasıl-çalışır)
- [Tasarım Felsefesi](#tasarım-felsefesi)
- [Özelleştirme](#özelleştirme)
- [Platform Desteği](#platform-desteği)
- [Topluluk](#topluluk)
- [Lisans](#lisans)

---

## Neler Dahil

| Kategori | Adet | Açıklama |
|----------|-------|-------------|
| **Ajanlar** | 48 | Tasarım, programlama, sanat, ses, anlatı, QA ve prodüksiyon alanlarında uzmanlaşmış alt ajanlar |
| **Beceriler** | 37 | Yaygın iş akışları için eğik çizgi komutları (`/start`, `/sprint-plan`, `/code-review`, `/brainstorm`, vb.) |
| **Hook'lar** | 8 | Commit'ler, push'lar, varlık değişiklikleri, oturum yaşam döngüsü, ajan denetimi ve boşluk tespitinde otomatik doğrulama |
| **Kurallar** | 11 | Oynanış, motor, yapay zeka, arayüz, ağ kodu ve daha fazlasını düzenlerken uygulanan yola dayalı kodlama standartları |
| **Şablonlar** | 29 | GDD'ler, ADR'ler, sprint planları, ekonomi modelleri, grup tasarımı ve daha fazlası için belge şablonları |

## Stüdyo Hiyerarşisi

Ajanlar, gerçek stüdyoların çalışma biçimiyle örtüşen üç kademede organize edilmiştir:

```
Kademe 1 — Yöneticiler (Opus)
  creative-director    technical-director    producer

Kademe 2 — Departman Liderleri (Sonnet)
  game-designer        lead-programmer       art-director
  audio-director       narrative-director    qa-lead
  release-manager      localization-lead

Kademe 3 — Uzmanlar (Sonnet/Haiku)
  gameplay-programmer  engine-programmer     ai-programmer
  network-programmer   tools-programmer      ui-programmer
  systems-designer     level-designer        economy-designer
  technical-artist     sound-designer        writer
  world-builder        ux-designer           prototyper
  performance-analyst  devops-engineer       analytics-engineer
  security-engineer    qa-tester             accessibility-specialist
  live-ops-designer    community-manager
```

### Motor Uzmanları

Şablon, üç büyük motor için ajan setleri içerir. Projenize uygun seti kullanın:

| Motor | Baş Ajan | Alt Uzmanlar |
|--------|-----------|-----------------|
| **Godot 4** | `godot-specialist` | GDScript, Shader'lar, GDExtension |
| **Unity** | `unity-specialist` | DOTS/ECS, Shader'lar/VFX, Addressables, UI Toolkit |
| **Unreal Engine 5** | `unreal-specialist` | GAS, Blueprint'ler, Replication, UMG/CommonUI |

## Eğik Çizgi Komutları

37 becerinin tamamına erişmek için Claude Code'da `/` yazın:

**İnceleme ve Analiz**
`/design-review` `/code-review` `/balance-check` `/asset-audit` `/scope-check` `/perf-profile` `/tech-debt`

**Prodüksiyon**
`/sprint-plan` `/milestone-review` `/estimate` `/retrospective` `/bug-report`

**Proje Yönetimi**
`/start` `/project-stage-detect` `/reverse-document` `/gate-check` `/map-systems` `/design-system`

**Yayın**
`/release-checklist` `/launch-checklist` `/changelog` `/patch-notes` `/hotfix`

**Yaratıcı**
`/brainstorm` `/playtest-report` `/prototype` `/onboard` `/localize`

**Ekip Orkestrasyon** (tek bir özellik üzerinde birden fazla ajanı koordine etme)
`/team-combat` `/team-narrative` `/team-ui` `/team-release` `/team-polish` `/team-audio` `/team-level`

## Başlarken

### Ön Koşullar

- [Git](https://git-scm.com/)
- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) (`npm install -g @anthropic-ai/claude-code`)
- **Önerilen**: [jq](https://jqlang.github.io/jq/) (hook doğrulaması için) ve Python 3 (JSON doğrulaması için)

İsteğe bağlı araçlar eksik olduğunda tüm hook'lar zararsız biçimde başarısız olur — hiçbir şey bozulmaz, yalnızca doğrulama kaybedilir.

### Kurulum

1. **Klonlayın veya şablon olarak kullanın**:
   ```bash
   git clone https://github.com/Donchitos/Claude-Code-Game-Studios.git my-game
   cd my-game
   ```

2. **Claude Code'u açın** ve bir oturum başlatın:
   ```bash
   claude
   ```

3. **`/start` çalıştırın** — sistem nerede olduğunuzu sorar (hiçbir fikir yok, belirsiz konsept,
   net tasarım, mevcut çalışma) ve sizi doğru iş akışına yönlendirir. Varsayım yok.

   Ya da ihtiyacınız olanı zaten biliyorsanız doğrudan belirli bir beceriye geçin:
   - `/brainstorm` — sıfırdan oyun fikirlerini keşfedin
   - `/setup-engine godot 4.6` — motoru zaten biliyorsanız yapılandırın
   - `/project-stage-detect` — mevcut bir projeyi analiz edin

## Yükseltme

Bu şablonun daha eski bir sürümünü mü kullanıyorsunuz? Adım adım geçiş talimatları,
sürümler arasında nelerin değiştiğinin ayrıntıları ve hangi dosyaların güvenle
üzerine yazılabileceği ile hangilerinin elle birleştirilmesi gerektiği için [UPGRADING.md](UPGRADING.md) dosyasına bakın.

## Proje Yapısı

```
CLAUDE.md                           # Ana yapılandırma
.claude/
  settings.json                     # Hook'lar, izinler, güvenlik kuralları
  agents/                           # 48 ajan tanımı (markdown + YAML ön bilgi)
  skills/                           # 37 eğik çizgi komutu (beceri başına alt dizin)
  hooks/                            # 8 hook betiği (bash, çapraz platform)
  rules/                            # 11 yola dayalı kodlama standardı
  docs/
    quick-start.md                  # Ayrıntılı kullanım kılavuzu
    agent-roster.md                 # Alanlarıyla tam ajan tablosu
    agent-coordination-map.md       # Delegasyon ve yükseltme yolları
    setup-requirements.md           # Ön koşullar ve platform notları
    templates/                      # 28 belge şablonu
src/                                # Oyun kaynak kodu
assets/                             # Sanat, ses, VFX, shader'lar, veri dosyaları
design/                             # GDD'ler, anlatı belgeleri, seviye tasarımları
docs/                               # Teknik belgeler ve ADR'ler
tests/                              # Test paketleri
tools/                              # Derleme ve boru hattı araçları
prototypes/                         # Tek kullanımlık prototipler (src/'den yalıtılmış)
production/                         # Sprint planları, kilometre taşları, yayın takibi
```

## Nasıl Çalışır

### Ajan Koordinasyonu

Ajanlar yapılandırılmış bir delegasyon modeli izler:

1. **Dikey delegasyon** — yöneticiler liderlere, liderler uzmanlara devreder
2. **Yatay danışma** — aynı kademedeki ajanlar birbirine danışabilir ancak alan dışı bağlayıcı kararlar alamaz
3. **Çatışma çözümü** — anlaşmazlıklar ortak üst ajana yükseltilir (tasarım için `creative-director`, teknik için `technical-director`)
4. **Değişiklik yayılımı** — departmanlar arası değişiklikler `producer` tarafından koordine edilir
5. **Alan sınırları** — ajanlar, açık delegasyon olmaksızın kendi alanları dışındaki dosyaları değiştirmez

### İşbirlikçi, Özerk Değil

Bu bir **otomatik pilot** sistemi **değildir**. Her ajan katı bir işbirliği protokolü izler:

1. **Sor** — ajanlar çözüm önermeden önce sorular sorar
2. **Seçenekleri sun** — ajanlar artıları ve eksileriyle 2-4 seçenek gösterir
3. **Siz karar verin** — kararı her zaman kullanıcı alır
4. **Taslak** — ajanlar tamamlamadan önce çalışmayı gösterir
5. **Onaylat** — sizin onayınız olmadan hiçbir şey yazılmaz

Kontrolü siz elinizde tutarsınız. Ajanlar özerklik değil, yapı ve uzmanlık sağlar.

### Otomatik Güvenlik

**Hook'lar** her oturumda otomatik olarak çalışır:

| Hook | Tetikleyici | Ne Yapar |
|------|---------|--------------|
| `validate-commit.sh` | `git commit` | Sabit kodlanmış değerleri, TODO biçimini, JSON geçerliliğini, tasarım belgesi bölümlerini kontrol eder |
| `validate-push.sh` | `git push` | Korumalı dallara push'larda uyarır |
| `validate-assets.sh` | `assets/` içinde dosya yazma | Adlandırma kurallarını ve JSON yapısını doğrular |
| `session-start.sh` | Oturum açma | Sprint bağlamını ve son git etkinliğini yükler |
| `detect-gaps.sh` | Oturum açma | Yeni projeleri algılar (`/start` önerir) ve kod/prototipler varken eksik belgeleri tespit eder |
| `pre-compact.sh` | Bağlam sıkıştırma | Oturum ilerleme notlarını korur |
| `session-stop.sh` | Oturum kapatma | Başarıları kaydeder |
| `log-agent.sh` | Ajan başlatıldı | Tüm alt ajan çağrılarının denetim izi |

`settings.json` içindeki **İzin kuralları** güvenli işlemlere (git status, test çalıştırmaları) otomatik izin verir ve tehlikeli olanları engeller (force push, `rm -rf`, `.env` dosyalarını okuma).

### Yola Dayalı Kurallar

Kodlama standartları dosya konumuna göre otomatik olarak uygulanır:

| Yol | Uygular |
|------|----------|
| `src/gameplay/**` | Veri odaklı değerler, delta zaman kullanımı, arayüz referansı yok |
| `src/core/**` | Sıcak yollarda sıfır bellek ayırma, iş parçacığı güvenliği, API kararlılığı |
| `src/ai/**` | Performans bütçeleri, hata ayıklanabilirlik, veri odaklı parametreler |
| `src/networking/**` | Sunucu yetkili, sürümlendirilmiş mesajlar, güvenlik |
| `src/ui/**` | Oyun durumu sahipliği yok, yerelleştirmeye hazır, erişilebilirlik |
| `design/gdd/**` | Zorunlu 8 bölüm, formül biçimi, kenar durumlar |
| `tests/**` | Test adlandırma, kapsam gereksinimleri, fikstür kalıpları |
| `prototypes/**` | Gevşek standartlar, README gerekli, hipotez belgelenmiş |

## Tasarım Felsefesi

Bu şablon, profesyonel oyun geliştirme pratiklerine dayanmaktadır:

- **MDA Çerçevesi** — Oyun tasarımı için Mekanik, Dinamik, Estetik analizi
- **Öz-Belirleme Teorisi** — Oyuncu motivasyonu için Özerklik, Yetkinlik, İlişki
- **Akış Durumu Tasarımı** — Oyuncu katılımı için zorluk-beceri dengesi
- **Bartle Oyuncu Tipleri** — Hedef kitle belirleme ve doğrulama
- **Doğrulama Odaklı Geliştirme** — Önce testler, sonra uygulama

## Özelleştirme

Bu bir **şablon**, kilitli bir çerçeve değil. Her şey özelleştirilebilir:

- **Ajan ekle/çıkar** — İhtiyaç duymadığınız ajan dosyalarını silin, alanlarınız için yenilerini ekleyin
- **Ajan istemlerini düzenle** — Ajan davranışını ayarlayın, projeye özgü bilgi ekleyin
- **Becerileri değiştir** — İş akışlarını ekibinizin sürecine uyacak şekilde ayarlayın
- **Kural ekle** — Projenizin dizin yapısı için yeni yola dayalı kurallar oluşturun
- **Hook'ları ayarla** — Doğrulama katılığını ayarlayın, yeni kontroller ekleyin
- **Motorunuzu seçin** — Godot, Unity veya Unreal ajan setini kullanın (ya da hiçbirini)

## Platform Desteği

**Windows 10** üzerinde Git Bash ile test edilmiştir. Tüm hook'lar POSIX uyumlu kalıplar kullanır (`grep -E`, `grep -P` değil) ve eksik araçlar için geri dönüş mekanizmaları içerir. macOS ve Linux üzerinde değişiklik gerektirmeden çalışır.

## Topluluk

- **Tartışmalar** — Sorular, fikirler ve geliştirdiklerinizi sergilemek için [GitHub Discussions](https://github.com/Donchitos/Claude-Code-Game-Studios/discussions)
- **Sorunlar** — [Hata raporları ve özellik istekleri](https://github.com/Donchitos/Claude-Code-Game-Studios/issues)

---

*Bu proje aktif geliştirme aşamasındadır. Ajan mimarisi, beceriler ve koordinasyon sistemi bugün sağlam ve kullanılabilir durumdadır — ancak daha fazlası geliyor.*

## Lisans

MIT Lisansı. Ayrıntılar için [LICENSE](LICENSE) dosyasına bakın.
