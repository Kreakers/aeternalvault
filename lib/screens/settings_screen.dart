import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import '../providers/app_provider.dart';
import '../l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
                child: ListTile(
                  leading: const Icon(Icons.save_alt),
                  title: Text(l.backup),
                  subtitle: Text(l.backupSaved),
                  onTap: () => _saveBackupToFile(context, provider, l),
                ),
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(title.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.2, color: Colors.grey)),
    );
  }

  Future<void> _saveBackupToFile(BuildContext context, AppProvider provider, AppLocalizations l) async {
    try {
      final json = await provider.generateBackup();
      final now = DateTime.now();
      final dateStr =
          '${now.day.toString().padLeft(2, '0')}${now.month.toString().padLeft(2, '0')}${now.year}';
      final fileName = 'aeterna_backup_$dateStr.json';

      Directory? dir;
      if (Platform.isAndroid) {
        dir = Directory('/storage/emulated/0/Download');
        if (!await dir.exists()) {
          dir = await getExternalStorageDirectory();
        }
      } else {
        dir = await getApplicationDocumentsDirectory();
      }

      final file = File('${dir!.path}/$fileName');
      await file.writeAsString(json);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l.backupSaved}: $fileName')),
        );
      }
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
