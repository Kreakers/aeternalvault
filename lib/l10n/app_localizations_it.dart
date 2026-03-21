// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Aeterna Vault';

  @override
  String get appSubtitle => 'CRM & Cassaforte Sicura';

  @override
  String get contacts => 'Contatti';

  @override
  String get digitalVault => 'Cassaforte Digitale';

  @override
  String get activateVault => 'Attiva Cassaforte';

  @override
  String get securitySettings => 'Impostazioni di Sicurezza';

  @override
  String get generalSettings => 'Impostazioni Generali';

  @override
  String get about => 'Informazioni';

  @override
  String get overview => 'PANORAMICA';

  @override
  String personsCount(int count) {
    return '$count contatti';
  }

  @override
  String vaultCount(int count) {
    return '$count cassaforte';
  }

  @override
  String totalContacts(int count) {
    return '$count Contatti';
  }

  @override
  String get totalContactsSub => 'Totale contatti';

  @override
  String vaultItems(int count) {
    return '$count Oggetti Cassaforte';
  }

  @override
  String get encryptedRecord => 'Registro crittografato';

  @override
  String get contactNotFound => 'Nessun contatto trovato.';

  @override
  String get vaultLock => 'Blocco Cassaforte';

  @override
  String get masterKey => 'Chiave Principale';

  @override
  String get cancel => 'Annulla';

  @override
  String get login => 'Accedi';

  @override
  String get vaultUnlockFailed => 'Impossibile sbloccare la cassaforte!';

  @override
  String get searchHint => 'Cerca per nome o telefono...';

  @override
  String birthdayAlert(String name) {
    return 'Oggi è il compleanno di $name! 🎂';
  }

  @override
  String meetingAlert(String name) {
    return 'È ora di contattare $name. 📞';
  }

  @override
  String get vaultScreenTitle => 'Cassaforte Digitale';

  @override
  String encryptedRecordsCount(int count) {
    return '$count registri crittografati';
  }

  @override
  String get protected => 'Protetto';

  @override
  String get hiddenContacts => 'Contatti Privati';

  @override
  String get documentsPasswords => 'Documenti e Password';

  @override
  String get noHiddenContacts => 'Nessun contatto privato';

  @override
  String get addWithPlusButton => 'Premi + per aggiungere';

  @override
  String get vaultEmpty => 'La cassaforte è vuota';

  @override
  String get filterAll => 'Tutti';

  @override
  String get filterPasswords => 'Password';

  @override
  String get filterBank => 'Banca';

  @override
  String get filterDocuments => 'Documenti';

  @override
  String get fileNotFound => 'File non trovato!';

  @override
  String get fileOpenError => 'Impossibile aprire il file.';

  @override
  String get openFile => 'Apri File';

  @override
  String get addVaultItem => 'Aggiungi Oggetto Cassaforte';

  @override
  String get editVaultItem => 'Modifica Oggetto';

  @override
  String get titleHint => 'Titolo (es. MetaMask Wallet)';

  @override
  String get required => 'Obbligatorio';

  @override
  String get category => 'Categoria';

  @override
  String get secretData => 'Dati Segreti';

  @override
  String get generatePassword => 'Genera Password';

  @override
  String get passwordGenerated => 'Password sicura generata!';

  @override
  String get fileAttachment => 'File / Allegato (PDF, Immagine ecc.)';

  @override
  String get additionalNotes => 'Note Aggiuntive';

  @override
  String get saveEncrypted => 'SALVA CRITTOGRAFATO';

  @override
  String get selectFile => 'Seleziona File (PDF, Immagine ecc.)';

  @override
  String get fileReady => 'File Pronto';

  @override
  String get filePickError => 'Impossibile selezionare il file.';

  @override
  String saveError(String error) {
    return 'Errore di salvataggio: $error';
  }

  @override
  String get decryptionError =>
      'Questo record non può essere letto. È stato probabilmente crittografato con una chiave principale diversa. Puoi ricompilare i campi e salvare nuovamente.';

  @override
  String get usernameEmail => 'Nome utente / Email';

  @override
  String get password => 'Password';

  @override
  String get websiteUrl => 'URL del sito web';

  @override
  String get walletAddress => 'Indirizzo Wallet (Chiave pubblica)';

  @override
  String get seedPhrase => 'Seed Phrase (12/24 Parole)';

  @override
  String get network => 'Rete (es. Ethereum, BTC)';

  @override
  String get ibanAccount => 'IBAN / Numero di conto';

  @override
  String get bankName => 'Nome Banca';

  @override
  String get branchInfo => 'Filiale / Info aggiuntive';

  @override
  String get serialId => 'Nr. Seriale / Numero ID';

  @override
  String get documentType => 'Tipo Documento (es. Passaporto)';

  @override
  String get expiryDate => 'Data di Scadenza';

  @override
  String get noteContent => 'Contenuto Nota';

  @override
  String get categoryPassword => 'Password';

  @override
  String get categoryBank => 'Banca';

  @override
  String get categoryDocument => 'Documento';

  @override
  String get categoryCrypto => 'Wallet Cripto';

  @override
  String get categorySecretNote => 'Nota Segreta';

  @override
  String get contactDetail => 'Dettaglio Contatto';

  @override
  String get contactInfo => 'Informazioni di Contatto';

  @override
  String get phone => 'Telefono';

  @override
  String get email => 'Email';

  @override
  String get birthday => 'Compleanno';

  @override
  String get lastContact => 'Ultimo Contatto';

  @override
  String get contactFrequency => 'Frequenza di Contatto';

  @override
  String everyNDays(int count) {
    return 'Ogni $count giorni';
  }

  @override
  String get reminders => 'Promemoria';

  @override
  String get noPendingTasks => 'Nessun compito in sospeso.';

  @override
  String get archiveTitle => 'Archivio';

  @override
  String get noArchivedReminders => 'Nessun promemoria archiviato.';

  @override
  String get activityLog => 'Registro Attività';

  @override
  String get newTask => 'Nuovo Compito / Promemoria';

  @override
  String get taskName => 'Nome Compito';

  @override
  String get add => 'Aggiungi';

  @override
  String get trackingLate => 'Tempo di Contatto Scaduto!';

  @override
  String get trackingGood => 'Stato Tracciamento Buono';

  @override
  String daysSinceLastContact(int days) {
    return '$days giorni dall\'ultimo contatto.';
  }

  @override
  String get call => 'Chiama';

  @override
  String get write => 'Email';

  @override
  String get sms => 'SMS';

  @override
  String shareContact(String name, String phone, String email) {
    return 'Condivisione Contatto:\nNome: $name\nTelefono: $phone\nEmail: $email\n\nCondiviso tramite Aeterna Vault.';
  }

  @override
  String get addContactTitle => 'Aggiungi Nuovo Contatto';

  @override
  String get addPrivateContactTitle => 'Aggiungi Contatto Privato';

  @override
  String get editContactTitle => 'Modifica Contatto';

  @override
  String get basicInfo => 'Informazioni di Base';

  @override
  String get firstName => 'Nome';

  @override
  String get lastName => 'Cognome';

  @override
  String get socialMedia => 'Link Social Media';

  @override
  String get professionalLocation => 'Professionale & Posizione';

  @override
  String get company => 'Azienda';

  @override
  String get jobTitle => 'Titolo di Lavoro';

  @override
  String get address => 'Indirizzo';

  @override
  String get importantDates => 'Date Importanti';

  @override
  String get anniversary => 'Anniversario / Giorno Speciale';

  @override
  String get relationshipManagement => 'Gestione Relazioni';

  @override
  String get howWeKnow => 'Come ci conosciamo?';

  @override
  String get tags => 'Tag (#tag1 #tag2)';

  @override
  String get saveAsPrivate => 'Salva come Privato (Cassaforte)';

  @override
  String get notes => 'Note';

  @override
  String get save => 'SALVA';

  @override
  String get imagePickError => 'Impossibile selezionare l\'immagine.';

  @override
  String get securitySettingsTitle => 'Impostazioni di Sicurezza';

  @override
  String get appProtectionSettings => 'Impostazioni di protezione app';

  @override
  String securityScore(int score) {
    return 'Punteggio Sicurezza: $score/100';
  }

  @override
  String get securityVeryStrong => 'Molto forte — tutte le protezioni attive';

  @override
  String get enableBiometric => 'Abilita biometria';

  @override
  String get passwordSecurity => 'Sicurezza Password';

  @override
  String get masterKeyTitle => 'Password Principale';

  @override
  String get lastChangedDaysAgo => 'Ultima modifica: 45 giorni fa';

  @override
  String get change => 'Cambia';

  @override
  String get passwordHints => 'Suggerimenti Password';

  @override
  String get showHintOnLogin =>
      'Mostra suggerimento nella schermata di accesso';

  @override
  String get biometricId => 'Identità Biometrica';

  @override
  String get fingerprint => 'Impronta Digitale';

  @override
  String get fingerprintEnabled => 'Abilitato — accesso rapido attivo';

  @override
  String get fingerprintDisabled => 'Disabilitato';

  @override
  String get active => 'Attivo';

  @override
  String get autoLock => 'Blocco Automatico';

  @override
  String get autoLockSubtitle => 'Blocca dopo 1 minuto di inattività';

  @override
  String get accountSecurity => 'Sicurezza Account';

  @override
  String get recoveryCode => 'Codice di Recupero';

  @override
  String get recoveryCodeExists => 'Hai un codice esistente.';

  @override
  String get recoveryCodeHint => 'Chiave di recupero a 12 parole';

  @override
  String get backupRestore => 'Backup & Ripristino';

  @override
  String get backup => 'Backup';

  @override
  String get backupDone => 'Salvato ✓';

  @override
  String get restore => 'Ripristina';

  @override
  String get dangerZone => 'Zona Pericolo';

  @override
  String get factoryReset => 'Ripristino di Fabbrica';

  @override
  String get deleteAllPermanently => 'Elimina definitivamente tutti i dati';

  @override
  String get doFactoryReset => 'Esegui Ripristino di Fabbrica';

  @override
  String get factoryResetConfirmTitle => 'Ripristino di Fabbrica';

  @override
  String get factoryResetConfirmContent =>
      'Tutti i dati verranno eliminati definitivamente. Questa azione non può essere annullata!';

  @override
  String get confirmAndDelete => 'CONFERMA ED ELIMINA';

  @override
  String get recoveryCodeGenerated => 'Codice di Recupero Generato';

  @override
  String get saveNote => 'Si prega di annotarlo in un luogo sicuro:';

  @override
  String get saveAndClose => 'SALVA E CHIUDI';

  @override
  String get dataBackupTitle => 'Backup Dati (JSON)';

  @override
  String get backupInstructions =>
      'Copia il testo sottostante e conservalo in un posto sicuro:';

  @override
  String get copyAndClose => 'COPIA E CHIUDI';

  @override
  String get backupCopied => 'Backup copiato negli appunti!';

  @override
  String get restoreFromBackup => 'Ripristina da Backup';

  @override
  String get restoreWarning =>
      'Incolla il testo del backup. I DATI ATTUALI VERRANNO ELIMINATI!';

  @override
  String get restoreSuccess => 'Dati ripristinati con successo!';

  @override
  String get restoreError => 'Errore: Formato non valido.';

  @override
  String get changePassword => 'Cambia Password';

  @override
  String get oldPassword => 'Vecchia Password';

  @override
  String get newPassword => 'Nuova Password (min 8 caratteri)';

  @override
  String get update => 'Aggiorna';

  @override
  String get passwordUpdated => 'Password aggiornata.';

  @override
  String get oldPasswordWrong => 'La vecchia password non è corretta!';

  @override
  String get passwordRequirements =>
      'La password deve essere di almeno 8 caratteri con lettere e numeri.';

  @override
  String get generalSettingsTitle => 'Impostazioni Generali';

  @override
  String get appearanceMode => 'Modalità Aspetto';

  @override
  String get darkModeActive => 'Tema Scuro Attivo';

  @override
  String get lightModeActive => 'Tema Chiaro Attivo';

  @override
  String get themeModeTip =>
      'Cambia modalità per ridurre l\'affaticamento degli occhi.';

  @override
  String get appIdentityColor => 'Identità App (Colore)';

  @override
  String get colorAutoAdapt =>
      'Tutte le tonalità dell\'app si adattano automaticamente al colore selezionato.';

  @override
  String get dataSecurity => 'Dati e Sicurezza';

  @override
  String get factoryRestoreTitle => 'Ripristino Impostazioni di Fabbrica';

  @override
  String get factoryRestoreSubtitle =>
      'Elimina definitivamente tutti i contatti, la cassaforte e le impostazioni.';

  @override
  String get permanentDeleteTitle => 'Eliminare i Dati Definitivamente?';

  @override
  String get permanentDeleteContent =>
      'Questa azione non può essere annullata. Tutti i documenti segreti e i record CRM nella tua cassaforte andranno persi.';

  @override
  String get cancelUpper => 'ANNULLA';

  @override
  String get deleteAndReset => 'ELIMINA E RIPRISTINA';

  @override
  String get appResetSuccess => 'App ripristinata con successo.';

  @override
  String get versionInfo => 'Aeterna Vault v1.0';

  @override
  String get language => 'Lingua';

  @override
  String get languageTurkish => 'Turco';

  @override
  String get languageEnglish => 'Inglese';

  @override
  String get languageGerman => 'Tedesco';

  @override
  String get languageItalian => 'Italiano';

  @override
  String get aboutTitle => 'Informazioni';

  @override
  String get version => 'Versione 1.0';

  @override
  String get dataSafetyTitle => 'Sicurezza Dati';

  @override
  String get dataSafetyContent =>
      'Aeterna Vault non invia mai i tuoi dati a nessun server o servizio cloud. Tutti i tuoi contatti, password e note sono memorizzati solo su questo dispositivo in un database crittografato.';

  @override
  String get developerTitle => 'Sviluppatore';

  @override
  String get developerContent =>
      'Questa app è stata sviluppata con l\'obiettivo della privacy e della gestione sicura dei dati personali.';

  @override
  String get contactFeedbackTitle => 'Contatto & Feedback';

  @override
  String get contactFeedbackContent =>
      'Per segnalazioni di bug o suggerimenti di funzionalità, puoi contattarci:';

  @override
  String get privacyPolicy => 'Informativa sulla Privacy';

  @override
  String get copyright => '© 2026 Aeterna Vault. Tutti i diritti riservati.';

  @override
  String get vaultSetupTitle => 'Configurazione Password Cassaforte';

  @override
  String get setupVaultTitle => 'Configura la tua Cassaforte Sicura';

  @override
  String get setupVaultSubtitle =>
      'Questa password verrà utilizzata per proteggere i dati nella tua cassaforte. Si prega di scegliere una password sicura.';

  @override
  String get masterKeyLabel => 'Chiave Principale (Password Principale)';

  @override
  String get minEightChars => 'Inserisci almeno 8 caratteri';

  @override
  String get mustContainLetterDigit => 'Deve contenere lettere e numeri';

  @override
  String get confirmPassword => 'Conferma Password';

  @override
  String get passwordsDoNotMatch => 'Le password non corrispondono';

  @override
  String get enableBiometricAuth => 'Abilita Autenticazione Biometrica';

  @override
  String get useFingerprintForQuickLogin =>
      'Usa l\'impronta digitale per l\'accesso rapido.';

  @override
  String get saveAndActivate => 'SALVA PASSWORD E ATTIVA';

  @override
  String get vaultPasswordSaved =>
      'La tua password della cassaforte e le tue preferenze sono state salvate!';

  @override
  String get categoryWork => 'Lavoro';

  @override
  String get categoryFamily => 'Famiglia';

  @override
  String get categoryFriend => 'Amico';

  @override
  String get categoryCustomer => 'Cliente';

  @override
  String get categorySupplier => 'Fornitore';

  @override
  String get categoryOther => 'Altro';

  @override
  String get deleteVaultItem => 'Elimina dal caveau';

  @override
  String deleteVaultItemConfirm(String title) {
    return 'Sei sicuro di voler eliminare definitivamente \"$title\"?';
  }

  @override
  String get clipboardCleared => 'Appunti cancellati dopo 30 secondi';

  @override
  String get autoLockEnabled => 'Abilitato — blocca in background';

  @override
  String get autoLockDisabled => 'Disabilitato';

  @override
  String get shareBackup => 'Condividi Backup';

  @override
  String get backupShared => 'Backup condiviso!';

  @override
  String get biometricReason => 'Autenticati per accedere alla cassaforte';

  @override
  String get connectionSource => 'Fonte di Contatto';

  @override
  String get deleteContact => 'Elimina Contatto';

  @override
  String get deleteContactConfirm =>
      'Sei sicuro di voler eliminare questo contatto?';

  @override
  String get sendEmail => 'Invia Email';

  @override
  String get sendSms => 'Invia SMS';

  @override
  String get openWhatsapp => 'Apri in WhatsApp';

  @override
  String get cannotLaunch => 'Impossibile aprire l\'app';

  @override
  String get confirmDelete => 'Conferma Eliminazione';

  @override
  String get delete => 'Elimina';

  @override
  String get addNote => 'Aggiungi nota';

  @override
  String get addNoteHint => 'Scrivi la tua nota su questo contatto...';

  @override
  String get backupSaved => 'Backup salvato';

  @override
  String get manualNote => 'Nota';

  @override
  String get comingSoon => 'Questa funzione sta arrivando presto';

  @override
  String get onbSkip => 'Salta';

  @override
  String get onbContinue => 'Continua';

  @override
  String get onbStart => 'Inizia';

  @override
  String get onbTitle1 => 'Aeterna Vault';

  @override
  String get onbDesc1 =>
      'Il tuo CRM personale e vault digitale. I tuoi dati rimangono solo nelle tue mani.';

  @override
  String get onbTitle2 => 'Crittografia di Livello Militare';

  @override
  String get onbDesc2 =>
      'Tutti i dati sono protetti con crittografia AES-256-CBC. Nessuno può accedervi senza la tua password principale.';

  @override
  String get onbTitle3 => 'Gestione Contatti Privata';

  @override
  String get onbDesc3 =>
      'Archivia i tuoi contatti privati, password e documenti sensibili in un unico posto sicuro.';

  @override
  String get onbFeat2a => 'Crittografia AES-256';

  @override
  String get onbFeat2b => 'Blocco Biometrico';

  @override
  String get onbFeat2c => 'Nessuna Condivisione';

  @override
  String get onbFeat3a => 'Contatti Privati';

  @override
  String get onbFeat3b => 'Promemoria Intelligenti';

  @override
  String get onbFeat3c => 'Backup Sicuro';

  @override
  String get autofillSectionTitle => 'Compilazione Automatica';

  @override
  String get autofillServiceTitle => 'Aeterna Vault Compilazione Automatica';

  @override
  String get autofillServiceDesc =>
      'Compila automaticamente le password in altre app';

  @override
  String get autofillServiceEnable => 'Attiva';

  @override
  String get autofillServiceEnabled =>
      'Attivo — Aeterna Vault è il tuo provider';

  @override
  String get autofillServiceDisabled => 'Disabilitato — Tocca per attivare';

  @override
  String get passwordLength => 'Lunghezza Password';

  @override
  String get secNeverChanged => 'Mai cambiata';

  @override
  String get secLastChangedToday => 'Cambiata oggi';

  @override
  String get secLastChangedYesterday => 'Cambiata ieri';

  @override
  String secLastChangedDaysAgo(int days) => 'Cambiata $days giorni fa';

  @override
  String get backupDesc => 'Condividi backup come file JSON crittografato';
}
