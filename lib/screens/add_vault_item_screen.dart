import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../models/vault_item.dart';
import '../providers/app_provider.dart';

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
  final List<String> _categories = ['Şifre', 'Banka', 'Belge', 'Gizli Not'];

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
        _field1Controller.text = widget.vaultItem!.secretContent; 
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
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        setState(() {
          _filePath = result.files.single.path;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Dosya seçilemedi.')));
      }
    }
  }

  void _generateStrongPassword() {
    const chars = r'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()';
    final rnd = Random.secure();
    final pwd = String.fromCharCodes(Iterable.generate(16, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
    setState(() {
      _field2Controller.text = pwd;
      _obscurePassword = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Güçlü şifre oluşturuldu!')));
  }

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
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
      if (widget.vaultItem == null) {
        provider.addVaultItem(item);
      } else {
        provider.updateVaultItem(item);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.vaultItem == null ? 'Kasa Öğesi Ekle' : 'Öğeyi Düzenle'),
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(_titleController, 'Başlık (Örn: Pasaportum)', validator: (v) => v != null && v.isEmpty ? 'Gerekli' : null),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: const InputDecoration(labelText: 'Kategori', border: OutlineInputBorder()),
                items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
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
                  const Text('Gizli Veriler', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent)),
                  if (_category == 'Şifre')
                    TextButton.icon(
                      icon: const Icon(Icons.generating_tokens, size: 18),
                      label: const Text('Şifre Üret'),
                      onPressed: _generateStrongPassword,
                    ),
                ],
              ),
              const Divider(color: Colors.redAccent),
              const SizedBox(height: 12),
              ..._buildDynamicFields(),
              const SizedBox(height: 24),
              const Text('Dosya / Ek (PDF, Görsel vb.)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 8),
              _buildFilePickerArea(),
              const SizedBox(height: 24),
              _buildTextField(_noteController, 'Ek Notlar', maxLines: 3),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveItem,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('ŞİFRELİ OLARAK KAYDET', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilePickerArea() {
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
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.upload_file, size: 32, color: Colors.grey),
                  SizedBox(height: 8),
                  Text('Dosya Seç (PDF, Resim vb.)', style: TextStyle(color: Colors.grey)),
                ],
              )
            : ListTile(
                leading: const Icon(Icons.file_present, color: Colors.redAccent),
                title: Text(_filePath!.split('/').last, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: const Text('Dosya Hazır', style: TextStyle(color: Colors.green, fontSize: 12)),
                trailing: IconButton(
                  icon: const Icon(Icons.cancel, color: Colors.red),
                  onPressed: () => setState(() => _filePath = null),
                ),
              ),
      ),
    );
  }

  List<Widget> _buildDynamicFields() {
    switch (_category) {
      case 'Şifre':
        return [
          _buildTextField(_field1Controller, 'Kullanıcı Adı / E-posta', icon: Icons.person),
          _buildTextField(
            _field2Controller, 
            'Şifre', 
            icon: Icons.vpn_key, 
            obscure: _obscurePassword,
            suffixIcon: IconButton(
              icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
          _buildTextField(_field3Controller, 'Web Sitesi URL', icon: Icons.language),
        ];
      case 'Banka':
        return [
          _buildTextField(_field1Controller, 'IBAN / Hesap No', icon: Icons.numbers),
          _buildTextField(_field2Controller, 'Banka Adı', icon: Icons.account_balance),
          _buildTextField(_field3Controller, 'Şube / Ek Bilgi', icon: Icons.location_city),
        ];
      case 'Belge':
        return [
          _buildTextField(_field1Controller, 'Seri No / Kimlik No', icon: Icons.badge),
          _buildTextField(_field2Controller, 'Belge Türü (Örn: Pasaport)', icon: Icons.description),
          _buildTextField(_field3Controller, 'Son Kullanma Tarihi', icon: Icons.calendar_today),
        ];
      default:
        return [
          _buildTextField(_field1Controller, 'Not İçeriği', maxLines: 10),
        ];
    }
  }

  Widget _buildTextField(TextEditingController controller, String label, {IconData? icon, bool obscure = false, int maxLines = 1, String? Function(String?)? validator, Widget? suffixIcon}) => Padding(
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
