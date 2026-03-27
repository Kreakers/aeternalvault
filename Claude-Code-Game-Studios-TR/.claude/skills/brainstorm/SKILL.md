---
name: brainstorm
description: "Rehberli oyun konsepti ideation — sıfırdan fikirlere yapılandırılmış oyun konsept belgesine. Profesyonel stüdyo ideation teknikleri, oyuncu psikolojisi çerçeveleri ve yapılandırılmış yaratıcı araştırma kullanır."
argument-hint: "[genre or theme hint, or 'open' for fully open brainstorm]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, WebSearch, AskUserQuestion
---

Bu skill çağrıldığında:

1. **Argümanı ayrıştırın** isteğe bağlı bir tür/tema ipucu için (örn. `roguelike`,
   `uzay hayatta kalma`, `rahat çiftlik`). `open` veya argüman yoksa,
   sıfırdan başlayın.

2. **Mevcut konsept çalışmasını kontrol edin**:
   - `design/gdd/game-concept.md` varsa okuyun (özgeçmişi yeniden başlamayın)
   - `design/gdd/game-pillars.md` varsa okuyun (kurulan ayaklarda inşa edin)

3. **Ideation aşamalarını etkileşimli olarak çalıştırın**, her aşamada kullanıcı sorularını sorun.
   **HER ŞEYİ sessizce üretmeyin** — amaç, AI'ın yaratıcı kolaylaştırıcı olarak davrandığı
   **işbirlikçi keşif**, insan vizyonunun değiştirilmesi değildir.

   **Her aşamada AskUserQuestion kullanın**:
   - Kısıtlı beğeni soruları (tür tercihleri, kapsam, ekip boyutu)
   - Konsept seçimi ("Hangi 2-3 konsept rezonans kuruyor?") seçenekler sunulduktan sonra
   - Yön seçimleri ("Daha geliştirir, daha çok keşfetsem mi, yoksa prototip mi?")
   - Kavramlar rafine edildikten sonra ayak sıralaması
   Önce konuşmada tam yaratıcı analiz yazın, ardından
   `AskUserQuestion` ile kararlı kısaltılmış etiketlerle yakalayın.

   Takip edilecek profesyonel stüdyo beyin fırtınası ilkeleri:
   - Yargıyı erteleyip — keşif sırasında kötü fikir yok
   - Olağandışı fikirleri teşvik edin — kutu dışı düşünme daha iyi konseptleri ateşler
   - Birbirinin üzerine inşa edin — "evet, ve..." yanıtları, "ancak..." değil
   - Kısıtlamaları yaratıcı yakıt olarak kullanın — sınırlamalar genellikle en iyi fikirleri üretir
   - Her aşamayı zaman kutusu — momentum koru, erken fazlasıyla düşünme yapma

---

### Aşama 1: Yaratıcı Keşif

Oyun değil, kişiyi anlayarak başlayın. Bu soruları konuşmacı olarak sorun (kontrol listesi değil):

**Duygusal çapalar**:
- Oyunda sizi gerçekten etkilemiş, heyecanlandırmış veya zamanı kaybettiren bir an nedir? Bu duyguyu özellikle neyin oluşturması?
- Oyunda hiç bulamadığınız bir fantezi veya güç tripleri var mı?

**Beğeni profili**:
- En çok zaman harcadığınız 3 oyun nelerdir? Sizi geri getiren neydi?
- Sevdiğiniz türler var mı? Kaçındığınız türler var mı? Neden?
- Oyunları sever misiniz sizi zorlasın, rahatlatı, hikaye anlatsın,
  yoksa kendinizi ifade ettirecek misiniz?

**Pratik kısıtlamalar** (brainstorm öncesinde sandbox şeklendirin):
- Tek geliştirici mi yoksa ekip mi? Hangi beceriler mevcut?
- Zaman çizelgesi: haftalar, aylar veya yıllar?
- Herhangi bir platform kısıtlaması var mı? (Sadece PC? Mobil? Konsol?)
- İlk oyun mu yoksa deneyimli geliştirici mi?

**Sentezleyin** yanıtları bir **Yaratıcı Özete** — kişinin duygusal hedeflerini,
beğeni profilini ve kısıtlamalarını özetleyen 3-5 cümle.
Özeti geri okuyun ve niyetlerini yakalaması için onaylayın.

---

### Aşama 2: Konsept Üretimi

Yaratıcı özeti temel olarak kullanarak, **3 farklı konsept** oluşturun
her biri farklı bir yaratıcı yöne gider. Bu ideation teknikleri kullanın:

**Teknik 1: Fiil-İlk Tasarım**
Çekirdek oyuncu fiilinden (inşa et, savaş, keşfet, çöz, hayatta kal,
oluştur, yönet, keşfet) başlayın ve buradan dışarıya çıkın. Fiil OYUN'dur.

**Teknik 2: Mashup Yöntemi**
İki beklenmedik unsuru birleştirin: [Tür A] + [Tema B]. İkisi arasındaki gerilim
eşsiz kancayı oluşturur. (örn. "çiftlik simülasyonu + kozmik korku",
"roguelike + dating simülasyonu", "şehir yapıcısı + gerçek zamanlı savaş")

**Teknik 3: Deneyim-İlk Tasarım (MDA Geriye Doğru)**
İstenen oyuncu duygusundan başlayın (MDA çerçevesinden estetik hedef:
duyum, fantezi, anlatı, meydan okuma, ortaklık, keşif, ifade,
teslim olma) ve bunu üretecek dinamikleri ve mekanikeri geriye çalışın.

Her konsept için sunun:
- **Çalışma Başlığı**
- **Asansör Tonu** (1-2 cümle — "10 saniye testini" geçmeli)
- **Çekirdek Fiili** (en sık oyuncu eylemi)
- **Çekirdek Fantezi** (duygusal söz)
- **Eşsiz Kanca** ("X gibi, VE AYRICA Y" testini geçer)
- **Birincil MDA Estetik** (hangi duygu egemen?)
- **Tahmini Kapsam** (küçük / orta / büyük)
- **Neden İşe Yarayabilir** (pazar/dinleyici uygunluğu hakkında 1 cümle)
- **En Büyük Risk** (en zor yanıtlanmamış soru hakkında 1 cümle)

Üç tanesini sunun. Kullanıcıdan bir tanesini seçmesini, öğeleri birleştirmesini veya
yeni konseptler talep etmesini isteyin. Asla seçime doğru zorlama yapma — bununla oturt.

---

### Aşama 3: Çekirdek Döngü Tasarımı

Seçilen konsept için, çekirdek döngüsünü inşa etmek için yapılandırılmış sorgulamayı kullanın.
Çekirdek döngü oyunun atardamarıdır — eğer
yalnız başına eğlenceli değilse, başka hiçbir içerik veya cilalaşma oyunu kurtaramaz.

**30 Saniyelik Döngü** (an-dan-ana):
- Oyuncu en çok ne yapıyor?
- Bu eylem içsel olarak tatmin edici mi? (Hiçbir
  ödül, ilerleme, hikaye olmadan — sadece hissi için yaparlarmı?)
- Bu eylemi neyin iyi hissettirdiği? (Ses geri bildirimi, görsel efektler,
  zamanlama tatmini, taktik derinliği?)

**5 Dakikalık Döngü** (kısa vadeli hedefler):
- Anı-dan-ana oyunu döngülere ne yapılandırıyor?
- "Bir tur daha" / "Bir koşu daha" psikolojisi nerede başlıyor?
- Oyuncu bu seviyede hangi seçimleri yapıyor?

**Oturum Döngüsü** (30-120 dakika):
- Tam bir oturum nasıl görünüyor?
- Doğal durma noktaları nerede?
- Oynanmadığını düşünürken onları düşünmelerine neden olan "kanca" nedir?

**İlerleme Döngüsü** (gün/hafta):
- Oyuncu nasıl büyüyor? (Güç? Bilgi? Seçenekler? Hikaye?)
- Uzun vadeli hedef nedir? Oyun ne zaman "bitti"?

**Oyuncu Motivasyonu Analizi** (Kendi Belirleme Teorisine dayalı):
- **Özerklik**: Oyuncunun ne kadar anlamlı seçime sahip olması?
- **Yeterlilik**: Oyuncu kendi becerilerinin büyümesini nasıl hissediyor?
- **İlişkililik**: Oyuncu kendini nasıl bağlı hissediyor (karakterlere,
  diğer oyunculara veya dünyaya)?

---

### Aşama 4: Ayaklar ve Sınırlar

Oyun ayakları gerçek AAA stüdyolar tarafından kullanılır (God of War, Hades, The Last of
Us) yüzlerce ekip üyesini aynı yöne işaret eden kararlar almaya tutmak için. Tek geliştirici için bile,
ayaklar kapsam tırmanışını önler ve vizyonu keskin tutar.

İşbirlikçi bir şekilde **3-5 ayak** tanımlayın:
- Her ayak bir **ad** ve **tek cümle tanımına** sahiptir
- Her ayak **tasarım testine** sahiptir: "X ve Y arasında tartışıyorsak,
  bu ayak bize __ seçmesini söyler"
- Ayaklar birbirleriyle gerilim oluşturuyor gibi hissetmelidir — eğer tüm
  ayaklar aynı yöne işaret ederse, yeterince çalışmıyor

Ardından **3+ karşı-ayak** (bu oyun DEĞİLDİR) tanımlayın:
- Karşı-ayaklar en yaygın kapsam tırmanışını önler: "şunlar yapmasak fena olmaz..." öğeleri
  temel vizyona hizmet etmez
- Şu şekilde çerçeveleyin: "X yapmayacağız çünkü [ayak] ile uzlaştırmak için"

---

### Aşama 5: Oyuncu Tipi Doğrulaması

Bartle taksonomisi ve Quantic Foundry motivasyon modeli kullanarak,
bu oyunun aslında kimler için olduğunu doğrulayın:

- **Birincil oyuncu tipi**: Kimler bu oyunu SEVECEK? (Başaranlar, Kaşifler,
  Sosyalleştiriciler, Rakipler, Yaratıcılar, Hikayeciler)
- **İkincil çekicilik**: Kim daha yaşayabilir?
- **Bu OLMAYAN kimler**: Bu oyunu kimlerin sevmeyeceğini bilmek kadar
  önemli sevenleri bilmek
- **Pazar doğrulaması**: Benzer oyuncu tipine hizmet eden başarılı oyunlar var mı? Onların
  dinleyici boyutundan ne öğrenebiliriz?

---

### Aşama 6: Kapsam ve Uygulanabilirlik

Konsepti gerçekliğe yerleştirin:

- **Motor tavsiyesi** (Godot / Unity / Unreal) kavram ihtiyaçları, ekip uzmanlığı ve
  platform hedeflerine dayalı mantık ile
- **Sanat boru hattı**: Sanat stili nedir ve işgücü yoğun midir?
- **İçerik kapsamı**: Seviye/alan sayısını, öğe sayısını, oynanabilir saat sayısını tahmin edin
- **MVP tanımı**: Çekirdek döngünün "eğlenceli midir?" testini yapan mutlak minimum nedir?
- **En büyük riskler**: Teknik riskler, tasarım riskleri, pazar riskleri
- **Kapsam seviyeleri**: Tam vizyon vs. zaman biterse gemi ne alır?

---

4. **Şablonu kullanarak oyun konsept belgesini oluşturun**
   `.claude/docs/templates/game-concept.md`. Brainstorm konuşmasından TÜM bölümleri doldurun,
   MDA analizi, oyuncu motivasyon
   profili ve akış durumu tasarım bölümleri de dahil.

5. **Kaydet** `design/gdd/game-concept.md`, gerekirse dizinler oluştur.

6. **Sonraki adımları öner** (bu sırayla — bu profesyonel stüdyo
   ön üretim boru hattı):
   - "Motor ve popülasyonu yapılandırmak için `/setup-engine [engine] [version]` çalıştırın sürüm bilgisi referans doçları"
   - "Eksiksizliği doğrulamak için `/design-review design/gdd/game-concept.md` kullanın"
   - "Ayak arınlaması için konsepti `creative-director` ajanı ile tartışın"
   - "Sistemi `/map-systems` ile ayrı sistemlere ayrıştırın — bağımlılıkları haritalar, öncelikleri atar ve sistem indexi oluşturur"
   - "Her sistem GDD'i `/design-system` ile yazın — rehberli, bölüm-bölüm GDD yazma"
   - "Çekirdek döngüsünü `/prototype [core-mechanic]` ile prototipile"
   - "Prototopi `/playtest-report` ile playtestleyin hipotezi doğrulamak için"
   - "Doğrulandıysa, ilk sprintle `/sprint-plan new` planlayın"

7. **Özet çıkartın** seçilen konseptin asansör tonu, ayakları,
   birincil oyuncu tipi, motor tavsiyesi, en büyük risk ve dosya yolu ile.
