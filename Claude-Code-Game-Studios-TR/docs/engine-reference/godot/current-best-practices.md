# Godot Mevcut En İyi Uygulamalar (4.5–4.6)

> Sürüm referansı için bkz. `VERSION.md`. Bu belgeler Godot 4.5 ve 4.6 için doğrulanmıştır.

## GDScript (4.5+)

### Tür Açıklamaları Her Zaman Kullanın

```gdscript
# YANLIŞ — yazılmamış
var speed = 5.0
func move(delta):
    position.x += speed * delta

# DOĞRU — tamamen yazılmış
var speed: float = 5.0
func move(delta: float) -> void:
    position.x += speed * delta
```

### @abstract Sınıfları (4.5+)

```gdscript
# Temel sınıflar için @abstract kullanın
@abstract class_name BaseEnemy extends CharacterBody3D

@abstract func get_attack_damage() -> float:
    pass
```

### Değişken Argümanlar (4.5+)

```gdscript
# Artık çeşitli arg sayısı için doğal sözdizimi var
func log_event(event_name: String, ...args: Array) -> void:
    print(event_name, args)
```

### Signal Tanımlamaları

```gdscript
# Yazılmış parametrelerle signal'lar
signal health_changed(old_value: float, new_value: float)
signal died(enemy: BaseEnemy)
```

## Fizik (4.6 — Jolt Varsayılan)

### CharacterBody3D Hareketi

```gdscript
func _physics_process(delta: float) -> void:
    # Yer çekimini uygula
    if not is_on_floor():
        velocity.y -= gravity * delta

    # Yatay hareketi uygula
    var direction = get_movement_direction()
    velocity.x = direction.x * speed
    velocity.z = direction.z * speed

    move_and_slide()
```

### Çarpışma Katmanları

Çarpışma katmanlarını ve maskelerini her zaman proje sabitleri olarak tanımlayın:

```gdscript
# autoload/physics_layers.gd
const PLAYER = 1
const ENEMY = 2
const ENVIRONMENT = 4
const PROJECTILE = 8
```

### Raycast Sorgular

```gdscript
# 4.x stili raycast
func cast_ray(from: Vector3, to: Vector3) -> Dictionary:
    var query = PhysicsRayQueryParameters3D.create(from, to)
    query.exclude = [self]
    return get_world_3d().direct_space_state.intersect_ray(query)
```

## İşleme (4.5–4.6)

### SMAA Anti-Aliasing (4.5+)

MSAA artık tercih edilmemektedir. Bunun yerine SMAA kullanın:
- `ProjectSettings > Rendering > Anti Aliasing > Quality > MSAA 3D` → Devre Dışı
- `ProjectSettings > Rendering > Anti Aliasing > Quality > Screen Space AA` → SMAA

### Shader Baker (4.5+)

Büyük projeler için: `ProjectSettings > Rendering > Shaders > Shader Cache` → Etkin

### Işıma (4.6+)

Işıma artık tonemap geçişinden önce işleniyor. Daha doğal ışıma elde etmek için `WorldEnvironment`'daki Glow ayarlarını kalibre edin.

```gdscript
# Çalışma zamanında ışımayı ayarlamak için:
var env: Environment = $WorldEnvironment.environment
env.glow_enabled = true
env.glow_intensity = 0.8  # Eski değerden daha düşük olabilir
```

## Ses (4.x)

### Ses Yönetimi

```gdscript
# AudioStreamPlayer'ı bus routing ile kullanın
@onready var sfx_player: AudioStreamPlayer = $SFXPlayer

func play_sound(stream: AudioStream, bus: String = "SFX") -> void:
    sfx_player.stream = stream
    sfx_player.bus = bus
    sfx_player.play()
```

## Sahne Organizasyonu

### Kompozisyon Üzerinden Miras

```gdscript
# İç içe geçmiş derin sınıf hiyerarşilerinden kaçının
# Bunun yerine bileşen nodlarını tercih edin:
# - HealthComponent
# - MovementComponent
# - AttackComponent
```

### Autoload Kullanımı

Global state'i temsil eden sistemler için autoload kullanın. Autoload'ları sık değişen sistemlere değil, gerçekten global olan şeylere saklayın:

```gdscript
# Uygun autoload kullanımı
# - EventBus (global eventler)
# - GameSettings (uygulama geneli ayarlar)
# - SaveManager (kayıt/yükleme yönetimi)
```
