import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  final _keyController    = TextEditingController();
  final _newKeyController = TextEditingController();
  final _importController = TextEditingController();
  bool _backupDone = false;

  @override
  void dispose() {
    _keyController.dispose();
    _newKeyController.dispose();
    _importController.dispose();
    super.dispose();
  }

  void _exportData() async {
    final l = AppLocalizations.of(context);
    final provider = Provider.of<AppProvider>(context, listen: false);
    final jsonString = await provider.generateBackup();
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l.dataBackupTitle),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(l.backupInstructions),
          const SizedBox(height: 12),
          SizedBox(
            height: 180,
            child: SingleChildScrollView(
              child: SelectableText(jsonString,
                  style: const TextStyle(fontSize: 10, fontFamily: 'monospace', color: AC.textSec)),
            ),
          ),
        ]),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: jsonString));
              setState(() => _backupDone = true);
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l.backupCopied)));
              Navigator.pop(context);
            },
            child: Text(l.copyAndClose),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.share, size: 16),
            label: Text(l.shareBackup),
            style: ElevatedButton.styleFrom(backgroundColor: AC.navyLight, foregroundColor: Colors.white),
            onPressed: () async {
              Navigator.pop(context);
              try {
                final dir = await getTemporaryDirectory();
                final file = File('${dir.path}/aeterna_backup_${DateTime.now().millisecondsSinceEpoch}.json');
                await file.writeAsString(jsonString);
                await Share.shareXFiles(
                  [XFile(file.path)],
                  subject: 'Aeterna Vault Backup',
                );
                setState(() => _backupDone = true);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l.backupShared)));
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l.saveError(e.toString()))));
                }
              }
            },
          ),
        ],
      ),
    );
  }

  void _importData() {
    final l = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l.restoreFromBackup),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(l.restoreWarning,
              style: const TextStyle(color: AC.danger)),
          const SizedBox(height: 12),
          TextField(
            controller: _importController,
            maxLines: 5,
            decoration: const InputDecoration(hintText: '{ "contacts": ... }'),
          ),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l.cancel)),
          ElevatedButton(
            onPressed: () async {
              final provider = Provider.of<AppProvider>(context, listen: false);
              final ok = await provider.restoreBackup(_importController.text);
              if (!mounted) return;
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(ok ? l.restoreSuccess : l.restoreError),
              ));
            },
            style: ElevatedButton.styleFrom(backgroundColor: AC.danger),
            child: Text(l.restore),
          ),
        ],
      ),
    );
  }

  void _showResetConfirm() {
    final l = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Row(children: [
          const Icon(Icons.warning_amber_rounded, color: AC.danger),
          const SizedBox(width: 8),
          Text(l.factoryResetConfirmTitle, style: const TextStyle(color: AC.danger)),
        ]),
        content: Text(l.factoryResetConfirmContent),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l.cancel)),
          ElevatedButton(
            onPressed: () async {
              final provider = Provider.of<AppProvider>(context, listen: false);
              await provider.performFactoryReset();
              if (!mounted) return;
              Navigator.pop(context);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l.appResetSuccess)),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AC.danger),
            child: Text(l.confirmAndDelete),
          ),
        ],
      ),
    );
  }

  void _showChangeKeyDialog() {
    final l = AppLocalizations.of(context);
    _keyController.clear();
    _newKeyController.clear();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l.changePassword),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
            controller: _keyController,
            obscureText: true,
            decoration: InputDecoration(labelText: l.oldPassword),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _newKeyController,
            obscureText: true,
            decoration: InputDecoration(labelText: l.newPassword),
          ),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l.cancel)),
          ElevatedButton(
            onPressed: () async {
              final provider = Provider.of<AppProvider>(context, listen: false);
              final newKey = _newKeyController.text;
              if (newKey.length < 8 ||
                  !newKey.contains(RegExp(r'[A-Za-z]')) ||
                  !newKey.contains(RegExp(r'[0-9]'))) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(l.passwordRequirements)));
                return;
              }
              final ok = await provider.updateMasterKey(_keyController.text, newKey);
              if (!mounted) return;
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(ok ? l.passwordUpdated : l.oldPasswordWrong)));
            },
            style: ElevatedButton.styleFrom(backgroundColor: AC.gold, foregroundColor: Colors.black),
            child: Text(l.update),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: isDark ? AC.bg : AL.bg,
      body: Column(children: [
        _buildHeader(l, isDark),
        Expanded(child: Consumer<AppProvider>(builder: (_, provider, __) => ListView(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 32),
          children: [
            _buildSecurityScore(provider, l, isDark),
            const SizedBox(height: 16),

            SectionLabel(l.passwordSecurity),
            const SizedBox(height: 8),
            GlassCard(child: Column(children: [
              _settingRow(
                isDark: isDark,
                icon: Icons.lock_outline,
                iconColor: AC.gold,
                title: l.masterKeyTitle,
                subtitle: l.lastChangedDaysAgo,
                badge: l.change,
                badgeColor: AC.gold,
                onTap: _showChangeKeyDialog,
              ),
              _divider(isDark),
              _settingRow(
                isDark: isDark,
                icon: Icons.visibility_outlined,
                iconColor: AC.navyLight,
                title: l.passwordHints,
                subtitle: l.showHintOnLogin,
                toggle: false,
                onToggle: () {},
              ),
            ])),
            const SizedBox(height: 12),

            SectionLabel(l.biometricId),
            const SizedBox(height: 8),
            GlassCard(child: Column(children: [
              _settingRow(
                isDark: isDark,
                icon: Icons.fingerprint,
                iconColor: AC.success,
                title: l.fingerprint,
                subtitle: provider.useBiometrics ? l.fingerprintEnabled : l.fingerprintDisabled,
                toggle: provider.useBiometrics,
                badge: provider.useBiometrics ? l.active : null,
                badgeColor: AC.success,
                onToggle: () => provider.updateBiometricPref(!provider.useBiometrics),
              ),
              _divider(isDark),
              _settingRow(
                isDark: isDark,
                icon: Icons.timer_outlined,
                iconColor: const Color(0xFF9C27B0),
                title: l.autoLock,
                subtitle: provider.autoLockEnabled ? l.autoLockEnabled : l.autoLockDisabled,
                toggle: provider.autoLockEnabled,
                onToggle: () => provider.updateAutoLock(!provider.autoLockEnabled),
              ),
            ])),
            const SizedBox(height: 12),

            SectionLabel(l.accountSecurity),
            const SizedBox(height: 8),
            GlassCard(child: Padding(
              padding: const EdgeInsets.fromLTRB(13, 10, 13, 12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(l.backupRestore,
                    style: TextStyle(
                        color: isDark ? Colors.white70 : AL.textSec,
                        fontSize: 11, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Row(children: [
                  Expanded(child: _actionBtn(
                    label: _backupDone ? l.backupDone : l.backup,
                    icon: Icons.cloud_upload_outlined,
                    color: _backupDone ? AC.success : AC.navyLight,
                    onTap: _exportData,
                  )),
                  const SizedBox(width: 8),
                  Expanded(child: _actionBtn(
                    label: l.restore,
                    icon: Icons.restore,
                    color: isDark ? Colors.white54 : AL.textSec,
                    onTap: _importData,
                  )),
                ]),
              ]),
            )),
            const SizedBox(height: 12),

            SectionLabel(l.dangerZone),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _showResetConfirm,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: AC.danger.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AC.danger.withOpacity(0.28)),
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.warning_amber_rounded, color: AC.danger, size: 16),
                  const SizedBox(width: 8),
                  Text(l.doFactoryReset,
                      style: const TextStyle(color: AC.danger, fontSize: 13, fontWeight: FontWeight.w700)),
                ]),
              ),
            ),
          ],
        ))),
      ]),
    );
  }

  Widget _buildHeader(AppLocalizations l, bool isDark) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        left: 16, right: 16, bottom: 14,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xE60D0D1A) : AL.bgCard,
        border: Border(bottom: BorderSide(
            color: isDark ? Colors.white.withOpacity(0.06) : AL.divider)),
      ),
      child: Row(children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.06) : AL.bg,
              borderRadius: BorderRadius.circular(11),
              border: Border.all(
                  color: isDark ? Colors.white.withOpacity(0.1) : AL.divider),
            ),
            child: Icon(Icons.arrow_back,
                color: isDark ? Colors.white70 : AL.textSec, size: 18),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 34, height: 34,
          decoration: BoxDecoration(
            color: AC.navyGlass(0.4),
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: AC.navyBorder(0.6)),
            boxShadow: [BoxShadow(color: AC.navy.withOpacity(0.4), blurRadius: 20)],
          ),
          child: const Icon(Icons.shield_outlined, color: AC.gold, size: 17),
        ),
        const SizedBox(width: 10),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(l.securitySettingsTitle,
              style: TextStyle(
                  color: isDark ? Colors.white : AL.textPrimary,
                  fontSize: 18, fontWeight: FontWeight.w700)),
          Text(l.appProtectionSettings,
              style: TextStyle(
                  color: isDark ? AC.textMuted : AL.textMuted, fontSize: 10)),
        ]),
      ]),
    );
  }

  Widget _buildSecurityScore(AppProvider provider, AppLocalizations l, bool isDark) {
    final score = provider.useBiometrics ? 94 : 72;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: isDark
            ? [const Color(0x1A00E676), const Color(0x331A237E)]
            : [AC.success.withOpacity(0.05), AL.navyGlass(0.08)]),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AC.success.withOpacity(0.18)),
      ),
      child: Row(children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color: AC.success.withOpacity(0.15),
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: AC.success.withOpacity(0.3)),
          ),
          child: const Icon(Icons.check_circle_outline, color: AC.success, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(l.securityScore(score),
              style: const TextStyle(color: AC.success, fontSize: 13, fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(score >= 90 ? l.securityVeryStrong : l.enableBiometric,
              style: TextStyle(color: isDark ? AC.textMuted : AL.textMuted, fontSize: 10)),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: score / 100,
              backgroundColor: isDark ? Colors.white.withOpacity(0.1) : AL.divider,
              valueColor: const AlwaysStoppedAnimation(AC.success),
              minHeight: 4,
            ),
          ),
        ])),
      ]),
    );
  }

  Widget _settingRow({
    required bool isDark,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    bool? toggle,
    VoidCallback? onToggle,
    bool arrow = false,
    String? badge,
    Color? badgeColor,
    bool danger = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap ?? onToggle,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
        child: Row(children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: danger ? AC.danger.withOpacity(0.12) : iconColor.withOpacity(0.09),
              borderRadius: BorderRadius.circular(11),
              border: Border.all(
                  color: danger ? AC.danger.withOpacity(0.25) : iconColor.withOpacity(0.17)),
            ),
            child: Icon(icon, color: danger ? AC.danger : iconColor, size: 17),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                style: TextStyle(
                    color: danger ? AC.danger : (isDark ? Colors.white : AL.textPrimary),
                    fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text(subtitle,
                style: TextStyle(color: isDark ? AC.textMuted : AL.textMuted, fontSize: 10)),
          ])),
          if (badge != null) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: (badgeColor ?? AC.success).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: (badgeColor ?? AC.success).withOpacity(0.2)),
              ),
              child: Text(badge,
                  style: TextStyle(
                      color: badgeColor ?? AC.success,
                      fontSize: 10, fontWeight: FontWeight.w700)),
            ),
          ],
          if (toggle != null) ...[
            const SizedBox(width: 8),
            Switch(value: toggle, onChanged: onToggle != null ? (_) => onToggle() : null),
          ],
          if (arrow) ...[
            const SizedBox(width: 4),
            Icon(Icons.chevron_right,
                color: isDark ? Colors.white24 : AL.textMuted, size: 16),
          ],
        ]),
      ),
    );
  }

  Widget _actionBtn({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon, color: color, size: 14),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
          ]),
        ),
      );

  Widget _divider(bool isDark) => Divider(
      height: 1,
      color: isDark ? Colors.white.withOpacity(0.04) : AL.divider,
      indent: 60,
      endIndent: 0);
}
