# 🛡️ Aeterna Vault: Teknik Dokümantasyon

Aeterna Vault, kişisel ilişki yönetimi (CRM) ve güvenli veri saklama (Dijital Kasa) ihtiyaçlarını tek bir potada eriten, gizlilik odaklı bir mobil uygulamadır.

## 🛠 Teknik Mimari
*   **Framework:** Flutter (Material 3)
*   **State Management:** Provider (AppProvider)
*   **Veritabanı:** SQLite (sqflite v11) - Tamamen yerel ve cihaz içi saklama.
*   **Şifreleme:** AES-256 (encrypt paketi) - Master Key tabanlı veritabanı dışı dosya/metin şifreleme.
*   **Güvenlik:** Biometrik Doğrulama (Fingerprint/FaceID) ve Master Key sistemi.

## 🏗 Veritabanı Şeması (v11)
Uygulama, verileri 4 ana tabloda yönetir:
1.  **contacts:** CRM kayıtları, sosyal medya, profesyonel bilgiler ve gizlilik statüsü.
2.  **vault_items:** Şifrelenmiş belgeler, banka bilgileri ve şifreler (Dinamik JSON içeriği).
3.  **reminders:** Kişi bazlı hatırlatıcılar ve görev takibi.
4.  **logs:** Zaman tüneli için işlem geçmişi (Log sistemi).
5.  **vault_settings:** Tema tercihleri, Master Key ve kurtarma kodu.

---

# 📖 Kullanım Kılavuzu (User Manual)

## 1. İlk Kurulum ve Güvenlik
Uygulamayı ilk açtığınızda CRM özelliklerini hemen kullanmaya başlayabilirsiniz. Ancak **Dijital Kasa**'yı kullanmak için:
*   Yan menüden **"Kasayı Aktif Et"** seçeneğine dokunun.
*   En az 4 haneli bir **Master Key (Ana Şifre)** belirleyin.
*   Varsa telefonunuzun parmak izi/yüz tanıma özelliğini (Biyometrik) aktif edin.
*   **Kurtarma Kodu:** Ayarlar kısmından mutlaka bir kurtarma kodu oluşturun ve not edin. Şifrenizi unutursanız kasanıza erişmenin tek yolu budur.

## 2. Kişisel CRM Yönetimi
*   **Kişi Ekleme:** Sağ alttaki `+` butonuyla yeni bir kişi ekleyebilirsiniz. İsim, telefon, e-posta, şirket, unvan, sosyal medya ve doğum günü gibi detaylı bilgileri girebilirsiniz.
*   **Kategorizasyon:** Kişileri "Müşteri", "İş", "Arkadaş" gibi gruplara ayırabilirsiniz. Ana ekranda bu grupları açıp kapatarak karmaşayı önleyebilirsiniz.
*   **Akıllı Takip:** Bir kişi için "Görüşme Sıklığı" belirlerseniz, Dashboard üzerinden görüşme zamanı gelen kişiler için otomatik uyarı alırsınız.
*   **Zaman Tüneli:** Kişi detay sayfasında o kişiyle ilgili geçmiş işlemleri (kayıt, güncelleme, tamamlanan görevler) kronolojik olarak görebilirsiniz.

## 3. Güvenlik Kasa (Vault)
*   **Gizli Kayıtlar:** Kasa içindeyken eklediğiniz her şey (Kişiler veya Şifreler) ana rehberden tamamen izole edilir.
*   **Şifre Üretici:** Yeni bir şifre eklerken "Şifre Üret" butonuna basarak kırılamaz şifreler oluşturabilirsiniz.
*   **Belge Saklama:** Kasanıza PDF, resim veya döküman ekleyebilir, bu dosyalara kasa içinden güvenle erişebilirsiniz.
*   **Şifre Gizleme:** Kasa listesinde şifreleriniz varsayılan olarak gizlidir. "Göz" ikonuna basarak şifrenizi güvenli bir şekilde görebilirsiniz.

## 4. İstatistikler ve Dashboard
Ana ekranın üst kısmındaki Dashboard paneli size şu bilgileri sunar:
*   Kayıtlı toplam kişi ve kasa öğesi sayısı.
*   Kategori bazlı dağılım (Pasta Grafiği).
*   **Akıllı Bildirimler:** Bugün doğum günü olanlar ve aranması gereken kişilerin listesi.

## 5. Yedekleme ve Tema
*   **Yedekleme:** "Güvenlik Ayarları" altından tüm verilerinizi şifreli bir metin (JSON) olarak dışa aktarabilir veya başka bir cihaza yükleyebilirsiniz.
*   **Kişiselleştirme:** "Genel Ayarlar" üzerinden 6 farklı profesyonel renk temasından birini seçebilir, Karanlık (Dark) veya Aydınlık (Light) mod arasında geçiş yapabilirsiniz.
*   **Sıfırlama:** "Fabrika Ayarlarına Dön" seçeneği ile tüm verilerinizi tek tıkla kalıcı olarak silebilirsiniz.

---

**⚠️ Önemli Uyarı:** Aeterna Vault verilerinizi internete göndermez. Telefonunuzu sıfırlamadan önce mutlaka manuel yedek alınız.
