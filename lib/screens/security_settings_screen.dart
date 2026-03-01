import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../providers/app_provider.dart';

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  final _keyController = TextEditingController();
  final _newKeyController = TextEditingController();
  final _importController = TextEditingController();

  void _generateRecoveryCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final rnd = Random.secure();
    final code = String.fromCharCodes(Iterable.generate(8, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kurtarma Kodu Oluşturuldu'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Şifrenizi unutursanız bu kodu kullanabilirsiniz. LÜTFEN GÜVENLİ BİR YERE NOT EDİN:'),
            const SizedBox(height: 16),
            SelectableText(
              code,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2, color: Colors.deepPurple),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Provider.of<AppProvider>(context, listen: false).updateRecoveryCode(code);
              Navigator.pop(context);
            },
            child: const Text('KODU KAYDET VE KAPAT'),
          ),
        ],
      ),
    );
  }

  void _exportData() async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final jsonString = await provider.generateBackup();
    
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Veri Yedeği (JSON)'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Aşağıdaki metni kopyalayıp güvenli bir yerde saklayın:'),
              const SizedBox(height: 12),
              SizedBox(
                height: 200,
                child: SingleChildScrollView(
                  child: SelectableText(jsonString, style: const TextStyle(fontSize: 10, fontFamily: 'monospace')),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: jsonString));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Yedek panoya kopyalandı!')));
                Navigator.pop(context);
              },
              child: const Text('KOPYALA VE KAPAT'),
            ),
          ],
        ),
      );
    }
  }

  void _importData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yedekten Geri Yükle'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Daha önce aldığınız yedek metnini buraya yapıştırın. MEVCUT TÜM VERİLERİNİZ SİLİNECEKTİR!'),
            const SizedBox(height: 12),
            TextField(
              controller: _importController,
              maxLines: 5,
              decoration: const InputDecoration(border: OutlineInputBorder(), hintText: '{ "contacts": ... }'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
          ElevatedButton(
            onPressed: () async {
              final provider = Provider.of<AppProvider>(context, listen: false);
              final success = await provider.restoreBackup(_importController.text);
              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(success ? 'Veriler başarıyla yüklendi!' : 'Hata: Geçersiz yedek formatı.')),
                );
              }
            },
            child: const Text('GERİ YÜKLE'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Güvenlik Ayarları')),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSectionTitle('Kasa Erişimi'),
              SwitchListTile(
                title: const Text('Biyometrik Doğrulama'),
                subtitle: const Text('Parmak izi veya yüz tanıma kullan.'),
                value: provider.useBiometrics,
                onChanged: (val) => provider.updateBiometricPref(val),
              ),
              ListTile(
                leading: const Icon(Icons.password),
                title: const Text('Kasa Şifresini Değiştir'),
                onTap: () => _showChangeKeyDialog(context),
              ),
              const Divider(),
              _buildSectionTitle('Yedekleme & Kurtarma'),
              ListTile(
                leading: const Icon(Icons.vibration),
                title: const Text('Kurtarma Kodu Oluştur'),
                subtitle: Text(provider.hasRecoveryCode ? 'Mevcut bir kodunuz var.' : 'Henüz kod oluşturulmadı.'),
                trailing: const Icon(Icons.refresh),
                onTap: _generateRecoveryCode,
              ),
              ListTile(
                leading: const Icon(Icons.cloud_upload),
                title: const Text('Verileri Yedekle (Export)'),
                subtitle: const Text('Tüm verileri JSON formatında dışa aktar.'),
                onTap: _exportData,
              ),
              ListTile(
                leading: const Icon(Icons.cloud_download),
                title: const Text('Yedekten Geri Yükle (Import)'),
                subtitle: const Text('Dosya veya metin yedeğini içeri aktar.'),
                onTap: _importData,
              ),
              const Divider(),
              _buildSectionTitle('Gelişmiş'),
              ListTile(
                leading: const Icon(Icons.timer),
                title: const Text('Otomatik Kilitleme'),
                subtitle: const Text('Uygulama arka plandayken kilitleme süresi.'),
                trailing: const Text('Anında'),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gelecek güncellemede eklenecek.')));
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
    );
  }

  void _showChangeKeyDialog(BuildContext context) {
    _keyController.clear();
    _newKeyController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Şifre Değiştir'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _keyController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Eski Şifre', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _newKeyController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Yeni Şifre (en az 8 karakter, harf+rakam)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
          ElevatedButton(
            onPressed: () async {
              final provider = Provider.of<AppProvider>(context, listen: false);
              final newKey = _newKeyController.text;
              final hasLetter = newKey.contains(RegExp(r'[A-Za-z]'));
              final hasDigit = newKey.contains(RegExp(r'[0-9]'));
              if (newKey.length < 8 || !hasLetter || !hasDigit) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Yeni şifre en az 8 karakter, harf ve rakam içermelidir.')),
                );
                return;
              }
              final success = await provider.updateMasterKey(_keyController.text, newKey);
              if (mounted) Navigator.pop(context);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(success ? 'Şifre başarıyla güncellendi.' : 'Eski şifre hatalı!')),
                );
              }
            },
            child: const Text('Güncelle'),
          ),
        ],
      ),
    );
  }
}
