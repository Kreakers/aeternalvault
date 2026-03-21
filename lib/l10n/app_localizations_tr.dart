// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Aeterna Vault';

  @override
  String get appSubtitle => 'Güvenli CRM & Kasa';

  @override
  String get contacts => 'Kişiler';

  @override
  String get digitalVault => 'Dijital Kasa';

  @override
  String get activateVault => 'Kasayı Aktif Et';

  @override
  String get securitySettings => 'Güvenlik Ayarları';

  @override
  String get generalSettings => 'Genel Ayarlar';

  @override
  String get about => 'Hakkında';

  @override
  String get overview => 'GENEL BAKIŞ';

  @override
  String personsCount(int count) {
    return '$count kişi';
  }

  @override
  String vaultCount(int count) {
    return '$count kasa';
  }

  @override
  String totalContacts(int count) {
    return '$count Kişi';
  }

  @override
  String get totalContactsSub => 'Toplam rehber';

  @override
  String vaultItems(int count) {
    return '$count Kasa Öğesi';
  }

  @override
  String get encryptedRecord => 'Şifreli kayıt';

  @override
  String get contactNotFound => 'Kişi bulunamadı.';

  @override
  String get vaultLock => 'Kasa Kilidi';

  @override
  String get masterKey => 'Master Key';

  @override
  String get cancel => 'İptal';

  @override
  String get login => 'Giriş';

  @override
  String get vaultUnlockFailed => 'Kasa kilidi açılamadı!';

  @override
  String get searchHint => 'İsim veya telefon ara...';

  @override
  String birthdayAlert(String name) {
    return 'Bugün $name\'ın doğum günü! 🎂';
  }

  @override
  String meetingAlert(String name) {
    return '$name ile görüşme zamanı gelmiş. 📞';
  }

  @override
  String get vaultScreenTitle => 'Dijital Kasa';

  @override
  String encryptedRecordsCount(int count) {
    return '$count şifreli kayıt';
  }

  @override
  String get protected => 'Korumalı';

  @override
  String get hiddenContacts => 'Gizli Kişiler';

  @override
  String get documentsPasswords => 'Belgeler & Şifreler';

  @override
  String get noHiddenContacts => 'Gizli kişi yok';

  @override
  String get addWithPlusButton => 'Eklemek için + butonuna bas';

  @override
  String get vaultEmpty => 'Kasa boş';

  @override
  String get filterAll => 'Tümü';

  @override
  String get filterPasswords => 'Şifreler';

  @override
  String get filterBank => 'Banka';

  @override
  String get filterDocuments => 'Belgeler';

  @override
  String get fileNotFound => 'Dosya bulunamadı!';

  @override
  String get fileOpenError => 'Dosya açılamadı.';

  @override
  String get openFile => 'Dosyayı Aç';

  @override
  String get addVaultItem => 'Kasa Öğesi Ekle';

  @override
  String get editVaultItem => 'Öğeyi Düzenle';

  @override
  String get titleHint => 'Başlık (Örn: MetaMask Cüzdanım)';

  @override
  String get required => 'Gerekli';

  @override
  String get category => 'Kategori';

  @override
  String get secretData => 'Gizli Veriler';

  @override
  String get generatePassword => 'Şifre Üret';

  @override
  String get passwordGenerated => 'Güçlü şifre oluşturuldu!';

  @override
  String get fileAttachment => 'Dosya / Ek (PDF, Görsel vb.)';

  @override
  String get additionalNotes => 'Ek Notlar';

  @override
  String get saveEncrypted => 'ŞİFRELİ OLARAK KAYDET';

  @override
  String get selectFile => 'Dosya Seç (PDF, Resim vb.)';

  @override
  String get fileReady => 'Dosya Hazır';

  @override
  String get filePickError => 'Dosya seçilemedi.';

  @override
  String saveError(String error) {
    return 'Kayıt hatası: $error';
  }

  @override
  String get decryptionError =>
      'Bu kayıt okunamadı. Muhtemelen farklı bir master key ile şifrelendi. Alanları yeniden doldurup kaydedebilirsin.';

  @override
  String get usernameEmail => 'Kullanıcı Adı / E-posta';

  @override
  String get password => 'Şifre';

  @override
  String get websiteUrl => 'Web Sitesi URL';

  @override
  String get walletAddress => 'Cüzdan Adresi (Public Key)';

  @override
  String get seedPhrase => 'Seed Phrase (12/24 Kelime)';

  @override
  String get network => 'Ağ (Örn: Ethereum, BTC)';

  @override
  String get ibanAccount => 'IBAN / Hesap No';

  @override
  String get bankName => 'Banka Adı';

  @override
  String get branchInfo => 'Şube / Ek Bilgi';

  @override
  String get serialId => 'Seri No / Kimlik No';

  @override
  String get documentType => 'Belge Türü (Örn: Pasaport)';

  @override
  String get expiryDate => 'Son Kullanma Tarihi';

  @override
  String get noteContent => 'Not İçeriği';

  @override
  String get categoryPassword => 'Şifre';

  @override
  String get categoryBank => 'Banka';

  @override
  String get categoryDocument => 'Belge';

  @override
  String get categoryCrypto => 'Kripto Cüzdanı';

  @override
  String get categorySecretNote => 'Gizli Not';

  @override
  String get contactDetail => 'Kişi Detayı';

  @override
  String get contactInfo => 'İletişim Bilgileri';

  @override
  String get phone => 'Telefon';

  @override
  String get email => 'E-posta';

  @override
  String get birthday => 'Doğum Günü';

  @override
  String get lastContact => 'Son Temas';

  @override
  String get contactFrequency => 'Görüşme Sıklığı';

  @override
  String everyNDays(int count) {
    return 'Her $count günde bir';
  }

  @override
  String get reminders => 'Hatırlatıcılar';

  @override
  String get noPendingTasks => 'Bekleyen görev yok.';

  @override
  String get activityLog => 'Aktivite Günlüğü';

  @override
  String get newTask => 'Yeni Görev / Hatırlatıcı';

  @override
  String get taskName => 'Görev Adı';

  @override
  String get add => 'Ekle';

  @override
  String get trackingLate => 'Görüşme Zamanı Geçmiş!';

  @override
  String get trackingGood => 'Takip Durumu İyi';

  @override
  String daysSinceLastContact(int days) {
    return 'Son görüşme üzerinden $days gün geçti.';
  }

  @override
  String get call => 'Ara';

  @override
  String get write => 'Yaz';

  @override
  String get sms => 'SMS';

  @override
  String shareContact(String name, String phone, String email) {
    return 'Kişi Paylaşımı:\nAd Soyad: $name\nTelefon: $phone\nE-posta: $email\n\nAeterna Vault üzerinden paylaşıldı.';
  }

  @override
  String get addContactTitle => 'Yeni Kişi Ekle';

  @override
  String get addPrivateContactTitle => 'Gizli Kişi Ekle';

  @override
  String get editContactTitle => 'Kişiyi Düzenle';

  @override
  String get basicInfo => 'Temel Bilgiler';

  @override
  String get firstName => 'Ad';

  @override
  String get lastName => 'Soyad';

  @override
  String get socialMedia => 'Sosyal Medya Linki';

  @override
  String get professionalLocation => 'Profesyonel & Lokasyon';

  @override
  String get company => 'Şirket';

  @override
  String get jobTitle => 'Unvan';

  @override
  String get address => 'Adres';

  @override
  String get importantDates => 'Önemli Günler';

  @override
  String get anniversary => 'Yıldönümü / Özel Gün';

  @override
  String get relationshipManagement => 'İlişki Yönetimi';

  @override
  String get howWeKnow => 'Nereden Tanışıyoruz?';

  @override
  String get tags => 'Etiketler (#tag1 #tag2)';

  @override
  String get saveAsPrivate => 'Gizli Olarak Kaydet (Kasa)';

  @override
  String get notes => 'Notlar';

  @override
  String get save => 'KAYDET';

  @override
  String get imagePickError => 'Resim seçilemedi.';

  @override
  String get securitySettingsTitle => 'Güvenlik Ayarları';

  @override
  String get appProtectionSettings => 'Uygulama koruma ayarları';

  @override
  String securityScore(int score) {
    return 'Güvenlik Skoru: $score/100';
  }

  @override
  String get securityVeryStrong => 'Çok güçlü — tüm korumalar aktif';

  @override
  String get enableBiometric => 'Biyometriği etkinleştir';

  @override
  String get passwordSecurity => 'Şifre Güvenliği';

  @override
  String get masterKeyTitle => 'Ana Şifre';

  @override
  String get lastChangedDaysAgo => 'Son değişiklik: 45 gün önce';

  @override
  String get change => 'Değiştir';

  @override
  String get passwordHints => 'Şifre İpuçları';

  @override
  String get showHintOnLogin => 'Giriş ekranında ipucu göster';

  @override
  String get biometricId => 'Biyometrik Kimlik';

  @override
  String get fingerprint => 'Parmak İzi';

  @override
  String get fingerprintEnabled => 'Etkin — hızlı giriş açık';

  @override
  String get fingerprintDisabled => 'Devre dışı';

  @override
  String get active => 'Aktif';

  @override
  String get autoLock => 'Otomatik Kilit';

  @override
  String get autoLockSubtitle => '1 dakika hareketsizlikte kilitle';

  @override
  String get accountSecurity => 'Hesap Güvenliği';

  @override
  String get recoveryCode => 'Kurtarma Kodu';

  @override
  String get recoveryCodeExists => 'Mevcut bir kodunuz var.';

  @override
  String get recoveryCodeHint => '12 kelimeli kurtarma anahtarı';

  @override
  String get backupRestore => 'Yedekleme & Geri Yükleme';

  @override
  String get backup => 'Yedekle';

  @override
  String get backupDone => 'Yedeklendi ✓';

  @override
  String get restore => 'Geri Yükle';

  @override
  String get dangerZone => 'Tehlike Bölgesi';

  @override
  String get factoryReset => 'Fabrika Sıfırlama';

  @override
  String get deleteAllPermanently => 'Tüm verileri kalıcı olarak sil';

  @override
  String get doFactoryReset => 'Fabrika Sıfırlama Yap';

  @override
  String get factoryResetConfirmTitle => 'Fabrika Sıfırlama';

  @override
  String get factoryResetConfirmContent =>
      'Tüm veriler kalıcı olarak silinecek. Bu işlem geri alınamaz!';

  @override
  String get confirmAndDelete => 'ONAYLA VE SİL';

  @override
  String get recoveryCodeGenerated => 'Kurtarma Kodu Oluşturuldu';

  @override
  String get saveNote => 'Lütfen güvenli bir yere not edin:';

  @override
  String get saveAndClose => 'KAYDET VE KAPAT';

  @override
  String get dataBackupTitle => 'Veri Yedeği (JSON)';

  @override
  String get backupInstructions =>
      'Aşağıdaki metni kopyalayıp güvenli bir yerde saklayın:';

  @override
  String get copyAndClose => 'KOPYALA VE KAPAT';

  @override
  String get backupCopied => 'Yedek panoya kopyalandı!';

  @override
  String get restoreFromBackup => 'Yedekten Geri Yükle';

  @override
  String get restoreWarning =>
      'Yedek metni yapıştırın. MEVCUT VERİLER SİLİNECEK!';

  @override
  String get restoreSuccess => 'Veriler başarıyla yüklendi!';

  @override
  String get restoreError => 'Hata: Geçersiz format.';

  @override
  String get changePassword => 'Şifre Değiştir';

  @override
  String get oldPassword => 'Eski Şifre';

  @override
  String get newPassword => 'Yeni Şifre (en az 8 karakter)';

  @override
  String get update => 'Güncelle';

  @override
  String get passwordUpdated => 'Şifre güncellendi.';

  @override
  String get oldPasswordWrong => 'Eski şifre hatalı!';

  @override
  String get passwordRequirements =>
      'Şifre en az 8 karakter, harf ve rakam içermelidir.';

  @override
  String get generalSettingsTitle => 'Genel Ayarlar';

  @override
  String get appearanceMode => 'Görünüm Modu';

  @override
  String get darkModeActive => 'Karanlık Tema Aktif';

  @override
  String get lightModeActive => 'Aydınlık Tema Aktif';

  @override
  String get themeModeTip => 'Göz yorgunluğunu azaltmak için mod değiştirin.';

  @override
  String get appIdentityColor => 'Uygulama Kimliği (Renk)';

  @override
  String get colorAutoAdapt =>
      'Uygulamanın tüm tonları seçtiğiniz renge göre otomatik uyarlanır.';

  @override
  String get dataSecurity => 'Veri ve Güvenlik';

  @override
  String get factoryRestoreTitle => 'Fabrika Ayarlarına Dön';

  @override
  String get factoryRestoreSubtitle =>
      'Tüm rehber, kasa ve ayarları kalıcı olarak temizler.';

  @override
  String get permanentDeleteTitle => 'Verileri Kalıcı Olarak Sil?';

  @override
  String get permanentDeleteContent =>
      'Bu işlem geri alınamaz. Kasanızdaki tüm gizli belgeler ve CRM kayıtlarınız yok olacaktır.';

  @override
  String get cancelUpper => 'İPTAL';

  @override
  String get deleteAndReset => 'SİL VE SIFIRLA';

  @override
  String get appResetSuccess => 'Uygulama başarıyla sıfırlandı.';

  @override
  String get versionInfo => 'Aeterna Vault v1.0';

  @override
  String get language => 'Dil';

  @override
  String get languageTurkish => 'Türkçe';

  @override
  String get languageEnglish => 'İngilizce';

  @override
  String get languageGerman => 'Almanca';

  @override
  String get languageItalian => 'İtalyanca';

  @override
  String get aboutTitle => 'Hakkında';

  @override
  String get version => 'Sürüm 1.0';

  @override
  String get dataSafetyTitle => 'Veri Güvenliği';

  @override
  String get dataSafetyContent =>
      'Aeterna Vault, verilerinizi asla herhangi bir sunucuya veya bulut servisine göndermez. Tüm rehber kayıtlarınız, şifreleriniz ve notlarınız sadece bu cihazda, şifrelenmiş bir veritabanında saklanır.';

  @override
  String get developerTitle => 'Geliştirici';

  @override
  String get developerContent =>
      'Bu uygulama, kişisel verilerin gizliliği ve güvenli yönetimi hedeflenerek geliştirilmiştir.';

  @override
  String get contactFeedbackTitle => 'İletişim & Geri Bildirim';

  @override
  String get contactFeedbackContent =>
      'Herhangi bir hata bildirimi veya özellik önerisi için bize ulaşabilirsiniz:';

  @override
  String get privacyPolicy => 'Gizlilik Politikası';

  @override
  String get copyright => '© 2026 Aeterna Vault. Tüm hakları saklıdır.';

  @override
  String get vaultSetupTitle => 'Kasa Şifre Belirleme';

  @override
  String get setupVaultTitle => 'Güvenli Kasanızı Kurun';

  @override
  String get setupVaultSubtitle =>
      'Bu şifre, kasanızdaki verileri korumak için kullanılacaktır. Lütfen güvenli bir şifre seçin.';

  @override
  String get masterKeyLabel => 'Master Key (Ana Şifre)';

  @override
  String get minEightChars => 'En az 8 karakter giriniz';

  @override
  String get mustContainLetterDigit => 'Harf ve rakam içermelidir';

  @override
  String get confirmPassword => 'Şifreyi Onayla';

  @override
  String get passwordsDoNotMatch => 'Şifreler eşleşmiyor';

  @override
  String get enableBiometricAuth => 'Biyometrik Doğrulamayı Aktif Et';

  @override
  String get useFingerprintForQuickLogin =>
      'Hızlı giriş için parmak izi kullan.';

  @override
  String get saveAndActivate => 'ŞİFREYİ KAYDET VE AKTİF ET';

  @override
  String get vaultPasswordSaved => 'Kasa şifreniz ve tercihleriniz kaydedildi!';

  @override
  String get categoryWork => 'İş';

  @override
  String get categoryFamily => 'Aile';

  @override
  String get categoryFriend => 'Arkadaş';

  @override
  String get categoryCustomer => 'Müşteri';

  @override
  String get categorySupplier => 'Tedarikçi';

  @override
  String get categoryOther => 'Diğer';

  @override
  String get deleteVaultItem => 'Kasadan Sil';

  @override
  String deleteVaultItemConfirm(String title) {
    return '\"$title\" öğesini kalıcı olarak silmek istediğine emin misin?';
  }

  @override
  String get clipboardCleared => 'Pano 30 saniye sonra temizlendi';

  @override
  String get autoLockEnabled => 'Etkin — arka plana geçince kilitle';

  @override
  String get autoLockDisabled => 'Devre dışı';

  @override
  String get shareBackup => 'Yedeği Paylaş';

  @override
  String get backupShared => 'Yedek paylaşıldı!';

  @override
  String get biometricReason => 'Kasaya erişmek için doğrulama yapın';

  @override
  String get connectionSource => 'Tanışma Kaynağı';

  @override
  String get deleteContact => 'Kişiyi Sil';

  @override
  String get deleteContactConfirm => 'Bu kişiyi silmek istediğine emin misin?';

  @override
  String get sendEmail => 'E-posta Gönder';

  @override
  String get sendSms => 'SMS Gönder';

  @override
  String get openWhatsapp => 'WhatsApp\'ta Aç';

  @override
  String get cannotLaunch => 'Uygulama açılamadı';

  @override
  String get confirmDelete => 'Silmeyi Onayla';

  @override
  String get delete => 'Sil';

  @override
  String get addNote => 'Not Ekle';

  @override
  String get addNoteHint => 'Bu kişiyle ilgili notunuzu yazın...';

  @override
  String get backupSaved => 'Yedek kaydedildi';

  @override
  String get manualNote => 'Not';

  @override
  String get comingSoon => 'Bu özellik yakında gelecek';

  @override
  String get onbSkip => 'Atla';

  @override
  String get onbContinue => 'Devam Et';

  @override
  String get onbStart => 'Başla';

  @override
  String get onbTitle1 => 'Aeterna Vault';

  @override
  String get onbDesc1 =>
      'Kişisel CRM\'iniz ve dijital kasanız. Verileriniz yalnızca sizin elinizde.';

  @override
  String get onbTitle2 => 'Askeri Düzey Şifreleme';

  @override
  String get onbDesc2 =>
      'Tüm verileriniz AES-256-CBC şifreleme ile korunur. Ana şifreniz olmadan hiç kimse erişemez.';

  @override
  String get onbTitle3 => 'Gizli Kişi Yönetimi';

  @override
  String get onbDesc3 =>
      'Özel kişilerinizi, şifrelerinizi ve hassas belgelerinizi tek bir güvenli yerde saklayın.';

  @override
  String get onbFeat2a => 'AES-256 Şifreleme';

  @override
  String get onbFeat2b => 'Biyometrik Kilit';

  @override
  String get onbFeat2c => 'Veri Paylaşımı Yok';

  @override
  String get onbFeat3a => 'Özel Kişi Listesi';

  @override
  String get onbFeat3b => 'Akıllı Hatırlatıcılar';

  @override
  String get onbFeat3c => 'Güvenli Yedekleme';

  @override
  String get autofillSectionTitle => 'Otomatik Doldurma';

  @override
  String get autofillServiceTitle => 'Aeterna Vault Otomatik Doldurma';

  @override
  String get autofillServiceDesc =>
      'Şifrelerinizi diğer uygulamalarda otomatik doldurun';

  @override
  String get autofillServiceEnable => 'Etkinleştir';

  @override
  String get autofillServiceEnabled =>
      'Etkin — Aeterna Vault aktif şifre sağlayıcı';

  @override
  String get autofillServiceDisabled =>
      'Devre dışı — Etkinleştirmek için dokunun';
}
