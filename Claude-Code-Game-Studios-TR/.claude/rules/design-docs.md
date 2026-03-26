---
paths:
  - "design/gdd/**"
---

# Tasarım Belgesi Kuralları

- Her tasarım belgesi şu 8 bölümü İÇERMELİDİR: Genel Bakış, Oyuncu Fantezisi, Ayrıntılı Kurallar, Formüller, Uç Durumlar, Bağımlılıklar, Ayar Düğmeleri, Kabul Kriterleri
- Formüller; değişken tanımlarını, beklenen değer aralıklarını ve örnek hesaplamaları içermelidir
- Uç durumlar, "nazikçe ele al" gibi ifadeler yerine ne olduğunu açıkça belirtmelidir
- Bağımlılıklar çift yönlü olmalıdır — A sistemi B'ye bağımlıysa B'nin belgesi A'dan söz etmelidir
- Ayar düğmeleri güvenli aralıkları ve hangi oyun deneyimi boyutunu etkilediğini belirtmelidir
- Kabul kriterleri test edilebilir olmalıdır — bir QA test uzmanı geçti/kaldı durumunu doğrulayabilmelidir
- Belirsizlik kabul edilmez: "sistem iyi hissettirmeli" geçerli bir şartname değildir
- Denge değerleri kaynak formülleri veya gerekçeleri ile ilişkilendirilmelidir
- Tasarım belgeleri ARTIMLI olarak yazılmalıdır: önce iskelet oluşturun, ardından bölümler arasında
  kullanıcı onayı alarak her bölümü tek tek doldurun. Onaylanan her
  bölümü kararları kalıcı kılmak ve bağlamı yönetmek için hemen dosyaya yazın
