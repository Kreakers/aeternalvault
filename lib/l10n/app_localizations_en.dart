// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Aeterna Vault';

  @override
  String get appSubtitle => 'Secure CRM & Vault';

  @override
  String get contacts => 'Contacts';

  @override
  String get digitalVault => 'Digital Vault';

  @override
  String get activateVault => 'Activate Vault';

  @override
  String get securitySettings => 'Security Settings';

  @override
  String get generalSettings => 'General Settings';

  @override
  String get about => 'About';

  @override
  String get overview => 'OVERVIEW';

  @override
  String personsCount(int count) {
    return '$count contacts';
  }

  @override
  String vaultCount(int count) {
    return '$count vault';
  }

  @override
  String totalContacts(int count) {
    return '$count Contacts';
  }

  @override
  String get totalContactsSub => 'Total contacts';

  @override
  String vaultItems(int count) {
    return '$count Vault Items';
  }

  @override
  String get encryptedRecord => 'Encrypted record';

  @override
  String get contactNotFound => 'No contacts found.';

  @override
  String get vaultLock => 'Vault Lock';

  @override
  String get masterKey => 'Master Key';

  @override
  String get cancel => 'Cancel';

  @override
  String get login => 'Login';

  @override
  String get vaultUnlockFailed => 'Failed to unlock vault!';

  @override
  String get searchHint => 'Search by name or phone...';

  @override
  String birthdayAlert(String name) {
    return 'Today is $name\'s birthday! 🎂';
  }

  @override
  String meetingAlert(String name) {
    return 'Time to contact $name. 📞';
  }

  @override
  String get vaultScreenTitle => 'Digital Vault';

  @override
  String encryptedRecordsCount(int count) {
    return '$count encrypted records';
  }

  @override
  String get protected => 'Protected';

  @override
  String get hiddenContacts => 'Private Contacts';

  @override
  String get documentsPasswords => 'Documents & Passwords';

  @override
  String get noHiddenContacts => 'No private contacts';

  @override
  String get addWithPlusButton => 'Tap + to add';

  @override
  String get vaultEmpty => 'Vault is empty';

  @override
  String get filterAll => 'All';

  @override
  String get filterPasswords => 'Passwords';

  @override
  String get filterBank => 'Bank';

  @override
  String get filterDocuments => 'Documents';

  @override
  String get fileNotFound => 'File not found!';

  @override
  String get fileOpenError => 'Could not open file.';

  @override
  String get openFile => 'Open File';

  @override
  String get addVaultItem => 'Add Vault Item';

  @override
  String get editVaultItem => 'Edit Item';

  @override
  String get titleHint => 'Title (e.g. MetaMask Wallet)';

  @override
  String get required => 'Required';

  @override
  String get category => 'Category';

  @override
  String get secretData => 'Secret Data';

  @override
  String get generatePassword => 'Generate Password';

  @override
  String get passwordGenerated => 'Strong password generated!';

  @override
  String get fileAttachment => 'File / Attachment (PDF, Image, etc.)';

  @override
  String get additionalNotes => 'Additional Notes';

  @override
  String get saveEncrypted => 'SAVE ENCRYPTED';

  @override
  String get selectFile => 'Select File (PDF, Image, etc.)';

  @override
  String get fileReady => 'File Ready';

  @override
  String get filePickError => 'Could not pick file.';

  @override
  String saveError(String error) {
    return 'Save error: $error';
  }

  @override
  String get decryptionError =>
      'This record could not be read. It was likely encrypted with a different master key. You can refill the fields and save again.';

  @override
  String get usernameEmail => 'Username / Email';

  @override
  String get password => 'Password';

  @override
  String get websiteUrl => 'Website URL';

  @override
  String get walletAddress => 'Wallet Address (Public Key)';

  @override
  String get seedPhrase => 'Seed Phrase (12/24 Words)';

  @override
  String get network => 'Network (e.g. Ethereum, BTC)';

  @override
  String get ibanAccount => 'IBAN / Account Number';

  @override
  String get bankName => 'Bank Name';

  @override
  String get branchInfo => 'Branch / Additional Info';

  @override
  String get serialId => 'Serial No / ID Number';

  @override
  String get documentType => 'Document Type (e.g. Passport)';

  @override
  String get expiryDate => 'Expiry Date';

  @override
  String get noteContent => 'Note Content';

  @override
  String get categoryPassword => 'Password';

  @override
  String get categoryBank => 'Bank';

  @override
  String get categoryDocument => 'Document';

  @override
  String get categoryCrypto => 'Crypto Wallet';

  @override
  String get categorySecretNote => 'Secret Note';

  @override
  String get contactDetail => 'Contact Detail';

  @override
  String get contactInfo => 'Contact Information';

  @override
  String get phone => 'Phone';

  @override
  String get email => 'Email';

  @override
  String get birthday => 'Birthday';

  @override
  String get lastContact => 'Last Contact';

  @override
  String get contactFrequency => 'Contact Frequency';

  @override
  String everyNDays(int count) {
    return 'Every $count days';
  }

  @override
  String get reminders => 'Reminders';

  @override
  String get noPendingTasks => 'No pending tasks.';

  @override
  String get archiveTitle => 'Archive';

  @override
  String get noArchivedReminders => 'No archived reminders.';

  @override
  String get activityLog => 'Activity Log';

  @override
  String get newTask => 'New Task / Reminder';

  @override
  String get taskName => 'Task Name';

  @override
  String get add => 'Add';

  @override
  String get trackingLate => 'Meeting Time Overdue!';

  @override
  String get trackingGood => 'Tracking Status Good';

  @override
  String daysSinceLastContact(int days) {
    return '$days days since last contact.';
  }

  @override
  String get call => 'Call';

  @override
  String get write => 'Email';

  @override
  String get sms => 'SMS';

  @override
  String shareContact(String name, Object email, Object phone) {
    return 'Contact Share:\nName: $name\nPhone: $phone\nEmail: $email\n\nShared via Aeterna Vault.';
  }

  @override
  String get addContactTitle => 'Add New Contact';

  @override
  String get addPrivateContactTitle => 'Add Private Contact';

  @override
  String get editContactTitle => 'Edit Contact';

  @override
  String get basicInfo => 'Basic Information';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get socialMedia => 'Social Media Link';

  @override
  String get professionalLocation => 'Professional & Location';

  @override
  String get company => 'Company';

  @override
  String get jobTitle => 'Job Title';

  @override
  String get address => 'Address';

  @override
  String get importantDates => 'Important Dates';

  @override
  String get anniversary => 'Anniversary / Special Day';

  @override
  String get relationshipManagement => 'Relationship Management';

  @override
  String get howWeKnow => 'How do we know each other?';

  @override
  String get tags => 'Tags (#tag1 #tag2)';

  @override
  String get saveAsPrivate => 'Save as Private (Vault)';

  @override
  String get notes => 'Notes';

  @override
  String get save => 'SAVE';

  @override
  String get imagePickError => 'Could not pick image.';

  @override
  String get securitySettingsTitle => 'Security Settings';

  @override
  String get appProtectionSettings => 'App protection settings';

  @override
  String securityScore(int score) {
    return 'Security Score: $score/100';
  }

  @override
  String get securityVeryStrong => 'Very strong — all protections active';

  @override
  String get enableBiometric => 'Enable biometrics';

  @override
  String get passwordSecurity => 'Password Security';

  @override
  String get masterKeyTitle => 'Master Password';

  @override
  String get lastChangedDaysAgo => 'Last changed: 45 days ago';

  @override
  String get change => 'Change';

  @override
  String get passwordHints => 'Password Hints';

  @override
  String get showHintOnLogin => 'Show hint on login screen';

  @override
  String get biometricId => 'Biometric Identity';

  @override
  String get fingerprint => 'Fingerprint';

  @override
  String get fingerprintEnabled => 'Enabled — quick login active';

  @override
  String get fingerprintDisabled => 'Disabled';

  @override
  String get active => 'Active';

  @override
  String get autoLock => 'Auto Lock';

  @override
  String get autoLockSubtitle => 'Lock after 1 minute of inactivity';

  @override
  String get accountSecurity => 'Account Security';

  @override
  String get recoveryCode => 'Recovery Code';

  @override
  String get recoveryCodeExists => 'You have an existing code.';

  @override
  String get recoveryCodeHint => '12-word recovery key';

  @override
  String get backupRestore => 'Backup & Restore';

  @override
  String get backup => 'Backup';

  @override
  String get backupDone => 'Backed up ✓';

  @override
  String get restore => 'Restore';

  @override
  String get dangerZone => 'Danger Zone';

  @override
  String get factoryReset => 'Factory Reset';

  @override
  String get deleteAllPermanently => 'Permanently delete all data';

  @override
  String get doFactoryReset => 'Perform Factory Reset';

  @override
  String get factoryResetConfirmTitle => 'Factory Reset';

  @override
  String get factoryResetConfirmContent =>
      'All data will be permanently deleted. This action cannot be undone!';

  @override
  String get confirmAndDelete => 'CONFIRM AND DELETE';

  @override
  String get recoveryCodeGenerated => 'Recovery Code Generated';

  @override
  String get saveNote => 'Please note it in a safe place:';

  @override
  String get saveAndClose => 'SAVE AND CLOSE';

  @override
  String get dataBackupTitle => 'Data Backup (JSON)';

  @override
  String get backupInstructions =>
      'Copy the text below and store it in a safe place:';

  @override
  String get copyAndClose => 'COPY AND CLOSE';

  @override
  String get backupCopied => 'Backup copied to clipboard!';

  @override
  String get restoreFromBackup => 'Restore from Backup';

  @override
  String get restoreWarning =>
      'Paste backup text. CURRENT DATA WILL BE DELETED!';

  @override
  String get restoreSuccess => 'Data restored successfully!';

  @override
  String get restoreError => 'Error: Invalid format.';

  @override
  String get changePassword => 'Change Password';

  @override
  String get oldPassword => 'Old Password';

  @override
  String get newPassword => 'New Password (min 8 characters)';

  @override
  String get update => 'Update';

  @override
  String get passwordUpdated => 'Password updated.';

  @override
  String get oldPasswordWrong => 'Old password is incorrect!';

  @override
  String get passwordRequirements =>
      'Password must be at least 8 characters with letters and numbers.';

  @override
  String get generalSettingsTitle => 'General Settings';

  @override
  String get appearanceMode => 'Appearance Mode';

  @override
  String get darkModeActive => 'Dark Theme Active';

  @override
  String get lightModeActive => 'Light Theme Active';

  @override
  String get themeModeTip => 'Switch mode to reduce eye strain.';

  @override
  String get appIdentityColor => 'App Identity (Color)';

  @override
  String get colorAutoAdapt =>
      'All app tones automatically adapt to your selected color.';

  @override
  String get dataSecurity => 'Data & Security';

  @override
  String get factoryRestoreTitle => 'Factory Reset';

  @override
  String get factoryRestoreSubtitle =>
      'Permanently clears all contacts, vault and settings.';

  @override
  String get permanentDeleteTitle => 'Permanently Delete Data?';

  @override
  String get permanentDeleteContent =>
      'This action cannot be undone. All secret documents and CRM records in your vault will be lost.';

  @override
  String get cancelUpper => 'CANCEL';

  @override
  String get deleteAndReset => 'DELETE AND RESET';

  @override
  String get appResetSuccess => 'App successfully reset.';

  @override
  String get versionInfo => 'Aeterna Vault v1.0';

  @override
  String get language => 'Language';

  @override
  String get languageTurkish => 'Turkish';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageGerman => 'German';

  @override
  String get languageItalian => 'Italian';

  @override
  String get aboutTitle => 'About';

  @override
  String get version => 'Version 1.0';

  @override
  String get dataSafetyTitle => 'Data Security';

  @override
  String get dataSafetyContent =>
      'Aeterna Vault never sends your data to any server or cloud service. All your contacts, passwords and notes are stored only on this device in an encrypted database.';

  @override
  String get developerTitle => 'Developer';

  @override
  String get developerContent =>
      'This app was developed with the goal of privacy and secure management of personal data.';

  @override
  String get contactFeedbackTitle => 'Contact & Feedback';

  @override
  String get contactFeedbackContent =>
      'For bug reports or feature suggestions, you can reach us:';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get copyright => '© 2026 Aeterna Vault. All rights reserved.';

  @override
  String get vaultSetupTitle => 'Vault Password Setup';

  @override
  String get setupVaultTitle => 'Set Up Your Secure Vault';

  @override
  String get setupVaultSubtitle =>
      'This password will be used to protect data in your vault. Please choose a secure password.';

  @override
  String get masterKeyLabel => 'Master Key (Main Password)';

  @override
  String get minEightChars => 'Enter at least 8 characters';

  @override
  String get mustContainLetterDigit => 'Must contain letters and numbers';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get enableBiometricAuth => 'Enable Biometric Authentication';

  @override
  String get useFingerprintForQuickLogin => 'Use fingerprint for quick login.';

  @override
  String get saveAndActivate => 'SAVE PASSWORD AND ACTIVATE';

  @override
  String get vaultPasswordSaved =>
      'Your vault password and preferences have been saved!';

  @override
  String get categoryWork => 'Work';

  @override
  String get categoryFamily => 'Family';

  @override
  String get categoryFriend => 'Friend';

  @override
  String get categoryCustomer => 'Customer';

  @override
  String get categorySupplier => 'Supplier';

  @override
  String get categoryOther => 'Other';

  @override
  String get deleteVaultItem => 'Delete from Vault';

  @override
  String deleteVaultItemConfirm(String title) {
    return 'Are you sure you want to permanently delete \"$title\"?';
  }

  @override
  String get clipboardCleared => 'Clipboard cleared after 30 seconds';

  @override
  String get autoLockEnabled => 'Enabled — lock when backgrounded';

  @override
  String get autoLockDisabled => 'Disabled';

  @override
  String get shareBackup => 'Share Backup';

  @override
  String get backupShared => 'Backup shared!';

  @override
  String get biometricReason => 'Authenticate to access the Vault';

  @override
  String get connectionSource => 'Connection Source';

  @override
  String get deleteContact => 'Delete Contact';

  @override
  String get deleteContactConfirm =>
      'Are you sure you want to delete this contact?';

  @override
  String get sendEmail => 'Send Email';

  @override
  String get sendSms => 'Send SMS';

  @override
  String get openWhatsapp => 'Open in WhatsApp';

  @override
  String get cannotLaunch => 'Could not open app';

  @override
  String get confirmDelete => 'Confirm Delete';

  @override
  String get delete => 'Delete';

  @override
  String get addNote => 'Add Note';

  @override
  String get addNoteHint => 'Write your note about this contact...';

  @override
  String get backupSaved => 'Backup saved';

  @override
  String get manualNote => 'Note';

  @override
  String get comingSoon => 'This feature is coming soon';

  @override
  String get onbSkip => 'Skip';

  @override
  String get onbContinue => 'Continue';

  @override
  String get onbStart => 'Get Started';

  @override
  String get onbTitle1 => 'Aeterna Vault';

  @override
  String get onbDesc1 =>
      'Your personal CRM and digital vault. Your data stays only in your hands.';

  @override
  String get onbTitle2 => 'Military-Grade Encryption';

  @override
  String get onbDesc2 =>
      'All your data is protected with AES-256-CBC encryption. No one can access it without your master password.';

  @override
  String get onbTitle3 => 'Private Contact Management';

  @override
  String get onbDesc3 =>
      'Store your private contacts, passwords and sensitive documents in one secure place.';

  @override
  String get onbFeat2a => 'AES-256 Encryption';

  @override
  String get onbFeat2b => 'Biometric Lock';

  @override
  String get onbFeat2c => 'No Data Sharing';

  @override
  String get onbFeat3a => 'Private Contacts';

  @override
  String get onbFeat3b => 'Smart Reminders';

  @override
  String get onbFeat3c => 'Secure Backup';

  @override
  String get autofillSectionTitle => 'Autofill';

  @override
  String get autofillServiceTitle => 'Aeterna Vault Autofill';

  @override
  String get autofillServiceDesc => 'Auto-fill your passwords in other apps';

  @override
  String get autofillServiceEnable => 'Enable';

  @override
  String get autofillServiceEnabled =>
      'Active — Aeterna Vault is your autofill provider';

  @override
  String get autofillServiceDisabled => 'Disabled — Tap to enable';

  @override
  String get passwordLength => 'Password Length';

  @override
  String get secNeverChanged => 'Never changed';

  @override
  String get secLastChangedToday => 'Last changed today';

  @override
  String get secLastChangedYesterday => 'Last changed yesterday';

  @override
  String secLastChangedDaysAgo(int days) {
    return 'Last changed $days days ago';
  }

  @override
  String get backupDesc => 'Share backup as encrypted JSON file';

  @override
  String get restoreEnterMasterKey => 'Enter the backup master key';

  @override
  String get restoreFailed => 'Restore failed. Master key may be incorrect.';

  @override
  String get invalidBackupFile => 'Invalid backup file.';
}
