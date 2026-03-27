---
name: release-checklist
description: "Derleme doğrulaması, sertifikasyon gereksinimleri, mağaza meta verileri ve başlatma hazırlığını kapsayan kapsamlı ön-yayın doğrulama kontrol listesi oluştur."
argument-hint: "[platform: pc|console|mobile|all]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write
---

Bu beceri çağrıldığında:

> **Açık çağrı sadece**: Bu beceri sadece kullanıcı `/release-checklist` ile açıkça istediğinde çalışmalı. Bağlam eşleşmesine dayanarak otomatik çağırma yapma.

1. **Argümanı oku** hedef platform için (`pc`, `console`, `mobile`,
   veya `all`). Eğer platform belirtilmemişse, varsayılanı `all`.

2. **CLAUDE.md'yi oku** proje bağlamı, sürüm bilgisi ve platform
   hedefleri için.

3. **Güncel kilometre taşını oku** `production/milestones/` den bu yayına
   hangi özelliklerin ve içeriğin dahil olması gerektiğini anlamak için.

4. **Kod tabanını tara** için ödenmemiş sorunlar:
   - `TODO` yorumlarını say
   - `FIXME` yorumlarını say
   - `HACK` yorumlarını say
   - Onların yerlerini ve şiddeti not et

5. **Test sonuçlarını kontrol et** varsa herhangi bir test çıktısı dizininde
   veya CI günlüklerinde.

6. **Yayın kontrol listesini oluştur**:

```markdown
## Yayın Kontrol Listesi: [Sürüm] -- [Platform]
Oluşturulan: [Tarih]

### Kod Tabanı Sağlığı
- TODO sayısı: [N] ([çoksa ilk 5'i listele])
- FIXME sayısı: [N] ([listele -- bunlar potansiyel engelleyiciler])
- HACK sayısı: [N] ([listele -- bunlar gözden geçirmeye ihtiyaç duyar])

### Derleme Doğrulama
- [ ] Temiz derleme tüm hedef platformlarda başarılı
- [ ] Derleyici uyarısı yok (sıfır-uyarı politikası)
- [ ] Tüm varlıklar dahil ve doğru yükleniyor
- [ ] Derleme boyutu bütçe içinde ([hedef boyut])
- [ ] Derleme sürüm numarası doğru ayarlanmış ([sürüm])
- [ ] Derleme etiketlenmiş commit'ten yeniden üretilebilir

### Kalite Kapıları
- [ ] Sıfır S1 (Kritik) hatası
- [ ] Sıfır S2 (Büyük) hatası -- veya yapımcı onayı ile belgelendirilen istisnalar
- [ ] Tüm kritik yol özellikleri test edilmiş ve QA tarafından imzalanmış
- [ ] Performans bütçeleri içinde:
  - [ ] Hedef FPS en düşük özellik donanımında sağlanmış
  - [ ] Bellek kullanımı bütçe içinde
  - [ ] Yükleme süreleri bütçe içinde
  - [ ] Uzun oyun seanslarında bellek sızıntısı yok
- [ ] Önceki derlemeden gerileme yok
- [ ] Soak test geçmiş (4+ saat kesintisiz oyun)

### İçerik Tamamlandı
- [ ] Tüm placeholder varlıklar son sürümlerle değiştirildi
- [ ] Tüm TODO/FIXME içerik dosyalarında çözüldü veya belgelendirdi
- [ ] Tüm oyuncu görmek için yazı düzeltildi
- [ ] Tüm yazı yerelleştirmeye hazır (sabit kodlanmış dizeler yok)
- [ ] Ses karması sonlandırılmış ve onaylanmış
- [ ] Krediler tamamlandı ve doğru
```

7. **Platforma özgü bölümleri ekle** argümana göre:

PC için:
```markdown
### Platform Gereksinimleri: PC
- [ ] En düşük ve tavsiye edilen özellikler doğrulanmış ve belgelendirdi
- [ ] Klavye+fare kontrolleri tam işlevsel
- [ ] Denetleyici desteği test edilmiş (Xbox, PlayStation, genel)
- [ ] Çözünürlük ölçeklendirmesi test edilmiş (1080p, 1440p, 4K, ultrawide)
- [ ] Pencereli, çerçevesiz ve tam ekran modlar çalışıyor
- [ ] Grafik ayarları kaydediyor ve yükleniyor
- [ ] Steam/Epic/GOG SDK entegre ve test edilmiş
- [ ] Başarılar işlevsel
- [ ] Bulut kaydı işlevsel
- [ ] Steam Deck uyumluluğu doğrulandı (hedefleniyor ise)
```

Console için:
```markdown
### Platform Gereksinimleri: Console
- [ ] TRC/TCR/Lotcheck gereksinimleri kontrol listesi tamamlandı
- [ ] Platforma özgü denetleyici istekleri doğru görüntüleniyor
- [ ] Askı/devam doğru çalışıyor
- [ ] Kullanıcı değişimi düzgün şekilde işleniyor
- [ ] Ağ bağlantısı kaybı zarif şekilde işleniyor
- [ ] Depolama dolu senaryosu işleniyor
- [ ] Ebeveyn kontrolleri saygılı
- [ ] Platforma özgü başarı/kupa entegrasyonu test edilmiş
- [ ] Birinci taraf sertifikasyon gönderimi hazırlandı
```

Mobil için:
```markdown
### Platform Gereksinimleri: Mobile
- [ ] Uygulama mağazası yönergeleri uyumluluğu doğrulandı
- [ ] Tüm gerekli cihaz izinleri haklı ve belgelendirdi
- [ ] Gizlilik politikası bağlantılı ve doğru
- [ ] Veri güvenliği/beslenme etiketleri tamamlandı
- [ ] Touch kontrolleri birden fazla ekran boyutunda test edilmiş
- [ ] Pil kullanımı kabul edilebilir aralıkta
- [ ] Arka plan davranışı doğru (duraklat, devam, sonlandır)
- [ ] Push bildirim izinleri düzgün şekilde işleniyor
- [ ] Uygulama içi satın alma akışı test edilmiş (varsa)
- [ ] Uygulama boyutu mağaza limitleri içinde
```

8. **Mağaza ve başlatma bölümleri ekle**:

```markdown
### Mağaza / Dağıtım
- [ ] Mağaza sayfa meta verileri tamamlandı ve düzeltildi
  - [ ] Kısa açıklama
  - [ ] Uzun açıklama
  - [ ] Özellik listesi
  - [ ] Sistem gereksinimleri (PC)
- [ ] Ekran görüntüleri güncellendi ve platforma özgü çözünürlük gereksinimlerini karşılıyor
- [ ] Tanıtımlar güncel
- [ ] Anahtar sanat ve kapsül görselleri güncel
- [ ] Yaş derecelendirilmesi elde edilmiş ve yapılandırılmış:
  - [ ] ESRB
  - [ ] PEGI
  - [ ] Gerekli olduğu kadar diğer bölgesel derecelendirilmeler
- [ ] Yasal bildirimler, EULA ve gizlilik politikası yerinde
- [ ] Üçüncü taraf lisans kredileri tamamlandı
- [ ] Fiyatlandırma tüm bölgeler için yapılandırıldı

### Başlatma Hazırlığı
- [ ] Analytics / telemetri doğrulandı ve veri alıyor
- [ ] Kilitlenme raporlaması yapılandırıldı ve pano erişilebilir
- [ ] Başlangıç günü yaması hazırlandı ve test edildi (gerekli ise)
- [ ] İlk 72 saatte çağrıda bekleyen takım programı ayarlandı
- [ ] Topluluk başlatma duyuruları taslak yapılmış
- [ ] Basın/etkileyici anahtarları dağıtım için hazırlandı
- [ ] Destek takımı bilinen sorunlar ve SSS hakkında bilgilendirildi
- [ ] Geri alma planı belgelendirdi (başlatma sonrası kritik sorunlar bulunursa)

### Git / Hazır Değil: [HAZIR / HAZIR DEĞİL]

**Gerekçe:**
[Hazırlık değerlendirmesinin özeti. Başlamamadan önce çözülmesi gereken tüm engelleyici
öğeleri listele. HAZIR DEĞİL ise, çözülmesi gereken spesifik öğeleri ve bunlara
yönelik tahmini saati listele.]

**Gerekli İmzalar:**
- [ ] QA Lideri
- [ ] Teknik Yönetmen
- [ ] Yapımcı
- [ ] Yaratıcı Yönetmen
```

9. **Kontrol listesini kaydet**
   `production/releases/release-checklist-[sürüm].md` ye, dizini oluştur eğer mevcut değilse.

10. **Kullanıcıya özet çıktısı**: toplam kontrol listesi öğeleri, bilinen engelleyici sayısı
    (FIXME/HACK sayıları, bilinen hatalar) ve dosya yolu.
