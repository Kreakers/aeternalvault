# Kodlama Standartları

- Tüm oyun kodu genel API'lerde doc yorum içermelidir
- Her sistem `docs/architecture/` içinde karşılık gelen bir mimari karar kaydına sahip olmalıdır
- Oyun değerleri veri tabanlı (harici yapılandırma) olmalı, hiçbir zaman sabit kodlanmış olmamalıdır
- Tüm genel yöntemler birim test edilebilir olmalıdır (tekil üzerinde bağımlılık enjeksiyonu)
- Taahhütler ilgili tasarım belgesini veya görev kimliğini referans almalıdır
- **Doğrulama odaklı geliştirme**: Oyun sistemleri eklerken ilk testleri yazın.
  Arayüz değişiklikleri için ekran görüntüleriyle doğrulayın. Beklenen çıkış ile gerçek çıkış
  karşılaştırın, işi tamamlandı olarak işaretlemeden önce. Her uygulamanın çalıştığını kanıtlamanın bir yolu olmalıdır.

# Tasarım Belgesi Standartları

- Tüm tasarım belgeleri Markdown kullanır
- Her mekanik `design/gdd/` içinde özel bir belgeye sahiptir
- Belgeler bu 8 gerekli bölümü içermelidir:
  1. **Genel Bakış** -- bir cümlelik özet
  2. **Oyuncu Fantazisi** -- amaçlanan hissetme ve deneyim
  3. **Ayrıntılı Kurallar** -- belirsiz olmayan mekanikler
  4. **Formüller** -- tüm matematik değişkenlerle tanımlanmış
  5. **Kenar Durumlar** -- alışılmadık durumlar işlenir
  6. **Bağımlılıklar** -- diğer sistemler listelenir
  7. **Ayarlama Düğmeleri** -- yapılandırılabilir değerler tanımlanmış
  8. **Kabul Kriterleri** -- test edilebilir başarı koşulları
- Denge değerleri kaynak formüllerine veya mantığa bağlantı vermelidir
