# ADR: [Karar Adı]

---
**Durum**: Ters-Belgelenmiş
**Kaynak**: `[uygulama kodu yolu]`
**Tarih**: [YYYY-MM-DD]
**Karar Alıcılar**: [Kullanıcı adı veya "koddan çıkarıldı"]
**Uygulama Durumu**: [Yayınlandı | Kısmi | Planlı]

---

> **⚠️ Ters-Belgeleme Bildirimi**
>
> Bu Mimari Karar Kaydı **uygulamadan sonra** oluşturuldu. Mevcut uygulama yaklaşımını
> ve açıklanmış mantığını kod analizi ve kullanıcı danışması temelinde yakalar.
> Bazı bağlam çağdaş olarak belgelenmiş yerine yeniden oluşturulmuş olabilir.

---

## Bağlam

**Problem Açıklaması**: [Bu uygulama hangi problemi çözdü?]

**Arka Plan** (koddan çıkarıldı):
- [Bağlam 1 -- bu problemin neden çözülmesi gerekiyordu]
- [Bağlam 2 -- o zamanki kısıtlamalar]
- [Bağlam 3 -- muhtemelen düşünülen alternatifler]

**Sistem Kapsamı**: [Kod tabanının hangi parçaları bunu etkiler?]

**Paydaşlar**:
- [Rol 1]: [Onların kaygısı veya gereksinimi]
- [Rol 2]: [Onların kaygısı veya gereksinimi]

---

## Karar

**Uygulanmış Yaklaşım**:

[Kodda bulunan mimarik yaklaşımı açıklayın]

**Ana Uygulama Detayları**:
- [Detay 1]: [Nasıl çalışır?]
- [Detay 2]: [Kullanılan desen veya yapı]
- [Detay 3]: [Dikkate değer tasarım seçimi]

**Açıklanmış Mantık** (kullanıcıdan):
- [Nedeni 1 -- bu yaklaşım neden seçildi?]
- [Nedeni 2 -- hangi problemi çözer?]
- [Nedeni 3 -- hangi yararı sağlar?]

**Kod Konumları**:
- `[dosya/yol 1]`: [Orada neler var?]
- `[dosya/yol 2]`: [Orada neler var?]

---

## Düşünülen Alternatifler

*(Bunlar çıkarılan veya kullanıcı ile açıklanmış olabilir)*

### Alternatif 1: [Yaklaşım Adı]

**Açıklama**: [Bu alternatif ne olurdu?]

**Artıları**:
- ✅ [Avantaj 1]
- ✅ [Avantaj 2]

**Eksileri**:
- ❌ [Dezavantaj 1]
- ❌ [Dezavantaj 2]

**Neden Seçilmedi**: [Nedeni -- kullanıcı açıklaması veya çıkarım]

### Alternatif 2: [Yaklaşım Adı]

**Açıklama**: [Bu alternatif ne olurdu?]

**Artıları**:
- ✅ [Avantaj 1]
- ✅ [Avantaj 2]

**Eksileri**:
- ❌ [Dezavantaj 1]
- ❌ [Dezavantaj 2]

**Neden Seçilmedi**: [Nedeni]

### Alternatif 3: [Statüko / Değişiklik Yok]

**Açıklama**: ["Hiçbir şey yapılmamak" ne anlama gelirdi?]

**Neden Kabul Edilemedi**: [Problemin neden çözülmesi gerekiyordu?]

---

## Sonuçlar

### Olumlu Sonuçlar (Gerçekleşen Yararlar)

✅ **[Yarar 1]**: [Uygulama bunu nasıl sağlar?]

✅ **[Yarar 2]**: [Etki]

✅ **[Yarar 3]**: [Etki]

### Olumsuz Sonuçlar (Kabul Edilen Ödünler)

⚠️ **[Ödün 1]**: [Sakrifiye edilen veya zorlaştırılan]

⚠️ **[Ödün 2]**: [Sınırlama veya maliyet]

⚠️ **[Ödün 3]**: [Karmaşıklık veya bakım yükü]

### Nötr Sonuçlar (Gözlemler)

ℹ️ **[Gözlem 1]**: [Ortaya çıkan özellik veya yan etki]

ℹ️ **[Gözlem 2]**: [Beklenmedik sonuç]

---

## Uygulama Notları

**Kullanılan Desenler**:
- [Desen 1]: [Nerede ve neden]
- [Desen 2]: [Nerede ve neden]

**Tanıtılan Bağımlılıklar**:
- [Bağımlılık 1]: [Neden gerekli]
- [Bağımlılık 2]: [Neden gerekli]

**Performans Özellikleri**:
- Zaman karmaşıklığı: [O(n), vb.]
- Alan karmaşıklığı: [Hafıza kullanımı]
- Darboğazlar: [Bilinen performans endişeleri]

**İş Parçacığı Güvenliği**:
- [İş parçacığı güvenliği yaklaşımı -- tek çizgili, mutex korumalı, lock-free, vb.]

**Test Stratejisi**:
- [Nasıl test edilir -- unit testler, entegrasyon testleri, vb.]
- Kapsama: [Tahmin edilen veya ölçülen]

---

## Doğrulama

**Bunun Çalışması Nasıl Bilinir?**:
- ✅ [Kanıt 1 -- ör., "6 ay üretimde sorun olmadan"]
- ✅ [Kanıt 2 -- ör., "60 FPS'de 10k varlık işler"]
- ⚠️ [Kanıt 3 -- ör., "çalışır ama izleme gerekir"]

**Analiz Sırasında Keşfedilen Bilinen Sorunlar**:
- ⚠️ [Sorun 1]: [Problem ve olası çözüm]
- ⚠️ [Sorun 2]: [Problem ve olası çözüm]

**Riskler**:
- [Risk 1]: [X olursa olası problem]
- [Risk 2]: [Ölçeklenebilirlik endişesi]

---

## Açık Sorular

**Ters-Belgeleme Sırasında Çözülmemiş**:
1. **[Soru 1]**: [Karar veya uygulama hakkında ne belirsiz?]
   - Şuradan açıklama gerekli: [Kim]
   - Çözülmezse etki: [Sonuç]

2. **[Soru 2]**: [Gelecek çalışma için neyin kararlaştırılması gerekir?]

---

## İzleme Çalışması

**Hemen**:
- [ ] [Görev 1 -- ör., "Eksik unit testleri ekle"]
- [ ] [Görev 2 -- ör., "Edge case işlemeyi belgele"]

**Kısa Vadeli**:
- [ ] [Görev 3 -- ör., "X'i açıklık için refactor et"]
- [ ] [Görev 4 -- ör., "Performans izlemesi ekle"]

**Uzun Vadeli**:
- [ ] [Görev 5 -- ör., "Y kullanılabilir olduğunda kararı gözden geçir"]

---

## İlgili Kararlar

**Bağımlı Olduğu** (Bunu temel alan ADRler):
- [ADR-XXX]: [İlgili karar]

**Etkileyen** (Bu tarafından etkilenen ADRler):
- [ADR-YYY]: [Bunu nasıl etkiler?]

**Yerini Alır**:
- [ADR-ZZZ]: [Varsa, değiştirilen eski karar]

**Yerine Alınır**:
- [Henüz yok | Bu karar varsa değiştirilir: ADR-WWW]

---

## Referanslar

**Kod Konumları**:
- `[yol/dosya 1]`: [Ana uygulama]
- `[yol/dosya 2]`: [İlgili kod]

**Dış Kaynaklar**:
- [Makale/Kitap]: [İlgili desen veya teknik referansı]
- [Belgeler]: [Danışılan motor veya kütüphane dokümanları]

**Tasarım Belgeler**:
- [GDD Bölümü]: [Eğer bu bir tasarımı uygularsa]

---

## Sürüm Geçmişi

| Tarih | Yazar | Değişiklikler |
|-------|-------|---|
| [Tarih] | Claude (ters-belge) | `[kaynak yolu]` dosyasından ilk ters-belgeleme |
| [Tarih] | [Kullanıcı] | [X] için mantık açıklandı |

---

## Durum Açıklaması

- **Proposed**: Tartışılıyor, uygulanmamış
- **Accepted**: Kararlaştırıldı, uygulama sürmekte
- **Deprecated**: Artık önerilmiyor ama kod olabilir
- **Superseded**: Başka bir karar tarafından değiştirildi
- **Reverse-Documented**: Uygulamadan sonra oluşturuldu (bu belge)

---

**Mevcut Durum**: **Ters-Belgelenmiş**

---

*Bu ADR `/reverse-document architecture [yol]` tarafından üretildi*

---

## Ek: Kod Parçaları

**Ana Uygulama Deseni**:

```[dil]
[Ana deseni veya kararı gösteren kod parçası]
```

**Mantık**: [Bu kod yapısı kararı neden somutlaştırır?]

**Alternatif Yaklaşım** (seçilmemiş):

```[dil]
[Alternatif nasıl görünürdü gösteren kod parçası]
```

**Neden Değil**: [Uygulanan yaklaşım neden tercih edildi?]
