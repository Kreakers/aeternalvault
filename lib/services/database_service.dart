import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/contact.dart';
import '../models/vault_item.dart';
import '../models/reminder.dart';
import '../models/log_entry.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('aeterna_vault.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 13,
      onConfigure: _onConfigure,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  // SQLite Yabancı Anahtar desteğini aktif ediyoruz
  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE contacts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        firstName TEXT NOT NULL,
        lastName TEXT NOT NULL,
        phone TEXT NOT NULL,
        email TEXT,
        socialMedia TEXT,
        company TEXT,
        jobTitle TEXT,
        address TEXT,
        lastContactDate TEXT,
        birthday TEXT,
        anniversary TEXT,
        connectionSource TEXT,
        tags TEXT,
        category TEXT NOT NULL,
        isPrivate INTEGER DEFAULT 0,
        imagePath TEXT,
        contactFrequency INTEGER DEFAULT 0,
        notes TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE vault_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        secretContent TEXT NOT NULL,
        category TEXT NOT NULL,
        note TEXT,
        filePath TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE vault_settings (
        id INTEGER PRIMARY KEY,
        isSetupComplete INTEGER DEFAULT 0,
        hashedMasterKey TEXT,
        useBiometrics INTEGER DEFAULT 0,
        lastUnlockTime TEXT,
        recoveryCode TEXT,
        autoLockMinutes INTEGER DEFAULT 0,
        themeColor INTEGER DEFAULT 4284572657,
        isDarkMode INTEGER DEFAULT 1,
        locale TEXT DEFAULT 'tr'
      )
    ''');

    await db.execute('''
      CREATE TABLE reminders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        contactId INTEGER NOT NULL,
        title TEXT NOT NULL,
        dateTime TEXT NOT NULL,
        isCompleted INTEGER DEFAULT 0,
        FOREIGN KEY (contactId) REFERENCES contacts (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        contactId INTEGER,
        action TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        isManual INTEGER DEFAULT 0,
        FOREIGN KEY (contactId) REFERENCES contacts (id) ON DELETE CASCADE
      )
    ''');
    
    await db.insert('vault_settings', {
      'id': 1,
      'isSetupComplete': 0,
      'autoLockMinutes': 0,
      'themeColor': 4284572657,
      'isDarkMode': 1,
      'locale': 'tr',
    });
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 11) {
      await db.execute('DROP TABLE IF EXISTS contacts');
      await db.execute('DROP TABLE IF EXISTS vault_items');
      await db.execute('DROP TABLE IF EXISTS vault_settings');
      await db.execute('DROP TABLE IF EXISTS reminders');
      await db.execute('DROP TABLE IF EXISTS logs');
      await _createDB(db, newVersion);
    } else if (oldVersion < 12) {
      // Add locale column to existing vault_settings table
      try {
        await db.execute("ALTER TABLE vault_settings ADD COLUMN locale TEXT DEFAULT 'tr'");
      } catch (_) {
        // Column may already exist
      }
    } else if (oldVersion < 13) {
      try {
        await db.execute('ALTER TABLE logs ADD COLUMN isManual INTEGER DEFAULT 0');
      } catch (_) {}
    }
  }

  // --- Ayarlar ---
  Future<Map<String, dynamic>?> getVaultSettings() async {
    final db = await database;
    final maps = await db.query('vault_settings', where: 'id = ?', whereArgs: [1]);
    return maps.isNotEmpty ? maps.first : null;
  }

  Future<void> updateVaultSettings(Map<String, dynamic> settings) async {
    final db = await database;
    await db.update('vault_settings', settings, where: 'id = ?', whereArgs: [1]);
  }

  // --- Kişiler ---
  Future<int> insertContact(Contact contact) async {
    final db = await database;
    return await db.insert('contacts', contact.toMap());
  }

  Future<List<Contact>> getContacts() async {
    final db = await database;
    final result = await db.query('contacts');
    return result.map((map) => Contact.fromMap(map)).toList();
  }

  Future<int> updateContact(Contact contact) async {
    final db = await database;
    return await db.update('contacts', contact.toMap(), where: 'id = ?', whereArgs: [contact.id]);
  }

  Future<int> deleteContact(int id) async {
    final db = await database;
    return await db.delete('contacts', where: 'id = ?', whereArgs: [id]);
  }

  // --- Hatırlatıcılar ---
  Future<int> insertReminder(Reminder reminder) async {
    final db = await database;
    return await db.insert('reminders', reminder.toMap());
  }

  Future<List<Reminder>> getReminders() async {
    final db = await database;
    final result = await db.query('reminders', orderBy: 'dateTime ASC');
    return result.map((map) => Reminder.fromMap(map)).toList();
  }

  Future<List<Reminder>> getRemindersForContact(int contactId) async {
    final db = await database;
    final result = await db.query('reminders', where: 'contactId = ?', whereArgs: [contactId], orderBy: 'dateTime ASC');
    return result.map((map) => Reminder.fromMap(map)).toList();
  }

  Future<int> updateReminder(Reminder reminder) async {
    final db = await database;
    return await db.update('reminders', reminder.toMap(), where: 'id = ?', whereArgs: [reminder.id]);
  }

  Future<int> deleteReminder(int id) async {
    final db = await database;
    return await db.delete('reminders', where: 'id = ?', whereArgs: [id]);
  }

  // --- Logs ---
  Future<int> insertLog(LogEntry log) async {
    final db = await database;
    return await db.insert('logs', log.toMap());
  }

  Future<List<LogEntry>> getLogs() async {
    final db = await database;
    final result = await db.query('logs', orderBy: 'timestamp DESC');
    return result.map((map) => LogEntry.fromMap(map)).toList();
  }

  Future<List<LogEntry>> getLogsForContact(int contactId) async {
    final db = await database;
    final result = await db.query('logs', where: 'contactId = ?', whereArgs: [contactId], orderBy: 'timestamp DESC');
    return result.map((map) => LogEntry.fromMap(map)).toList();
  }

  // --- Kasa Öğeleri ---
  Future<int> insertVaultItem(VaultItem item) async {
    final db = await database;
    return await db.insert('vault_items', item.toMap());
  }

  Future<List<VaultItem>> getVaultItems() async {
    final db = await database;
    final result = await db.query('vault_items');
    return result.map((map) => VaultItem.fromMap(map)).toList();
  }

  Future<int> updateVaultItem(VaultItem item) async {
    final db = await database;
    return await db.update('vault_items', item.toMap(), where: 'id = ?', whereArgs: [item.id]);
  }

  Future<int> deleteVaultItem(int id) async {
    final db = await database;
    return await db.delete('vault_items', where: 'id = ?', whereArgs: [id]);
  }

  // --- Veri Yönetimi ---
  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('contacts');
    await db.delete('vault_items');
    await db.delete('reminders');
    await db.delete('logs');
  }

  Future<void> factoryReset() async {
    final db = await database;
    await clearAllData();
    await db.update('vault_settings', {
      'isSetupComplete': 0,
      'hashedMasterKey': null,
      'useBiometrics': 0,
      'lastUnlockTime': null,
      'recoveryCode': null,
      'autoLockMinutes': 0,
      'themeColor': 4284572657,
      'isDarkMode': 1
    }, where: 'id = ?', whereArgs: [1]);
  }
}
