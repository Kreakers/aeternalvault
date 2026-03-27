---
name: prototype
description: "Hızlı prototipler oluşturma iş akışı. Oyun konseptini veya mekaniklerini hızlı doğrulamak için normal standartları atlayarak. Tek kullanımlık kod ve yapılandırılmış prototip raporu üretir."
argument-hint: "[konsept-açıklaması]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Bash
---

Bu beceri çağrıldığında:

1. **Konsept açıklamasını argümandan oku**. Bu prototipşiddetine cevap vermesi gereken temel
   soruyu tanımla. Eğer konsept belirsizse, devam etmeden önce soruyu açıkça belirt.

2. **CLAUDE.md'yi oku** proje bağlamı ve mevcut teknoloji yığını için. Prototipşi uyumlu
   araçlarla oluşturabilmesi için kullanılan motoru, dili ve çerçeveleri anla.

3. **Prototip planı oluştur**: 3-5 madde içinde minimum uygulanabilir prototipşinin neyle
   görüneceğini tanımla. Temel soru nedir? Cevaplamak için gereken mutlak minimum kod nedir?
   Ne atlanabilir?

4. **Prototip dizini oluştur**: `prototypes/[konsept-adı]/` burada
   `[konsept-adı]`, konseptten türetilen kısa, kebab-case tanımlayıcıdır.

5. **Prototipşi izole dizinde uygula**. Her dosya ile başlamalı:
   ```
   // PROTOTYPE - PRODÜKSIYON İÇİN DEĞİL
   // Soru: [Test edilen Temel soru]
   // Tarih: [Güncel tarih]
   ```
   Standartlar kasıtlı olarak gevşetilmiş:
   - Değerleri serbestçe sabit kodla
   - Placeholder varlıkları kullan
   - Hata yönetimini atla
   - İşe yarayan en basit yaklaşımı kullan
   - Prodüksiyon'dan içe aktarmak yerine kodu kopyala

6. **Konsepti test et**: Prototipi çalıştır. Davranışı gözlemle. Ölçülebilir veri topla
   (çerçeve süreleri, etkileşim sayısı, his değerlendirmeleri).

7. **Prototip Raporunu Oluştur** ve `prototypes/[konsept-adı]/REPORT.md` ye kaydet:

```markdown
## Prototip Raporu: [Konsept Adı]

### Hipotez
[Ne olmasını umduğumuz -- cevap vermek istediğimiz soru]

### Yaklaşım
[Ne inşa ettik, ne kadar zaman aldı, hangi kısa yolları aldık]

### Sonuç
[Gerçekte ne oldu -- görüşler değil, spesifik gözlemler]

### Metrikler
[Test sırasında toplanan ölçülebilir veriler]
- Çerçeve süresi: [ilgili ise]
- His değerlendirmesi: [öznel ama spesifik -- "yanıt 200ms gecikmede hantal hissetti"
  "kötü hissetti" değil]
- Oyuncu eylem sayıları: [ilgili ise]
- İterasyon sayısı: [çalışmaya almak için kaç deneme]

### Tavsiye: [DEVAM ET / DÖN / ÖLDÜR]

[Tavsiyeyi kanıtla ile destekleyen tek paragraf]

### Devam Ederse
[Üretim kalitesi uygulaması için ne değişmesi gerekir]
- Mimari gereksinimler
- Performans hedefleri
- Orijinal tasarımdan kapsam ayarlamaları
- Tahmini prodüksiyon çalışması

### Dönerse
[Sonuçların önerdiği alternatif yön]

### Öldürülürse
[Bu konseptin neden işe yaramadığı ve bunun yerine ne yapmalıyız]

### Ders Alınan
[Diğer sistemleri veya gelecek işi etkileyen keşifler]
```

8. **Özet çıktısı** kullanıcıya: temel soru, sonuç ve tavsiye.
   `prototypes/[konsept-adı]/REPORT.md` ye olan linki.

### Önemli Kısıtlamalar

- Prototip kodu prodüksiyon kaynak dosyalarından ASLA içe aktarmamalı
- Prodüksiyon kodu prototip dizinlerinden ASLA içe aktarmamalı
- Eğer tavsiye DEVAM ET ise, prodüksiyon uygulaması sıfırdan yazılmalı -- prototip kodu
  prodüksiyon'a refaktör edilmemeli
- Toplam prototip çalışması 1-3 gün eşdeğer çalışmaya sınırlandırılmalı
- Eğer prototip kapsamı büyümeye başlarsa, dur ve soru simpleleştirilip simpleleştirilmeyeceğini
  yeniden değerlendir
