---
paths:
  - "prototypes/**"
---

# Prototip Kod Standartları (Gevşek)

Prototiplerin, fikirleri doğrulamak için atılabilir kod olduğu düşünülmektedir. Standartlar
kasıtlı olarak gevşektir, yineleme hızını maksimize etmek için. Amaç üretim kalitesi değil, öğrenmedir.

## Prototipler İçinde İzin Verilenler
- Sabit kodlanmış değerler (veri güdümlü yapılandırma gerekli değil)
- Minimal veya hiç belge açıklaması
- Basit mimari (bağımlılık enjeksiyonu gerekli değil)
- Singleton'lar ve global durum
- Kopyalanmış kod (soyutlama gerekli değil)
- Hata ayıklama çıktısı yerinde bırakılmış
- Yer tutucu sanat ve ses
- Hızlı ve kirli çözümler

## Hala Gerekli Olanlar
- Her prototip kendi alt dizinde bulunur: `prototypes/[ad]/`
- Her prototip MUTLAKA bir `README.md` dosyasına sahip olmalıdır:
  - Hangi hipotezin test edildiği
  - Prototip nasıl çalıştırılır
  - Mevcut durum (devam ediyor / sonlandırıldı)
  - Bulgular (prototip sonlandırıldığında güncellenir)
- Hiçbir üretim kodu `prototypes/` dosyasını referans görmeyebilir veya içeri aktaramaz
- Prototiplerin `prototypes/` dışında dosyaları değiştirmemesi gerekir
- Prototiplerin dağıtılmaması veya gönderilmemesi gerekir

## Bir Prototip Başarılı Olduğunda
Bir prototip bir konsepti doğrulamışsa ve özellik üretim sürümüne giderse:
1. Prototip kodu DOĞRUDAN aktarılmaz — üretim standartlarına yeniden yazılır
2. Prototip `README.md` bulguları üretim tasarım belgesini bilgilendirir
3. Prototip dizini referans için saklanır ama asla genişletilmez

## Temizleme
Sonuçlanan prototiplerin bulgular yakalandıktan sonra arşivlenmesi veya silinmesi gerekir.
Prototip kodunun artımlı "temizleme" yoluyla asla üretim koduna dönüşmesine izin vermeyin.
