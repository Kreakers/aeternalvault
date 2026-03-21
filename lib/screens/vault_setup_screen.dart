import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';

class VaultSetupScreen extends StatefulWidget {
  const VaultSetupScreen({super.key});

  @override
  State<VaultSetupScreen> createState() => _VaultSetupScreenState();
}

class _VaultSetupScreenState extends State<VaultSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _keyController = TextEditingController();
  final _confirmKeyController = TextEditingController();
  bool _useBiometrics = false;

  @override
  void dispose() {
    _keyController.dispose();
    _confirmKeyController.dispose();
    super.dispose();
  }

  void _completeSetup() async {
    final l = AppLocalizations.of(context);
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<AppProvider>(context, listen: false);
      await provider.completeVaultSetup(_keyController.text, _useBiometrics);
      await provider.unlockVault(_keyController.text);

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (_) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.vaultSetupTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.lock_outline, size: 80, color: AC.gold),
              const SizedBox(height: 24),
              Text(
                l.setupVaultTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                l.setupVaultSubtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _keyController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: l.masterKeyLabel,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.key),
                ),
                validator: (value) {
                  if (value == null || value.length < 8) return l.minEightChars;
                  final hasLetter = value.contains(RegExp(r'[A-Za-z]'));
                  final hasDigit = value.contains(RegExp(r'[0-9]'));
                  if (!hasLetter || !hasDigit) return l.mustContainLetterDigit;
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmKeyController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: l.confirmPassword,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.check),
                ),
                validator: (value) => value != _keyController.text ? l.passwordsDoNotMatch : null,
              ),
              const SizedBox(height: 24),
              SwitchListTile(
                title: Text(l.enableBiometricAuth),
                subtitle: Text(l.useFingerprintForQuickLogin),
                value: _useBiometrics,
                onChanged: (val) => setState(() => _useBiometrics = val),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _completeSetup,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AC.gold,
                  foregroundColor: Colors.black,
                ),
                child: Text(l.saveAndActivate, style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
