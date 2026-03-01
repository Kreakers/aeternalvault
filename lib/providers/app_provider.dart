import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../models/vault_item.dart';
import '../models/reminder.dart';
import '../services/database_service.dart';
import '../services/encryption_service.dart';

class AppProvider with ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  final EncryptionService _encryptionService = EncryptionService();

  List<Contact> _contacts = [];
  List<Contact> get contacts => _contacts;

  List<VaultItem> _vaultItems = [];
  List<VaultItem> get vaultItems => _vaultItems;

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

  // --- Theme Settings ---
  Color _themeColor = const Color(0xFF673AB7); // Default DeepPurple
  Color get themeColor => _themeColor;

  bool _isDarkMode = true;
  bool get isDarkMode => _isDarkMode;

  Future<void> loadContacts() async {
    _contacts = await _dbService.getContacts();
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
      _themeColor = Color(settings['themeColor'] ?? 4284572657);
      _isDarkMode = settings['isDarkMode'] == 1;
      if (settings['lastUnlockTime'] != null) {
        _lastVaultUnlockTime = DateTime.tryParse(settings['lastUnlockTime']);
      }
    }
  }

  Future<void> completeVaultSetup(String masterKey, bool useBio) async {
    await _dbService.updateVaultSettings({
      'isSetupComplete': 1,
      'hashedMasterKey': masterKey,
      'useBiometrics': useBio ? 1 : 0,
    });
    await checkVaultStatus();
    notifyListeners();
  }

  // --- Theme Updates ---
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

  // --- Security Updates ---
  Future<void> updateMasterKey(String newKey) async {
    await _dbService.updateVaultSettings({'hashedMasterKey': newKey});
    await checkVaultStatus();
    notifyListeners();
  }

  Future<void> updateBiometricPref(bool useBio) async {
    await _dbService.updateVaultSettings({'useBiometrics': useBio ? 1 : 0});
    await checkVaultStatus();
    notifyListeners();
  }

  Future<void> updateRecoveryCode(String code) async {
    await _dbService.updateVaultSettings({'recoveryCode': code});
    await checkVaultStatus();
    notifyListeners();
  }

  Future<void> performFactoryReset() async {
    await _dbService.factoryReset();
    _isVaultUnlocked = false;
    _isVaultSetupComplete = false;
    _vaultMasterKey = null;
    _contacts = [];
    _vaultItems = [];
    await loadContacts();
  }

  // --- Backup & Restore ---
  Future<String> generateBackup() async {
    final allContacts = await _dbService.getContacts();
    final allVaultItems = await _dbService.getVaultItems();
    final allReminders = await _dbService.getAllReminders();

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
        for (var item in backupData['contacts']) {
          await _dbService.insertContact(Contact.fromMap(item));
        }
      }
      if (backupData['vault_items'] != null) {
        for (var item in backupData['vault_items']) {
          await _dbService.insertVaultItem(VaultItem.fromMap(item));
        }
      }
      if (backupData['reminders'] != null) {
        for (var item in backupData['reminders']) {
          await _dbService.insertReminder(Reminder.fromMap(item));
        }
      }
      await loadContacts();
      return true;
    } catch (e) {
      return false;
    }
  }

  // --- Dashboard Stats ---
  int get totalContacts => _contacts.where((c) => !c.isPrivate).length;
  int get privateContactsCount => _contacts.where((c) => c.isPrivate).length;
  int get totalVaultItems => _vaultItems.length;

  // --- Contacts CRUD ---
  Future<void> addContact(Contact contact) async {
    await _dbService.insertContact(contact);
    await loadContacts();
  }

  Future<void> updateContact(Contact contact) async {
    await _dbService.updateContact(contact);
    await loadContacts();
  }

  Future<void> deleteContact(int id) async {
    await _dbService.deleteContact(id);
    await loadContacts();
  }

  // --- Reminders Methods ---
  Future<List<Reminder>> getRemindersForContact(int contactId) async {
    return await _dbService.getRemindersForContact(contactId);
  }

  Future<void> addReminder(Reminder reminder) async {
    await _dbService.insertReminder(reminder);
    notifyListeners();
  }

  Future<void> updateReminder(Reminder reminder) async {
    await _dbService.updateReminder(reminder);
    notifyListeners();
  }

  Future<void> deleteReminder(int id) async {
    await _dbService.deleteReminder(id);
    notifyListeners();
  }

  // --- Vault Methods ---
  Future<bool> unlockVault(String masterKey) async {
    if (_isVaultSetupComplete && _vaultMasterKey != masterKey) {
      return false;
    }

    try {
      _encryptionService.init(masterKey);
      _isVaultUnlocked = true;
      final now = DateTime.now();
      _lastVaultUnlockTime = now;
      await _dbService.updateVaultSettings({'lastUnlockTime': now.toIso8601String()});
      await loadVaultItems();
      return true;
    } catch (e) {
      _isVaultUnlocked = false;
      return false;
    }
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
        return item; 
      }
    }).toList();
    notifyListeners();
  }

  Future<void> addVaultItem(VaultItem item) async {
    if (!_isVaultUnlocked) return;
    final encryptedSecret = _encryptionService.encryptData(item.secretContent);
    final encryptedItem = item.copyWith(secretContent: encryptedSecret);
    await _dbService.insertVaultItem(encryptedItem);
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
}
