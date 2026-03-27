---
paths:
  - "tests/**"
---

# Test Standartları

- Test adlandırması: `test_[sistem]_[senaryo]_[beklenen_sonuç]` deseni
- Her testin açık bir arrange/act/assert yapısı olmalıdır
- Birim testleri harici duruma bağlı olmamalıdır (dosya sistemi, ağ, veritabanı)
- Entegrasyon testleri temizleme yapmalıdır
- Performans testleri kabul edilebilir eşikleri belirtmeli ve aşılırsa başarısız olmalıdır
- Test verileri testte veya özel fixture'lerde tanımlanmalı, hiçbir zaman paylaşılan mutable durumda değil
- Harici bağımlılıkları taklit edin — testler hızlı ve belirleyici olmalıdır
- Her hata düzeltmesi, orijinal hatayı yakalayacak bir regresyon testiyle sonuçlanmalıdır

## Örnekler

**Doğru** (uygun adlandırma + Arrange/Act/Assert):

```gdscript
func test_health_system_take_damage_reduces_health() -> void:
    # Arrange
    var health := HealthComponent.new()
    health.max_health = 100
    health.current_health = 100

    # Act
    health.take_damage(25)

    # Assert
    assert_eq(health.current_health, 75)
```

**Yanlış**:

```gdscript
func test1() -> void:  # İHLAL: açıklayıcı ad yok
    var h := HealthComponent.new()
    h.take_damage(25)  # İHLAL: arrange adımı yok, açık assert yok
    assert_true(h.current_health < 100)  # İHLAL: kesin olmayan assertion
```
