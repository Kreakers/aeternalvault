---
name: architecture-decision
description: "Önemli bir teknik kararı, bağlamını, değerlendirilen alternatifleri ve sonuçlarını belgeleyen bir Mimari Karar Kaydı (ADR) oluşturur. Her büyük teknik seçimin bir ADR'si olmalıdır."
argument-hint: "[başlık]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write
---

Bu beceri çağrıldığında:

1. **Bir sonraki ADR numarasını belirle** — `docs/architecture/` dizinini tarayarak
   mevcut ADR'leri bul.

2. **Bağlamı topla** — İlgili kodu ve mevcut ADR'leri oku.

3. **Kullanıcıyı karar sürecinde yönlendir** — Başlık tek başına yeterli değilse
   açıklayıcı sorular sor.

4. **ADR'yi oluştur** — Şu biçimi kullan:

```markdown
# ADR-[NNNN]: [Başlık]

## Durum
[Önerilen | Kabul Edildi | Kullanımdan Kaldırıldı | ADR-XXXX tarafından Değiştirildi]

## Tarih
[Karar tarihi]

## Bağlam

### Sorun Tanımı
[Hangi sorunu çözüyoruz? Bu kararın şimdi alınması neden gerekiyor?]

### Kısıtlamalar
- [Teknik kısıtlamalar]
- [Zaman çizelgesi kısıtlamaları]
- [Kaynak kısıtlamaları]
- [Uyumluluk gereksinimleri]

### Gereksinimler
- [X'i desteklemeli]
- [Y bütçesi içinde çalışmalı]
- [Z ile entegre olmalı]

## Karar

[Alınan teknik kararın, birinin uygulayabileceği kadar ayrıntılı açıklaması.]

### Mimari Şema
[Bu kararın oluşturduğu sistem mimarisinin ASCII diyagramı veya açıklaması]

### Temel Arayüzler
[Bu kararın oluşturduğu API sözleşmeleri veya arayüz tanımları]

## Değerlendirilen Alternatifler

### Alternatif 1: [Ad]
- **Açıklama**: [Nasıl çalışırdı]
- **Artılar**: [Avantajlar]
- **Eksiler**: [Dezavantajlar]
- **Reddedilme Nedeni**: [Neden seçilmedi]

### Alternatif 2: [Ad]
- **Açıklama**: [Nasıl çalışırdı]
- **Artılar**: [Avantajlar]
- **Eksiler**: [Dezavantajlar]
- **Reddedilme Nedeni**: [Neden seçilmedi]

## Sonuçlar

### Olumlu
- [Bu kararın iyi sonuçları]

### Olumsuz
- [Kabul edilen takas-offs ve maliyetler]

### Riskler
- [Ters gidebilecek şeyler]
- [Her risk için azaltma önlemi]

## Performans Etkileri
- **CPU**: [Beklenen etki]
- **Bellek**: [Beklenen etki]
- **Yükleme Süresi**: [Beklenen etki]
- **Ağ**: [Beklenen etki, varsa]

## Geçiş Planı
[Bu mevcut kodu değiştiriyorsa, oradan buraya nasıl geçeceğiz?]

## Doğrulama Kriterleri
[Bu kararın doğru olduğunu nasıl bileceğiz? Hangi ölçütler veya testler?]

## İlgili Kararlar
- [İlgili ADR'lere bağlantılar]
- [İlgili tasarım belgelerine bağlantılar]
```

5. **ADR'yi kaydet** — `docs/architecture/adr-[NNNN]-[slug].md` yoluna kaydet.
