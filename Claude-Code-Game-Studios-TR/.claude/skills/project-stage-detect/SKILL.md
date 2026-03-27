---
name: project-stage-detect
description: "Proje durumunu otomatik olarak analiz edin, aşamayı tespit edin, boşlukları tanımlayın ve mevcut yapıtlara dayanarak sonraki adımları önerin."
argument-hint: "[isteğe bağlı: 'programmer' veya 'designer' gibi rol filtresi]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Bash
---

# Proje Aşaması Tespiti

Bu beceri, projenizi tarayarak mevcut geliştirme aşamasını, yapıtların tamlığını ve
dikkat gerektiren boşlukları belirler. Özellikle şu durumlarda faydalıdır:
- Mevcut bir proje ile başlarken
- Bir kod tabanına dahil olurken
- Bir dönüm noktasından önce neler eksik olduğunu kontrol ederken
- "Nerede olduğumuzu?" anlamak istediğinizde

---

## İş Akışı

### 1. Anahtar Dizinleri Tarayin

Proje yapısını ve içeriğini analiz edin:

**Tasarım Belgeleri** (`design/`):
- `design/gdd/*.md` içindeki GDD dosyalarını sayın
- game-concept.md, game-pillars.md, systems-index.md dosyalarını kontrol edin
- systems-index.md varsa, toplam sistemleri vs. tasarlanmış sistemleri sayın
- Tamlığı analiz edin (Genel Bakış, Ayrıntılı Tasarım, Uç Durumlar, vb.)
- `design/narrative/` içindeki anlatı belgelerini sayın
- `design/levels/` içindeki seviye tasarımlarını sayın

**Kaynak Kodu** (`src/`):
- Kaynak dosyalarını sayın (dile bağlı olmaksızın)
- Ana sistemleri tanımlayın (5+ dosyası olan dizinler)
- core/, gameplay/, ai/, networking/, ui/ dizinlerini kontrol edin
- Kod satırlarını tahmin edin (kaba ölçek)

**Üretim Yapıtları** (`production/`):
- Aktif sprint planlarını kontrol edin
- Dönüm noktası tanımlarını arayın
- Yol haritası belgelerini bulun

**Prototipler** (`prototypes/`):
- Prototip dizinlerini sayın
- README dosyalarını kontrol edin (belgelenmiş vs. belgelenmemiş)
- Prototipin arşivlenmiş mi yoksa aktif mi olduğunu değerlendirin

**Mimari Belgeler** (`docs/architecture/`):
- ADR'leri (Mimari Karar Kayıtları) sayın
- Genel bakış/index belgelerini kontrol edin

**Testler** (`tests/`):
- Test dosyalarını sayın
- Test kapsamını tahmin edin (kaba sezgisel yöntem)

### 2. Proje Aşamasını Sınıflandırın

Taranan yapıtlara dayanarak aşamayı belirleyin. Önce `production/stage.txt` dosyasını
kontrol edin — varsa, değerini kullanın (`/gate-check` komutundan gelen açık geçersiz kılma).
Aksi takdirde, bu buluşsal yöntemleri kullanarak otomatik tespit edin (en ileri olanlardan
geri doğru kontrol edin):

| Aşama | Göstergeler |
|-------|-----------|
| **Kavram** | Oyun konsept belgesi yok, beyin fırtınası aşaması |
| **Sistemler Tasarımı** | Oyun konsepti var, sistemler indeksi eksik veya tamamlanmamış |
| **Teknik Kurulum** | Sistemler indeksi var, motor yapılandırılmamış |
| **Ön Üretim** | Motor yapılandırılmış, `src/` 10'dan az kaynak dosyasına sahip |
| **Üretim** | `src/` 10+ kaynak dosyasına sahip, aktif geliştirme |
| **Cilalama** | Yalnız açık (by `/gate-check` Production → Polish geçidi tarafından ayarlandı) |
| **Yayın** | Yalnız açık (by `/gate-check` Polish → Release geçidi tarafından ayarlandı) |

### 3. İşbirlikçi Boşluk Tanımlaması

**Sadece eksik dosyaları listelemeyin.** Bunun yerine, **açıklayıcı sorular sorun**:

- "Muharebe kodu göyorum (`src/gameplay/combat/`) ancak `design/gdd/combat-system.md` yok. Bu önce prototip mi yapıldı, yoksa ters-belge mi yapması gerekir?"
- "15 ADR'niz var ama mimari genel bakış yok. Yeni katkıda bulunanlara yardımcı olması için bir tane oluşturmalı mıyım?"
- "`production/` içinde sprint planları yok. İşi başka yerde (Jira, Trello, vb.) takip ediyor musunuz?"
- "Bir oyun konsepti buldum ama sistemler indeksi yok. Konsepti bireysel sistemlere ayrıştırdınız mı, yoksa `/map-systems` çalıştırmalı mıyız?"
- "Prototipler dizini README'siz 3 projesi var. Bunlar deneyler miydi, yoksa dokümantasyon mı gerekiyor?"

### 4. Aşama Raporu Oluşturun

Şablonu kullanın: `.claude/docs/templates/project-stage-report.md`

**Rapor yapısı**:
```markdown
# Proje Aşaması Analizi

**Tarih**: [tarih]
**Aşama**: [Kavram/Sistemler Tasarımı/Teknik Kurulum/Ön Üretim/Üretim/Cilalama/Yayın]

## Tamlık Genel Bakışı
- Tasarım: [X%] ([N] belge, [boşluklar])
- Kod: [X%] ([N] dosya, [sistemler])
- Mimari: [X%] ([N] ADR, [boşluklar])
- Üretim: [X%] ([durum])
- Testler: [X%] ([kapsam tahmini])

## Tanımlanan Boşluklar
1. [Boşluk açıklaması + açıklayıcı soru]
2. [Boşluk açıklaması + açıklayıcı soru]

## Önerilen Sonraki Adımlar
[Aşama ve role dayalı olarak öncelik sırasına göre derlenen liste]
```

### 5. Role Göre Filtrelenen Öneriler (İsteğe Bağlı)

Kullanıcı bir rol argümanı sağlıyorsa (ör. `/project-stage-detect programmer`):

**Programcı**:
- Mimari belgeler, test kapsamı, eksik ADR'lere odaklanın
- Kod-belge boşluklarını kontrol edin

**Tasarımcı**:
- GDD tamlığına, eksik tasarım bölümlerine odaklanın
- Prototip belgeleştirmesini kontrol edin

**Yapımcı**:
- Sprint planlarına, dönüm noktası takibine, yol haritasına odaklanın
- Ekipler arası koordinasyon belgelerine odaklanın

**Genel** (rol yok):
- Tüm boşlukların bütünsel görünümü
- Alanlar arasında en yüksek öncelikli öğeler

### 6. Yazılmadan Önce Onay İsteyin

**İşbirlikçi protokol**:
```
Projenizi analiz ettim. İşte bulduklarım:

[Özet göster]

Tanımlanan boşluklar:
1. [Boşluk 1 + soru]
2. [Boşluk 2 + soru]

Önerilen sonraki adımlar:
- [Öncelik 1]
- [Öncelik 2]
- [Öncelik 3]

production/project-stage-report.md dosyasına tam aşama analizi yazabilir miyim?
```

Dosyayı oluşturmadan önce kullanıcı onayını bekleyin.

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

## İzleme Eylemleri

Raporu oluşturduktan sonra, ilgili sonraki adımları önerin:

- **Konsept var ama sistemler indeksi yok?** → `/map-systems` ile sistemlere ayırın
- **Eksik tasarım belgeleri?** → `/reverse-document design src/[system]`
- **Eksik mimari belgeler?** → `/architecture-decision` veya `/reverse-document architecture`
- **Prototipler belgeleştirme gerekli?** → `/reverse-document concept prototypes/[name]`
- **Sprint planı yok?** → `/sprint-plan`
- **Dönüm noktasına yaklaşırken?** → `/milestone-review`

---

## İşbirlikçi Protokol

Bu beceri işbirlikçi tasarım ilkesini takip eder:

1. **Önce Soru Sorun**: Boşluklar hakkında soru sorun, varsayım yapmayın
2. **Seçenekleri Sunun**: "X oluşturmalı mıyım, yoksa başka yerde takip edilir mi?"
3. **Kullanıcı Karar Versin**: Yön için bekleyin
4. **Taslağı Göster**: Rapor özetini göster
5. **Onay Al**: "production/project-stage-report.md dosyasına yazabilir miyim?"

**Asla** sessizce dosya yazılmayın. **Her zaman** bulguları gösterin ve yapıtlar oluşturmadan önce sorun.
