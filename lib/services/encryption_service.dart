import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionService {
  static final EncryptionService _instance = EncryptionService._internal();
  factory EncryptionService() => _instance;
  EncryptionService._internal();

  encrypt.Key? _key;
  // Basitlik için şimdilik sabit bir IV kullanıyoruz. 
  // Gerçek uygulamada her kayıt için farklı IV üretilip veritabanında saklanmalıdır.
  final _iv = encrypt.IV.fromLength(16); 
  encrypt.Encrypter? _encrypter;

  bool get isInitialized => _encrypter != null;

  void init(String masterKey) {
    // MasterKey'den 32 bytelık güvenli bir key türetelim (SHA256)
    final bytes = utf8.encode(masterKey);
    final digest = sha256.convert(bytes);
    _key = encrypt.Key(Uint8List.fromList(digest.bytes));
    _encrypter = encrypt.Encrypter(encrypt.AES(_key!));
  }

  String encryptData(String plainText) {
    if (!isInitialized) throw Exception('Şifreleme servisi başlatılmadı');
    final encrypted = _encrypter!.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }

  String decryptData(String encryptedText) {
    if (!isInitialized) throw Exception('Şifreleme servisi başlatılmadı');
    try {
      final encrypted = encrypt.Encrypted.fromBase64(encryptedText);
      return _encrypter!.decrypt(encrypted, iv: _iv);
    } catch (e) {
      throw Exception('Veri çözülemedi, anahtar hatalı olabilir.');
    }
  }
}
