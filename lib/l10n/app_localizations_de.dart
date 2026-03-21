// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Aeterna Vault';

  @override
  String get appSubtitle => 'Sicheres CRM & Tresor';

  @override
  String get contacts => 'Kontakte';

  @override
  String get digitalVault => 'Digitaler Tresor';

  @override
  String get activateVault => 'Tresor aktivieren';

  @override
  String get securitySettings => 'Sicherheitseinstellungen';

  @override
  String get generalSettings => 'Allgemeine Einstellungen';

  @override
  String get about => 'Über';

  @override
  String get overview => 'ÜBERSICHT';

  @override
  String personsCount(int count) {
    return '$count Kontakte';
  }

  @override
  String vaultCount(int count) {
    return '$count Tresor';
  }

  @override
  String totalContacts(int count) {
    return '$count Kontakte';
  }

  @override
  String get totalContactsSub => 'Kontakte gesamt';

  @override
  String vaultItems(int count) {
    return '$count Tresorobjekte';
  }

  @override
  String get encryptedRecord => 'Verschlüsselter Eintrag';

  @override
  String get contactNotFound => 'Kein Kontakt gefunden.';

  @override
  String get vaultLock => 'Tresorsperre';

  @override
  String get masterKey => 'Hauptschlüssel';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get login => 'Anmelden';

  @override
  String get vaultUnlockFailed => 'Tresor konnte nicht entsperrt werden!';

  @override
  String get searchHint => 'Name oder Telefon suchen...';

  @override
  String birthdayAlert(String name) {
    return 'Heute hat $name Geburtstag! 🎂';
  }

  @override
  String meetingAlert(String name) {
    return 'Es ist Zeit, $name zu kontaktieren. 📞';
  }

  @override
  String get vaultScreenTitle => 'Digitaler Tresor';

  @override
  String encryptedRecordsCount(int count) {
    return '$count verschlüsselte Einträge';
  }

  @override
  String get protected => 'Geschützt';

  @override
  String get hiddenContacts => 'Private Kontakte';

  @override
  String get documentsPasswords => 'Dokumente & Passwörter';

  @override
  String get noHiddenContacts => 'Keine privaten Kontakte';

  @override
  String get addWithPlusButton => 'Zum Hinzufügen + drücken';

  @override
  String get vaultEmpty => 'Tresor ist leer';

  @override
  String get filterAll => 'Alle';

  @override
  String get filterPasswords => 'Passwörter';

  @override
  String get filterBank => 'Bank';

  @override
  String get filterDocuments => 'Dokumente';

  @override
  String get fileNotFound => 'Datei nicht gefunden!';

  @override
  String get fileOpenError => 'Datei konnte nicht geöffnet werden.';

  @override
  String get openFile => 'Datei öffnen';

  @override
  String get addVaultItem => 'Tresome-Objekt hinzufügen';

  @override
  String get editVaultItem => 'Objekt bearbeiten';

  @override
  String get titleHint => 'Titel (z.B. MetaMask Wallet)';

  @override
  String get required => 'Erforderlich';

  @override
  String get category => 'Kategorie';

  @override
  String get secretData => 'Geheime Daten';

  @override
  String get generatePassword => 'Passwort generieren';

  @override
  String get passwordGenerated => 'Starkes Passwort generiert!';

  @override
  String get fileAttachment => 'Datei / Anhang (PDF, Bild usw.)';

  @override
  String get additionalNotes => 'Zusätzliche Notizen';

  @override
  String get saveEncrypted => 'VERSCHLÜSSELT SPEICHERN';

  @override
  String get selectFile => 'Datei auswählen (PDF, Bild usw.)';

  @override
  String get fileReady => 'Datei bereit';

  @override
  String get filePickError => 'Datei konnte nicht ausgewählt werden.';

  @override
  String saveError(String error) {
    return 'Speicherfehler: $error';
  }

  @override
  String get decryptionError =>
      'Dieser Eintrag konnte nicht gelesen werden. Er wurde wahrscheinlich mit einem anderen Hauptschlüssel verschlüsselt. Sie können die Felder erneut ausfüllen und speichern.';

  @override
  String get usernameEmail => 'Benutzername / E-Mail';

  @override
  String get password => 'Passwort';

  @override
  String get websiteUrl => 'Website-URL';

  @override
  String get walletAddress => 'Wallet-Adresse (Public Key)';

  @override
  String get seedPhrase => 'Seed-Phrase (12/24 Wörter)';

  @override
  String get network => 'Netzwerk (z.B. Ethereum, BTC)';

  @override
  String get ibanAccount => 'IBAN / Kontonummer';

  @override
  String get bankName => 'Bankname';

  @override
  String get branchInfo => 'Filiale / Zusatzinfo';

  @override
  String get serialId => 'Seriennr. / Ausweisnummer';

  @override
  String get documentType => 'Dokumenttyp (z.B. Reisepass)';

  @override
  String get expiryDate => 'Ablaufdatum';

  @override
  String get noteContent => 'Notizinhalt';

  @override
  String get categoryPassword => 'Passwort';

  @override
  String get categoryBank => 'Bank';

  @override
  String get categoryDocument => 'Dokument';

  @override
  String get categoryCrypto => 'Krypto-Wallet';

  @override
  String get categorySecretNote => 'Geheime Notiz';

  @override
  String get contactDetail => 'Kontaktdetail';

  @override
  String get contactInfo => 'Kontaktinformationen';

  @override
  String get phone => 'Telefon';

  @override
  String get email => 'E-Mail';

  @override
  String get birthday => 'Geburtstag';

  @override
  String get lastContact => 'Letzter Kontakt';

  @override
  String get contactFrequency => 'Kontakthäufigkeit';

  @override
  String everyNDays(int count) {
    return 'Alle $count Tage';
  }

  @override
  String get reminders => 'Erinnerungen';

  @override
  String get noPendingTasks => 'Keine ausstehenden Aufgaben.';

  @override
  String get archiveTitle => 'Archiv';

  @override
  String get noArchivedReminders => 'Keine archivierten Erinnerungen.';

  @override
  String get activityLog => 'Aktivitätsprotokoll';

  @override
  String get newTask => 'Neue Aufgabe / Erinnerung';

  @override
  String get taskName => 'Aufgabenname';

  @override
  String get add => 'Hinzufügen';

  @override
  String get trackingLate => 'Gesprächszeit überschritten!';

  @override
  String get trackingGood => 'Tracking-Status gut';

  @override
  String daysSinceLastContact(int days) {
    return '$days Tage seit dem letzten Kontakt.';
  }

  @override
  String get call => 'Anrufen';

  @override
  String get write => 'E-Mail';

  @override
  String get sms => 'SMS';

  @override
  String shareContact(String name, String phone, String email) {
    return 'Kontakt teilen:\nName: $name\nTelefon: $phone\nE-Mail: $email\n\nGeteilt über Aeterna Vault.';
  }

  @override
  String get addContactTitle => 'Neuen Kontakt hinzufügen';

  @override
  String get addPrivateContactTitle => 'Privaten Kontakt hinzufügen';

  @override
  String get editContactTitle => 'Kontakt bearbeiten';

  @override
  String get basicInfo => 'Grundlegende Informationen';

  @override
  String get firstName => 'Vorname';

  @override
  String get lastName => 'Nachname';

  @override
  String get socialMedia => 'Social-Media-Link';

  @override
  String get professionalLocation => 'Beruflich & Standort';

  @override
  String get company => 'Unternehmen';

  @override
  String get jobTitle => 'Berufsbezeichnung';

  @override
  String get address => 'Adresse';

  @override
  String get importantDates => 'Wichtige Termine';

  @override
  String get anniversary => 'Jahrestag / Besonderer Tag';

  @override
  String get relationshipManagement => 'Beziehungsmanagement';

  @override
  String get howWeKnow => 'Woher kennen wir uns?';

  @override
  String get tags => 'Tags (#tag1 #tag2)';

  @override
  String get saveAsPrivate => 'Als privat speichern (Tresor)';

  @override
  String get notes => 'Notizen';

  @override
  String get save => 'SPEICHERN';

  @override
  String get imagePickError => 'Bild konnte nicht ausgewählt werden.';

  @override
  String get securitySettingsTitle => 'Sicherheitseinstellungen';

  @override
  String get appProtectionSettings => 'App-Schutzeinstellungen';

  @override
  String securityScore(int score) {
    return 'Sicherheitsbewertung: $score/100';
  }

  @override
  String get securityVeryStrong => 'Sehr stark — alle Schutzmaßnahmen aktiv';

  @override
  String get enableBiometric => 'Biometrie aktivieren';

  @override
  String get passwordSecurity => 'Passwortsicherheit';

  @override
  String get masterKeyTitle => 'Hauptpasswort';

  @override
  String get lastChangedDaysAgo => 'Zuletzt geändert: vor 45 Tagen';

  @override
  String get change => 'Ändern';

  @override
  String get passwordHints => 'Passworthinweise';

  @override
  String get showHintOnLogin => 'Hinweis auf dem Anmeldebildschirm anzeigen';

  @override
  String get biometricId => 'Biometrische Identität';

  @override
  String get fingerprint => 'Fingerabdruck';

  @override
  String get fingerprintEnabled => 'Aktiviert — Schnellanmeldung aktiv';

  @override
  String get fingerprintDisabled => 'Deaktiviert';

  @override
  String get active => 'Aktiv';

  @override
  String get autoLock => 'Automatische Sperre';

  @override
  String get autoLockSubtitle => 'Nach 1 Minute Inaktivität sperren';

  @override
  String get accountSecurity => 'Kontosicherheit';

  @override
  String get recoveryCode => 'Wiederherstellungscode';

  @override
  String get recoveryCodeExists => 'Sie haben einen vorhandenen Code.';

  @override
  String get recoveryCodeHint => '12-Wort-Wiederherstellungsschlüssel';

  @override
  String get backupRestore => 'Sicherung & Wiederherstellung';

  @override
  String get backup => 'Sichern';

  @override
  String get backupDone => 'Gesichert ✓';

  @override
  String get restore => 'Wiederherstellen';

  @override
  String get dangerZone => 'Gefahrenzone';

  @override
  String get factoryReset => 'Werksreset';

  @override
  String get deleteAllPermanently => 'Alle Daten dauerhaft löschen';

  @override
  String get doFactoryReset => 'Werksreset durchführen';

  @override
  String get factoryResetConfirmTitle => 'Werksreset';

  @override
  String get factoryResetConfirmContent =>
      'Alle Daten werden dauerhaft gelöscht. Diese Aktion kann nicht rückgängig gemacht werden!';

  @override
  String get confirmAndDelete => 'BESTÄTIGEN UND LÖSCHEN';

  @override
  String get recoveryCodeGenerated => 'Wiederherstellungscode generiert';

  @override
  String get saveNote => 'Bitte notieren Sie ihn an einem sicheren Ort:';

  @override
  String get saveAndClose => 'SPEICHERN UND SCHLIESSEN';

  @override
  String get dataBackupTitle => 'Datensicherung (JSON)';

  @override
  String get backupInstructions =>
      'Kopieren Sie den folgenden Text und bewahren Sie ihn sicher auf:';

  @override
  String get copyAndClose => 'KOPIEREN UND SCHLIESSEN';

  @override
  String get backupCopied => 'Sicherung in Zwischenablage kopiert!';

  @override
  String get restoreFromBackup => 'Aus Sicherung wiederherstellen';

  @override
  String get restoreWarning =>
      'Sicherungstext einfügen. AKTUELLE DATEN WERDEN GELÖSCHT!';

  @override
  String get restoreSuccess => 'Daten erfolgreich wiederhergestellt!';

  @override
  String get restoreError => 'Fehler: Ungültiges Format.';

  @override
  String get changePassword => 'Passwort ändern';

  @override
  String get oldPassword => 'Altes Passwort';

  @override
  String get newPassword => 'Neues Passwort (mind. 8 Zeichen)';

  @override
  String get update => 'Aktualisieren';

  @override
  String get passwordUpdated => 'Passwort aktualisiert.';

  @override
  String get oldPasswordWrong => 'Altes Passwort ist falsch!';

  @override
  String get passwordRequirements =>
      'Das Passwort muss mindestens 8 Zeichen mit Buchstaben und Zahlen enthalten.';

  @override
  String get generalSettingsTitle => 'Allgemeine Einstellungen';

  @override
  String get appearanceMode => 'Darstellungsmodus';

  @override
  String get darkModeActive => 'Dunkles Design aktiv';

  @override
  String get lightModeActive => 'Helles Design aktiv';

  @override
  String get themeModeTip => 'Modus wechseln, um die Augen zu schonen.';

  @override
  String get appIdentityColor => 'App-Identität (Farbe)';

  @override
  String get colorAutoAdapt =>
      'Alle App-Töne passen sich automatisch an Ihre ausgewählte Farbe an.';

  @override
  String get dataSecurity => 'Daten & Sicherheit';

  @override
  String get factoryRestoreTitle => 'Werkseinstellungen zurücksetzen';

  @override
  String get factoryRestoreSubtitle =>
      'Löscht dauerhaft alle Kontakte, den Tresor und die Einstellungen.';

  @override
  String get permanentDeleteTitle => 'Daten dauerhaft löschen?';

  @override
  String get permanentDeleteContent =>
      'Diese Aktion kann nicht rückgängig gemacht werden. Alle geheimen Dokumente und CRM-Einträge in Ihrem Tresor gehen verloren.';

  @override
  String get cancelUpper => 'ABBRECHEN';

  @override
  String get deleteAndReset => 'LÖSCHEN UND ZURÜCKSETZEN';

  @override
  String get appResetSuccess => 'App erfolgreich zurückgesetzt.';

  @override
  String get versionInfo => 'Aeterna Vault v1.0';

  @override
  String get language => 'Sprache';

  @override
  String get languageTurkish => 'Türkisch';

  @override
  String get languageEnglish => 'Englisch';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get languageItalian => 'Italienisch';

  @override
  String get aboutTitle => 'Über';

  @override
  String get version => 'Version 1.0';

  @override
  String get dataSafetyTitle => 'Datensicherheit';

  @override
  String get dataSafetyContent =>
      'Aeterna Vault sendet Ihre Daten niemals an einen Server oder Cloud-Dienst. Alle Ihre Kontakte, Passwörter und Notizen werden nur auf diesem Gerät in einer verschlüsselten Datenbank gespeichert.';

  @override
  String get developerTitle => 'Entwickler';

  @override
  String get developerContent =>
      'Diese App wurde mit dem Ziel der Privatsphäre und sicheren Verwaltung persönlicher Daten entwickelt.';

  @override
  String get contactFeedbackTitle => 'Kontakt & Feedback';

  @override
  String get contactFeedbackContent =>
      'Für Fehlermeldungen oder Funktionsvorschläge können Sie uns erreichen:';

  @override
  String get privacyPolicy => 'Datenschutzerklärung';

  @override
  String get copyright => '© 2026 Aeterna Vault. Alle Rechte vorbehalten.';

  @override
  String get vaultSetupTitle => 'Tresor-Passwort einrichten';

  @override
  String get setupVaultTitle => 'Sicheren Tresor einrichten';

  @override
  String get setupVaultSubtitle =>
      'Dieses Passwort wird zum Schutz der Daten in Ihrem Tresor verwendet. Bitte wählen Sie ein sicheres Passwort.';

  @override
  String get masterKeyLabel => 'Hauptschlüssel (Hauptpasswort)';

  @override
  String get minEightChars => 'Mindestens 8 Zeichen eingeben';

  @override
  String get mustContainLetterDigit => 'Muss Buchstaben und Zahlen enthalten';

  @override
  String get confirmPassword => 'Passwort bestätigen';

  @override
  String get passwordsDoNotMatch => 'Passwörter stimmen nicht überein';

  @override
  String get enableBiometricAuth => 'Biometrische Authentifizierung aktivieren';

  @override
  String get useFingerprintForQuickLogin =>
      'Fingerabdruck für schnelle Anmeldung verwenden.';

  @override
  String get saveAndActivate => 'PASSWORT SPEICHERN UND AKTIVIEREN';

  @override
  String get vaultPasswordSaved =>
      'Ihr Tresor-Passwort und Ihre Einstellungen wurden gespeichert!';

  @override
  String get categoryWork => 'Arbeit';

  @override
  String get categoryFamily => 'Familie';

  @override
  String get categoryFriend => 'Freund';

  @override
  String get categoryCustomer => 'Kunde';

  @override
  String get categorySupplier => 'Lieferant';

  @override
  String get categoryOther => 'Andere';

  @override
  String get deleteVaultItem => 'Aus dem Tresor löschen';

  @override
  String deleteVaultItemConfirm(String title) {
    return 'Möchten Sie \"$title\" wirklich dauerhaft löschen?';
  }

  @override
  String get clipboardCleared => 'Zwischenablage nach 30 Sekunden geleert';

  @override
  String get autoLockEnabled => 'Aktiviert — bei Hintergrund sperren';

  @override
  String get autoLockDisabled => 'Deaktiviert';

  @override
  String get shareBackup => 'Sicherung teilen';

  @override
  String get backupShared => 'Sicherung geteilt!';

  @override
  String get biometricReason =>
      'Authentifizieren Sie sich, um auf den Tresor zuzugreifen';

  @override
  String get connectionSource => 'Kontaktquelle';

  @override
  String get deleteContact => 'Kontakt löschen';

  @override
  String get deleteContactConfirm =>
      'Möchten Sie diesen Kontakt wirklich löschen?';

  @override
  String get sendEmail => 'E-Mail senden';

  @override
  String get sendSms => 'SMS senden';

  @override
  String get openWhatsapp => 'In WhatsApp öffnen';

  @override
  String get cannotLaunch => 'App konnte nicht geöffnet werden';

  @override
  String get confirmDelete => 'Löschen bestätigen';

  @override
  String get delete => 'Löschen';

  @override
  String get addNote => 'Notiz hinzufügen';

  @override
  String get addNoteHint => 'Schreiben Sie Ihre Notiz über diesen Kontakt...';

  @override
  String get backupSaved => 'Backup gespeichert';

  @override
  String get manualNote => 'Notiz';

  @override
  String get comingSoon => 'Diese Funktion kommt bald';

  @override
  String get onbSkip => 'Überspringen';

  @override
  String get onbContinue => 'Weiter';

  @override
  String get onbStart => 'Loslegen';

  @override
  String get onbTitle1 => 'Aeterna Vault';

  @override
  String get onbDesc1 =>
      'Ihr persönliches CRM und digitaler Tresor. Ihre Daten bleiben nur in Ihren Händen.';

  @override
  String get onbTitle2 => 'Militärische Verschlüsselung';

  @override
  String get onbDesc2 =>
      'Alle Daten werden mit AES-256-CBC verschlüsselt. Ohne Ihr Hauptpasswort hat niemand Zugriff.';

  @override
  String get onbTitle3 => 'Privates Kontaktmanagement';

  @override
  String get onbDesc3 =>
      'Speichern Sie private Kontakte, Passwörter und sensible Dokumente an einem sicheren Ort.';

  @override
  String get onbFeat2a => 'AES-256-Verschlüsselung';

  @override
  String get onbFeat2b => 'Biometrische Sperre';

  @override
  String get onbFeat2c => 'Keine Datenweitergabe';

  @override
  String get onbFeat3a => 'Private Kontakte';

  @override
  String get onbFeat3b => 'Intelligente Erinnerungen';

  @override
  String get onbFeat3c => 'Sichere Sicherung';

  @override
  String get autofillSectionTitle => 'Automatisches Ausfüllen';

  @override
  String get autofillServiceTitle => 'Aeterna Vault Autovervollständigung';

  @override
  String get autofillServiceDesc =>
      'Passwörter in anderen Apps automatisch ausfüllen';

  @override
  String get autofillServiceEnable => 'Aktivieren';

  @override
  String get autofillServiceEnabled =>
      'Aktiv — Aeterna Vault ist Ihr Autofill-Anbieter';

  @override
  String get autofillServiceDisabled => 'Deaktiviert — Zum Aktivieren tippen';

  @override
  String get passwordLength => 'Passwortlänge';

  @override
  String get secNeverChanged => 'Nie geändert';

  @override
  String get secLastChangedToday => 'Heute geändert';

  @override
  String get secLastChangedYesterday => 'Gestern geändert';

  @override
  String secLastChangedDaysAgo(int days) => 'Vor $days Tagen geändert';

  @override
  String get backupDesc => 'Sicherung als verschlüsselte JSON-Datei teilen';
}
