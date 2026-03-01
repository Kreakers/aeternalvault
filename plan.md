# Aeterna Vault - Proje Geliştirme Planı

Bu döküman, Aeterna Vault adlı çevrimdışı (offline-first) Kişisel CRM ve Dijital Kasa uygulamasının adım adım geliştirme aşamalarını içermektedir.

## 1. Aşama: Proje Kurulumu ve Yapılandırma
- Flutter projesinin başlangıç (default) kodlarının temizlenmesi.
- `pubspec.yaml` dosyasının güncellenerek gerekli bağımlılıkların eklenmesi:
  - Veritabanı: `sqflite`, `path`
  - Durum Yönetimi (State Management): `provider`
  - Güvenlik ve Şifreleme: `local_auth`, `encrypt`
- Proje içerisindeki dizin yapısının (`lib/models`, `lib/services`, `lib/screens`, `lib/providers`) oluşturulması.

## 2. Aşama: Veri Modellerinin Oluşturulması (`lib/models`)
- `Contact` Modeli (Kişi): Ad, Soyad, Telefon, Özel Notlar, Son Görüşme Tarihi, Kategori.
- `VaultItem` Modeli (Kasa Öğesi): Başlık, Şifreli İçerik (Secret), Kategori (Vasiyet, Şifre, Belge vb.).

## 3. Aşama: Veritabanı ve Şifreleme Servisleri (`lib/services`)
- AES-256 şifreleme/şifre çözme işlemleri için `EncryptionService` sınıfının yazılması.
- `sqflite` kütüphanesi ile yerel veritabanı (SQLite) kurulumunu sağlayan ve CRUD (Oluşturma, Okuma, Güncelleme, Silme) operasyonlarını üstlenen `DatabaseService` sınıfının inşa edilmesi.

## 4. Aşama: State Management (Provider) Entegrasyonu (`lib/providers`)
- `ContactProvider` ve `VaultProvider` sınıflarının (veya tek bir `AppProvider`'ın) oluşturulması.
- UI bileşenlerinin ve veritabanı servisinin bu sağlayıcılar (Providers) üzerinden birbirine bağlanması.

## 5. Aşama: Yedekleme ve Biyometrik Güvenlik (`lib/services` devamı)
- Biyometrik doğrulama arayüzü olan `AuthService` sınıfının `local_auth` kullanarak implemente edilmesi.
- Veritabanındaki verileri JSON tabanlı bir rapora dönüştüren (`export` yapan) ve bu veriyi özel bir 'Master Key' ile şifreleyen `BackupService` iskeletinin kurgulanması.

## 6. Aşama: Arayüz (UI) Geliştirilmesi (`lib/screens` ve Tema)
- Tüm uygulamada Koyu Tema (Dark Mode) renk paletinin tanımlanıp uygulanması.
- **Ana Ekran (CRM Ekranı):** Modern dizayna sahip listeler veya kart (card) yapıları ile kişilerin (Contact) sergilenmesi.
- Ana ekranda sağ alt köşede bulunacak, Kasa ekranına geçiş yapmak için tıklanacak "Güvenli Kasa" (biometric lock destekli) butonunun konumlandırılması.
- **Kasa Ekranı:** Şifreli verilerin (VaultItem) listeleneceği, biyometrik doğrulama geçildikten sonra açılan ekranın tasarlanması.

---

*Not: Her aşamada bir önceki aşamanın başarılıyla tamamlandığı test edilecektir. Plan dahilinde ilk olarak 1. ve 2. aşamalar uygulanacaktır.*
