---
paths:
  - "src/ui/**"
---

# Kullanıcı Arayüzü Kod Kuralları

- Kullanıcı Arayüzü asla oyun durumunun sahibi veya doğrudan değiştirmeyecek — yalnızca görüntüle, değişiklikleri istemek için komut/etkinlikleri kullan
- Tüm Kullanıcı Arayüzü metinleri yerelleştirme sistemi aracılığıyla geçmeli — sabit kodlanmış kullanıcıyla karşılaşan dizeler yok
- Tüm etkileşimli öğeler için klavye/fare VE oyun kumandası girişini destekle
- Tüm animasyonlar atlanabilir olmalı ve kullanıcı hareket/erişilebilirlik tercihlerini saygı görmeli
- Kullanıcı Arayüzü sesleri ses etkinlik sistemi aracılığıyla tetikleniyor, doğrudan değil
- Kullanıcı Arayüzü asla oyun iş parçacığını engellemeyen
- Ölçeklenebilir metin ve renk körü modları zorunlu, isteğe bağlı değil
- Tüm ekranları minimum ve maksimum desteklenen çözünürlüklerde test et
