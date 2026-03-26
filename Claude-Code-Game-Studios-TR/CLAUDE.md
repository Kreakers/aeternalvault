# Claude Code Game Studios -- Oyun Stüdyosu Ajan Mimarisi

Bağımsız oyun geliştirme, 48 koordineli Claude Code alt ajanı aracılığıyla yönetilir.
Her ajan belirli bir alana sahiptir; endişelerin ayrılmasını ve kaliteyi sağlar.

## Teknoloji Yığını

- **Motor**: [SEÇİN: Godot 4 / Unity / Unreal Engine 5]
- **Dil**: [SEÇİN: GDScript / C# / C++ / Blueprint]
- **Sürüm Kontrolü**: Trunk tabanlı geliştirme ile Git
- **Derleme Sistemi**: [Motor seçildikten sonra BELİRTİN]
- **Varlık Hattı**: [Motor seçildikten sonra BELİRTİN]

> **Not**: Godot, Unity ve Unreal için özel alt uzmanlarla birlikte motor uzmanı
> ajanlar mevcuttur. Motorunuzla eşleşen seti kullanın.

## Proje Yapısı

@.claude/docs/directory-structure.md

## Motor Sürüm Referansı

@docs/engine-reference/godot/VERSION.md

## Teknik Tercihler

@.claude/docs/technical-preferences.md

## Koordinasyon Kuralları

@.claude/docs/coordination-rules.md

## İşbirliği Protokolü

**Kullanıcı odaklı işbirliği, özerk yürütme değil.**
Her görev şu akışı izler: **Soru -> Seçenekler -> Karar -> Taslak -> Onay**

- Ajanlar Yazma/Düzenleme araçlarını kullanmadan önce "Bunu [dosyayolu] adresine yazabilir miyim?" diye SORMALIDIR
- Ajanlar onay istemeden önce taslakları veya özetleri GÖSTERMELİDİR
- Çok dosyalı değişiklikler, tüm değişiklik seti için açık onay gerektirir
- Kullanıcı talimatı olmadan commit yapılmaz

Tam protokol ve örnekler için `docs/COLLABORATIVE-DESIGN-PRINCIPLE.md` dosyasına bakın.

> **İlk oturum mu?** Projede yapılandırılmış bir motor ve oyun konsepti yoksa,
> rehberli katılım akışını başlatmak için `/start` çalıştırın.

## Kodlama Standartları

@.claude/docs/coding-standards.md

## Bağlam Yönetimi

@.claude/docs/context-management.md
