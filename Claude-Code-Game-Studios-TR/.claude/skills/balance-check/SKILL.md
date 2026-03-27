---
name: balance-check
description: "Oyun dengesi veri dosyalarını, formülleri ve konfigürasyonları analiz ederek aykırı değerleri, bozuk progressyonları, dejenere stratejileri ve ekonomi dengesizliklerini tanımlar. Herhangi bir denge ile ilgili veri veya tasarım değiştirdikten sonra kullanın."
argument-hint: "[system-name|path-to-data-file]"
user-invocable: true
allowed-tools: Read, Glob, Grep
---

Bu skill çağrıldığında:

1. **Denge alanını tanımlayın** argümandan.

2. **İlgili veri dosyalarını okuyun** `assets/data/` ve `design/balance/` dizinlerinden.

3. **Tasarım belgesini okuyun** kontrol edilen sistem için `design/gdd/` dizininden.

4. **Analiz gerçekleştirin**:

   **Savaş dengesi** için:
   - Tüm silahlar/yetenekler için her güç seviyesinde DPS hesaplayın
   - Her seviyede ölüme kadar geçen süreyi kontrol edin
   - Diğer tüm seçenekleri egemen hale getiren seçenekleri tanımlayın (tamamen daha iyi)
   - Defansif seçeneklerin öldürülemez durumlar oluşturup oluşturamayacağını kontrol edin
   - Hasar tipi/direnç etkileşimlerinin dengeli olup olmadığını doğrulayın

   **Ekonomi dengesi** için:
   - Tüm kaynak kaynaklarını ve yutma kanallarını akış hızları ile haritala
   - Zaman içinde kaynak birikimini tahmin et
   - Sonsuz kaynak döngüleri için kontrol yapın
   - Altın yutmasının altın üretimi ile ölçeklenip ölçeklenmediğini doğrulayın
   - Satın almaya değer olmayan öğelerin olup olmadığını kontrol edin

   **İlerleme dengesi** için:
   - XP eğrisi ve güç eğrisini çizin
   - Ölü bölgeleri kontrol edin (çok uzun anlamlı ilerleme yok)
   - Güç ani artışlarını kontrol edin (ani yetenek artışları)
   - İçerik kapılarının beklenen oyuncu gücü ile hizalanıp hizalanmadığını doğrulayın
   - Atlama/öğütme stratejilerinin amaçlanan tempoyu bozup bozmadığını kontrol edin

   **Loot dengesi** için:
   - Her nadir kademesi elde etmek için beklenen süreyi hesaplayın
   - Acı zamanlama matematiğini kontrol edin
   - Hiçbir loot'un herhangi bir aşamada tamamen kullanılamaz olmadığını doğrulayın
   - Envanter baskısını elde etme hızına karşı kontrol edin

5. **Analizi çıkartın**:

```
## Denge Kontrolü: [Sistem Adı]

### Analiz Edilen Veri Kaynakları
- [Okunan dosyaların listesi]

### Sağlık Özeti: [SAĞLIKLI / ENDIŞELER / KRİTİK SORUNLAR]

### Tespit Edilen Aykırılıklar
| Öğe/Değer | Beklenen Aralık | Gerçekleşen | Sorun |
|-----------|---------------|--------|-------|

### Bulunan Dejenere Stratejiler
- [Strateji açıklaması ve neden problemli olduğu]

### İlerleme Analizi
[İlerleme eğrisi sağlığını gösteren grafik açıklaması veya tablo]

### Öneriler
| Öncelik | Sorun | Önerilen Çözüm | Etki |
|----------|-------|--------------|--------|

### Dikkat Gerektiren Değerler
[Önerilen ayarlamalar ve mantık ile belirli değerler]
```
