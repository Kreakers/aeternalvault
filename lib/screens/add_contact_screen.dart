import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../models/contact.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';

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
  String _fullPhoneNumber = '';

  // Category keys kept in Turkish for data compatibility
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
    _fullPhoneNumber = c?.phone ?? '';
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
    final l = AppLocalizations.of(context);
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.imagePickError)));
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
        phone: _fullPhoneNumber.isNotEmpty ? _fullPhoneNumber : _phoneController.text.trim(),
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

  String _localizedCategory(AppLocalizations l, String cat) {
    switch (cat) {
      case 'Müşteri': return l.categoryCustomer;
      case 'Aile': return l.categoryFamily;
      case 'Arkadaş': return l.categoryFriend;
      case 'İş': return l.categoryWork;
      case 'Tedarikçi': return l.categorySupplier;
      case 'Diğer': return l.categoryOther;
      default: return cat;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    String title;
    if (widget.contact != null) {
      title = l.editContactTitle;
    } else if (_isPrivate) {
      title = l.addPrivateContactTitle;
    } else {
      title = l.addContactTitle;
    }

    return Scaffold(
      backgroundColor: AC.bg,
      body: Column(children: [
        _buildHeader(context, title, l),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 40),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Avatar
                  Center(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Stack(children: [
                        Container(
                          width: 80, height: 80,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [AC.navy, AC.navyLight],
                                begin: Alignment.topLeft, end: Alignment.bottomRight),
                            borderRadius: BorderRadius.circular(26),
                            border: Border.all(color: AC.gold.withOpacity(0.35), width: 2.5),
                          ),
                          child: _imagePath != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(24),
                                  child: Image.file(File(_imagePath!), fit: BoxFit.cover))
                              : const Icon(Icons.camera_alt, size: 30, color: Colors.white54),
                        ),
                        Positioned(
                          bottom: 0, right: 0,
                          child: Container(
                            width: 24, height: 24,
                            decoration: BoxDecoration(
                              color: AC.gold,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AC.bg, width: 2),
                            ),
                            child: const Icon(Icons.edit, size: 12, color: Colors.black),
                          ),
                        ),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Basic Info
                  _sectionLabel(l.basicInfo),
                  const SizedBox(height: 8),
                  GlassCard(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(children: [
                        Row(children: [
                          Expanded(child: _buildTextField(_firstNameController, l.firstName,
                              validator: (v) => v != null && v.isEmpty ? l.required : null)),
                          const SizedBox(width: 10),
                          Expanded(child: _buildTextField(_lastNameController, l.lastName)),
                        ]),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: IntlPhoneField(
                            decoration: InputDecoration(labelText: l.phone),
                            initialCountryCode: 'TR',
                            initialValue: widget.contact?.phone,
                            onChanged: (phone) {
                              _fullPhoneNumber = phone.completeNumber;
                            },
                            dropdownIconPosition: IconPosition.trailing,
                            flagsButtonPadding: const EdgeInsets.only(left: 8),
                            showDropdownIcon: true,
                            dropdownTextStyle: const TextStyle(color: Colors.white),
                          ),
                        ),
                        _buildTextField(_emailController, l.email, icon: Icons.email, keyboard: TextInputType.emailAddress),
                        _buildTextField(_socialMediaController, l.socialMedia, icon: Icons.link),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Professional
                  _sectionLabel(l.professionalLocation),
                  const SizedBox(height: 8),
                  GlassCard(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(children: [
                        _buildTextField(_companyController, l.company, icon: Icons.business),
                        _buildTextField(_jobTitleController, l.jobTitle, icon: Icons.work),
                        _buildTextField(_addressController, l.address, icon: Icons.location_on, maxLines: 2),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Important Dates
                  _sectionLabel(l.importantDates),
                  const SizedBox(height: 8),
                  GlassCard(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(children: [
                        _buildDatePickerTile(l.birthday, _selectedBirthday, Icons.cake, true, l),
                        const SizedBox(height: 8),
                        _buildDatePickerTile(l.anniversary, _selectedAnniversary, Icons.event, false, l),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Relationship Management
                  _sectionLabel(l.relationshipManagement),
                  const SizedBox(height: 8),
                  GlassCard(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(children: [
                        _buildTextField(_connectionSourceController, l.howWeKnow, icon: Icons.handshake),
                        _buildTextField(_tagsController, l.tags, icon: Icons.tag),
                        DropdownButtonFormField<String>(
                          value: _category,
                          decoration: InputDecoration(
                            labelText: l.category,
                            prefixIcon: const Icon(Icons.category_outlined),
                          ),
                          dropdownColor: AC.bgCard,
                          items: _categories.map((c) => DropdownMenuItem(
                            value: c,
                            child: Text(_localizedCategory(l, c)),
                          )).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _category = val);
                          },
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () => setState(() => _isPrivate = !_isPrivate),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            decoration: BoxDecoration(
                              color: _isPrivate ? AC.danger.withOpacity(0.08) : Colors.white.withOpacity(0.03),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: _isPrivate ? AC.danger.withOpacity(0.25) : Colors.white.withOpacity(0.09)),
                            ),
                            child: Row(children: [
                              Icon(Icons.security, color: _isPrivate ? AC.danger : Colors.white38, size: 18),
                              const SizedBox(width: 12),
                              Expanded(child: Text(l.saveAsPrivate,
                                  style: TextStyle(
                                      color: _isPrivate ? AC.danger : Colors.white54,
                                      fontSize: 13, fontWeight: FontWeight.w500))),
                              Switch(
                                value: _isPrivate,
                                onChanged: (v) => setState(() => _isPrivate = v),
                                activeColor: AC.danger,
                              ),
                            ]),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(_notesController, l.notes, icon: Icons.notes_outlined, maxLines: 3),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Save Button
                  GestureDetector(
                    onTap: _saveContact,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [AC.gold, AC.goldDim],
                            begin: Alignment.topLeft, end: Alignment.bottomRight),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: AC.gold.withOpacity(0.35), blurRadius: 20, offset: const Offset(0, 6))],
                      ),
                      child: Center(
                        child: Text(l.save,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w800, letterSpacing: 1)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildHeader(BuildContext context, String title, AppLocalizations l) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        left: 14, right: 14, bottom: 14,
      ),
      decoration: BoxDecoration(
        color: const Color(0xCC0D0D1A),
        border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.06))),
      ),
      child: Row(children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(11),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white70, size: 18),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 34, height: 34,
          decoration: BoxDecoration(
            color: _isPrivate ? AC.danger.withOpacity(0.12) : AC.goldGlass(),
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: _isPrivate ? AC.danger.withOpacity(0.3) : AC.goldBorder()),
          ),
          child: Icon(_isPrivate ? Icons.security : Icons.person_add_outlined,
              color: _isPrivate ? AC.danger : AC.gold, size: 17),
        ),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
        ])),
      ]),
    );
  }

  Widget _sectionLabel(String label) => Padding(
    padding: const EdgeInsets.only(left: 2, bottom: 0),
    child: Text(label.toUpperCase(),
        style: const TextStyle(
            color: Color(0x73FFFFFF), fontSize: 11,
            fontWeight: FontWeight.w600, letterSpacing: 0.8)),
  );

  Widget _buildTextField(TextEditingController controller, String label,
      {IconData? icon, TextInputType? keyboard, String? Function(String?)? validator, int maxLines = 1}) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: icon != null ? Icon(icon, size: 18) : null,
          ),
          keyboardType: keyboard,
          validator: validator,
          maxLines: maxLines,
        ),
      );

  Widget _buildDatePickerTile(String label, DateTime? date, IconData icon, bool isBirthday, AppLocalizations l) {
    return GestureDetector(
      onTap: () => _selectDate(context, isBirthday),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.09)),
        ),
        child: Row(children: [
          Icon(icon, color: AC.gold, size: 18),
          const SizedBox(width: 12),
          Expanded(child: Text(
            date == null ? label : '$label: ${DateFormat('dd MMMM yyyy', 'tr').format(date)}',
            style: TextStyle(color: date == null ? Colors.white38 : Colors.white, fontSize: 13),
          )),
          const Icon(Icons.calendar_today, color: Colors.white38, size: 16),
        ]),
      ),
    );
  }
}
