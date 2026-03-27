---
name: brainstorm
description: "Sıfırdan yapılandırılmış oyun konsepti belgesine kadar rehberli oyun konsepti ideasyonu. Profesyonel stüdyo ideasyonu teknikleri, oyuncu psikolojisi çerçeveleri ve yapılandırılmış yaratıcı keşif kullanır."
argument-hint: "[tür veya tema ipucu, veya açık beyin fırtınası için 'open']"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, WebSearch, AskUserQuestion
---

Bu beceri çağrıldığında:

1. **Argümanı analiz et** isteğe bağlı tür/tema ipucu için (örn. roguelike, uzay hayatta kalma, rahat çiftçilik). open veya argüman yoksa sıfırdan başla.

2. **Mevcut konsept çalışmasını kontrol et**:
   - design/gdd/game-concept.md varsa oku (devam et, yeniden başlama)
   - design/gdd/game-pillars.md varsa oku (kurulan direkler üzerine inşa et)

3. **İdeasyon aşamalarından geç** etkileşimli olarak, her aşamada kullanıcıdan soru sor. HER ŞEYİ sessizce üretme - amaç işbirlikçi keşif yapay zekanın yaratıcı kolaylaştırıcı olduğu, insan vizyonunun yedek olmadığı yer.

   **AskUserQuestion kullan** anahtar karar noktalarında:
   - Kısıtlanmış zevk soruları (tür tercihleri, kapsam, ekip boyutu)
   - Konsept seçimi (Hangi 2-3 konsept rezonans kuruyor?) seçenekleri sunulduktan sonra
   - Yön seçimleri (Daha fazla geliştir, daha fazla keşfet veya prototip yap?)
   - Konseptler rafine edildikten sonra pillar sıralaması
   Önce konuşma metninde tam yaratıcı analiz yaz, ardından AskUserQuestion kullanarak kararı özlü etiketlerle yakla.

   Takip edilecek profesyonel stüdyo beyin fırtınası ilkeleri:
   - Yargıyı tutut - keşif sırasında hiçbir fikir kötü değil
   - Alışılmadık fikirleri teşvik et - kutudan çıkan düşünce daha iyi kavramları kışkırtır
   - Birbirinin üzerine inşa et - "ama" değil "evet, ve..." yanıtları
   - Kısıtlamaları yaratıcı yakıt olarak kullan - sınırlamalar genellikle en iyi fikirleri üretir
   - Her aşamayı zaman kes - momentum tut, erken aşamada aşırı tartış

---

### Aşama 1: Yaratıcı Keşif

İnsan oyunlara değil, oyunları anlayarak başla. Bu soruları sohbet tarzında sor (kontrol listesi olarak değil):

**Duygusal çapaları**:
- Oyunda seni gerçekten etkilemiş, heyecanlandırmış veya zamanını kaybettiren bir an? Spesifik olarak ne o duyguyu yarattı?
- Hiçbir zaman tam olarak oyunda bulamadığın ama her zaman istediğin bir fantezi veya güç çılgınlığı var mı?

**Zevk profili**:
- En çok zaman harcadığın 3 oyun nedir? Seni geri döndüren neydi?
- Sevdiğin türler var mı? Kaçındığın türler var mı? Neden?
- Seni zorlayan, rahatlatıcı, hikaye anlatan veya kendini ifade etmene izin veren oyunları mı tercih edersin?

**Pratik kısıtlamalar** (beyin fırtınasından önce sandbox'u şekillendir):
- Tek geliştirici mi yoksa takım mı? Hangi beceriler mevcut?
- Zaman çizelgesi: haftalar, aylar mı, yıllar mı?
- Herhangi bir platform kısıtlaması var mı? (Sadece PC? Mobil? Konsol?)
- İlk oyun mu yoksa deneyimli geliştirici mi?

**Sentez** cevapları Yaratıcı Brifle - kişinin duygusal hedefleri, zevk profili ve kısıtlamalarının 3-5 cümlelik özeti. Brifı geri oku ve niyetini yakaladığını doğrula.

---

### Aşama 2: Konsept Oluşturma

Yaratıcı brifı temel olarak kullanarak, her biri farklı bir yaratıcı yön alan 3 ayrı konsept oluştur. Bu ideasyonu tekniklerini kullan:

**Teknik 1: Fiil-Önce Tasarım**
Temel oyuncu fiilinden (inşa et, savaş, keşfet, çöz, hayatta kal, yarat, yönet, keşfet) başla ve oradan çıkarak inşa et. Fiil OYUNDUR.

**Teknik 2: Mashup Yöntemi**
İki beklenmedik öğeyi birleştir: [Tür A] + [Tema B]. İki arasındaki gerilim eşsiz hookunu yaratır. (örn. çiftçilik simülasyonu + kozmik korku, roguelike + dating simülasyonu, şehir inşaatçısı + gerçek zamanlı savaş)

**Teknik 3: Deneyim-Önce Tasarım (MDA Geriye)**
İstenen oyuncu duygusundan başla (MDA çerçevesinden estetik hedef: duyum, fantezi, anlatı, meydan okuma, arkadaşlık, keşif, ifade, teslim) ve bunu üretecek dinamikleri ve mekanikleri işin sonuna çalış.

Her konsept için, sunun:
- Çalışma Başlığı
- Asansör Adımı (1-2 cümle - "10 saniye testini" geçmesi gerekir)
- Temel Fiil (en yaygın oyuncu eylemi)
- Temel Fantezi (duygusal söz)
- Benzersiz Hook ("ve ayrıca" testini geçer: X Gibi, VE AYRICA Y)
- Birincil MDA Estetik (hangi duygu baskındır?)
- Tahmini Kapsam (küçük / orta / büyük)
- Neden İşe Yarayabilir (pazarda/kitlede 1 cümle uyum)
- En Büyük Risk (en zor cevapsız soru hakkında 1 cümle)

Üçünü de sunun. Kullanıcıdan bir seçim, öğeleri birleştirmeyi veya yeni konseptleri isteyin. Seçime karşı asla baskı yapmayın - bununla oturt.

---

### Aşama 3: Çekirdek Döngü Tasarımı

Seçilen konsept için, yapılandırılmış sorgulamayı kullanarak çekirdek döngüyü inşa et. Çekirdek döngü oyunun atması gereken kalp - eğer izole halde eğlenceli değilse, hiçbir içerik veya cilam oyunu kurtaramaz.

**30 Saniyelik Döngü** (an-an):
- Oyuncu fiziksel olarak en sık ne yapıyor?
- Bu eylem doğal olarak tatmin edici mi? (Hiçbir ödül, ilerleme, hikaye olmadan yaparlarmı - sadece hissi için mi?)
- Bu eylemi iyi ne yapıyor? (Ses geri bildirimi, görsel enerji, zamanlamada tatmin, taktik derinlik?)

**5 Dakikalık Döngü** (kısa vadeli hedefler):
- Hangi şey an-an oyunu döngülere yapılandırıyor?
- "Bir tur daha" / "Bir oyuncu daha" psikolojisi nereye tekme vuruyor?
- Oyuncu bu seviyede hangi seçimleri yapıyor?

**Oturum Döngüsü** (30-120 dakika):
- Tam bir oturum neye benziyor?
- Doğal durdurma noktaları nerede?
- Oynarken olmadığında oyunu düşündüren "hook" nedir?

**İlerleme Döngüsü** (günler/haftalar):
- Oyuncu nasıl büyüyor? (Güç? Bilgi? Seçenekler? Hikaye?)
- Uzun vadeli hedef nedir? Oyun ne zaman "yapılır"?

**Oyuncu Motivasyonu Analizi** (Öz-Belirleme Teorisine dayalı):
- Özerklik: Oyuncunun ne kadar anlamlı seçimi var?
- Yeterlik: Oyuncu yeteneklerinin büyüdüğünü nasıl hissediyor?
- İlişkililik: Oyuncu nasıl bağlandığını hissediyor (karakterlere, diğer oyunculara veya dünyaya)?

---

### Aşama 4: Direkler ve Sınırlar

Oyun direkler gerçek AAA stüdyolar (God of War, Hades, The Last of Us) tarafından yüzlerce takım üyesini aynı yöne işaret eden kararlar vermek için tutulur. Hatta Tek geliştiriciler için bile, direkleri kapsam kaymasını önlenir ve vizyonu keskinleştirir.

İşbirlikçi olarak 3-5 direk tanımla:
- Her direğin bir adı ve tek cümlelik tanımı var
- Her direğin bir tasarım testi var: X ve Y arasında tartışıyorsak, bu direk bize __ seçmemizi söyler
- Direktek, birbirleriyle gerilim yaratabilecek şekilde hissetmelidir - eğer tüm direkler aynı yöne işaret ediyorsa yeterince iş yapılmıyor

Ardından 3+ anti-direk tanımla (bu oyun DEĞİL):
- Anti-direktek, en yaygın kapsam kaymağını önler: "öyle olmasa iyiydi mi..." özellikleri temel vizyona hizmet etmez
- Çerçeve: Biz [şey] yapmayacağız çünkü [direk] tehlikeye atardı

---

### Aşama 5: Oyuncu Tipi Doğrulaması

Bartle taksonomi ve Quantic Foundry motivasyon modelini kullanarak, bu oyunun aslında kimin olduğunu doğrula:

- Birincil oyuncu tipi: Bu oyunu KIM SEVECEKTİR? (Başarı Arayıcıları, Kaşifler, Sosyalciler, Rekabetçiler, Yaratıcılar, Hikaye Anlatıcıları)
- İkincil çekicilik: Başka kim bunu beğenebilir?
- Bu DEĞIL kimin için: Bu oyunu kimin sevmeyeceğini bilmek olduğu kadar önemlidir kim sevecek bilmek
- Pazar doğrulaması: Benzer bir oyuncu tipine hizmet eden başarılı oyunlar var mı? Onların kitlesi boyutu hakkında neler öğrenebiliriz?

---

### Aşama 6: Kapsam ve Uygulanabilirlik

Konsepti gerçeğe temel al:

- Motor önerisi (Godot / Unity / Unreal) konsept ihtiyaçlarına dayalı akıl yürütme ile, takım uzmanlığı ve platform hedefleri
- Sanat işlem hattı: Sanat stili nedir ve ne kadar emek yoğun?
- İçerik kapsamı: Seviye/alan sayısı, öğe sayısı, oynanış saati tahmin et
- MVP tanımı: "Çekirdek döngü eğlencelikmi?" testini yapan mutlak minimum derleme nedir?
- En büyük riskler: Teknik riskler, tasarım riskleri, pazar riskleri
- Kapsam katmanları: Tam vizyon nedir vs. zaman bitmişse gönder?

---

4. **Oyun konsepti belgesini oluştur** .claude/docs/templates/game-concept.md adresindeki şablonu kullanarak. Beyin fırtınası konuşmasından tüm bölümleri doldur, MDA analizi, oyuncu motivasyonu profili ve akış durumu tasarım bölümleri dahil.

5. **Kaydet** design/gdd/game-concept.md, gerektiğinde dizinler oluştur.

6. **Sonraki adımları öner** (bu sırada - bu profesyonel stüdyo ön-üretim işlem hattıdır):
   - Motor'u yapılandırmak için /setup-engine [motor] [sürüm] çalıştır ve sürüm farkında referans dokümanları doldur
   - Bütünlüğü doğrulamak için /design-review design/gdd/game-concept.md kullan
   - Vizyon hakkında creative-director agentle tartış direk rafinasyon için
   - Konsepti /map-systems ile bireysel sistemlere ayrıştır — bağımlılıkları eşle, öncelikleri ata ve sistem dizini oluştur
   - System GDD'leri /design-system ile yaz — rehberli, bölüm-bölüm GDD yazması
   - Çekirdek döngüyü /prototype [çekirdek-mekanik] ile prototipyle
   - Prototip /playtest-report ile test et hipotezi doğrula
   - Doğrulandıysa, ilk sprint'i /sprint-plan new ile planla

7. **Özet çıkar** seçilen konseptin asansör adımı, direktek ile, birincil oyuncu tipi, motor önerisi, en büyük risk ve dosya yolu.
