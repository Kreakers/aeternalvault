---
paths:
  - "src/gameplay/**"
---

# Oyun Kodu Kuralları

- TÜM oyun değerleri dış yapılandırma/veri dosyalarından GELMELİDİR, asla sabit kodlanmamalıdır
- Zamana bağlı tüm hesaplamalar için delta zamanı kullanın (kare hızından bağımsızlık)
- UI koduna doğrudan referans YOKTUR — sistemler arası iletişim için olay/sinyal kullanın
- Her oyun sistemi net bir arayüz uygulamalıdır
- Durum makineleri, belgelenmiş durumlarla açık geçiş tablolarına sahip olmalıdır
- Tüm oyun mantığı için birim testleri yazın — mantığı sunumdan ayırın
- Her özelliğin hangi tasarım belgesini uyguladığını kod yorumlarında belgelein
- Oyun durumu için statik tekil nesneler kullanmayın — bağımlılık enjeksiyonu kullanın

## Örnekler

**Doğru** (veri güdümlü):

```gdscript
var damage: float = config.get_value("combat", "base_damage", 10.0)
var speed: float = stats_resource.movement_speed * delta
```

**Yanlış** (sabit kodlanmış):

```gdscript
var damage: float = 25.0   # İHLAL: sabit kodlanmış oyun değeri
var speed: float = 5.0      # İHLAL: yapılandırmadan gelmiyor, delta kullanılmıyor
```
