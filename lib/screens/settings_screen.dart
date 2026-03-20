import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import '../providers/app_provider.dart';
import '../l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // Profesyonel ve Ağırbaşlı Renk Paleti (Material 3 Seed Colors)
  final List<Color> _professionalColors = const [
    Color(0xFF1A237E), // Midnight Navy
    Color(0xFF004D40), // Deep Teal
    Color(0xFF37474F), // Slate Grey
    Color(0xFF4E342E), // Coffee Brown
    Color(0xFF880E4F), // Maroon
    Color(0xFF311B92), // Deep Purple
  ];

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
                  secondary: Icon(provider.isDarkMode ? Icons.dark_mode : Icons.light_mode, color: provider.themeColor),
                  value: provider.isDarkMode,
                  onChanged: (val) => provider.toggleDarkMode(val),
                ),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle(l.appIdentityColor),
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Text(l.colorAutoAdapt, style: const TextStyle(fontSize: 13, color: Colors.grey)),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.5,
                ),
                itemCount: _professionalColors.length,
                itemBuilder: (context, index) {
                  final color = _professionalColors[index];
                  final isSelected = provider.themeColor.value == color.value;
                  return GestureDetector(
                    onTap: () => provider.updateThemeColor(color),
                    child: Container(
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(12),
                        border: isSelected ? Border.all(color: Theme.of(context).colorScheme.outline, width: 4) : null,
                        boxShadow: [
                          if (isSelected) BoxShadow(color: color.withOpacity(0.4), blurRadius: 10, spreadRadius: 2)
                        ],
                      ),
                      child: isSelected ? const Icon(Icons.check_circle, color: Colors.white) : null,
                    ),
                  );
                },
              ),
              const Divider(height: 48),
              _buildSectionTitle(l.language),
              Card(
                child: Column(
                  children: _languages.map((lang) {
                    final isSelected = provider.locale.languageCode == lang.$1;
                    return ListTile(
                      leading: Text(lang.$2, style: const TextStyle(fontSize: 24)),
                      title: Text(lang.$3),
                      trailing: isSelected
                          ? Icon(Icons.check_circle, color: provider.themeColor)
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
              const SizedBox(height: 16),
              _buildSectionTitle(l.dataSecurity),
              Card(
                color: Colors.red.withOpacity(0.05),
                child: ListTile(
                  leading: const Icon(Icons.delete_forever, color: Colors.red),
                  title: Text(l.factoryRestoreTitle, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  subtitle: Text(l.factoryRestoreSubtitle),
                  onTap: () => _showResetConfirm(context, provider),
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
            content: Text('Backup hatası: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showResetConfirm(BuildContext context, AppProvider provider) {
    final l = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.permanentDeleteTitle),
        content: Text(l.permanentDeleteContent),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l.cancelUpper)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () async {
              await provider.performFactoryReset();
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.appResetSuccess)));
              }
            },
            child: Text(l.deleteAndReset),
          ),
        ],
      ),
    );
  }
}
