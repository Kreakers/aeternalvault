# Ajan Roteri

Aşağıdaki ajanlar mevcuttur. Her birinin `.claude/agents/` içinde özel bir tanım dosyası vardır.
Göreve en uygun ajancı kullanın. Görev birden fazla alanı kapsıyorsa, koordinasyon yapan ajan
(genellikle `producer` veya etki alanı lideri) uzmanlaşmış ajanlarına delegasyon yapmalıdır.

## Kademe 1 -- Liderlik Ajanları (Opus)
| Ajan | Etki Alanı | Ne Zaman Kullanılır |
|-------|--------|-------------|
| `creative-director` | Yüksek düzey vizyon | Başlıca yaratıcı kararlar, sütun çatışmaları, ton/yön |
| `technical-director` | Teknik vizyon | Mimari kararlar, teknoloji yığını seçimleri, performans stratejisi |
| `producer` | Üretim yönetimi | Sprint planlama, kilometre taşı takibi, risk yönetimi, koordinasyon |

## Kademe 2 -- Departman Lideri Ajanları (Sonnet)
| Ajan | Etki Alanı | Ne Zaman Kullanılır |
|-------|--------|-------------|
| `game-designer` | Oyun tasarımı | Mekanikler, sistemler, ilerleme, ekonomi, dengeleme |
| `lead-programmer` | Kod mimarisi | Sistem tasarımı, kod incelemesi, API tasarımı, yeniden düzenleme |
| `art-director` | Görsel yön | Stil kılavuzları, sanat bibliyası, varlık standartları, Arayüz/UX yönü |
| `audio-director` | Ses yönü | Müzik yönü, ses paleti, ses uygulama stratejisi |
| `narrative-director` | Hikaye ve yazı | Hikaye yayları, dünya oluşturma, karakter tasarımı, diyalog stratejisi |
| `qa-lead` | Kalite güvence | Test stratejisi, hata yönetimi, yayın hazırlığı, regresyon planlama |
| `release-manager` | Yayın ardışık düzeni | Yapı yönetimi, sürümleme, değişiklik günlükleri, dağıtım, geri almalar |
| `localization-lead` | Uluslararasılaştırma | Metin dışsallaştırma, çeviri ardışık düzeni, yerel dili test etme |

## Kademe 3 -- Uzman Ajanları (Sonnet veya Haiku)
| Ajan | Etki Alanı | Model | Ne Zaman Kullanılır |
|-------|--------|-------|-------------|
| `systems-designer` | Sistem tasarımı | Sonnet | Spesifik mekanik uygulaması, formül tasarımı, döngüler |
| `level-designer` | Seviye tasarımı | Sonnet | Seviye yerleşimleri, hız, karşılaşma tasarımı, akış |
| `economy-designer` | Ekonomi/denge | Sonnet | Kaynak ekonomileri, ödül tabloları, ilerleme eğrileri |
| `gameplay-programmer` | Oyun kodu | Sonnet | Özellik uygulaması, oyun sistemi kodu |
| `engine-programmer` | Motor sistemleri | Sonnet | Çekirdek motor, oluşturma, fizik, bellek yönetimi |
| `ai-programmer` | Yapay zeka sistemleri | Sonnet | Davranış ağaçları, yol bulma, NPC mantığı, durum makineleri |
| `network-programmer` | Ağ iletişimi | Sonnet | Netcode, replikasyon, gecikme telafisi, eşleştirme |
| `tools-programmer` | Geliştirici araçları | Sonnet | Editör uzantıları, ardışık düzen araçları, hata ayıklama yardımcıları |
| `ui-programmer` | Arayüz uygulaması | Sonnet | Arayüz çerçevesi, ekranlar, widget'lar, veri bağlama |
| `technical-artist` | Teknik sanat | Sonnet | Shaders, VFX, optimizasyon, sanat ardışık düzeni araçları |
| `sound-designer` | Ses tasarımı | Haiku | SFX tasarım belgeleri, ses etkinliği listeleri, karıştırma notları |
| `writer` | Diyalog/lore | Sonnet | Diyalog yazısı, lore girişleri, eşya açıklamaları |
| `world-builder` | Dünya/lore tasarımı | Sonnet | Dünya kuralları, faksiyon tasarımı, tarih, coğrafya |
| `qa-tester` | Test yürütme | Haiku | Test durumları yazma, hata raporları, test kontrol listeleri |
| `performance-analyst` | Performans | Sonnet | Profil oluşturma, optimizasyon önerileri, bellek analizi |
| `devops-engineer` | Derleme/dağıtım | Haiku | CI/CD, derleme betikleri, sürüm kontrol iş akışı |
| `analytics-engineer` | Telemetri | Sonnet | Etkinlik izleme, panolar, A/B test tasarımı |
| `ux-designer` | Arayüz akışları | Sonnet | Kullanıcı akışları, wireframe'ler, erişilebilirlik, giriş işleme |
| `prototyper` | Hızlı prototip oluşturma | Sonnet | Atılır prototipler, mekanik testi, uygulanabilirlik doğrulama |
| `security-engineer` | Güvenlik | Sonnet | Anti-hile, açık önleme, kayıt şifreleme, ağ güvenliği |
| `accessibility-specialist` | Erişilebilirlik | Haiku | WCAG uyumluluğu, renk körlüğü modları, yeniden eşleme, metin ölçeklendirme |
| `live-ops-designer` | Canlı operasyonlar | Sonnet | Sezonlar, etkinlikler, battle pass'ler, tutma, canlı ekonomi |
| `community-manager` | Komunite | Haiku | Yama notları, oyuncu geri bildirimi, kriz iletişimi, komunite sağlığı |

## Motor Spesifik Ajanları (motorunuzla eşleşen seti kullanın)

### Motor Liderleri

| Ajan | Motor | Model | Ne Zaman Kullanılır |
| ---- | ---- | ---- | ---- |
| `unreal-specialist` | Unreal Engine 5 | Sonnet | Blueprint vs C++, GAS genel bakışı, UE alt sistemleri, Unreal optimizasyonu |
| `unity-specialist` | Unity | Sonnet | MonoBehaviour vs DOTS, Addressables, URP/HDRP, Unity optimizasyonu |
| `godot-specialist` | Godot 4 | Sonnet | GDScript desenleri, düğüm/sahne mimarisi, sinyaller, Godot optimizasyonu |

### Unreal Engine Alt-Uzmanları

| Ajan | Alt Sistem | Model | Ne Zaman Kullanılır |
| ---- | ---- | ---- | ---- |
| `ue-gas-specialist` | Gameplay Ability System | Sonnet | Yetenekler, oyun efektleri, nitelik setleri, etiketler, tahmin |
| `ue-blueprint-specialist` | Blueprint Mimarisi | Sonnet | BP/C++ sınırı, grafik standartları, adlandırma, BP optimizasyonu |
| `ue-replication-specialist` | Ağ İletişimi/Replikasyon | Sonnet | Mülk replikasyonu, RPC'ler, tahmin, uygunluk, bant genişliği |
| `ue-umg-specialist` | UMG/CommonUI | Sonnet | Widget hiyerarşisi, veri bağlama, CommonUI girişi, Arayüz performansı |

### Unity Alt-Uzmanları

| Ajan | Alt Sistem | Model | Ne Zaman Kullanılır |
| ---- | ---- | ---- | ---- |
| `unity-dots-specialist` | DOTS/ECS | Sonnet | Entity Component System, İşler, Burst derleyicisi, hibrit oluşturucu |
| `unity-shader-specialist` | Shaders/VFX | Sonnet | Shader Graph, VFX Graph, URP/HDRP özelleştirmesi, işleme sonrası |
| `unity-addressables-specialist` | Varlık Yönetimi | Sonnet | Addressable grupları, zaman uyumsuz yükleme, bellek, içerik sunumu |
| `unity-ui-specialist` | Arayüz Araç Seti/UGUI | Sonnet | Arayüz Araç Seti, UXML/USS, UGUI Canvas, veri bağlama, platformlar arası giriş |

### Godot Alt-Uzmanları

| Ajan | Alt Sistem | Model | Ne Zaman Kullanılır |
| ---- | ---- | ---- | ---- |
| `godot-gdscript-specialist` | GDScript | Sonnet | Statik yazma, tasarım desenleri, sinyaller, korutinler, GDScript performansı |
| `godot-shader-specialist` | Shaders/Oluşturma | Sonnet | Godot gölgelendirme dili, görsel shaders, partiküller, işleme sonrası |
| `godot-gdextension-specialist` | GDExtension | Sonnet | C++/Rust bağlamaları, yerel performans, özel düğümler, derleme sistemleri |
