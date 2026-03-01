import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionService {
  static final EncryptionService _instance = EncryptionService._internal();
  factory EncryptionService() => _instance;
  EncryptionService._internal();

  encrypt.Key? _key;
  encrypt.Encrypter? _encrypter;

  bool get isInitialized => _encrypter != null;

  void init(String masterKey) {
    final bytes = utf8.encode(masterKey);
    final digest = sha256.convert(bytes);
    _key = encrypt.Key(Uint8List.fromList(digest.bytes));
    _encrypter = encrypt.Encrypter(encrypt.AES(_key!, mode: encrypt.AESMode.cbc));
  }

  /// Bellekten anahtarı temizler (kasa kilitlendiğinde çağrılır).
  void clear() {
    _key = null;
    _encrypter = null;
  }

  /// Her şifreleme için kriptografik olarak güvenli rastgele IV üretir.
  /// Çıktı formatı: base64(iv):base64(ciphertext)
  String encryptData(String plainText) {
    if (!isInitialized) throw Exception('Şifreleme servisi başlatılmadı');
    final rng = Random.secure();
    final ivBytes = Uint8List.fromList(List.generate(16, (_) => rng.nextInt(256)));
    final iv = encrypt.IV(ivBytes);
    final encrypted = _encrypter!.encrypt(plainText, iv: iv);
    return '${base64Encode(iv.bytes)}:${encrypted.base64}';
  }

  /// IV:ciphertext formatını ve geriye dönük uyumluluk için eski sabit-IV formatını destekler.
  String decryptData(String encryptedText) {
    if (!isInitialized) throw Exception('Şifreleme servisi başlatılmadı');
    try {
      final colonIdx = encryptedText.indexOf(':');
      if (colonIdx != -1) {
        // Yeni format: base64(iv):base64(ciphertext)
        final ivBytes = base64Decode(encryptedText.substring(0, colonIdx));
        final iv = encrypt.IV(Uint8List.fromList(ivBytes));
        final encrypted = encrypt.Encrypted.fromBase64(encryptedText.substring(colonIdx + 1));
        return _encrypter!.decrypt(encrypted, iv: iv);
      } else {
        // Eski format (geriye dönük uyumluluk): sabit sıfır IV
        final iv = encrypt.IV.fromLength(16);
        final encrypted = encrypt.Encrypted.fromBase64(encryptedText);
        return _encrypter!.decrypt(encrypted, iv: iv);
      }
    } catch (e) {
      throw Exception('Veri çözülemedi, anahtar hatalı olabilir.');
    }
  }
}
