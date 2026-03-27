# Ajan Koordinasyon ve Delegasyon Haritası

## Organizasyonel Hiyerarşi

```
                           [İnsan Geliştirici]
                                 |
                 +---------------+---------------+
                 |               |               |
         creative-director  technical-director  producer
                 |               |               |
        +--------+--------+     |        (tüm koordinasyonu sağlar)
        |        |        |     |
  game-designer art-dir  narr-dir  lead-programmer  qa-lead  audio-dir
        |        |        |         |                |        |
     +--+--+     |     +--+--+  +--+--+--+--+--+   |        |
     |  |  |     |     |     |  |  |  |  |  |  |   |        |
    sys lvl eco  ta   wrt  wrld gp ep  ai net tl ui qa-t    snd
                                 |
                             +---+---+
                             |       |
                          perf-a   devops   analytics

  Ek Liderler (producer/director'lara rapor verir):
    release-manager         -- Yayın ardışık düzeni, sürümleme, dağıtım
    localization-lead       -- i18n, metin tabloları, çeviri ardışık düzeni
    prototyper              -- Hızlı atılır prototipler, konsept doğrulama
    security-engineer       -- Anti-hile, açıklar, veri gizliliği, ağ güvenliği
    accessibility-specialist -- WCAG, renk körlüğü, yeniden eşleme, metin ölçeklendirme
    live-ops-designer       -- Sezonlar, etkinlikler, battle pass'ler, oyuncu tutma, canlı ekonomi
    community-manager       -- Yama notları, oyuncu geri bildirimi, kriz iletişimi

  Motor Uzmanları (motorunuzla eşleşen seti kullanın):
    unreal-specialist  -- UE5 lider: Blueprint/C++, GAS genel bakışı, UE alt sistemleri
      ue-gas-specialist         -- GAS: yetenekler, efektler, nitelikler, etiketler, tahmin
      ue-blueprint-specialist   -- Blueprint: BP/C++ sınırı, grafik standartları, optimizasyon
      ue-replication-specialist -- Ağ iletişimi: replikasyon, RPC'ler, tahmin, bant genişliği
      ue-umg-specialist         -- Arayüz: UMG, CommonUI, widget hiyerarşisi, veri bağlama

    unity-specialist   -- Unity lider: MonoBehaviour/DOTS, Addressables, URP/HDRP
      unity-dots-specialist         -- DOTS/ECS: İşler, Burst, hibrit oluşturucu
      unity-shader-specialist       -- Shaders: Shader Graph, VFX Graph, SRP özelleştirmesi
      unity-addressables-specialist -- Varlıklar: zaman uyumsuz yükleme, paketler, bellek, CDN
      unity-ui-specialist           -- Arayüz: UI Toolkit, UGUI, UXML/USS, veri bağlama

    godot-specialist   -- Godot 4 lider: GDScript, düğüm/sahne, sinyaller, kaynaklar
      godot-gdscript-specialist    -- GDScript: statik yazma, desenler, sinyaller, performans
      godot-shader-specialist      -- Shaders: Godot gölgelendirme dili, görsel shaders, VFX
      godot-gdextension-specialist -- Yerel: C++/Rust bağlamalar, GDExtension, derleme sistemleri
```

### Efsane
```
sys  = systems-designer       gp  = gameplay-programmer
lvl  = level-designer         ep  = engine-programmer
eco  = economy-designer       ai  = ai-programmer
ta   = technical-artist       net = network-programmer
wrt  = writer                 tl  = tools-programmer
wrld = world-builder          ui  = ui-programmer
snd  = sound-designer         qa-t = qa-tester
narr-dir = narrative-director perf-a = performance-analyst
art-dir = art-director
```

## Delegasyon Kuralları

### Kim Kime Delegasyon Yapabilir

| Kişi | Delegasyon Yapabileceği Kişiler |
|------|----------------|
| creative-director | game-designer, art-director, audio-director, narrative-director |
| technical-director | lead-programmer, devops-engineer, performance-analyst, technical-artist (teknik kararlar) |
| producer | Herhangi bir ajan (yalnızca kendi alanları içindeki görev atama) |
| game-designer | systems-designer, level-designer, economy-designer |
| lead-programmer | gameplay-programmer, engine-programmer, ai-programmer, network-programmer, tools-programmer, ui-programmer |
| art-director | technical-artist, ux-designer |
| audio-director | sound-designer |
| narrative-director | writer, world-builder |
| qa-lead | qa-tester |
| release-manager | devops-engineer (yayın derlemeleri), qa-lead (yayın testi) |
| localization-lead | writer (metin incelemesi), ui-programmer (metin uyumu) |
| prototyper | (bağımsız çalışır, bulgularını producer ve ilgili liderlere raporlar) |
| security-engineer | network-programmer (güvenlik incelemesi), lead-programmer (güvenli desenler) |
| accessibility-specialist | ux-designer (erişilebilir desenler), ui-programmer (uygulama), qa-tester (a11y testi) |
| [motor]-specialist | motor alt-uzmanları (alt sistem-spesifik çalışmayı delegasyon yapabilir) |
| [motor] alt-uzmanları | (tüm programcılara motor alt sistemi desenleri ve optimizasyonu hakkında tavsiye verir) |
| live-ops-designer | economy-designer (canlı ekonomi), community-manager (etkinlik iletişimi), analytics-engineer (katılım metrikleri) |
| community-manager | (onay için producer ile çalışır, patch notu zamanlaması için release-manager ile çalışır) |

### Yükseltme Yolları

| Durum | Yükseltme Adı |
|-----------|------------|
| İki tasarımcı bir mekanik konusunda anlaşamıyor | game-designer |
| Oyun tasarımı vs anlatı çatışması | creative-director |
| Oyun tasarımı vs teknik uygulanabilirlik | producer (hızlandırır), sonra creative-director + technical-director |
| Sanat vs ses tonsal çatışması | creative-director |
| Kod mimarisi anlaşmazlığı | technical-director |
| Sistemler arası kod çatışması | lead-programmer, sonra technical-director |
| Departmanlar arasında zamanlama çatışması | producer |
| Kapsam kapasiteyi aşıyor | producer, sonra creative-director kesimleri için |
| Kalite kapısı anlaşmazlığı | qa-lead, sonra technical-director |
| Performans bütçesi ihlali | performance-analyst işaretler, technical-director karar verir |

## Yaygın İş Akışı Desenleri

### Desen 1: Yeni Özellik (Tam Ardışık Düzen)

```
1. creative-director  -- Özellik konsepti vizyonla uyumlu mı kontrol eder
2. game-designer      -- Tam spesifikasyonla tasarım belgesi oluşturur
3. producer           -- Çalışmayı zamanlar, bağımlılıkları tanımlar
4. lead-programmer    -- Kod mimarisini tasarlar, arayüz taslağı oluşturur
5. [specialist-programmer] -- Özelliği uygular
6. technical-artist   -- Görsel efektleri uygular (gerekirse)
7. writer             -- Metin içeriğini oluşturur (gerekirse)
8. sound-designer     -- Ses etkinliği listesi oluşturur (gerekirse)
9. qa-tester          -- Test durumları yazar
10. qa-lead           -- Test kapsamını gözden geçirir ve onaylar
11. lead-programmer   -- Kodu gözden geçirir
12. qa-tester         -- Testleri yürütür
13. producer          -- Görev tamamlandı olarak işaretler
```

### Desen 2: Hata Düzeltme

```
1. qa-tester          -- /bug-report ile hata raporu açar
2. qa-lead            -- Önem düzeyini ve önceliğini belirler
3. producer           -- Sprintle atar (S1 değilse)
4. lead-programmer    -- Temel nedeni tanımlar, programcıya atar
5. [specialist-programmer] -- Hatayı düzeltir
6. lead-programmer    -- Kodu gözden geçirir
7. qa-tester          -- Düzeltmeyi doğrular ve regresyon testini çalıştırır
8. qa-lead            -- Hatayı kapatır
```

### Desen 3: Denge Ayarlaması

```
1. analytics-engineer -- Verilerden dengesizliği tanımlar (veya oyuncu raporlarından)
2. game-designer      -- Sorunu tasarım amacına karşı değerlendirir
3. economy-designer   -- Ayarlamayı modeller
4. game-designer      -- Yeni değerleri onaylar
5. [veri dosyası güncelleme] -- Yapılandırma değerlerini değiştir
6. qa-tester          -- Etkilenen sistemleri regresyon testi yapabilir
7. analytics-engineer -- Değişiklik sonrası metrikleri izle
```

### Desen 4: Yeni Alan/Seviye

```
1. narrative-director -- Alan için anlatı amacını ve vuruşları tanımlar
2. world-builder      -- Lore ve çevresel bağlam oluşturur
3. level-designer     -- Yerleşimi, karşılaşmaları, hızı tasarlar
4. game-designer      -- Karşılaşmaların mekanik tasarımını gözden geçirir
5. art-director       -- Alan için görsel yönü tanımlar
6. audio-director     -- Alan için ses yönünü tanımlar
7. [ilgili programcılar ve sanatçılar tarafından uygulanır]
8. writer             -- Alan spesifik metin içeriğini oluşturur
9. qa-tester          -- Tüm alanı test eder
```

### Desen 5: Sprint Döngüsü

```
1. producer           -- /sprint-plan new ile sprintti planlar
2. [Tüm ajanlar]       -- Atanan görevleri yürütür
3. producer           -- /sprint-plan status ile günlük durum
4. qa-lead            -- Sprint sırasında sürekli test
5. lead-programmer    -- Sprint sırasında sürekli kod incelemesi
6. producer           -- Post-sprint hook ile retrospektif
7. producer           -- Öğrenimleri birleştirerek sonraki sprintti planlar
```

### Desen 6: Kilometre Taşı Denetim Noktası

```
1. producer           -- /milestone-review çalıştırır
2. creative-director  -- Yaratıcı ilerlemeyi gözden geçirir
3. technical-director -- Teknik sağlığı gözden geçirir
4. qa-lead            -- Kalite metriklerini gözden geçirir
5. producer           -- Git/gitmeme tartışmasını kolaylaştırır
6. [Tüm direktörler]    -- Kapsam ayarlamalarında anlaşmazlığa varır
7. producer           -- Kararları belgelendirir ve planları günceller
```

### Desen 7: Yayın Ardışık Düzeni

```text
1. producer             -- Yayın adayı bildirir, kilometre taşı kriterlerinin karşılandığını doğrular
2. release-manager      -- Yayın dalını keser, /release-checklist oluşturur
3. qa-lead              -- Tam regresyon çalıştırır, kaliteyi onaylar
4. localization-lead    -- Tüm stringlerin çevrildiğini, metin uyumunun geçtiğini doğrular
5. performance-analyst  -- Performans kıyaslamalarının hedeflerin içinde olduğunu doğrular
6. devops-engineer      -- Yayın yapılarını derler, dağıtım ardışık düzenini çalıştırır
7. release-manager      -- /changelog oluşturur, yayını etiketler, yayın notlarını oluşturur
8. technical-director   -- Ana yayınlarda son onayı verir
9. release-manager      -- Dağıtır ve 48 saat boyunca izler
10. producer            -- Yayın tamamlandı olarak işaretler
```

### Desen 8: Hızlı Prototip

```text
1. game-designer        -- Hipotezi ve başarı kriterlerini tanımlar
2. prototyper           -- /prototype ile prototipi yapılandırır
3. prototyper           -- Minimal uygulamayı inşa eder (saatler, günler değil)
4. game-designer        -- Prototipü kriterlere karşı değerlendirir
5. prototyper           -- Bulgu raporunu belgelendiri
6. creative-director    -- Üretime devam etme konusunda git/gitmeme kararı verir
7. producer             -- Onaylanmışsa üretim çalışmasını zamanlar
```

### Desen 9: Canlı Etkinlik / Sezon Lansmanı

```text
1. live-ops-designer     -- Etkinlik/sezon içeriğini, ödülleri, zamanlamayı tasarlar
2. game-designer         -- Etkinlik için oyun mekaniklerini doğrular
3. economy-designer      -- Etkinlik ekonomisini ve ödül değerlerini dengeler
4. narrative-director    -- Mevsimsel anlatı teması sağlar
5. writer                -- Etkinlik açıklamalarını ve lore'unu oluşturur
6. producer              -- Uygulama çalışmasını zamanlar
7. [ilgili programcılar tarafından uygulanır]
8. qa-lead               -- Etkinlik akışını uçtan uca test eder
9. community-manager     -- Etkinlik duyurusunu ve yama notlarını yazar
10. release-manager      -- Etkinlik içeriğini dağıtır
11. analytics-engineer   -- Etkinlik katılımını ve metriklerini izler
12. live-ops-designer    -- Etkinlik sonrası analiz ve öğrenimler
```

## Etki Alanları Arası İletişim Protokolleri

### Tasarım Değişikliği Bildirimi

Bir tasarım belgesi değiştiğinde, game-designer şunları bildirmelidir:
- lead-programmer (uygulama etkisi)
- qa-lead (test planı güncellemesi gerekiyor)
- producer (zamanlama etkisi değerlendirmesi)
- Değişikliğe bağlı olarak ilgili uzman ajanlar

### Mimari Değişiklik Bildirimi

Bir ADR oluşturulduğunda veya değiştirildiğinde, technical-director şunları bildirmelidir:
- lead-programmer (kod değişiklikleri gerekiyor)
- Tüm etkilenen uzman programcılar
- qa-lead (test stratejisi değişebilir)
- producer (zamanlama etkisi)

### Varlık Standart Değişiklik Bildirimi

Sanat bibliyası veya varlık standartları değiştiğinde, art-director şunları bildirmelidir:
- technical-artist (ardışık düzen değişiklikleri)
- Etkilenen varlıklarla çalışan tüm içerik oluşturucular
- devops-engineer (derleme ardışık düzeni etkilenirse)

## Kaçınılması Gereken Ters Desenler

1. **Hiyerarşiyi Atlamak**: Bir uzman ajan, danışmadan ilgili liderinden kendi alanı dışında karar almamalıdır.
2. **Etki Alanı Arası Uygulama**: Bir ajan, ilgili sahibinden açık delegasyon olmadan alanı dışında dosyaları değiştirmemelidir.
3. **Gölge Kararlar**: Tüm kararlar belgelendirilmelidir. Yazılı kayıt olmayan sözleşmeler çelişkilere yol açar.
4. **Monolitik Görevler**: Bir ajana atanan her görev 1-3 gün içinde tamamlanabilir olmalıdır. Daha büyükse, önce bölünmeli.
5. **Varsayım Tabanlı Uygulama**: Bir spesifikasyon belirsizse, uygulayıcı tahmin yapmak yerine spesifikasyoncu'ya sormalıdır. Yanlış tahminler bir sorudan daha pahalıdır.
