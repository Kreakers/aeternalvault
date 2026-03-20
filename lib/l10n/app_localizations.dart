import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_it.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('tr'),
    Locale('en'),
    Locale('de'),
    Locale('it'),
  ];

  /// Uygulama başlığı
  ///
  /// In tr, this message translates to:
  /// **'Aeterna Vault'**
  String get appTitle;

  /// Uygulama alt başlığı
  ///
  /// In tr, this message translates to:
  /// **'Güvenli CRM & Kasa'**
  String get appSubtitle;

  /// Kişiler menü öğesi
  ///
  /// In tr, this message translates to:
  /// **'Kişiler'**
  String get contacts;

  /// Dijital kasa başlığı
  ///
  /// In tr, this message translates to:
  /// **'Dijital Kasa'**
  String get digitalVault;

  /// Kasa aktivasyon butonu
  ///
  /// In tr, this message translates to:
  /// **'Kasayı Aktif Et'**
  String get activateVault;

  /// Güvenlik ayarları menü öğesi
  ///
  /// In tr, this message translates to:
  /// **'Güvenlik Ayarları'**
  String get securitySettings;

  /// Genel ayarlar menü öğesi
  ///
  /// In tr, this message translates to:
  /// **'Genel Ayarlar'**
  String get generalSettings;

  /// Hakkında menü öğesi
  ///
  /// In tr, this message translates to:
  /// **'Hakkında'**
  String get about;

  /// Dashboard genel bakış başlığı
  ///
  /// In tr, this message translates to:
  /// **'GENEL BAKIŞ'**
  String get overview;

  /// Kişi sayısı
  ///
  /// In tr, this message translates to:
  /// **'{count} kişi'**
  String personsCount(int count);

  /// Kasa öğesi sayısı
  ///
  /// In tr, this message translates to:
  /// **'{count} kasa'**
  String vaultCount(int count);

  /// Toplam kişi sayısı etiketi
  ///
  /// In tr, this message translates to:
  /// **'{count} Kişi'**
  String totalContacts(int count);

  /// Toplam rehber alt metni
  ///
  /// In tr, this message translates to:
  /// **'Toplam rehber'**
  String get totalContactsSub;

  /// Kasa öğesi sayısı
  ///
  /// In tr, this message translates to:
  /// **'{count} Kasa Öğesi'**
  String vaultItems(int count);

  /// Şifreli kayıt alt metni
  ///
  /// In tr, this message translates to:
  /// **'Şifreli kayıt'**
  String get encryptedRecord;

  /// Boş durum mesajı
  ///
  /// In tr, this message translates to:
  /// **'Kişi bulunamadı.'**
  String get contactNotFound;

  /// Kasa kilidi dialog başlığı
  ///
  /// In tr, this message translates to:
  /// **'Kasa Kilidi'**
  String get vaultLock;

  /// Master key placeholder
  ///
  /// In tr, this message translates to:
  /// **'Master Key'**
  String get masterKey;

  /// İptal butonu
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get cancel;

  /// Giriş butonu
  ///
  /// In tr, this message translates to:
  /// **'Giriş'**
  String get login;

  /// Kasa açma hata mesajı
  ///
  /// In tr, this message translates to:
  /// **'Kasa kilidi açılamadı!'**
  String get vaultUnlockFailed;

  /// Arama alanı placeholder
  ///
  /// In tr, this message translates to:
  /// **'İsim veya telefon ara...'**
  String get searchHint;

  /// Doğum günü uyarısı
  ///
  /// In tr, this message translates to:
  /// **'Bugün {name}\'ın doğum günü! 🎂'**
  String birthdayAlert(String name);

  /// Görüşme zamanı uyarısı
  ///
  /// In tr, this message translates to:
  /// **'{name} ile görüşme zamanı gelmiş. 📞'**
  String meetingAlert(String name);

  /// Vault ekranı başlığı
  ///
  /// In tr, this message translates to:
  /// **'Dijital Kasa'**
  String get vaultScreenTitle;

  /// Şifreli kayıt sayısı
  ///
  /// In tr, this message translates to:
  /// **'{count} şifreli kayıt'**
  String encryptedRecordsCount(int count);

  /// Korumalı badge metni
  ///
  /// In tr, this message translates to:
  /// **'Korumalı'**
  String get protected;

  /// Gizli kişiler tab başlığı
  ///
  /// In tr, this message translates to:
  /// **'Gizli Kişiler'**
  String get hiddenContacts;

  /// Belgeler ve şifreler tab başlığı
  ///
  /// In tr, this message translates to:
  /// **'Belgeler & Şifreler'**
  String get documentsPasswords;

  /// Gizli kişi yok mesajı
  ///
  /// In tr, this message translates to:
  /// **'Gizli kişi yok'**
  String get noHiddenContacts;

  /// Ekleme yönergesi
  ///
  /// In tr, this message translates to:
  /// **'Eklemek için + butonuna bas'**
  String get addWithPlusButton;

  /// Kasa boş mesajı
  ///
  /// In tr, this message translates to:
  /// **'Kasa boş'**
  String get vaultEmpty;

  /// Tüm filtresi
  ///
  /// In tr, this message translates to:
  /// **'Tümü'**
  String get filterAll;

  /// Şifreler filtresi
  ///
  /// In tr, this message translates to:
  /// **'Şifreler'**
  String get filterPasswords;

  /// Banka filtresi
  ///
  /// In tr, this message translates to:
  /// **'Banka'**
  String get filterBank;

  /// Belgeler filtresi
  ///
  /// In tr, this message translates to:
  /// **'Belgeler'**
  String get filterDocuments;

  /// Dosya bulunamadı hata mesajı
  ///
  /// In tr, this message translates to:
  /// **'Dosya bulunamadı!'**
  String get fileNotFound;

  /// Dosya açılamadı hata mesajı
  ///
  /// In tr, this message translates to:
  /// **'Dosya açılamadı.'**
  String get fileOpenError;

  /// Dosyayı aç butonu
  ///
  /// In tr, this message translates to:
  /// **'Dosyayı Aç'**
  String get openFile;

  /// Kasa öğesi ekleme başlığı
  ///
  /// In tr, this message translates to:
  /// **'Kasa Öğesi Ekle'**
  String get addVaultItem;

  /// Kasa öğesi düzenleme başlığı
  ///
  /// In tr, this message translates to:
  /// **'Öğeyi Düzenle'**
  String get editVaultItem;

  /// Başlık placeholder
  ///
  /// In tr, this message translates to:
  /// **'Başlık (Örn: MetaMask Cüzdanım)'**
  String get titleHint;

  /// Zorunlu alan mesajı
  ///
  /// In tr, this message translates to:
  /// **'Gerekli'**
  String get required;

  /// Kategori etiketi
  ///
  /// In tr, this message translates to:
  /// **'Kategori'**
  String get category;

  /// Gizli veriler bölüm başlığı
  ///
  /// In tr, this message translates to:
  /// **'Gizli Veriler'**
  String get secretData;

  /// Şifre üret butonu
  ///
  /// In tr, this message translates to:
  /// **'Şifre Üret'**
  String get generatePassword;

  /// Şifre oluşturuldu snackbar mesajı
  ///
  /// In tr, this message translates to:
  /// **'Güçlü şifre oluşturuldu!'**
  String get passwordGenerated;

  /// Dosya ek bölüm başlığı
  ///
  /// In tr, this message translates to:
  /// **'Dosya / Ek (PDF, Görsel vb.)'**
  String get fileAttachment;

  /// Ek notlar etiketi
  ///
  /// In tr, this message translates to:
  /// **'Ek Notlar'**
  String get additionalNotes;

  /// Şifreli kaydet butonu
  ///
  /// In tr, this message translates to:
  /// **'ŞİFRELİ OLARAK KAYDET'**
  String get saveEncrypted;

  /// Dosya seç metni
  ///
  /// In tr, this message translates to:
  /// **'Dosya Seç (PDF, Resim vb.)'**
  String get selectFile;

  /// Dosya hazır metni
  ///
  /// In tr, this message translates to:
  /// **'Dosya Hazır'**
  String get fileReady;

  /// Dosya seçilemedi hata mesajı
  ///
  /// In tr, this message translates to:
  /// **'Dosya seçilemedi.'**
  String get filePickError;

  /// Kayıt hatası mesajı
  ///
  /// In tr, this message translates to:
  /// **'Kayıt hatası: {error}'**
  String saveError(String error);

  /// Şifre çözme hatası mesajı
  ///
  /// In tr, this message translates to:
  /// **'Bu kayıt okunamadı. Muhtemelen farklı bir master key ile şifrelendi. Alanları yeniden doldurup kaydedebilirsin.'**
  String get decryptionError;

  /// Kullanıcı adı / e-posta etiketi
  ///
  /// In tr, this message translates to:
  /// **'Kullanıcı Adı / E-posta'**
  String get usernameEmail;

  /// Şifre etiketi
  ///
  /// In tr, this message translates to:
  /// **'Şifre'**
  String get password;

  /// Web sitesi URL etiketi
  ///
  /// In tr, this message translates to:
  /// **'Web Sitesi URL'**
  String get websiteUrl;

  /// Cüzdan adresi etiketi
  ///
  /// In tr, this message translates to:
  /// **'Cüzdan Adresi (Public Key)'**
  String get walletAddress;

  /// Seed phrase etiketi
  ///
  /// In tr, this message translates to:
  /// **'Seed Phrase (12/24 Kelime)'**
  String get seedPhrase;

  /// Ağ etiketi
  ///
  /// In tr, this message translates to:
  /// **'Ağ (Örn: Ethereum, BTC)'**
  String get network;

  /// IBAN etiketi
  ///
  /// In tr, this message translates to:
  /// **'IBAN / Hesap No'**
  String get ibanAccount;

  /// Banka adı etiketi
  ///
  /// In tr, this message translates to:
  /// **'Banka Adı'**
  String get bankName;

  /// Şube bilgisi etiketi
  ///
  /// In tr, this message translates to:
  /// **'Şube / Ek Bilgi'**
  String get branchInfo;

  /// Seri no etiketi
  ///
  /// In tr, this message translates to:
  /// **'Seri No / Kimlik No'**
  String get serialId;

  /// Belge türü etiketi
  ///
  /// In tr, this message translates to:
  /// **'Belge Türü (Örn: Pasaport)'**
  String get documentType;

  /// Son kullanma tarihi etiketi
  ///
  /// In tr, this message translates to:
  /// **'Son Kullanma Tarihi'**
  String get expiryDate;

  /// Not içeriği etiketi
  ///
  /// In tr, this message translates to:
  /// **'Not İçeriği'**
  String get noteContent;

  /// Şifre kategorisi
  ///
  /// In tr, this message translates to:
  /// **'Şifre'**
  String get categoryPassword;

  /// Banka kategorisi
  ///
  /// In tr, this message translates to:
  /// **'Banka'**
  String get categoryBank;

  /// Belge kategorisi
  ///
  /// In tr, this message translates to:
  /// **'Belge'**
  String get categoryDocument;

  /// Kripto cüzdanı kategorisi
  ///
  /// In tr, this message translates to:
  /// **'Kripto Cüzdanı'**
  String get categoryCrypto;

  /// Gizli not kategorisi
  ///
  /// In tr, this message translates to:
  /// **'Gizli Not'**
  String get categorySecretNote;

  /// Kişi detayı başlığı
  ///
  /// In tr, this message translates to:
  /// **'Kişi Detayı'**
  String get contactDetail;

  /// İletişim bilgileri bölüm başlığı
  ///
  /// In tr, this message translates to:
  /// **'İletişim Bilgileri'**
  String get contactInfo;

  /// Telefon etiketi
  ///
  /// In tr, this message translates to:
  /// **'Telefon'**
  String get phone;

  /// E-posta etiketi
  ///
  /// In tr, this message translates to:
  /// **'E-posta'**
  String get email;

  /// Doğum günü etiketi
  ///
  /// In tr, this message translates to:
  /// **'Doğum Günü'**
  String get birthday;

  /// Son temas etiketi
  ///
  /// In tr, this message translates to:
  /// **'Son Temas'**
  String get lastContact;

  /// Görüşme sıklığı etiketi
  ///
  /// In tr, this message translates to:
  /// **'Görüşme Sıklığı'**
  String get contactFrequency;

  /// Her N günde bir
  ///
  /// In tr, this message translates to:
  /// **'Her {count} günde bir'**
  String everyNDays(int count);

  /// Hatırlatıcılar bölüm başlığı
  ///
  /// In tr, this message translates to:
  /// **'Hatırlatıcılar'**
  String get reminders;

  /// Bekleyen görev yok mesajı
  ///
  /// In tr, this message translates to:
  /// **'Bekleyen görev yok.'**
  String get noPendingTasks;

  /// Aktivite günlüğü bölüm başlığı
  ///
  /// In tr, this message translates to:
  /// **'Aktivite Günlüğü'**
  String get activityLog;

  /// Yeni görev dialog başlığı
  ///
  /// In tr, this message translates to:
  /// **'Yeni Görev / Hatırlatıcı'**
  String get newTask;

  /// Görev adı etiketi
  ///
  /// In tr, this message translates to:
  /// **'Görev Adı'**
  String get taskName;

  /// Ekle butonu
  ///
  /// In tr, this message translates to:
  /// **'Ekle'**
  String get add;

  /// Görüşme zamanı geçmiş mesajı
  ///
  /// In tr, this message translates to:
  /// **'Görüşme Zamanı Geçmiş!'**
  String get trackingLate;

  /// Takip durumu iyi mesajı
  ///
  /// In tr, this message translates to:
  /// **'Takip Durumu İyi'**
  String get trackingGood;

  /// Son görüşmeden bu yana geçen gün
  ///
  /// In tr, this message translates to:
  /// **'Son görüşme üzerinden {days} gün geçti.'**
  String daysSinceLastContact(int days);

  /// Ara butonu
  ///
  /// In tr, this message translates to:
  /// **'Ara'**
  String get call;

  /// Yaz butonu
  ///
  /// In tr, this message translates to:
  /// **'Yaz'**
  String get write;

  /// SMS butonu
  ///
  /// In tr, this message translates to:
  /// **'SMS'**
  String get sms;

  /// Kişi paylaşım metni
  ///
  /// In tr, this message translates to:
  /// **'Kişi Paylaşımı:\nAd Soyad: {name}\nTelefon: {phone}\nE-posta: {email}\n\nAeterna Vault üzerinden paylaşıldı.'**
  String shareContact(String name, String phone, String email);

  /// Yeni kişi ekleme başlığı
  ///
  /// In tr, this message translates to:
  /// **'Yeni Kişi Ekle'**
  String get addContactTitle;

  /// Gizli kişi ekleme başlığı
  ///
  /// In tr, this message translates to:
  /// **'Gizli Kişi Ekle'**
  String get addPrivateContactTitle;

  /// Kişi düzenleme başlığı
  ///
  /// In tr, this message translates to:
  /// **'Kişiyi Düzenle'**
  String get editContactTitle;

  /// Temel bilgiler bölüm başlığı
  ///
  /// In tr, this message translates to:
  /// **'Temel Bilgiler'**
  String get basicInfo;

  /// Ad etiketi
  ///
  /// In tr, this message translates to:
  /// **'Ad'**
  String get firstName;

  /// Soyad etiketi
  ///
  /// In tr, this message translates to:
  /// **'Soyad'**
  String get lastName;

  /// Sosyal medya etiketi
  ///
  /// In tr, this message translates to:
  /// **'Sosyal Medya Linki'**
  String get socialMedia;

  /// Profesyonel ve lokasyon bölüm başlığı
  ///
  /// In tr, this message translates to:
  /// **'Profesyonel & Lokasyon'**
  String get professionalLocation;

  /// Şirket etiketi
  ///
  /// In tr, this message translates to:
  /// **'Şirket'**
  String get company;

  /// Unvan etiketi
  ///
  /// In tr, this message translates to:
  /// **'Unvan'**
  String get jobTitle;

  /// Adres etiketi
  ///
  /// In tr, this message translates to:
  /// **'Adres'**
  String get address;

  /// Önemli günler bölüm başlığı
  ///
  /// In tr, this message translates to:
  /// **'Önemli Günler'**
  String get importantDates;

  /// Yıldönümü etiketi
  ///
  /// In tr, this message translates to:
  /// **'Yıldönümü / Özel Gün'**
  String get anniversary;

  /// İlişki yönetimi bölüm başlığı
  ///
  /// In tr, this message translates to:
  /// **'İlişki Yönetimi'**
  String get relationshipManagement;

  /// Nereden tanışıyoruz etiketi
  ///
  /// In tr, this message translates to:
  /// **'Nereden Tanışıyoruz?'**
  String get howWeKnow;

  /// Etiketler etiketi
  ///
  /// In tr, this message translates to:
  /// **'Etiketler (#tag1 #tag2)'**
  String get tags;

  /// Gizli olarak kaydet etiketi
  ///
  /// In tr, this message translates to:
  /// **'Gizli Olarak Kaydet (Kasa)'**
  String get saveAsPrivate;

  /// Notlar etiketi
  ///
  /// In tr, this message translates to:
  /// **'Notlar'**
  String get notes;

  /// Kaydet butonu
  ///
  /// In tr, this message translates to:
  /// **'KAYDET'**
  String get save;

  /// Resim seçilemedi hata mesajı
  ///
  /// In tr, this message translates to:
  /// **'Resim seçilemedi.'**
  String get imagePickError;

  /// Güvenlik ayarları başlığı
  ///
  /// In tr, this message translates to:
  /// **'Güvenlik Ayarları'**
  String get securitySettingsTitle;

  /// Uygulama koruma ayarları alt metni
  ///
  /// In tr, this message translates to:
  /// **'Uygulama koruma ayarları'**
  String get appProtectionSettings;

  /// Güvenlik skoru
  ///
  /// In tr, this message translates to:
  /// **'Güvenlik Skoru: {score}/100'**
  String securityScore(int score);

  /// Çok güçlü güvenlik mesajı
  ///
  /// In tr, this message translates to:
  /// **'Çok güçlü — tüm korumalar aktif'**
  String get securityVeryStrong;

  /// Biyometriği etkinleştir mesajı
  ///
  /// In tr, this message translates to:
  /// **'Biyometriği etkinleştir'**
  String get enableBiometric;

  /// Şifre güvenliği bölüm başlığı
  ///
  /// In tr, this message translates to:
  /// **'Şifre Güvenliği'**
  String get passwordSecurity;

  /// Ana şifre başlığı
  ///
  /// In tr, this message translates to:
  /// **'Ana Şifre'**
  String get masterKeyTitle;

  /// Son değişiklik metni
  ///
  /// In tr, this message translates to:
  /// **'Son değişiklik: 45 gün önce'**
  String get lastChangedDaysAgo;

  /// Değiştir butonu
  ///
  /// In tr, this message translates to:
  /// **'Değiştir'**
  String get change;

  /// Şifre ipuçları başlığı
  ///
  /// In tr, this message translates to:
  /// **'Şifre İpuçları'**
  String get passwordHints;

  /// Giriş ekranında ipucu göster metni
  ///
  /// In tr, this message translates to:
  /// **'Giriş ekranında ipucu göster'**
  String get showHintOnLogin;

  /// Biyometrik kimlik bölüm başlığı
  ///
  /// In tr, this message translates to:
  /// **'Biyometrik Kimlik'**
  String get biometricId;

  /// Parmak izi başlığı
  ///
  /// In tr, this message translates to:
  /// **'Parmak İzi'**
  String get fingerprint;

  /// Parmak izi etkin mesajı
  ///
  /// In tr, this message translates to:
  /// **'Etkin — hızlı giriş açık'**
  String get fingerprintEnabled;

  /// Parmak izi devre dışı mesajı
  ///
  /// In tr, this message translates to:
  /// **'Devre dışı'**
  String get fingerprintDisabled;

  /// Aktif badge metni
  ///
  /// In tr, this message translates to:
  /// **'Aktif'**
  String get active;

  /// Otomatik kilit başlığı
  ///
  /// In tr, this message translates to:
  /// **'Otomatik Kilit'**
  String get autoLock;

  /// Otomatik kilit alt metni
  ///
  /// In tr, this message translates to:
  /// **'1 dakika hareketsizlikte kilitle'**
  String get autoLockSubtitle;

  /// Hesap güvenliği bölüm başlığı
  ///
  /// In tr, this message translates to:
  /// **'Hesap Güvenliği'**
  String get accountSecurity;

  /// Kurtarma kodu başlığı
  ///
  /// In tr, this message translates to:
  /// **'Kurtarma Kodu'**
  String get recoveryCode;

  /// Mevcut kurtarma kodu mesajı
  ///
  /// In tr, this message translates to:
  /// **'Mevcut bir kodunuz var.'**
  String get recoveryCodeExists;

  /// Kurtarma kodu ipucu
  ///
  /// In tr, this message translates to:
  /// **'12 kelimeli kurtarma anahtarı'**
  String get recoveryCodeHint;

  /// Yedekleme ve geri yükleme başlığı
  ///
  /// In tr, this message translates to:
  /// **'Yedekleme & Geri Yükleme'**
  String get backupRestore;

  /// Yedekle butonu
  ///
  /// In tr, this message translates to:
  /// **'Yedekle'**
  String get backup;

  /// Yedeklendi mesajı
  ///
  /// In tr, this message translates to:
  /// **'Yedeklendi ✓'**
  String get backupDone;

  /// Geri yükle butonu
  ///
  /// In tr, this message translates to:
  /// **'Geri Yükle'**
  String get restore;

  /// Tehlike bölgesi başlığı
  ///
  /// In tr, this message translates to:
  /// **'Tehlike Bölgesi'**
  String get dangerZone;

  /// Fabrika sıfırlama başlığı
  ///
  /// In tr, this message translates to:
  /// **'Fabrika Sıfırlama'**
  String get factoryReset;

  /// Tüm verileri sil alt metni
  ///
  /// In tr, this message translates to:
  /// **'Tüm verileri kalıcı olarak sil'**
  String get deleteAllPermanently;

  /// Fabrika sıfırlama yap butonu
  ///
  /// In tr, this message translates to:
  /// **'Fabrika Sıfırlama Yap'**
  String get doFactoryReset;

  /// Fabrika sıfırlama onay başlığı
  ///
  /// In tr, this message translates to:
  /// **'Fabrika Sıfırlama'**
  String get factoryResetConfirmTitle;

  /// Fabrika sıfırlama onay içeriği
  ///
  /// In tr, this message translates to:
  /// **'Tüm veriler kalıcı olarak silinecek. Bu işlem geri alınamaz!'**
  String get factoryResetConfirmContent;

  /// Onayla ve sil butonu
  ///
  /// In tr, this message translates to:
  /// **'ONAYLA VE SİL'**
  String get confirmAndDelete;

  /// Kurtarma kodu oluşturuldu dialog başlığı
  ///
  /// In tr, this message translates to:
  /// **'Kurtarma Kodu Oluşturuldu'**
  String get recoveryCodeGenerated;

  /// Güvenli not al metni
  ///
  /// In tr, this message translates to:
  /// **'Lütfen güvenli bir yere not edin:'**
  String get saveNote;

  /// Kaydet ve kapat butonu
  ///
  /// In tr, this message translates to:
  /// **'KAYDET VE KAPAT'**
  String get saveAndClose;

  /// Veri yedeği dialog başlığı
  ///
  /// In tr, this message translates to:
  /// **'Veri Yedeği (JSON)'**
  String get dataBackupTitle;

  /// Yedek kopyalama talimatı
  ///
  /// In tr, this message translates to:
  /// **'Aşağıdaki metni kopyalayıp güvenli bir yerde saklayın:'**
  String get backupInstructions;

  /// Kopyala ve kapat butonu
  ///
  /// In tr, this message translates to:
  /// **'KOPYALA VE KAPAT'**
  String get copyAndClose;

  /// Yedek kopyalandı snackbar mesajı
  ///
  /// In tr, this message translates to:
  /// **'Yedek panoya kopyalandı!'**
  String get backupCopied;

  /// Yedekten geri yükle dialog başlığı
  ///
  /// In tr, this message translates to:
  /// **'Yedekten Geri Yükle'**
  String get restoreFromBackup;

  /// Geri yükleme uyarısı
  ///
  /// In tr, this message translates to:
  /// **'Yedek metni yapıştırın. MEVCUT VERİLER SİLİNECEK!'**
  String get restoreWarning;

  /// Geri yükleme başarı mesajı
  ///
  /// In tr, this message translates to:
  /// **'Veriler başarıyla yüklendi!'**
  String get restoreSuccess;

  /// Geri yükleme hata mesajı
  ///
  /// In tr, this message translates to:
  /// **'Hata: Geçersiz format.'**
  String get restoreError;

  /// Şifre değiştir dialog başlığı
  ///
  /// In tr, this message translates to:
  /// **'Şifre Değiştir'**
  String get changePassword;

  /// Eski şifre etiketi
  ///
  /// In tr, this message translates to:
  /// **'Eski Şifre'**
  String get oldPassword;

  /// Yeni şifre etiketi
  ///
  /// In tr, this message translates to:
  /// **'Yeni Şifre (en az 8 karakter)'**
  String get newPassword;

  /// Güncelle butonu
  ///
  /// In tr, this message translates to:
  /// **'Güncelle'**
  String get update;

  /// Şifre güncellendi mesajı
  ///
  /// In tr, this message translates to:
  /// **'Şifre güncellendi.'**
  String get passwordUpdated;

  /// Eski şifre hatalı mesajı
  ///
  /// In tr, this message translates to:
  /// **'Eski şifre hatalı!'**
  String get oldPasswordWrong;

  /// Şifre gereksinimleri mesajı
  ///
  /// In tr, this message translates to:
  /// **'Şifre en az 8 karakter, harf ve rakam içermelidir.'**
  String get passwordRequirements;

  /// Genel ayarlar başlığı
  ///
  /// In tr, this message translates to:
  /// **'Genel Ayarlar'**
  String get generalSettingsTitle;

  /// Görünüm modu bölüm başlığı
  ///
  /// In tr, this message translates to:
  /// **'Görünüm Modu'**
  String get appearanceMode;

  /// Karanlık tema aktif metni
  ///
  /// In tr, this message translates to:
  /// **'Karanlık Tema Aktif'**
  String get darkModeActive;

  /// Aydınlık tema aktif metni
  ///
  /// In tr, this message translates to:
  /// **'Aydınlık Tema Aktif'**
  String get lightModeActive;

  /// Tema modu ipucu
  ///
  /// In tr, this message translates to:
  /// **'Göz yorgunluğunu azaltmak için mod değiştirin.'**
  String get themeModeTip;

  /// Uygulama renk başlığı
  ///
  /// In tr, this message translates to:
  /// **'Uygulama Kimliği (Renk)'**
  String get appIdentityColor;

  /// Renk otomatik uyarlama açıklaması
  ///
  /// In tr, this message translates to:
  /// **'Uygulamanın tüm tonları seçtiğiniz renge göre otomatik uyarlanır.'**
  String get colorAutoAdapt;

  /// Veri ve güvenlik bölüm başlığı
  ///
  /// In tr, this message translates to:
  /// **'Veri ve Güvenlik'**
  String get dataSecurity;

  /// Fabrika ayarlarına dön başlığı
  ///
  /// In tr, this message translates to:
  /// **'Fabrika Ayarlarına Dön'**
  String get factoryRestoreTitle;

  /// Fabrika ayarlarına dön alt metni
  ///
  /// In tr, this message translates to:
  /// **'Tüm rehber, kasa ve ayarları kalıcı olarak temizler.'**
  String get factoryRestoreSubtitle;

  /// Kalıcı silme onay başlığı
  ///
  /// In tr, this message translates to:
  /// **'Verileri Kalıcı Olarak Sil?'**
  String get permanentDeleteTitle;

  /// Kalıcı silme onay içeriği
  ///
  /// In tr, this message translates to:
  /// **'Bu işlem geri alınamaz. Kasanızdaki tüm gizli belgeler ve CRM kayıtlarınız yok olacaktır.'**
  String get permanentDeleteContent;

  /// İptal butonu (büyük harf)
  ///
  /// In tr, this message translates to:
  /// **'İPTAL'**
  String get cancelUpper;

  /// Sil ve sıfırla butonu
  ///
  /// In tr, this message translates to:
  /// **'SİL VE SIFIRLA'**
  String get deleteAndReset;

  /// Uygulama sıfırlama başarı mesajı
  ///
  /// In tr, this message translates to:
  /// **'Uygulama başarıyla sıfırlandı.'**
  String get appResetSuccess;

  /// Sürüm bilgisi
  ///
  /// In tr, this message translates to:
  /// **'Aeterna Vault v1.0.3'**
  String get versionInfo;

  /// Dil bölüm başlığı
  ///
  /// In tr, this message translates to:
  /// **'Dil'**
  String get language;

  /// Türkçe dil seçeneği
  ///
  /// In tr, this message translates to:
  /// **'Türkçe'**
  String get languageTurkish;

  /// İngilizce dil seçeneği
  ///
  /// In tr, this message translates to:
  /// **'İngilizce'**
  String get languageEnglish;

  /// Almanca dil seçeneği
  ///
  /// In tr, this message translates to:
  /// **'Almanca'**
  String get languageGerman;

  /// İtalyanca dil seçeneği
  ///
  /// In tr, this message translates to:
  /// **'İtalyanca'**
  String get languageItalian;

  /// Hakkında başlığı
  ///
  /// In tr, this message translates to:
  /// **'Hakkında'**
  String get aboutTitle;

  /// Sürüm metni
  ///
  /// In tr, this message translates to:
  /// **'Sürüm 1.0.3'**
  String get version;

  /// Veri güvenliği bölüm başlığı
  ///
  /// In tr, this message translates to:
  /// **'Veri Güvenliği'**
  String get dataSafetyTitle;

  /// Veri güvenliği içeriği
  ///
  /// In tr, this message translates to:
  /// **'Aeterna Vault, verilerinizi asla herhangi bir sunucuya veya bulut servisine göndermez. Tüm rehber kayıtlarınız, şifreleriniz ve notlarınız sadece bu cihazda, şifrelenmiş bir veritabanında saklanır.'**
  String get dataSafetyContent;

  /// Geliştirici bölüm başlığı
  ///
  /// In tr, this message translates to:
  /// **'Geliştirici'**
  String get developerTitle;

  /// Geliştirici içeriği
  ///
  /// In tr, this message translates to:
  /// **'Bu uygulama, kişisel verilerin gizliliği ve güvenli yönetimi hedeflenerek geliştirilmiştir.'**
  String get developerContent;

  /// İletişim ve geri bildirim bölüm başlığı
  ///
  /// In tr, this message translates to:
  /// **'İletişim & Geri Bildirim'**
  String get contactFeedbackTitle;

  /// İletişim ve geri bildirim içeriği
  ///
  /// In tr, this message translates to:
  /// **'Herhangi bir hata bildirimi veya özellik önerisi için bize ulaşabilirsiniz:'**
  String get contactFeedbackContent;

  /// Telif hakkı metni
  ///
  /// In tr, this message translates to:
  /// **'© 2024 Aeterna Vault. Tüm hakları saklıdır.'**
  String get copyright;

  /// Kasa şifre belirleme başlığı
  ///
  /// In tr, this message translates to:
  /// **'Kasa Şifre Belirleme'**
  String get vaultSetupTitle;

  /// Kasayı kurma başlığı
  ///
  /// In tr, this message translates to:
  /// **'Güvenli Kasanızı Kurun'**
  String get setupVaultTitle;

  /// Kasayı kurma alt başlığı
  ///
  /// In tr, this message translates to:
  /// **'Bu şifre, kasanızdaki verileri korumak için kullanılacaktır. Lütfen güvenli bir şifre seçin.'**
  String get setupVaultSubtitle;

  /// Master key etiketi
  ///
  /// In tr, this message translates to:
  /// **'Master Key (Ana Şifre)'**
  String get masterKeyLabel;

  /// En az 8 karakter uyarısı
  ///
  /// In tr, this message translates to:
  /// **'En az 8 karakter giriniz'**
  String get minEightChars;

  /// Harf ve rakam içermeli uyarısı
  ///
  /// In tr, this message translates to:
  /// **'Harf ve rakam içermelidir'**
  String get mustContainLetterDigit;

  /// Şifreyi onayla etiketi
  ///
  /// In tr, this message translates to:
  /// **'Şifreyi Onayla'**
  String get confirmPassword;

  /// Şifreler eşleşmiyor uyarısı
  ///
  /// In tr, this message translates to:
  /// **'Şifreler eşleşmiyor'**
  String get passwordsDoNotMatch;

  /// Biyometrik doğrulama etiketi
  ///
  /// In tr, this message translates to:
  /// **'Biyometrik Doğrulamayı Aktif Et'**
  String get enableBiometricAuth;

  /// Parmak izi hızlı giriş alt metni
  ///
  /// In tr, this message translates to:
  /// **'Hızlı giriş için parmak izi kullan.'**
  String get useFingerprintForQuickLogin;

  /// Şifreyi kaydet ve aktif et butonu
  ///
  /// In tr, this message translates to:
  /// **'ŞİFREYİ KAYDET VE AKTİF ET'**
  String get saveAndActivate;

  /// Kasa şifresi kaydedildi mesajı
  ///
  /// In tr, this message translates to:
  /// **'Kasa şifreniz ve tercihleriniz kaydedildi!'**
  String get vaultPasswordSaved;

  /// İş kategorisi
  ///
  /// In tr, this message translates to:
  /// **'İş'**
  String get categoryWork;

  /// Aile kategorisi
  ///
  /// In tr, this message translates to:
  /// **'Aile'**
  String get categoryFamily;

  /// Arkadaş kategorisi
  ///
  /// In tr, this message translates to:
  /// **'Arkadaş'**
  String get categoryFriend;

  /// Müşteri kategorisi
  ///
  /// In tr, this message translates to:
  /// **'Müşteri'**
  String get categoryCustomer;

  /// Tedarikçi kategorisi
  ///
  /// In tr, this message translates to:
  /// **'Tedarikçi'**
  String get categorySupplier;

  /// Diğer kategorisi
  ///
  /// In tr, this message translates to:
  /// **'Diğer'**
  String get categoryOther;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'it', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'it':
      return AppLocalizationsIt();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
