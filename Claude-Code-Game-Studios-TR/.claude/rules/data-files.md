---
paths:
  - "assets/data/**"
---

# Veri Dosyası Kuralları

- Tüm JSON dosyaları geçerli JSON olmalıdır — bozuk JSON tüm derleme hattını bloke eder
- Dosya adlandırması: yalnızca küçük harf ve alt çizgi kullanın, `[sistem]_[ad].json` kalıbını izleyin
- Her veri dosyasının belgelenmiş bir şeması olmalıdır (JSON Şeması veya karşılık gelen tasarım belgesinde belgelenmiş)
- Sayısal değerler, rakamların ne anlama geldiğini açıklayan yorumlar veya yardımcı belgeler içermelidir
- Tutarlı anahtar adlandırması kullanın: JSON dosyalarındaki anahtarlar için camelCase
- Sahipsiz veri girişleri olmamalıdır — her giriş kod veya başka bir veri dosyası tarafından başvurulmalıdır
- Şemayı bozan değişiklikler yapıldığında veri dosyalarını sürümleyin
- Tüm isteğe bağlı alanlar için makul varsayılan değerler ekleyin

## Örnekler

**Doğru** adlandırma ve yapı (`combat_enemies.json`):

```json
{
  "goblin": {
    "baseHealth": 50,
    "baseDamage": 8,
    "moveSpeed": 3.5,
    "lootTable": "loot_goblin_common"
  },
  "goblin_chief": {
    "baseHealth": 150,
    "baseDamage": 20,
    "moveSpeed": 2.8,
    "lootTable": "loot_goblin_rare"
  }
}
```

**Yanlış** (`EnemyData.json`):

```json
{
  "Goblin": { "hp": 50 }
}
```

İhlaller: büyük harfli dosya adı, büyük harfli anahtar, `[sistem]_[ad]` kalıbı yok, zorunlu alanlar eksik.
