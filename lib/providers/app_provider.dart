import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/contact.dart';
import '../models/vault_item.dart';
import '../models/reminder.dart';
import '../models/log_entry.dart';
import '../services/database_service.dart';
import '../services/encryption_service.dart';
import '../services/notification_service.dart';

class AppProvider with ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  final EncryptionService _encryptionService = EncryptionService();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  List<Contact> _contacts = [];
  List<Contact> get contacts => _contacts;

  List<VaultItem> _vaultItems = [];
  List<VaultItem> get vaultItems => _vaultItems;

  List<Reminder> _allReminders = [];
  List<Reminder> get allReminders => _allReminders;

  List<LogEntry> _allLogs = [];
  List<LogEntry> get allLogs => _allLogs;

  bool _isVaultUnlocked = false;
  bool get isVaultUnlocked => _isVaultUnlocked;

  bool _isVaultSetupComplete = false;
  bool get isVaultSetupComplete => _isVaultSetupComplete;

  String? _vaultMasterKey;

  int _failedUnlockAttempts = 0;
  DateTime? _lastFailedAttempt;

  bool _useBiometrics = false;
  bool get useBiometrics => _useBiometrics;

  DateTime? _lastVaultUnlockTime;
  DateTime? get lastVaultUnlockTime => _lastVaultUnlockTime;

  bool _autoLockEnabled = false;
  bool get autoLockEnabled => _autoLockEnabled;

  int _autoLockMinutes = 1;
  int get autoLockMinutes => _autoLockMinutes;

  Color _themeColor = const Color(0xFF1A237E);
  Color get themeColor => _themeColor;

  bool _isDarkMode = true;
  bool get isDarkMode => _isDarkMode;

  Locale _locale = const Locale('tr');
  Locale get locale => _locale;

  bool _onboardingDone = false;
  bool get onboardingDone => _onboardingDone;

  DateTime? _masterKeyChangedAt;
  DateTime? get masterKeyChangedAt => _masterKeyChangedAt;

  Future<void> loadContacts() async {
    _contacts = await _dbService.getContacts();
    _allReminders = await _dbService.getReminders();
    _allLogs = await _dbService.getLogs();
    await checkVaultStatus();
    final done = await _secureStorage.read(key: 'onboarding_done');
    _onboardingDone = done == 'true';
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    _onboardingDone = true;
    await _secureStorage.write(key: 'onboarding_done', value: 'true');
    notifyListeners();
  }

  Future<void> checkVaultStatus() async {
    final settings = await _dbService.getVaultSettings();
    if (settings != null) {
      _isVaultSetupComplete = settings['isSetupComplete'] == 1;
      _vaultMasterKey = settings['hashedMasterKey'];
      _useBiometrics = settings['useBiometrics'] == 1;
      _themeColor = Color(settings['themeColor'] ?? 4279935870);
      _isDarkMode = (settings['isDarkMode'] ?? 1) == 1;
      final savedLocale = settings['locale'] as String?;
      _locale = Locale(_resolveLocale(savedLocale));
      _autoLockEnabled = (settings['autoLockEnabled'] ?? 0) == 1;
      _autoLockMinutes = settings['autoLockMinutes'] ?? 1;
      if (settings['lastUnlockTime'] != null) {
        _lastVaultUnlockTime = DateTime.tryParse(settings['lastUnlockTime']);
      }
      if (settings['masterKeyChangedAt'] != null) {
        _masterKeyChangedAt = DateTime.tryParse(settings['masterKeyChangedAt']);
      }
    }
  }

  static const _supportedLocales = ['tr', 'en', 'de', 'it'];

  String _resolveLocale(String? saved) {
    if (saved != null && _supportedLocales.contains(saved)) return saved;
    final systemLang = Platform.localeName.split('_').first;
    return _supportedLocales.contains(systemLang) ? systemLang : 'en';
  }

  Future<void> _addLog(String action, {int? contactId}) async {
    final log = LogEntry(contactId: contactId, action: action, timestamp: DateTime.now());
    final id = await _dbService.insertLog(log);
    _allLogs.insert(0, log.copyWith(id: id));
  }

  Future<void> addManualNote(int contactId, String note) async {
    final log = LogEntry(
      contactId: contactId,
      action: note,
      timestamp: DateTime.now(),
      isManual: true,
    );
    final id = await _dbService.insertLog(log);
    _allLogs.insert(0, log.copyWith(id: id));
    notifyListeners();
  }

  // --- Theme ---
  Future<void> updateThemeColor(Color color) async {
    _themeColor = color;
    await _dbService.updateVaultSettings({'themeColor': color.value});
    notifyListeners();
  }

  Future<void> toggleDarkMode(bool isDark) async {
    _isDarkMode = isDark;
    await _dbService.updateVaultSettings({'isDarkMode': isDark ? 1 : 0});
    notifyListeners();
  }

  // --- Locale ---
  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    await _dbService.updateVaultSettings({'locale': locale.languageCode});
    notifyListeners();
  }

  // --- Security ---
  static String _hashKey(String key) => sha256.convert(utf8.encode(key)).toString();

  Future<bool> updateMasterKey(String oldKey, String newKey) async {
    if (_vaultMasterKey == null) return false;
    final hashedOld = _hashKey(oldKey);
    if (_vaultMasterKey != hashedOld && _vaultMasterKey != oldKey) return false;
    final hashedNew = _hashKey(newKey);
    final now = DateTime.now().toIso8601String();
    await _dbService.updateVaultSettings({'hashedMasterKey': hashedNew, 'masterKeyChangedAt': now});
    _vaultMasterKey = hashedNew;
    _masterKeyChangedAt = DateTime.now();
    if (_useBiometrics) {
      await _secureStorage.write(key: 'vault_master_key', value: newKey);
    }
    await _addLog('Kasa ana şifresi değiştirildi');
    return true;
  }

  Future<void> updateBiometricPref(bool useBio) async {
    await _dbService.updateVaultSettings({'useBiometrics': useBio ? 1 : 0});
    if (!useBio) {
      await _secureStorage.delete(key: 'vault_master_key');
    }
    await checkVaultStatus();
    notifyListeners();
  }

  Future<void> updateAutoLock(bool enabled, {int? minutes}) async {
    _autoLockEnabled = enabled;
    if (minutes != null) _autoLockMinutes = minutes;
    await _dbService.updateVaultSettings({
      'autoLockEnabled': enabled ? 1 : 0,
      if (minutes != null) 'autoLockMinutes': minutes,
    });
    notifyListeners();
  }

  // --- Stats ---
  int get totalContacts => _contacts.where((c) => !c.isPrivate).length;
  int get privateContactsCount => _contacts.where((c) => c.isPrivate).length;
  int get totalVaultItems => _vaultItems.length;

  // --- CRM & Reminders ---
  Future<void> addContact(Contact contact) async {
    final id = await _dbService.insertContact(contact);
    final saved = contact.copyWith(id: id);
    _contacts.add(saved);
    await _addLog('Kişi sisteme dahil edildi', contactId: id);
    notifyListeners();
  }

  Future<void> updateContact(Contact contact) async {
    await _dbService.updateContact(contact);
    final idx = _contacts.indexWhere((c) => c.id == contact.id);
    if (idx != -1) _contacts[idx] = contact;
    await _addLog('Kişi bilgileri güncellendi', contactId: contact.id);
    notifyListeners();
  }

  Future<void> deleteContact(int id) async {
    await _dbService.deleteContact(id);
    _contacts.removeWhere((c) => c.id == id);
    _allReminders.removeWhere((r) => r.contactId == id);
    _allLogs.removeWhere((l) => l.contactId == id);
    notifyListeners();
  }

  Future<void> addReminder(Reminder reminder) async {
    final id = await _dbService.insertReminder(reminder);
    final saved = reminder.copyWith(id: id);
    _allReminders.add(saved);
    notifyListeners();
    await _addLog('Yeni görev eklendi: ${reminder.title}', contactId: reminder.contactId);
    try {
      await NotificationService().scheduleReminder(
        id: id,
        title: '⏰ Hatırlatıcı',
        body: reminder.title,
        scheduledDate: reminder.dateTime,
      );
      // Onay bildirimi — kullanıcı bildirim sisteminin çalıştığını görsün
      await NotificationService().showNow(
        id: id + 100000,
        title: '✅ Hatırlatıcı Ayarlandı',
        body: reminder.title,
      );
    } catch (e) {
      debugPrint('⚠️ Bildirim zamanlanamadı: $e');
    }
  }

  Future<void> updateReminder(Reminder reminder) async {
    final idx = _allReminders.indexWhere((r) => r.id == reminder.id);
    if (idx != -1) _allReminders[idx] = reminder;
    notifyListeners();
    await _dbService.updateReminder(reminder);
    if (reminder.isCompleted && reminder.id != null) {
      try { await NotificationService().cancelReminder(reminder.id!); } catch (_) {}
      await _addLog('Görev tamamlandı: ${reminder.title}', contactId: reminder.contactId);
    }
  }

  Future<void> deleteReminder(int id) async {
    _allReminders.removeWhere((r) => r.id == id);
    notifyListeners();
    await _dbService.deleteReminder(id);
    try { await NotificationService().cancelReminder(id); } catch (_) {}
  }

  // --- Vault ---
  Future<bool> unlockVault(String masterKey) async {
    if (!_isVaultSetupComplete || _vaultMasterKey == null) return false;

    // Rate limiting: 3 başarısız denemeden sonra bekleme süresi
    if (_failedUnlockAttempts >= 3 && _lastFailedAttempt != null) {
      const waits = [5, 10, 20, 40, 60];
      final waitSec = waits[(_failedUnlockAttempts - 3).clamp(0, 4)];
      if (DateTime.now().difference(_lastFailedAttempt!).inSeconds < waitSec) {
        return false;
      }
    }

    final hashedInput = _hashKey(masterKey);
    bool isValid = false;

    if (_vaultMasterKey == hashedInput) {
      isValid = true;
    } else if (_vaultMasterKey == masterKey) {
      // Legacy plaintext → hash'e migrate et
      await _dbService.updateVaultSettings({'hashedMasterKey': hashedInput});
      _vaultMasterKey = hashedInput;
      isValid = true;
    }

    if (!isValid) {
      _failedUnlockAttempts++;
      _lastFailedAttempt = DateTime.now();
      return false;
    }

    _failedUnlockAttempts = 0;
    _lastFailedAttempt = null;

    try {
      _encryptionService.init(masterKey);
      _isVaultUnlocked = true;
      await _dbService.updateVaultSettings({'lastUnlockTime': DateTime.now().toIso8601String()});
      if (_useBiometrics) {
        await _secureStorage.write(key: 'vault_master_key', value: masterKey);
      }
      await loadVaultItems();
      return true;
    } catch (e) { return false; }
  }

  void lockVault() {
    _isVaultUnlocked = false;
    _vaultItems = [];
    _encryptionService.clear();
    notifyListeners();
  }

  Future<void> loadVaultItems() async {
    if (!_isVaultUnlocked) return;
    final items = await _dbService.getVaultItems();
    _vaultItems = items.map((item) {
      try {
        final decryptedSecret = _encryptionService.decryptData(item.secretContent);
        return item.copyWith(secretContent: decryptedSecret);
      } catch (e) {
        debugPrint('⚠️ VaultItem #${item.id} ("${item.title}") çözülemedi: $e');
        return item.copyWith(secretContent: '{"f1":"","f2":"","f3":"","_error":"decrypt_failed"}');
      }
    }).toList();
    notifyListeners();
  }

  Future<void> addVaultItem(VaultItem item) async {
    if (!_isVaultUnlocked) return;
    final encryptedSecret = _encryptionService.encryptData(item.secretContent);
    final encryptedItem = item.copyWith(secretContent: encryptedSecret);
    final id = await _dbService.insertVaultItem(encryptedItem);
    _vaultItems.add(item.copyWith(id: id));
    await _addLog('Kasa öğesi eklendi: ${item.title}');
    notifyListeners();
  }

  Future<void> updateVaultItem(VaultItem item) async {
    if (!_isVaultUnlocked) return;
    final encryptedSecret = _encryptionService.encryptData(item.secretContent);
    final encryptedItem = item.copyWith(secretContent: encryptedSecret);
    await _dbService.updateVaultItem(encryptedItem);
    final idx = _vaultItems.indexWhere((v) => v.id == item.id);
    if (idx != -1) _vaultItems[idx] = item;
    notifyListeners();
  }

  Future<void> deleteVaultItem(int id) async {
    if (!_isVaultUnlocked) return;
    await _dbService.deleteVaultItem(id);
    _vaultItems.removeWhere((v) => v.id == id);
    notifyListeners();
  }

  // --- Reset & Backup ---
  Future<void> completeVaultSetup(String masterKey, bool useBio) async {
    final now = DateTime.now().toIso8601String();
    await _dbService.updateVaultSettings({
      'isSetupComplete': 1,
      'hashedMasterKey': _hashKey(masterKey),
      'useBiometrics': useBio ? 1 : 0,
      'masterKeyChangedAt': now,
    });
    if (useBio) {
      await _secureStorage.write(key: 'vault_master_key', value: masterKey);
    }
    await checkVaultStatus();
    notifyListeners();
  }

  Future<void> performFactoryReset() async {
    await _dbService.factoryReset();
    _isVaultUnlocked = false;
    _isVaultSetupComplete = false;
    await loadContacts();
  }

  Future<String> generateBackup() async {
    final allContacts = await _dbService.getContacts();
    final allVaultItems = await _dbService.getVaultItems();
    final allReminders = await _dbService.getReminders();
    final settings = await _dbService.getVaultSettings();
    final backupData = {
      'contacts': allContacts.map((c) => c.toMap()).toList(),
      'vault_items': allVaultItems.map((v) => v.toMap()).toList(),
      'reminders': allReminders.map((r) => r.toMap()).toList(),
      'hashedMasterKey': settings?['hashedMasterKey'],
      'version': 1,
      'export_date': DateTime.now().toIso8601String(),
    };
    return jsonEncode(backupData);
  }

  Future<bool> restoreBackup(String jsonString) async {
    try {
      final Map<String, dynamic> backupData = jsonDecode(jsonString);
      await _dbService.clearAllData();
      if (backupData['contacts'] != null) {
        for (var item in backupData['contacts']) await _dbService.insertContact(Contact.fromMap(item));
      }
      if (backupData['vault_items'] != null) {
        for (var item in backupData['vault_items']) await _dbService.insertVaultItem(VaultItem.fromMap(item));
      }
      if (backupData['reminders'] != null) {
        for (var item in backupData['reminders']) await _dbService.insertReminder(Reminder.fromMap(item));
      }
      await loadContacts();
      return true;
    } catch (e) { return false; }
  }

  /// İlk kurulumda yedeği yükler. masterKey doğrulaması yapar,
  /// vault ayarlarını kurar ve vault'u açık hale getirir.
  Future<bool> restoreBackupOnSetup(String jsonString, String masterKey) async {
    try {
      final Map<String, dynamic> backupData = jsonDecode(jsonString);

      // Eğer backup'ta hashedMasterKey varsa doğrula
      final storedHash = backupData['hashedMasterKey'] as String?;
      if (storedHash != null && storedHash != _hashKey(masterKey)) {
        return false;
      }

      await _dbService.clearAllData();
      if (backupData['contacts'] != null) {
        for (var item in backupData['contacts']) await _dbService.insertContact(Contact.fromMap(item));
      }
      if (backupData['vault_items'] != null) {
        for (var item in backupData['vault_items']) await _dbService.insertVaultItem(VaultItem.fromMap(item));
      }
      if (backupData['reminders'] != null) {
        for (var item in backupData['reminders']) await _dbService.insertReminder(Reminder.fromMap(item));
      }

      // Vault ayarlarını kur (biometric opsiyonel — kullanıcı sonradan açabilir)
      await completeVaultSetup(masterKey, false);
      await unlockVault(masterKey);
      await loadContacts();
      return true;
    } catch (e) { return false; }
  }
}
