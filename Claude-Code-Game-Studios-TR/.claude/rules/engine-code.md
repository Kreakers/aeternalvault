---
paths:
  - "src/core/**"
---

# Motor Kod Kuralları

- Sıcak yollarda (güncelleme döngüleri, render, fizik) SIFIR bellek tahsisi — önceden tahsis edin, havuzlayın, yeniden kullanın
- Tüm motor API'leri iş parçacığı güvenli OLMALI VEYA açıkça tek iş parçacığına özgü olarak belgelenmelidir
- Her optimizasyondan ÖNCE ve SONRA profilleme yapın — ölçülen sayıları belgeleyin
- Motor kodu hiçbir zaman oyun kodu bağımlılığı içermemelidir (katı bağımlılık yönü: motor <- oyun)
- Her genel API'nin belge yorumunda kullanım örnekleri bulunmalıdır
- Genel arayüzlerdeki değişiklikler bir kullanımdan kaldırma süreci ve geçiş kılavuzu gerektirir
- Tüm kaynaklar için RAII / belirleyici temizleme kullanın
- Tüm motor sistemleri zarif bozulmayı (graceful degradation) desteklemelidir
- Motor API kodu yazmadan önce mevcut motor sürümü için `docs/engine-reference/` dizinine başvurun ve API'leri referans belgelerle doğrulayın

## Örnekler

**Doğru** (sıfır tahsisli sıcak yol):

```gdscript
# Her kare yeniden kullanılan önceden tahsis edilmiş dizi
var _nearby_cache: Array[Node3D] = []

func _physics_process(delta: float) -> void:
    _nearby_cache.clear()  # Yeniden kullan, yeniden tahsis etme
    _spatial_grid.query_radius(position, radius, _nearby_cache)
```

**Yanlış** (sıcak yolda bellek tahsisi):

```gdscript
func _physics_process(delta: float) -> void:
    var nearby: Array[Node3D] = []  # İHLAL: her kare bellek tahsis eder
    nearby = get_tree().get_nodes_in_group("enemies")  # İHLAL: her kare ağaç sorgusu
```
