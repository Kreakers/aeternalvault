# ADR-[NNNN]: [Başlık]

## Durum

[Proposed | Accepted | Deprecated | Superseded by ADR-XXXX]

## Tarih

[YYYY-MM-DD]

## Karar Alıcılar

[Bu karar sürecinde kimler yer aldı?]

## Bağlam

### Problem Açıklaması

[Hangi problemi çözmek istiyoruz? Bu karar neden şimdi verilmeli? Karar vermemenin maliyeti nedir?]

### Mevcut Durum

[Sistem bugün nasıl çalışıyor? Mevcut yaklaşımda ne yanlış?]

### Kısıtlamalar

- [Teknik kısıtlamalar -- motor sınırlamaları, platform gereksinimleri]
- [Zaman kısıtlamaları -- son tarih baskıları, bağımlılıklar]
- [Kaynak kısıtlamaları -- takım boyutu, mevcut uzmanlık]
- [Uyumluluk gereksinimleri -- mevcut sistemlerle uyum sağlaması gerekir]

### Gereksinimler

- [İşlevsel gereksinim 1]
- [İşlevsel gereksinim 2]
- [Performans gereksinimi -- özel ve ölçülebilir]
- [Ölçeklenebilirlik gereksinimi]

## Karar

[Spesifik teknik karar, birinin başkadan açıklama almadan bunu uygulamalarına yetecek kadar detaylı olarak açıklanmalıdır.]

### Mimari

```
[Bu kararın yarattığı sistem mimarisini gösteren ASCII diyagram.
Bileşenleri, veri akış yönünü ve ana arayüzleri gösterin.]
```

### Ana Arayüzler

```
[Pseudokod veya dile özgü arayüz tanımları bu karar tarafından
oluşturulan. Bunlar uygulayıcıların uyması gereken kontratlar haline gelir.]
```

### Uygulama Rehberi

[Bu kararı uygulayacak programcıya yönelik spesifik kılavuz.]

## Düşünülen Alternatifler

### Alternatif 1: [Adı]

- **Açıklama**: [Bu yaklaşım nasıl çalışır?]
- **Artıları**: [Bu yaklaşımın iyi tarafları]
- **Eksileri**: [Bu yaklaşımın kötü tarafları]
- **Tahmini Çaba**: [Seçilen yaklaşımla karşılaştırıldığında göreli çaba]
- **Reddedilme Nedeni**: [Neden bu seçilmedi?]

### Alternatif 2: [Adı]

[Yukarıdakiyle aynı yapı]

## Sonuçlar

### Olumlu

- [Bu kararın iyi sonuçları]

### Olumsuz

- [Kabul ettiğimiz ödünler ve maliyetler]

### Nötr

- [Ne iyi ne de kötü, sadece farklı olan değişiklikler]

## Riskler

| Risk | Olasılık | Etki | Azaltma |
|------|----------|------|---------|

## Performans Etkileri

| Metrik | Önce | Sonra Beklenen | Bütçe |
|--------|------|-----------------|--------|
| CPU (frame time) | [X]ms | [Y]ms | [Z]ms |
| Memory | [X]MB | [Y]MB | [Z]MB |
| Load Time | [X]s | [Y]s | [Z]s |
| Network (eğer varsa) | [X]KB/s | [Y]KB/s | [Z]KB/s |

## Geçiş Planı

[Eğer bu mevcut sistemleri değiştirirse, adım adım geçiş planı.]

1. [Adım 1 -- ne değişir, ne kırılır, nasıl doğrulanır]
2. [Adım 2]
3. [Adım 3]

**Geri çekilme planı**: [Bu karar yanlışsa nasıl geri çekilir?]

## Doğrulama Kriterleri

[Bu kararın doğru olduğunu nasıl bileceğiz?]

- [ ] [Ölçülebilir kriter 1]
- [ ] [Ölçülebilir kriter 2]
- [ ] [Performans kriteri]

## İlgili

- [İlgili ADRlara bağlantı]
- [İlgili tasarım belgelerine bağlantı]
- [İlgili kod dosyalarına bağlantı]
