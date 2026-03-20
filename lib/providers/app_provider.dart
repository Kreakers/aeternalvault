import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../models/vault_item.dart';
import '../models/reminder.dart';
import '../models/log_entry.dart';
import '../services/database_service.dart';
import '../services/encryption_service.dart';

class AppProvider with ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  final EncryptionService _encryptionService = EncryptionService();

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
  String? get vaultMasterKey => _vaultMasterKey;

  bool _useBiometrics = false;
  bool get useBiometrics => _useBiometrics;

  DateTime? _lastVaultUnlockTime;
  DateTime? get lastVaultUnlockTime => _lastVaultUnlockTime;

  String? _recoveryCode;
  bool get hasRecoveryCode => _recoveryCode != null && _recoveryCode!.isNotEmpty;

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

  Future<void> loadContacts() async {
    _contacts = await _dbService.getContacts();
    _allReminders = await _dbService.getReminders();
    _allLogs = await _dbService.getLogs();
    await checkVaultStatus();
    notifyListeners();
  }

  Future<void> checkVaultStatus() async {
    final settings = await _dbService.getVaultSettings();
    if (settings != null) {
      _isVaultSetupComplete = settings['isSetupComplete'] == 1;
      _vaultMasterKey = settings['hashedMasterKey'];
      _useBiometrics = settings['useBiometrics'] == 1;
      _recoveryCode = settings['recoveryCode'];
      _themeColor = Color(settings['themeColor'] ?? 4279935870);
      _isDarkMode = (settings['isDarkMode'] ?? 1) == 1;
      final localeCode = settings['locale'] as String? ?? 'tr';
      _locale = Locale(localeCode);
      _autoLockEnabled = (settings['autoLockEnabled'] ?? 0) == 1;
      _autoLockMinutes = settings['autoLockMinutes'] ?? 1;
      if (settings['lastUnlockTime'] != null) {
        _lastVaultUnlockTime = DateTime.tryParse(settings['lastUnlockTime']);
      }
    }
  }

  Future<void> _addLog(String action, {int? contactId}) async {
    final log = LogEntry(contactId: contactId, action: action, timestamp: DateTime.now());
    await _dbService.insertLog(log);
    _allLogs = await _dbService.getLogs();
  }

  Future<void> addManualNote(int contactId, String note) async {
    final log = LogEntry(
      contactId: contactId,
      action: note,
      timestamp: DateTime.now(),
      isManual: true,
    );
    await _dbService.insertLog(log);
    _allLogs = await _dbService.getLogs();
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
  Future<bool> updateMasterKey(String oldKey, String newKey) async {
    if (oldKey != _vaultMasterKey) return false;
    await _dbService.updateVaultSettings({'hashedMasterKey': newKey});
    await _addLog('Kasa ana şifresi değiştirildi');
    await checkVaultStatus();
    return true;
  }

  Future<void> updateBiometricPref(bool useBio) async {
    await _dbService.updateVaultSettings({'useBiometrics': useBio ? 1 : 0});
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

  Future<void> updateRecoveryCode(String code) async {
    await _dbService.updateVaultSettings({'recoveryCode': code});
    await _addLog('Kurtarma kodu güncellendi');
    await checkVaultStatus();
  }

  // --- Stats ---
  int get totalContacts => _contacts.where((c) => !c.isPrivate).length;
  int get privateContactsCount => _contacts.where((c) => c.isPrivate).length;
  int get totalVaultItems => _vaultItems.length;

  // --- CRM & Reminders ---
  Future<void> addContact(Contact contact) async {
    final id = await _dbService.insertContact(contact);
    await _addLog('Kişi sisteme dahil edildi', contactId: id);
    await loadContacts();
  }

  Future<void> updateContact(Contact contact) async {
    await _dbService.updateContact(contact);
    await _addLog('Kişi bilgileri güncellendi', contactId: contact.id);
    await loadContacts();
  }

  Future<void> deleteContact(int id) async {
    await _dbService.deleteContact(id);
    await loadContacts();
  }

  Future<void> addReminder(Reminder reminder) async {
    await _dbService.insertReminder(reminder);
    await _addLog('Yeni görev eklendi: ${reminder.title}', contactId: reminder.contactId);
    await loadContacts();
  }

  Future<void> updateReminder(Reminder reminder) async {
    await _dbService.updateReminder(reminder);
    if (reminder.isCompleted) {
      await _addLog('Görev tamamlandı: ${reminder.title}', contactId: reminder.contactId);
    }
    await loadContacts();
  }

  Future<void> deleteReminder(int id) async {
    await _dbService.deleteReminder(id);
    await loadContacts();
  }

  // --- Vault ---
  Future<bool> unlockVault(String masterKey) async {
    if (_isVaultSetupComplete && _vaultMasterKey != masterKey) return false;
    try {
      _encryptionService.init(masterKey);
      _isVaultUnlocked = true;
      final now = DateTime.now();
      await _dbService.updateVaultSettings({'lastUnlockTime': now.toIso8601String()});
      await loadVaultItems();
      return true;
    } catch (e) { return false; }
  }

  void lockVault() {
    _isVaultUnlocked = false;
    _vaultItems = [];
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
    await _dbService.insertVaultItem(encryptedItem);
    await _addLog('Kasa öğesi eklendi: ${item.title}');
    await loadVaultItems();
  }

  Future<void> updateVaultItem(VaultItem item) async {
    if (!_isVaultUnlocked) return;
    final encryptedSecret = _encryptionService.encryptData(item.secretContent);
    final encryptedItem = item.copyWith(secretContent: encryptedSecret);
    await _dbService.updateVaultItem(encryptedItem);
    await loadVaultItems();
  }

  Future<void> deleteVaultItem(int id) async {
    if (!_isVaultUnlocked) return;
    await _dbService.deleteVaultItem(id);
    await loadVaultItems();
  }

  // --- Reset & Backup ---
  Future<void> completeVaultSetup(String masterKey, bool useBio) async {
    await _dbService.updateVaultSettings({
      'isSetupComplete': 1,
      'hashedMasterKey': masterKey,
      'useBiometrics': useBio ? 1 : 0,
    });
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
    final backupData = {
      'contacts': allContacts.map((c) => c.toMap()).toList(),
      'vault_items': allVaultItems.map((v) => v.toMap()).toList(),
      'reminders': allReminders.map((r) => r.toMap()).toList(),
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
}
