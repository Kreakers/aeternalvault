import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class VaultSetupScreen extends StatefulWidget {
  const VaultSetupScreen({super.key});

  @override
  State<VaultSetupScreen> createState() => _VaultSetupScreenState();
}

class _VaultSetupScreenState extends State<VaultSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _keyController = TextEditingController();
  final _confirmKeyController = TextEditingController();
  bool _useBiometrics = false; // Varsayılan olarak kapalı, kullanıcı açabilir

  @override
  void dispose() {
    _keyController.dispose();
    _confirmKeyController.dispose();
    super.dispose();
  }

  void _completeSetup() async {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<AppProvider>(context, listen: false);
      await provider.completeVaultSetup(_keyController.text, _useBiometrics);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kasa şifreniz ve tercihleriniz kaydedildi!')),
        );
        Navigator.pop(context); 
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kasa Şifre Belirleme')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.lock_outline, size: 80, color: Colors.deepPurple),
              const SizedBox(height: 24),
              const Text(
                'Güvenli Kasanızı Kurun',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Bu şifre, kasanızdaki verileri korumak için kullanılacaktır. Lütfen güvenli bir şifre seçin.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _keyController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Master Key (Ana Şifre)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.key),
                ),
                validator: (value) => (value == null || value.length < 4) ? 'En az 4 karakter giriniz' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmKeyController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Şifreyi Onayla',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.check),
                ),
                validator: (value) => value != _keyController.text ? 'Şifreler eşleşmiyor' : null,
              ),
              const SizedBox(height: 24),
              SwitchListTile(
                title: const Text('Biyometrik Doğrulamayı Aktif Et'),
                subtitle: const Text('Hızlı giriş için parmak izi kullan.'),
                value: _useBiometrics,
                onChanged: (val) => setState(() => _useBiometrics = val),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _completeSetup,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
                child: const Text('ŞİFREYİ KAYDET VE AKTİF ET', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
