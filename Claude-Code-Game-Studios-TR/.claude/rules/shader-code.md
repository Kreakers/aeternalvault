---
paths:
  - "assets/shaders/**"
---

# Shader Kod Standartları

`assets/shaders/` içindeki tüm shader dosyaları görsel kaliteyi, performansı ve
platformlar arası uyumluluğu korumak için bu standartları izlemelidir.

## Adlandırma Kuralları
- Dosya adlandırması: `[tip]_[kategori]_[ad].[uzantı]`
  - `spatial_env_water.gdshader` (Godot)
  - `SG_Env_Water` (Unity Shader Graph)
  - `M_Env_Water` (Unreal Material)
- Malzeme amacını gösteren açıklayıcı adlar kullanın
- Shader türü ile ön ek: `spatial_`, `canvas_`, `particles_`, `post_`

## Kod Kalitesi
- Tüm uniform/parametreler açıklayıcı adlara ve uygun ipuçlarına sahip olmalıdır
- İlgili parametreleri gruplandırın (Godot: `group_uniforms`, Unity: `[Header]`, Unreal: Category)
- Belirgin olmayan hesaplamaları açıkla (özellikle matematik ağır bölümler)
- Sihirli numaralar yok — adlandırılmış sabitler veya belgelenmiş uniform değerleri kullanın
- Her shader dosyasının üstünde yazarı ve amaçlayan bir açıklama ekleyin

## Performans Gereksinimleri
- Her shader için hedef platformu ve karmaşıklık bütçesini belirtin
- Uygun hassasiyeti kullanın: mobil cihazlarda tam hassasiyet gerekli olmadığında `half`/`mediump`
- Fragment shader'larda doku örneklemesini en aza indirin
- Fragment shader'larda dinamik branching'ten kaçının — `step()`, `mix()`, `smoothstep()` kullanın
- Döngülerin içinde doku okuması yok
- Bulanık efektler için iki geçişli yaklaşım (önce yatay sonra dikey)

## Platformlar Arası
- Shader'ları minimum spec hedef donanımda test edin
- Daha düşük kalite seviyeleri için basitleştirilmiş sürümler sağlayın
- Shader'ın hangi render pipeline'ını hedeflediğini belirtin (Forward/Deferred, URP/HDRP, Forward+/Mobile/Compatibility)
- Aynı dizinde farklı render pipeline'larından shader'ları karıştırmayın

## Varyant Yönetimi
- Shader varyantlarını en aza indirin — her varyant ayrı bir derlenmiş shader'dır
- Tüm anahtar sözcükleri/varyantları ve amaçlarını belirtin
- Derleme boyutunu azaltmak için özellik söküşünü kullanın
- Shader başına toplam varyant sayısını günlüğe kaydedin ve izleyin
