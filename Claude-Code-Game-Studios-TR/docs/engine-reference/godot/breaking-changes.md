# Godot Kırıcı Değişiklikler (4.2 → 4.6)

> **Referans:** [Godot 4.6 Sürüm Notları](https://godotengine.org/releases/4.6/) ve geçiş kılavuzları

## Hızlı Referans Tablosu

| Sürüm | Alan | Değişiklik | Geçiş |
|-------|------|------------|-------|
| 4.4 | Fizik | Jolt fizik motoru opsiyonel olarak eklendi | `ProjectSettings > Physics > 3D > Physics Engine`'de etkinleştirin |
| 4.4 | FileAccess | `FileAccess.open()` artık `FileAccess` yerine `Variant` döndürüyor | Dönüş değerini açık biçimde kontrol edin: `var f = FileAccess.open(...)` |
| 4.4 | Shader | Doku örnekleyici türleri ayrımı yapılmış (uniform sampler2D bölündü) | Shader'ları `texture_2d`, `texture_2d_array` kullanacak şekilde güncelleyin |
| 4.5 | GDScript | `@abstract` sınıf anahtar sözcüğü eklendi | Soyut örüntüleri kullanan kod artık bunu açıkça beyan edebilir |
| 4.5 | GDScript | Değişken argümanlar (`...args`) eklendi | Değişken arg kalıpları için eski geçici çözümler artık gereksiz |
| 4.5 | İşleme | SMAA, MSAAyı ana anti-aliasing seçeneği olarak değiştirdi | Proje ayarlarında anti-aliasing modunu kontrol edin |
| 4.5 | İşleme | Shader Baker - shader derleme sürprizlerini azaltır | Geriye dönük uyumlu; büyük projelerde isteğe bağlı olarak etkinleştirin |
| 4.5 | Erişilebilirlik | AccessKit entegrasyonu — ekran okuyucu desteği | Genel olarak geriye dönük uyumlu; UI nodları otomatik semantik alır |
| 4.6 | Fizik | Jolt, 3D için varsayılan fizik motoru oldu (GodotPhysics kaldırıldı) | Jolt uyumsuzlukları için fizik ayarlarını ve çarpışma şekillerini doğrulayın |
| 4.6 | İşleme | D3D12, Windows'ta varsayılan renderer oldu | Genellikle sorunsuz; D3D12 sorunları için Vulkan'a geri dönün |
| 4.6 | İşleme | Işıma tonemapping öncesine taşındı | Görsel fark; `Environment`'da ışıma ayarlarını kalibre edin |
| 4.6 | Animasyon | FABRIK/CCD IK sistemleri geri yüklendi, `BoneConstraint3D` eklendi | Yeni IK sistemi için eski IK geçici çözümlerini kaldırın |

## Ayrıntılı Notlar

### Jolt Fizik (4.4 opsiyonel → 4.6 varsayılan)

Jolt şimdi varsayılan. GodotPhysics kaldırıldı. Eğer şu anda GodotPhysics kullanıyorsanız ve 4.6'ya geçiş yapıyorsanız:
- Tüm fiziksel davranışları test edin; küçük sayısal farklılıklar olabilir
- Jolt, özellikle yığın stabilitesi açısından GodotPhysics'ten farklı davranır
- Fizik davranışı değişirse `physics/3d/physics_engine` proje ayarına bakın

### D3D12 Varsayılan (4.6)

D3D12, Windows'ta Vulkan'ın yerini aldı. Sorunlar için:
```
# Proje ayarlarında veya komut satırında:
--rendering-driver vulkan
```

### Işıma Tonemapping Öncesine Taşındı (4.6)

Işıma artık tonemap geçişinden önce işleniyor. Bu, şu anlama gelir:
- Işıma daha gerçekçi davranır (HDR ışıma)
- Eski sahneler `WorldEnvironment`'daki `glow_intensity` yeniden kalibre gerektirebilir
- Görsel regresyon testleri yapın

### FileAccess Dönüş Türü (4.4)

```gdscript
# YANLIŞ (4.4 öncesi)
var file: FileAccess = FileAccess.open("res://data.json", FileAccess.READ)

# DOĞRU (4.4+)
var file = FileAccess.open("res://data.json", FileAccess.READ)
if file == null:
    push_error("Dosya açılamadı")
    return
```
