---
name: asset-audit
description: "Oyun varlıklarını adlandırma kurallarına, dosya boyutu bütçelerine, biçim standartlarına ve boru hattı gereksinimlerine uygunluk açısından denetler. Sahipsiz varlıkları, eksik referansları ve standart ihlallerini tespit eder."
argument-hint: "[kategori|hepsi]"
user-invocable: true
allowed-tools: Read, Glob, Grep
---

Bu beceri çağrıldığında:

1. **Sanat kitabını veya varlık standartlarını oku** — İlgili tasarım belgelerinden ve
   CLAUDE.md adlandırma kurallarından.

2. **Hedef varlık dizinini Glob ile tara**:
   - Sanat varlıkları için `assets/art/**/*`
   - Ses varlıkları için `assets/audio/**/*`
   - VFX varlıkları için `assets/vfx/**/*`
   - Shader'lar için `assets/shaders/**/*`
   - Veri dosyaları için `assets/data/**/*`

3. **Adlandırma kurallarını kontrol et**:
   - Sanat: `[kategori]_[ad]_[varyant]_[boyut].[uzantı]`
   - Ses: `[kategori]_[bağlam]_[ad]_[varyant].[uzantı]`
   - Tüm dosyalar alt çizgi kullanarak küçük harf olmalı

4. **Dosya standartlarını kontrol et**:
   - Dokular: İkinin kuvveti boyutlar, doğru biçim (UI için PNG, 3D için sıkıştırılmış),
     boyut bütçesi içinde
   - Ses: Doğru örnekleme hızı, biçim (SFX için OGG, müzik için OGG/MP3),
     süre sınırları içinde
   - Veri: Geçerli JSON/YAML, şemaya uygun

5. **Sahipsiz varlıkları kontrol et** — Her varlık dosyasına yapılan referanslar
   için kodu ara.

6. **Eksik varlıkları kontrol et** — Kodda varlık referanslarını ara ve
   dosyaların var olduğunu doğrula.

7. **Denetim çıktısını oluştur**:

```markdown
# Varlık Denetim Raporu -- [Kategori] -- [Tarih]

## Özet
- **Taranan toplam varlık**: [N]
- **Adlandırma ihlalleri**: [N]
- **Boyut ihlalleri**: [N]
- **Biçim ihlalleri**: [N]
- **Sahipsiz varlıklar**: [N]
- **Eksik varlıklar**: [N]
- **Genel sağlık**: [TEMİZ / KÜÇÜK SORUNLAR / DİKKAT GEREKTİRİYOR]

## Adlandırma İhlalleri
| Dosya | Beklenen Desen | Sorun |
|-------|---------------|-------|

## Boyut İhlalleri
| Dosya | Bütçe | Gerçek | Aşım |
|-------|-------|--------|------|

## Biçim İhlalleri
| Dosya | Beklenen Biçim | Gerçek Biçim |
|-------|---------------|-------------|

## Sahipsiz Varlıklar (kod referansı bulunamadı)
| Dosya | Son Değiştirilme | Boyut | Öneri |
|-------|----------------|-------|-------|

## Eksik Varlıklar (referans var ama dosya yok)
| Referans Konumu | Beklenen Yol |
|----------------|-------------|

## Öneriler
[Önceliklendirilmiş düzeltme listesi]
```
