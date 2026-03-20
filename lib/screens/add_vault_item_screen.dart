import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../models/vault_item.dart';
import '../providers/app_provider.dart';
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
    final rnd = Random();
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
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.vaultItem == null ? l.addVaultItem : l.editVaultItem),
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(_titleController, l.titleHint,
                  validator: (v) => v != null && v.isEmpty ? l.required : null),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: InputDecoration(labelText: l.category, border: const OutlineInputBorder()),
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
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l.secretData, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent)),
                  if (_category == 'Şifre')
                    TextButton.icon(
                      icon: const Icon(Icons.generating_tokens, size: 18),
                      label: Text(l.generatePassword),
                      onPressed: _generateStrongPassword,
                    ),
                ],
              ),
              const Divider(color: Colors.redAccent),
              const SizedBox(height: 12),
              if (_decryptionFailed)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.orange.withOpacity(0.4)),
                  ),
                  child: Row(children: [
                    const Icon(Icons.warning_amber, color: Colors.orange, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l.decryptionError,
                        style: const TextStyle(color: Colors.orange, fontSize: 12),
                      ),
                    ),
                  ]),
                ),
              ..._buildDynamicFields(l),
              const SizedBox(height: 24),
              Text(l.fileAttachment, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 8),
              _buildFilePickerArea(l),
              const SizedBox(height: 24),
              _buildTextField(_noteController, l.additionalNotes, maxLines: 3),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveItem,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: Text(l.saveEncrypted, style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilePickerArea(AppLocalizations l) {
    return InkWell(
      onTap: _pickFile,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade700, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.withAlpha(25),
        ),
        child: _filePath == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.upload_file, size: 32, color: Colors.grey),
                  const SizedBox(height: 8),
                  Text(l.selectFile, style: const TextStyle(color: Colors.grey)),
                ],
              )
            : ListTile(
                leading: const Icon(Icons.file_present, color: Colors.redAccent),
                title: Text(_filePath!.split('/').last, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text(l.fileReady, style: const TextStyle(color: Colors.green, fontSize: 12)),
                trailing: IconButton(
                  icon: const Icon(Icons.cancel, color: Colors.red),
                  onPressed: () => setState(() => _filePath = null),
                ),
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
        padding: const EdgeInsets.only(bottom: 16),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            prefixIcon: icon != null ? Icon(icon) : null,
            suffixIcon: suffixIcon,
          ),
          obscureText: obscure,
          maxLines: obscure ? 1 : (maxLines > 1 ? maxLines : 1),
          validator: validator,
        ),
      );
}
