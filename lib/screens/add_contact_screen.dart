import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import '../models/contact.dart';
import '../providers/app_provider.dart';

class AddContactScreen extends StatefulWidget {
  final Contact? contact;
  final bool isInitiallyPrivate;

  const AddContactScreen({super.key, this.contact, this.isInitiallyPrivate = false});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _socialMediaController;
  late TextEditingController _companyController;
  late TextEditingController _jobTitleController;
  late TextEditingController _addressController;
  late TextEditingController _connectionSourceController;
  late TextEditingController _tagsController;
  late TextEditingController _notesController;
  
  String _category = 'Müşteri';
  late bool _isPrivate;
  DateTime? _selectedBirthday;
  DateTime? _selectedAnniversary;
  String? _imagePath;

  final List<String> _categories = ['Müşteri', 'Aile', 'Arkadaş', 'İş', 'Tedarikçi', 'Diğer'];

  @override
  void initState() {
    super.initState();
    final c = widget.contact;
    _firstNameController = TextEditingController(text: c?.firstName ?? '');
    _lastNameController = TextEditingController(text: c?.lastName ?? '');
    _phoneController = TextEditingController(text: c?.phone ?? '');
    _emailController = TextEditingController(text: c?.email ?? '');
    _socialMediaController = TextEditingController(text: c?.socialMedia ?? '');
    _companyController = TextEditingController(text: c?.company ?? '');
    _jobTitleController = TextEditingController(text: c?.jobTitle ?? '');
    _addressController = TextEditingController(text: c?.address ?? '');
    _connectionSourceController = TextEditingController(text: c?.connectionSource ?? '');
    _tagsController = TextEditingController(text: c?.tags ?? '');
    _notesController = TextEditingController(text: c?.notes ?? '');
    
    _isPrivate = c?.isPrivate ?? widget.isInitiallyPrivate;
    _selectedBirthday = c?.birthday;
    _selectedAnniversary = c?.anniversary;
    _imagePath = c?.imagePath;
    if (c != null) {
      _category = c.category;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _socialMediaController.dispose();
    _companyController.dispose();
    _jobTitleController.dispose();
    _addressController.dispose();
    _connectionSourceController.dispose();
    _tagsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
      if (pickedFile != null) {
        setState(() {
          _imagePath = pickedFile.path;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Resim seçilemedi.')));
      }
    }
  }

  Future<void> _selectDate(BuildContext context, bool isBirthday) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: (isBirthday ? _selectedBirthday : _selectedAnniversary) ?? DateTime(1990),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
    );
    if (picked != null) {
      setState(() {
        if (isBirthday) {
          _selectedBirthday = picked;
        } else {
          _selectedAnniversary = picked;
        }
      });
    }
  }

  void _saveContact() {
    if (_formKey.currentState!.validate()) {
      final contact = Contact(
        id: widget.contact?.id,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        socialMedia: _socialMediaController.text.trim(),
        company: _companyController.text.trim(),
        jobTitle: _jobTitleController.text.trim(),
        address: _addressController.text.trim(),
        birthday: _selectedBirthday,
        anniversary: _selectedAnniversary,
        connectionSource: _connectionSourceController.text.trim(),
        tags: _tagsController.text.trim(),
        notes: _notesController.text.trim(),
        category: _category,
        isPrivate: _isPrivate,
        imagePath: _imagePath,
        lastContactDate: widget.contact?.lastContactDate ?? DateTime.now(),
      );

      final provider = Provider.of<AppProvider>(context, listen: false);
      if (widget.contact == null) {
        provider.addContact(contact);
      } else {
        provider.updateContact(contact);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact == null ? (_isPrivate ? 'Gizli Kişi Ekle' : 'Yeni Kişi Ekle') : 'Kişiyi Düzenle'),
        backgroundColor: _isPrivate ? Theme.of(context).colorScheme.errorContainer : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: _imagePath != null ? FileImage(File(_imagePath!)) : null,
                        child: _imagePath == null ? const Icon(Icons.camera_alt, size: 40, color: Colors.white) : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(color: Colors.deepPurple, shape: BoxShape.circle),
                          child: const Icon(Icons.edit, size: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Temel Bilgiler'),
              Row(
                children: [
                  Expanded(child: _buildTextField(_firstNameController, 'Ad', validator: (v) => v != null && v.isEmpty ? 'Gerekli' : null)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildTextField(_lastNameController, 'Soyad')),
                ],
              ),
              _buildTextField(_phoneController, 'Telefon', icon: Icons.phone, keyboard: TextInputType.phone),
              _buildTextField(_emailController, 'E-posta', icon: Icons.email, keyboard: TextInputType.emailAddress),
              _buildTextField(_socialMediaController, 'Sosyal Medya Linki', icon: Icons.link),

              const SizedBox(height: 24),
              _buildSectionTitle('Profesyonel & Lokasyon'),
              _buildTextField(_companyController, 'Şirket', icon: Icons.business),
              _buildTextField(_jobTitleController, 'Unvan', icon: Icons.work),
              _buildTextField(_addressController, 'Adres', icon: Icons.location_on, maxLines: 2),

              const SizedBox(height: 24),
              _buildSectionTitle('Önemli Günler'),
              _buildDatePickerTile('Doğum Günü', _selectedBirthday, Icons.cake, true),
              _buildDatePickerTile('Yıldönümü / Özel Gün', _selectedAnniversary, Icons.event, false),

              const SizedBox(height: 24),
              _buildSectionTitle('İlişki Yönetimi'),
              _buildTextField(_connectionSourceController, 'Nereden Tanışıyoruz?', icon: Icons.handshake),
              _buildTextField(_tagsController, 'Etiketler (#tag1 #tag2)', icon: Icons.tag),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(labelText: 'Kategori', border: OutlineInputBorder()),
                items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _category = val);
                  }
                },
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Gizli Olarak Kaydet (Kasa)'),
                value: _isPrivate,
                onChanged: (val) => setState(() => _isPrivate = val),
                secondary: Icon(Icons.security, color: _isPrivate ? Colors.red : Colors.grey),
              ),
              _buildTextField(_notesController, 'Notlar', maxLines: 3),

              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveContact,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: _isPrivate ? Colors.red : null,
                  foregroundColor: _isPrivate ? Colors.white : null,
                ),
                child: const Text('KAYDET', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 12, top: 8),
    child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
  );

  Widget _buildTextField(TextEditingController controller, String label, {IconData? icon, TextInputType? keyboard, String? Function(String?)? validator, int maxLines = 1}) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder(), prefixIcon: icon != null ? Icon(icon) : null),
      keyboardType: keyboard,
      validator: validator,
      maxLines: maxLines,
    ),
  );

  Widget _buildDatePickerTile(String label, DateTime? date, IconData icon, bool isBirthday) => ListTile(
    title: Text(date == null ? label : '$label: ${DateFormat('dd MMMM yyyy', 'tr').format(date)}'),
    leading: Icon(icon),
    trailing: const Icon(Icons.calendar_today, size: 20),
    shape: RoundedRectangleBorder(side: const BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(4)),
    onTap: () => _selectDate(context, isBirthday),
  );
}
