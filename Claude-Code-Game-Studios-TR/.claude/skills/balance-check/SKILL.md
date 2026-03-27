---
name: balance-check
description: "Oyun denge veri dosyalarını, formüllerini ve yapılandırmasını analiz ederek aykırı değerleri, kırık ilerlemeleri, dejenere stratejileri ve ekonomi dengesizliklerini tanımlar. Denge ile ilgili herhangi bir veriyi değiştirdikten sonra kullanın."
argument-hint: "[sistem-adı|veri-dosyası-yolu]"
user-invocable: true
allowed-tools: Read, Glob, Grep
---

Bu beceri çağrıldığında:

1. **Denge alanını tanımla** argümandan.

2. **İlgili veri dosyalarını oku** `assets/data/` ve `design/balance/` klasörlerinden.

3. **Tasarım belgesini oku** kontrol edilen sistem için `design/gdd/` klasöründen.

4. **Analiz gerçekleştir**:

   **Savaş dengesi** için:
   - Tüm silahlar/yeteneklerin her güç seviyesindeki DPS'sini hesapla
   - Her seviyedeki öldürme zamanını kontrol et
   - Diğer tüm seçenekleri baskılayan seçenekleri tanımla (kesinlikle daha iyi)
   - Savunma seçeneklerinin öldürülemez durumlar yaratıp yaratmadığını kontrol et
   - Hasar türü/dirençi etkileşimlerinin dengeli olup olmadığını doğrula

   **Ekonomi dengesi** için:
   - Tüm kaynak muslukları ve lavabolar ile akış hızlarını eşle
   - Zaman içinde kaynak birikimini projekte et
   - Sonsuz kaynak döngüleri olup olmadığını kontrol et
   - Altın lavabolarının altın oluşturmaya uyum sağlayıp sağlamadığını doğrula
   - Hiçbir öğenin satın almaya değer olmamasını kontrol et

   **İlerleme dengesi** için:
   - XP eğrisi ve güç eğrisini çiz
   - Ölü bölgeleri kontrol et (çok uzun bir süre anlamlı ilerleme yok)
   - Güç artışlarını kontrol et (yetenekte ani atlamalar)
   - İçerik kapılarının beklenen oyuncu gücüyle hizalanmasını doğrula
   - Atlama/öğütme stratejilerinin amaçlanan tempoyu bozup bozmadığını kontrol et

   **Loot dengesi** için:
   - Her nadir tier'in alınması için beklenen zamanı hesapla
   - Acı zamanlayıcı matematik kontrol
   - Herhangi bir loot'un hiçbir aşamada tamamen işe yaramaz olmadığını doğrula
   - Envanter baskısı ile alım oranını kontrol et

5. **Analizi çıkar**:

```
## Denge Kontrolü: [Sistem Adı]

### Analiz Edilen Veri Kaynakları
- [Okunan dosyaların listesi]

### Sağlık Özeti: [HEALTHY / ENDIŞELER / KRİTİK SORUNLAR]

### Tespit Edilen Aykırı Değerler
| Öğe/Değer | Beklenen Aralık | Gerçek | Sorun |
|-----------|-----------------|--------|-------|

### Bulunan Dejenere Stratejiler
- [Strateji açıklaması ve neden sorunlu olduğu]

### İlerleme Analizi
[Grafik açıklaması veya ilerleme eğrisi sağlığını gösteren tablo]

### Öneriler
| Öncelik | Sorun | Önerilen Çözüm | Etki |
|---------|-------|---------------|------|

### Dikkat Edilmesi Gereken Değerler
[Spesifik değerler önerilen ayarlamalar ve gerekçe ile]
```
