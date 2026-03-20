import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../models/vault_item.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';

class AddVaultItemScreen extends StatefulWidget {
  final VaultItem? vaultItem;

  const AddVaultItemScreen({super.key, this.vaultItem});

  @override
  State<AddVaultItemScreen> createState() => _AddVaultItemScreenState();
}

class _AddVaultItemScreenState extends State<AddVaultItemScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _noteController;

  final _field1Controller = TextEditingController();
  final _field2Controller = TextEditingController();
  final _field3Controller = TextEditingController();

  String _category = 'Şifre';
  String? _filePath;
  bool _obscurePassword = true;
  bool _decryptionFailed = false;

  // Category keys that are stored in the database (Turkish keys kept for data compatibility)
  final List<String> _categories = ['Şifre', 'Banka', 'Belge', 'Kripto Cüzdanı', 'Gizli Not'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.vaultItem?.title ?? '');
    _noteController = TextEditingController(text: widget.vaultItem?.note ?? '');
    _filePath = widget.vaultItem?.filePath;

    if (widget.vaultItem != null) {
      _category = widget.vaultItem!.category;
      try {
        final Map<String, dynamic> data = jsonDecode(widget.vaultItem!.secretContent);
        _field1Controller.text = data['f1'] ?? '';
        _field2Controller.text = data['f2'] ?? '';
        _field3Controller.text = data['f3'] ?? '';
      } catch (e) {
        _decryptionFailed = true;
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    _field1Controller.dispose();
    _field2Controller.dispose();
    _field3Controller.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final l = AppLocalizations.of(context);
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        setState(() {
          _filePath = result.files.single.path;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.filePickError)));
      }
    }
  }

  void _generateStrongPassword() {
    final l = AppLocalizations.of(context);
    const chars = r'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()';
    final rnd = Random.secure();
    final pwd = String.fromCharCodes(Iterable.generate(12, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
    setState(() {
      _field2Controller.text = pwd;
      _obscurePassword = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.passwordGenerated)));
  }

  Future<void> _saveItem() async {
    final l = AppLocalizations.of(context);
    if (!_formKey.currentState!.validate()) return;

    final Map<String, String> dynamicData = {
      'f1': _field1Controller.text.trim(),
      'f2': _field2Controller.text.trim(),
      'f3': _field3Controller.text.trim(),
    };

    final item = VaultItem(
      id: widget.vaultItem?.id,
      title: _titleController.text.trim(),
      category: _category,
      secretContent: jsonEncode(dynamicData),
      note: _noteController.text.trim(),
      filePath: _filePath,
    );

    final provider = Provider.of<AppProvider>(context, listen: false);
    try {
      if (widget.vaultItem == null) {
        await provider.addVaultItem(item);
      } else {
        await provider.updateVaultItem(item);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l.saveError(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _localizedCategory(AppLocalizations l, String cat) {
    switch (cat) {
      case 'Şifre': return l.categoryPassword;
      case 'Banka': return l.categoryBank;
      case 'Belge': return l.categoryDocument;
      case 'Kripto Cüzdanı': return l.categoryCrypto;
      case 'Gizli Not': return l.categorySecretNote;
      default: return cat;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: isDark ? AC.bg : AL.bg,
      body: Column(children: [
        _buildHeader(context, l),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 40),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GlassCard(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(children: [
                        _buildTextField(_titleController, l.titleHint,
                            validator: (v) => v != null && v.isEmpty ? l.required : null),
                        const SizedBox(height: 4),
                        DropdownButtonFormField<String>(
                          value: _category,
                          decoration: InputDecoration(
                            labelText: l.category,
                            prefixIcon: const Icon(Icons.category_outlined, size: 18),
                          ),
                          dropdownColor: isDark ? AC.bgCard : AL.bgCard,
                          items: _categories.map((c) => DropdownMenuItem(
                            value: c,
                            child: Text(_localizedCategory(l, c)),
                          )).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _category = val);
                            }
                          },
                        ),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l.secretData.toUpperCase(),
                          style: TextStyle(color: isDark ? const Color(0x73FFFFFF) : AL.textMuted, fontSize: 11,
                              fontWeight: FontWeight.w600, letterSpacing: 0.8)),
                      if (_category == 'Şifre')
                        GestureDetector(
                          onTap: _generateStrongPassword,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: AC.goldGlass(),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AC.goldBorder()),
                            ),
                            child: Row(mainAxisSize: MainAxisSize.min, children: [
                              const Icon(Icons.generating_tokens, color: AC.gold, size: 14),
                              const SizedBox(width: 4),
                              Text(l.generatePassword,
                                  style: const TextStyle(color: AC.gold, fontSize: 11, fontWeight: FontWeight.w600)),
                            ]),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  GlassCard(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(children: [
                        if (_decryptionFailed)
                          Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AC.warning.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AC.warning.withOpacity(0.4)),
                            ),
                            child: Row(children: [
                              Icon(Icons.warning_amber, color: AC.warning, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(l.decryptionError,
                                    style: TextStyle(color: AC.warning, fontSize: 12)),
                              ),
                            ]),
                          ),
                        ..._buildDynamicFields(l),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(l.fileAttachment.toUpperCase(),
                      style: TextStyle(color: isDark ? const Color(0x73FFFFFF) : AL.textMuted, fontSize: 11,
                          fontWeight: FontWeight.w600, letterSpacing: 0.8)),
                  const SizedBox(height: 8),
                  _buildFilePickerArea(l),
                  const SizedBox(height: 14),
                  GlassCard(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: _buildTextField(_noteController, l.additionalNotes, maxLines: 3),
                    ),
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: _saveItem,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [AC.danger, Color(0xFFCC0020)],
                            begin: Alignment.topLeft, end: Alignment.bottomRight),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: AC.danger.withOpacity(0.35), blurRadius: 20, offset: const Offset(0, 6))],
                      ),
                      child: Center(
                        child: Text(l.saveEncrypted,
                            style: const TextStyle(color: Colors.white, fontSize: 14,
                                fontWeight: FontWeight.w800, letterSpacing: 1)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        left: 14, right: 14, bottom: 14,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xCC0D0D1A) : AL.bgCard,
        border: Border(bottom: BorderSide(color: isDark ? Colors.white.withOpacity(0.06) : AL.divider)),
      ),
      child: Row(children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.06) : AL.bg,
              borderRadius: BorderRadius.circular(11),
              border: Border.all(color: isDark ? Colors.white.withOpacity(0.1) : AL.divider),
            ),
            child: Icon(Icons.arrow_back, color: isDark ? Colors.white70 : AL.textSec, size: 18),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 34, height: 34,
          decoration: BoxDecoration(
            color: AC.danger.withOpacity(0.12),
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: AC.danger.withOpacity(0.3)),
          ),
          child: const Icon(Icons.enhanced_encryption, color: AC.danger, size: 17),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(
          widget.vaultItem == null ? l.addVaultItem : l.editVaultItem,
          style: TextStyle(color: isDark ? Colors.white : AL.textPrimary, fontSize: 16, fontWeight: FontWeight.w700),
        )),
      ]),
    );
  }

  Widget _buildFilePickerArea(AppLocalizations l) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: _pickFile,
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.04) : AL.bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isDark ? Colors.white.withOpacity(0.1) : AL.divider),
        ),
        child: _filePath == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.upload_file, size: 28, color: AC.navyLight),
                  const SizedBox(height: 6),
                  Text(l.selectFile, style: TextStyle(color: isDark ? AC.textMuted : AL.textMuted, fontSize: 12)),
                ],
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(children: [
                  const Icon(Icons.file_present, color: AC.navyLight, size: 22),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(_filePath!.split('/').last,
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: isDark ? Colors.white : AL.textPrimary, fontSize: 12, fontWeight: FontWeight.w600)),
                    Text(l.fileReady, style: const TextStyle(color: AC.success, fontSize: 10)),
                  ])),
                  GestureDetector(
                    onTap: () => setState(() => _filePath = null),
                    child: const Icon(Icons.close, color: AC.danger, size: 18),
                  ),
                ]),
              ),
      ),
    );
  }

  List<Widget> _buildDynamicFields(AppLocalizations l) {
    switch (_category) {
      case 'Şifre':
        return [
          _buildTextField(_field1Controller, l.usernameEmail, icon: Icons.person),
          _buildTextField(
            _field2Controller,
            l.password,
            icon: Icons.vpn_key,
            obscure: _obscurePassword,
            suffixIcon: IconButton(
              icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
          _buildTextField(_field3Controller, l.websiteUrl, icon: Icons.language),
        ];
      case 'Kripto Cüzdanı':
        return [
          _buildTextField(_field1Controller, l.walletAddress, icon: Icons.wallet),
          _buildTextField(
            _field2Controller,
            l.seedPhrase,
            icon: Icons.security,
            obscure: _obscurePassword,
            maxLines: _obscurePassword ? 1 : 3,
            suffixIcon: IconButton(
              icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
          _buildTextField(_field3Controller, l.network, icon: Icons.lan),
        ];
      case 'Banka':
        return [
          _buildTextField(_field1Controller, l.ibanAccount, icon: Icons.numbers),
          _buildTextField(_field2Controller, l.bankName, icon: Icons.account_balance),
          _buildTextField(_field3Controller, l.branchInfo, icon: Icons.location_city),
        ];
      case 'Belge':
        return [
          _buildTextField(_field1Controller, l.serialId, icon: Icons.badge),
          _buildTextField(_field2Controller, l.documentType, icon: Icons.description),
          _buildTextField(_field3Controller, l.expiryDate, icon: Icons.calendar_today),
        ];
      default:
        return [
          _buildTextField(_field1Controller, l.noteContent, maxLines: 10),
        ];
    }
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {IconData? icon, bool obscure = false, int maxLines = 1, String? Function(String?)? validator, Widget? suffixIcon}) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: icon != null ? Icon(icon, size: 18) : null,
            suffixIcon: suffixIcon,
          ),
          obscureText: obscure,
          maxLines: obscure ? 1 : (maxLines > 1 ? maxLines : 1),
          validator: validator,
        ),
      );
}
