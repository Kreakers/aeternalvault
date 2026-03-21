import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/app_provider.dart';
import '../l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const _autofillChannel = MethodChannel('aeterna/autofill');

  bool? _autofillEnabled;

  @override
  void initState() {
    super.initState();
    _checkAutofillStatus();
  }

  Future<void> _checkAutofillStatus() async {
    if (!Platform.isAndroid) return;
    try {
      final enabled = await _autofillChannel.invokeMethod<bool>('isAutofillServiceEnabled') ?? false;
      if (mounted) setState(() => _autofillEnabled = enabled);
    } catch (_) {}
  }

  Future<void> _openAutofillSettings() async {
    try {
      await _autofillChannel.invokeMethod('openAutofillSettings');
      // Re-check status after returning from settings
      await Future.delayed(const Duration(milliseconds: 500));
      _checkAutofillStatus();
    } catch (_) {}
  }

  static const _languages = [
    ('tr', '🇹🇷', 'Türkçe'),
    ('en', '🇬🇧', 'English'),
    ('de', '🇩🇪', 'Deutsch'),
    ('it', '🇮🇹', 'Italiano'),
  ];

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.generalSettingsTitle)),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              if (Platform.isAndroid) ...[
                _buildSectionTitle(l.autofillSectionTitle),
                _buildAutofillCard(l),
                const SizedBox(height: 24),
              ],
              _buildSectionTitle(l.appearanceMode),
              Card(
                child: SwitchListTile(
                  title: Text(provider.isDarkMode ? l.darkModeActive : l.lightModeActive),
                  subtitle: Text(l.themeModeTip),
                  secondary: Icon(provider.isDarkMode ? Icons.dark_mode : Icons.light_mode, color: Theme.of(context).colorScheme.primary),
                  value: provider.isDarkMode,
                  onChanged: (val) => provider.toggleDarkMode(val),
                ),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle(l.language),
              Card(
                child: Column(
                  children: _languages.map((lang) {
                    final isSelected = provider.locale.languageCode == lang.$1;
                    return ListTile(
                      leading: Text(lang.$2, style: const TextStyle(fontSize: 24)),
                      title: Text(lang.$3),
                      trailing: isSelected
                          ? Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary)
                          : const Icon(Icons.circle_outlined, color: Colors.grey),
                      selected: isSelected,
                      onTap: () => provider.setLocale(Locale(lang.$1)),
                    );
                  }).toList(),
                ),
              ),
              const Divider(height: 48),
              _buildSectionTitle(l.backupRestore),
              Card(
                child: Column(children: [
                  ListTile(
                    leading: const Icon(Icons.save_alt),
                    title: Text(l.backup),
                    subtitle: Text(l.backupDesc),
                    onTap: () => _saveBackupToFile(context, provider, l),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.restore, color: Colors.orange),
                    title: Text(l.restore),
                    subtitle: const Text('aeterna_backup_*.json'),
                    onTap: () => _showRestoreDialog(context, provider, l),
                  ),
                ]),
              ),
              const SizedBox(height: 40),
              Center(
                child: Text(l.versionInfo, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAutofillCard(AppLocalizations l) {
    final enabled = _autofillEnabled ?? false;
    return Card(
      child: ListTile(
        leading: Icon(
          Icons.password,
          color: enabled ? Colors.green : Colors.grey,
        ),
        title: Text(l.autofillServiceTitle),
        subtitle: Text(
          enabled ? l.autofillServiceEnabled : l.autofillServiceDisabled,
          style: TextStyle(color: enabled ? Colors.green : Colors.grey),
        ),
        trailing: enabled
            ? const Icon(Icons.check_circle, color: Colors.green)
            : OutlinedButton(
                onPressed: _openAutofillSettings,
                child: Text(l.autofillServiceEnable),
              ),
        onTap: enabled ? null : _openAutofillSettings,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(title.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.2, color: Colors.grey)),
    );
  }

  Future<void> _showRestoreDialog(BuildContext context, AppProvider provider, AppLocalizations l) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (result == null || result.files.single.path == null) return;
    final jsonStr = await File(result.files.single.path!).readAsString();
    if (!context.mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.restoreFromBackup),
        content: Text(l.restoreWarning, style: const TextStyle(color: Colors.orange)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: Text(l.restore),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    final ok = await provider.restoreBackup(jsonStr);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(ok ? l.restoreSuccess : l.restoreError),
        backgroundColor: ok ? Colors.green : Colors.red,
      ));
    }
  }

  Future<void> _saveBackupToFile(BuildContext context, AppProvider provider, AppLocalizations l) async {
    try {
      final json = await provider.generateBackup();
      final now = DateTime.now();
      final dateStr = '${now.day.toString().padLeft(2, '0')}${now.month.toString().padLeft(2, '0')}${now.year}';
      final fileName = 'aeterna_backup_$dateStr.json';

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/$fileName');
      await file.writeAsString(json);

      await Share.shareXFiles(
        [XFile(file.path)],
        subject: fileName,
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l.saveError(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

}
