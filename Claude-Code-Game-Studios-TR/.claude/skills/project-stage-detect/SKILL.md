---
name: project-stage-detect
description: "Proje durumunu otomatik olarak analiz et, aşamasını tespit et, eksiklikleri belirle ve mevcut yapıtlara dayalı sonraki adımları öner."
argument-hint: "[İsteğe bağlı: 'programmer' veya 'designer' gibi rol filtresi]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Bash
---

# Proje Aşama Tespiti

Bu beceri, projenizi tarayarak mevcut geliştirme aşamasını belirler, yapıtların
eksiksizliğini ve dikkat gereken boşlukları tanımlar. Özellikle şu durumlarda yararlıdır:
- Mevcut bir projeyle başlamak
- Kod tabanına dahil olmak
- Bir kilometre taşından önce neyin eksik olduğunu kontrol etmek
- "Nerede olduğumuzu" anlamak

---

## İş Akışı

### 1. Ana Dizinleri Tara

Proje yapısını ve içeriğini analiz et:

**Tasarım Belgeleri** (`design/`):
- `design/gdd/*.md` içindeki GDD dosyalarını say
- game-concept.md, game-pillars.md, systems-index.md için kontrol et
- systems-index.md varsa, toplam sistemleri vs. tasarlanan sistemleri karşılaştır
- Eksiksizliği analiz et (Özet, Detaylı Tasarım, Kenar Durumları vb.)
- `design/narrative/` içindeki anlatı dokümanlarını say
- `design/levels/` içindeki seviye tasarımlarını say

**Kaynak Kodu** (`src/`):
- Kaynak dosyalarını say (dile bağlı olmayan)
- Ana sistemleri tanımla (5+ dosyalı dizinler)
- core/, gameplay/, ai/, networking/, ui/ dizinleri için kontrol et
- Kod satırlarını kabaca tahmin et (ölçek)

**Üretim Yapıtları** (`production/`):
- Aktif sprint planlarını ara
- Kilometre taşı tanımlarını bul
- Yol haritası dokümanlarını bul

**Prototipler** (`prototypes/`):
- Prototip dizinlerini say
- README'ler için kontrol et (dokümante edilen vs. dokümante edilmeyen)
- Prototiplerin arşivlenip arşivlenmediğini değerlendir

**Mimari Dokümanlar** (`docs/architecture/`):
- ADR'leri (Mimari Karar Kayıtları) say
- Özet/dizin dokümanlarını kontrol et

**Testler** (`tests/`):
- Test dosyalarını say
- Test kapsamını kabaca tahmin et (sezgisel yöntemle)

### 2. Proje Aşamasını Sınıflandır

Taranan yapıtlara dayanarak aşamayı belirle. Önce `production/stage.txt` kontrol et —
eğer varsa, değerini kullan (açık geçersiz kılma `/gate-check` ten). Aksi takdirde,
bu heuristics kullanarak otomatik tespit et (en ileri olandan geriye doğru kontrol et):

| Aşama | Göstergeler |
|-------|-----------|
| **Konsept** | Oyun konsept dokümanı yok, beyin fırtınası aşaması |
| **Sistem Tasarımı** | Oyun konsepti var, sistem indeksi eksik veya eksik |
| **Teknik Kurulum** | Sistem indeksi var, motor yapılandırılmamış |
| **Ön-Prodüksiyon** | Motor yapılandırılmış, `src/` < 10 kaynak dosyası var |
| **Prodüksiyon** | `src/` 10+ kaynak dosyası var, aktif geliştirme |
| **Parlatma** | Sadece açık (yapılandırılmış `/gate-check` Prodüksiyon → Parlatma kapısından) |
| **Yayın** | Sadece açık (yapılandırılmış `/gate-check` Parlatma → Yayın kapısından) |

### 3. İşbirlikçi Boşluk Tanımlaması

Sadece eksik dosyaları listeleme. Bunun yerine, **açıklayıcı sorular sor**:

- "Savaş kodu görüyorum (`src/gameplay/combat/`) ama `design/gdd/combat-system.md` yok. Bunu önce prototip mi yaptın, yoksa ters-belgelemeli miyim?"
- "15 ADR'in var ama mimari özeti yok. Yeni katkıcılara yardımcı olmak için birini oluşturmam mı?"
- "Prodüksiyon'da sprint planı yok. İşi başka yerde takip ediyor musun (Jira, Trello vb.)?"
- "Oyun konsepti buldum ama sistem indeksi yok. Konsepti ayrı sistemlere ayırdın mı, yoksa `/map-systems` çalıştırmalı mıyız?"
- "Prototipler dizininde 3 proje var, README yok. Bunlar deneyler miydi, yoksa belgelendirmeye ihtiyaçları mı var?"

### 4. Aşama Raporu Oluştur

Şablonu kullan: `.claude/docs/templates/project-stage-report.md`

**Rapor yapısı**:
```markdown
# Proje Aşama Analizi

**Tarih**: [tarih]
**Aşama**: [Konsept/Sistem Tasarımı/Teknik Kurulum/Ön-Prodüksiyon/Prodüksiyon/Parlatma/Yayın]

## Eksiksizlik Özeti
- Tasarım: [X%] ([N] doküman, [boşluklar])
- Kod: [X%] ([N] dosya, [sistemler])
- Mimari: [X%] ([N] ADR, [boşluklar])
- Prodüksiyon: [X%] ([durum])
- Testler: [X%] ([kapsam tahmini])

## Tanımlanan Boşluklar
1. [Boşluk tanımı + açıklayıcı soru]
2. [Boşluk tanımı + açıklayıcı soru]

## Önerilen Sonraki Adımlar
[Aşama ve role göre öncelikli sırada listele]
```

### 5. Role Göre Filtrelenmiş Öneriler (İsteğe Bağlı)

Kullanıcı bir rol argümanı verdiyse (ör. `/project-stage-detect programmer`):

**Programcı**:
- Mimari dokümanlar, test kapsamı, eksik ADR'lere odaklan
- Kod-doküman boşluklarına odaklan

**Tasarımcı**:
- GDD eksiksizliği, eksik tasarım bölümlerine odaklan
- Prototip dokümantasyonuna odaklan

**Yapımcı**:
- Sprint planları, kilometre taşı takibi, yol haritasına odaklan
- Takımlar arası koordinasyon dokümanlarına odaklan

**Genel** (rol yok):
- Tüm boşlukların bütünsel görünümü
- Tüm alanlar arasında en yüksek öncelikli öğeler

### 6. Yazılmadan Önce Onay Iste

**İşbirlikçi protokol**:
```
Projenizi analiz ettim. İşte bulduklarım:

[Özeti göster]

Tanımlanan boşluklar:
1. [Boşluk 1 + soru]
2. [Boşluk 2 + soru]

Önerilen sonraki adımlar:
- [Öncelik 1]
- [Öncelik 2]
- [Öncelik 3]

Tam aşama analizini production/project-stage-report.md'ye yazabilir miyim?
```

Dosyayı oluşturmadan önce kullanıcı onayını bekle.

---

## Örnek Kullanım

```bash
# Genel proje analizi
/project-stage-detect

# Programcı odaklı analiz
/project-stage-detect programmer

# Tasarımcı odaklı analiz
/project-stage-detect designer
```

---

## Takip Edilen Eylemler

Raporu oluşturduktan sonra, ilgili sonraki adımları öner:

- **Konsept var ama sistem indeksi yok?** → `/map-systems` ile sistemlere ayır
- **Tasarım dokümanları eksik?** → `/reverse-document design src/[system]`
- **Mimari dokümanlar eksik?** → `/architecture-decision` veya `/reverse-document architecture`
- **Prototipler belgelenmesi gerekiyor?** → `/reverse-document concept prototypes/[name]`
- **Sprint planı yok?** → `/sprint-plan`
- **Kilometre taşına yaklaşıyor?** → `/milestone-review`

---

## İşbirlikçi Protokol

Bu beceri, işbirlikçi tasarım ilkesini takip eder:

1. **Soru Sor Önce**: Boşluklar hakkında sor, varsayımda bulunma
2. **Seçenekleri Göster**: "X oluşturmalı mıyım, yoksa başka yerde takip ediliyor mu?"
3. **Kullanıcı Karar Ver**: Yön için bekle
4. **Taslak Göster**: Rapor özetini görüntüle
5. **Onay Al**: "production/project-stage-report.md'ye yazabilir miyim?"

**Asla** sessizce dosya yazma. **Daima** bulgularını göster ve yapı oluşturmadan önce sor.
