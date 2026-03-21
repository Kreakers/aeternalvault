import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
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
  bool _isRestoring = false;

  @override
  void dispose() {
    _keyController.dispose();
    _confirmKeyController.dispose();
    super.dispose();
  }

  void _restoreFromBackup() async {
    final l = AppLocalizations.of(context);

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (result == null || result.files.isEmpty) return;

    final path = result.files.first.path;
    if (path == null) return;

    final file = File(path);
    if (!file.existsSync()) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.invalidBackupFile), backgroundColor: Colors.red),
      );
      return;
    }

    String jsonString;
    try {
      jsonString = await file.readAsString();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.invalidBackupFile), backgroundColor: Colors.red),
      );
      return;
    }

    // Master key dialog
    final masterKeyController = TextEditingController();
    final enteredKey = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(l.restoreFromBackup),
        content: TextField(
          controller: masterKeyController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: l.restoreEnterMasterKey,
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.key),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, masterKeyController.text),
            style: ElevatedButton.styleFrom(backgroundColor: AC.gold, foregroundColor: Colors.black),
            child: const Text('Yükle'),
          ),
        ],
      ),
    );
    masterKeyController.dispose();

    if (enteredKey == null || enteredKey.isEmpty) return;

    setState(() => _isRestoring = true);

    final provider = Provider.of<AppProvider>(context, listen: false);
    final success = await provider.restoreBackupOnSetup(jsonString, enteredKey);

    if (!mounted) return;
    setState(() => _isRestoring = false);

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.restoreError), backgroundColor: Colors.red),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l.restoreSuccess), backgroundColor: Colors.green),
    );

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (_) => false,
    );
  }

  void _completeSetup() async {
    final l = AppLocalizations.of(context);
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<AppProvider>(context, listen: false);
      await provider.completeVaultSetup(_keyController.text, _useBiometrics);
      final success = await provider.unlockVault(_keyController.text);

      if (!mounted) return;

      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l.vaultUnlockFailed),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (_) => false,
      );
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
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.withValues(alpha: 0.4)),
                ),
                child: Text(
                  l.masterKeyWarning,
                  style: const TextStyle(color: Colors.orange, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _completeSetup,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AC.gold,
                  foregroundColor: Colors.black,
                ),
                child: Text(l.saveAndActivate, style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _isRestoring ? null : _restoreFromBackup,
                icon: _isRestoring
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.restore),
                label: Text(l.restoreFromBackup),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: AC.gold),
                  foregroundColor: AC.gold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
