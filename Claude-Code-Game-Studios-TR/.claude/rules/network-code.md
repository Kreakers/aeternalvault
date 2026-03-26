---
paths:
  - "src/networking/**"
---

# Ağ Kodu Kuralları

- Sunucu, oyunla kritik tüm durum için YETKILIDIR — istemciye asla güvenmeyin
- Tüm ağ mesajları ileri/geri uyumluluk için sürümlendirilmiş olmalıdır
- İstemci yerel olarak tahmin eder, sunucu ile uzlaşır — yanlış tahminler için geri alma (rollback) uygulayın
- Bağlantı kesilmesini, yeniden bağlanmayı ve ana bilgisayar geçişini (host migration) zarif biçimde ele alın
- Kayıt taşmasını önlemek için tüm ağ kayıtlarını hız sınırlayın
- Tüm ağa bağlı değerler çoğaltma stratejisini belirtmelidir: güvenilir/güvenilmez, sıklık, enterpolasyon
- Bant genişliği bütçesi: mesaj türü başına bant genişliği kullanımını tanımlayın ve izleyin
- Güvenlik: gelen tüm paket boyutlarını ve alan aralıklarını doğrulayın
