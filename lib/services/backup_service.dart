import 'dart:convert';
import '../services/database_service.dart';
import '../services/encryption_service.dart';

class BackupService {
  static final BackupService _instance = BackupService._internal();
  factory BackupService() => _instance;
  BackupService._internal();

  final DatabaseService _dbService = DatabaseService();
  
  /// Veritabanındaki tüm veriyi JSON'a döküp master key ile şifreleyen iskelet fonksiyon
  Future<String> exportAndEncrypt(String masterKey) async {
    try {
      // 1. Verileri Çek
      final contacts = await _dbService.getContacts();
      final vaultItems = await _dbService.getVaultItems();

      // 2. JSON Formatına Dönüştür
      final Map<String, dynamic> backupData = {
        'contacts': contacts.map((c) => c.toMap()).toList(),
        'vaultItems': vaultItems.map((v) => v.toMap()).toList(),
        'exportDate': DateTime.now().toIso8601String(),
      };

      final String jsonString = jsonEncode(backupData);

      // 3. Şifreleme (EncryptionService kullanarak veya geçici bir nesne ile)
      final encryptionService = EncryptionService();
      encryptionService.init(masterKey);
      
      final String encryptedBackup = encryptionService.encryptData(jsonString);

      // Not: Gerçek senaryoda bu String bir dosyaya yazılmalı (örneğin path_provider ile File'a yazılmalı)
      // veya bulut servisine/paylaşım eylemine (share_plus) gönderilmelidir.
      return encryptedBackup;
    } catch (e) {
      throw Exception('Yedekleme oluşturulurken hata oluştu: $e');
    }
  }

  /// Şifrelenmiş JSON yedeğini okuyup veritabanına geri yükleyen iskelet fonksiyon
  Future<void> decryptAndImport(String encryptedBackup, String masterKey) async {
    try {
      final encryptionService = EncryptionService();
      encryptionService.init(masterKey);

      // 1. Şifreyi Çöz
      final String decryptedJson = encryptionService.decryptData(encryptedBackup);
      
      // 2. JSON'u Parse Et
      final Map<String, dynamic> backupData = jsonDecode(decryptedJson);

      // TODO: Veritabanına yazma stratejisi (clearAllData + insert) eklenecek
      assert(backupData.containsKey('exportDate'));
      
    } catch (e) {
      throw Exception('Yedek geri yüklenirken hata oluştu: $e');
    }
  }
}
