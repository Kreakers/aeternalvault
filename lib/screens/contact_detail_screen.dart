import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../models/contact.dart';
import '../models/reminder.dart';
import '../providers/app_provider.dart';
import 'add_contact_screen.dart';

class ContactDetailScreen extends StatefulWidget {
  final Contact contact;

  const ContactDetailScreen({super.key, required this.contact});

  @override
  State<ContactDetailScreen> createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends State<ContactDetailScreen> {
  List<Reminder> _reminders = [];

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final reminders = await provider.getRemindersForContact(widget.contact.id!);
    setState(() {
      _reminders = reminders;
    });
  }

  void _shareContact(Contact contact) {
    final text = 'Kişi Paylaşımı:\n'
        'Ad Soyad: ${contact.firstName} ${contact.lastName}\n'
        'Telefon: ${contact.phone}\n'
        'E-posta: ${contact.email}\n'
        'Şirket: ${contact.company}\n'
        '\nAeterna Vault CRM üzerinden paylaşıldı.';
    Share.share(text);
  }

  Future<void> _showAddReminderDialog() async {
    final titleController = TextEditingController();
    DateTime selectedDate = DateTime.now().add(const Duration(hours: 1));

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Yeni Hatırlatıcı'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Görev / Hatırlatma'),
                autofocus: true,
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(DateFormat('dd MMMM yyyy HH:mm', 'tr').format(selectedDate)),
                leading: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    if (!mounted) return;
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(selectedDate),
                    );
                    if (time != null) {
                      setDialogState(() {
                        selectedDate = DateTime(date.year, date.month, date.day, time.hour, time.minute);
                      });
                    }
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isNotEmpty) {
                  final reminder = Reminder(
                    contactId: widget.contact.id!,
                    title: titleController.text,
                    dateTime: selectedDate,
                  );
                  await Provider.of<AppProvider>(context, listen: false).addReminder(reminder);
                  if (!mounted) return;
                  Navigator.pop(context);
                  _loadReminders();
                }
              },
              child: const Text('Ekle'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kişi Detayları'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareContact(widget.contact),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddContactScreen(contact: widget.contact)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: () => _showDeleteConfirm(context),
          ),
        ],
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          final currentContact = provider.contacts.firstWhere(
            (c) => c.id == widget.contact.id,
            orElse: () => widget.contact,
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, currentContact),
                const SizedBox(height: 24),
                _buildTimeline(context, currentContact),
                const SizedBox(height: 24),
                _buildSmartTrackingCard(context, currentContact),
                const SizedBox(height: 16),
                _buildContactInfo(context, currentContact),
                const SizedBox(height: 24),
                _buildRemindersSection(context),
                const SizedBox(height: 80), 
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddReminderDialog,
        icon: const Icon(Icons.alarm_add),
        label: const Text('Görev Ekle'),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Contact contact) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            backgroundImage: contact.imagePath != null ? FileImage(File(contact.imagePath!)) : null,
            child: contact.imagePath == null 
                ? Text(contact.firstName[0].toUpperCase(), style: const TextStyle(fontSize: 48)) 
                : null,
          ),
          const SizedBox(height: 16),
          Text('${contact.firstName} ${contact.lastName}', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          if (contact.jobTitle.isNotEmpty)
            Text('${contact.jobTitle} @ ${contact.company}', style: const TextStyle(fontSize: 16, color: Colors.grey)),
          if (contact.tags.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Wrap(
                spacing: 8,
                children: contact.tags.split(',').map((tag) => Chip(
                  label: Text(tag.trim(), style: const TextStyle(fontSize: 10)),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                )).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTimeline(BuildContext context, Contact contact) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Zaman Tüneli', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _buildTimelineItem(context, Icons.person_add, 'Kayıt Edildi', contact.anniversary != null ? DateFormat('dd MMM yyyy').format(contact.anniversary!) : 'Bilinmiyor'),
        _buildTimelineItem(context, Icons.history, 'Son Görüşme', contact.lastContactDate != null ? DateFormat('dd MMM yyyy').format(contact.lastContactDate!) : 'Henüz görüşülmedi'),
      ],
    );
  }

  Widget _buildTimelineItem(BuildContext context, IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Text('$title: ', style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(subtitle, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildSmartTrackingCard(BuildContext context, Contact contact) {
    if (contact.contactFrequency == 0) return const SizedBox.shrink();

    final now = DateTime.now();
    final lastDate = contact.lastContactDate ?? now;
    final diff = now.difference(lastDate).inDays;
    final isLate = diff >= contact.contactFrequency;

    return Card(
      color: isLate ? Colors.orange.shade50 : Colors.green.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: isLate ? Colors.orange : Colors.green)),
      child: ListTile(
        leading: Icon(isLate ? Icons.warning_amber_rounded : Icons.check_circle_outline, color: isLate ? Colors.orange : Colors.green),
        title: Text(isLate ? 'Görüşme Zamanı Geçmiş!' : 'Takip Durumu İyi'),
        subtitle: Text('Son görüşme üzerinden $diff gün geçti. (Hedef: ${contact.contactFrequency} gün)'),
        trailing: TextButton(
          onPressed: () async {
            final updated = contact.copyWith(lastContactDate: DateTime.now());
            await Provider.of<AppProvider>(context, listen: false).updateContact(updated);
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Takip tarihi güncellendi.')));
          },
          child: const Text('GÖRÜŞTÜM'),
        ),
      ),
    );
  }

  Widget _buildContactInfo(BuildContext context, Contact contact) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInfoRow(context, Icons.phone, 'Telefon', contact.phone),
            if (contact.email.isNotEmpty) _buildInfoRow(context, Icons.email, 'E-posta', contact.email),
            if (contact.socialMedia.isNotEmpty) _buildInfoRow(context, Icons.link, 'Sosyal Medya', contact.socialMedia),
            if (contact.address.isNotEmpty) _buildInfoRow(context, Icons.location_on, 'Adres', contact.address),
            _buildInfoRow(context, Icons.category, 'Kategori', contact.category),
            if (contact.birthday != null)
              _buildInfoRow(context, Icons.cake, 'Doğum Günü', DateFormat('dd MMMM yyyy', 'tr').format(contact.birthday!)),
            if (contact.connectionSource.isNotEmpty)
              _buildInfoRow(context, Icons.handshake, 'Tanışma Kaynağı', contact.connectionSource),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                Text(value, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemindersSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Görevler ve Hatırlatıcılar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        if (_reminders.isEmpty)
          const Text('Henüz bir hatırlatıcı eklenmemiş.', style: TextStyle(color: Colors.grey)),
        ..._reminders.map((r) => Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: CheckboxListTile(
            title: Text(r.title, style: TextStyle(decoration: r.isCompleted ? TextDecoration.lineThrough : null)),
            subtitle: Text(DateFormat('dd MMM HH:mm', 'tr').format(r.dateTime)),
            value: r.isCompleted,
            onChanged: (val) async {
              final updated = Reminder(id: r.id, contactId: r.contactId, title: r.title, dateTime: r.dateTime, isCompleted: val!);
              await Provider.of<AppProvider>(context, listen: false).updateReminder(updated);
              _loadReminders();
            },
            secondary: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: () async {
                await Provider.of<AppProvider>(context, listen: false).deleteReminder(r.id!);
                _loadReminders();
              },
            ),
          ),
        )),
      ],
    );
  }

  void _showDeleteConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sil?'),
        content: const Text('Bu kişiyi ve tüm verilerini silmek istediğinize emin misiniz?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('İptal')),
          TextButton(
            onPressed: () {
              Provider.of<AppProvider>(context, listen: false).deleteContact(widget.contact.id!);
              Navigator.pop(dialogContext);
              Navigator.pop(context);
            },
            child: const Text('Sil', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
