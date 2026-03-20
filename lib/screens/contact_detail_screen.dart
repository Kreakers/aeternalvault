import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/contact.dart';
import '../models/reminder.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import 'add_contact_screen.dart';

class ContactDetailScreen extends StatefulWidget {
  final Contact contact;
  const ContactDetailScreen({super.key, required this.contact});

  @override
  State<ContactDetailScreen> createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends State<ContactDetailScreen> {
  Contact get contact => widget.contact;

  static const _catColors = {
    'İş':      AC.navyLight,
    'Aile':    AC.gold,
    'Arkadaş': AC.success,
    'Work':    AC.navyLight,
    'Family':  AC.gold,
    'Friend':  AC.success,
    'Arbeit':  AC.navyLight,
    'Familie': AC.gold,
    'Freund':  AC.success,
    'Lavoro':  AC.navyLight,
    'Famiglia':AC.gold,
    'Amico':   AC.success,
  };
  Color _catColor() => _catColors[contact.category] ?? AC.navyLight;

  String _localizedCategory(AppLocalizations l, String cat) {
    switch (cat) {
      case 'Müşteri': return l.categoryCustomer;
      case 'Aile':    return l.categoryFamily;
      case 'Arkadaş': return l.categoryFriend;
      case 'İş':      return l.categoryWork;
      case 'Tedarikçi': return l.categorySupplier;
      case 'Diğer':   return l.categoryOther;
      default:        return cat;
    }
  }

  void _shareContact(Contact c, AppLocalizations l) {
    Share.share(l.shareContact(
      '${c.firstName} ${c.lastName}',
      c.phone,
      c.email,
    ));
  }

  Future<void> _launchUrl(String url) async {
    final l = AppLocalizations.of(context);
    try {
      final uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l.cannotLaunch)),
          );
        }
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).cannotLaunch)),
        );
      }
    }
  }

  void _callContact(Contact c) => _launchUrl('tel:${c.phone}');
  void _emailContact(Contact c) => _launchUrl('mailto:${c.email}');
  void _smsContact(Contact c) => _launchUrl('sms:${c.phone}');
  void _whatsappContact(Contact c) {
    final digits = c.phone.replaceAll(RegExp(r'[^0-9]'), '');
    _launchUrl('https://wa.me/$digits');
  }

  Future<void> _showAddNoteDialog(BuildContext context, AppLocalizations l) async {
    final ctrl = TextEditingController();
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              color: AC.cyan.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AC.cyan.withOpacity(0.3)),
            ),
            child: const Icon(Icons.edit_note, color: AC.cyan, size: 16),
          ),
          const SizedBox(width: 10),
          Text(l.addNote),
        ]),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          maxLines: 4,
          decoration: InputDecoration(hintText: l.addNoteHint),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l.cancel)),
          ElevatedButton(
            onPressed: () async {
              if (ctrl.text.trim().isNotEmpty) {
                await Provider.of<AppProvider>(context, listen: false)
                    .addManualNote(contact.id!, ctrl.text.trim());
                if (ctx.mounted) Navigator.pop(ctx);
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AC.cyan, foregroundColor: Colors.white),
            child: Text(l.save),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddReminderDialog(BuildContext context, AppLocalizations l) async {
    final ctrl = TextEditingController();
    DateTime selected = DateTime.now().add(const Duration(hours: 1));
    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDs) => AlertDialog(
          title: Text(l.newTask),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
              controller: ctrl,
              decoration: InputDecoration(labelText: l.taskName),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: selected,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (date != null && context.mounted) {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(selected),
                  );
                  if (time != null) {
                    setDs(() {
                      selected = DateTime(date.year, date.month, date.day, time.hour, time.minute);
                    });
                  }
                }
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AC.navyGlass(),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AC.navyBorder(0.3)),
                ),
                child: Row(children: [
                  const Icon(Icons.calendar_today, color: AC.gold, size: 16),
                  const SizedBox(width: 10),
                  Text(DateFormat('dd MMM yyyy HH:mm').format(selected),
                      style: const TextStyle(color: Colors.white, fontSize: 13)),
                ]),
              ),
            ),
          ]),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l.cancel)),
            ElevatedButton(
              onPressed: () async {
                if (ctrl.text.isNotEmpty) {
                  final reminder = Reminder(
                      contactId: contact.id!, title: ctrl.text, dateTime: selected);
                  await Provider.of<AppProvider>(context, listen: false).addReminder(reminder);
                  if (ctx.mounted) Navigator.pop(ctx);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: AC.gold, foregroundColor: Colors.black),
              child: Text(l.add),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: isDark ? AC.bg : AL.bg,
      body: Consumer<AppProvider>(builder: (context, provider, _) {
        final c = provider.contacts.firstWhere((x) => x.id == contact.id, orElse: () => contact);
        final logs = provider.allLogs.where((log) => log.contactId == contact.id).toList();
        final reminders = provider.allReminders.where((r) => r.contactId == contact.id).toList();

        return Stack(children: [
          SingleChildScrollView(
            child: Column(children: [
              _buildTopBar(context, c, l),
              _buildAvatarHero(context, c, l),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 120),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _sectionLabel(l.contactInfo),
                  const SizedBox(height: 8),
                  _infoCard(Icons.phone, l.phone, c.phone.isEmpty ? '-' : c.phone, AC.success),
                  const SizedBox(height: 7),
                  _infoCard(Icons.email_outlined, l.email, c.email.isEmpty ? '-' : c.email, AC.cyan),
                  const SizedBox(height: 7),
                  if (c.birthday != null)
                    _infoCard(Icons.cake_outlined, l.birthday,
                        DateFormat('dd MMMM yyyy').format(c.birthday!), AC.gold),
                  if (c.birthday != null) const SizedBox(height: 7),
                  if (c.lastContactDate != null)
                    _infoCard(Icons.access_time, l.lastContact,
                        DateFormat('dd MMM yyyy').format(c.lastContactDate!), AC.navyLight),
                  if (c.lastContactDate != null) const SizedBox(height: 7),
                  if (c.contactFrequency > 0)
                    _infoCard(Icons.repeat, l.contactFrequency,
                        l.everyNDays(c.contactFrequency), const Color(0xFF9C27B0)),
                  if (c.contactFrequency > 0) const SizedBox(height: 7),
                  if (c.connectionSource.isNotEmpty)
                    _infoCard(Icons.handshake_outlined, l.connectionSource,
                        c.connectionSource, const Color(0xFF9C27B0)),
                  if (c.connectionSource.isNotEmpty) const SizedBox(height: 7),
                  if (c.tags.isNotEmpty)
                    _infoCard(Icons.tag, l.tags, c.tags, AC.navyLight),
                  if (c.tags.isNotEmpty) const SizedBox(height: 7),
                  if (c.notes.isNotEmpty) ...[
                    _infoCard(Icons.notes_outlined, l.notes, c.notes, AC.gold),
                    const SizedBox(height: 7),
                  ],
                  const SizedBox(height: 9),

                  if (c.contactFrequency > 0) ...[
                    _buildTrackingCard(c, l),
                    const SizedBox(height: 16),
                  ],

                  if (reminders.isNotEmpty || true) ...[
                    _sectionLabel(l.reminders),
                    const SizedBox(height: 8),
                    GlassCard(
                      child: Column(children: [
                        if (reminders.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(l.noPendingTasks, style: TextStyle(color: isDark ? AC.textMuted : AL.textMuted, fontSize: 12)),
                          ),
                        ...List.generate(reminders.length, (i) {
                          final r = reminders[i];
                          return Column(children: [
                            GestureDetector(
                              onTap: () {
                                final updated = Reminder(
                                    id: r.id, contactId: r.contactId, title: r.title,
                                    dateTime: r.dateTime, isCompleted: !r.isCompleted);
                                provider.updateReminder(updated);
                              },
                              child: Container(
                                color: Colors.transparent,
                                padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
                                child: Row(children: [
                                  Icon(r.isCompleted ? Icons.check_box : Icons.check_box_outline_blank,
                                      color: r.isCompleted ? AC.success : (isDark ? const Color(0x40FFFFFF) : AL.textMuted), size: 18),
                                  const SizedBox(width: 10),
                                  Expanded(child: Text(r.title, style: TextStyle(
                                      color: r.isCompleted ? (isDark ? Colors.white38 : AL.textMuted) : (isDark ? Colors.white : AL.textPrimary),
                                      fontSize: 12, fontWeight: FontWeight.w500,
                                      decoration: r.isCompleted ? TextDecoration.lineThrough : null))),
                                  Text(DateFormat('dd MMM').format(r.dateTime),
                                      style: TextStyle(
                                          color: r.isCompleted ? (isDark ? Colors.white24 : AL.textMuted) : AC.gold,
                                          fontSize: 10, fontWeight: FontWeight.w600)),
                                ]),
                              ),
                            ),
                            if (i < reminders.length - 1)
                              Divider(height: 1, color: isDark ? Colors.white.withOpacity(0.04) : AL.divider),
                          ]);
                        }),
                      ]),
                    ),
                    const SizedBox(height: 16),
                  ],

                  if (logs.isNotEmpty) ...[
                    _sectionLabel(l.activityLog),
                    const SizedBox(height: 8),
                    GlassCard(
                      child: Column(children: List.generate(logs.take(10).length, (i) {
                        final log = logs[i];
                        final isNote = log.isManual;
                        return Column(children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
                            child: Row(children: [
                              Container(
                                width: 34, height: 34,
                                decoration: BoxDecoration(
                                  color: isNote
                                      ? AC.gold.withOpacity(0.12)
                                      : AC.navyLight.withOpacity(0.09),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: isNote
                                          ? AC.gold.withOpacity(0.25)
                                          : AC.navyLight.withOpacity(0.17)),
                                ),
                                child: Icon(
                                  isNote ? Icons.edit_note : Icons.history,
                                  color: isNote ? AC.gold : AC.navyLight,
                                  size: 15,
                                ),
                              ),
                              const SizedBox(width: 11),
                              Expanded(child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (isNote)
                                    Text(l.manualNote,
                                        style: TextStyle(
                                            color: AC.gold.withOpacity(0.7),
                                            fontSize: 9,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.4)),
                                  Text(log.action,
                                      style: TextStyle(
                                          color: isNote ? AC.gold : (isDark ? Colors.white : AL.textPrimary),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600)),
                                ],
                              )),
                              Text(DateFormat('dd MMM').format(log.timestamp),
                                  style: TextStyle(color: isDark ? AC.textMuted : AL.textMuted, fontSize: 10)),
                            ]),
                          ),
                          if (i < logs.take(10).length - 1)
                            Divider(height: 1, color: isDark ? Colors.white.withOpacity(0.04) : AL.divider),
                        ]);
                      })),
                    ),
                  ],
                ]),
              ),
            ]),
          ),
          Positioned(
            bottom: 24, right: 14,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              GestureDetector(
                onTap: () => _showAddReminderDialog(context, l),
                child: Container(
                  width: 52, height: 52,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [AC.navyLight, AC.navy],
                        begin: Alignment.topLeft, end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AC.gold.withOpacity(0.25)),
                    boxShadow: [BoxShadow(color: AC.navy.withOpacity(0.5), blurRadius: 20, offset: const Offset(0, 6))],
                  ),
                  child: const Icon(Icons.alarm_add, color: AC.gold, size: 22),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => _showAddNoteDialog(context, l),
                child: Container(
                  width: 52, height: 52,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [AC.cyan, Color(0xFF0097A7)],
                        begin: Alignment.topLeft, end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AC.cyan.withOpacity(0.35)),
                    boxShadow: [BoxShadow(
                        color: AC.cyan.withOpacity(0.35),
                        blurRadius: 20, offset: const Offset(0, 6))],
                  ),
                  child: const Icon(Icons.edit_note, color: Colors.white, size: 22),
                ),
              ),
              const SizedBox(height: 10),
              GoldFab(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => AddContactScreen(contact: c))),
                icon: Icons.edit_outlined,
              ),
            ]),
          ),
        ]);
      }),
    );
  }

  Widget _buildTopBar(BuildContext context, Contact c, AppLocalizations l) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        left: 14, right: 14, bottom: 0,
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
            child: Icon(Icons.arrow_back, color: isDark ? Colors.white70 : AL.textSec, size: 16),
          ),
        ),
        const Spacer(),
        Text(l.contactDetail,
            style: TextStyle(color: isDark ? AC.textSec : AL.textSec, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.4)),
        const Spacer(),
        GestureDetector(
          onTap: () => _shareContact(c, l),
          child: Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: AC.goldGlass(),
              borderRadius: BorderRadius.circular(11),
              border: Border.all(color: AC.goldBorder()),
            ),
            child: const Icon(Icons.share_outlined, color: AC.gold, size: 16),
          ),
        ),
      ]),
    );
  }

  Widget _buildAvatarHero(BuildContext context, Contact c, AppLocalizations l) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = _catColor();
    final hasImage = c.imagePath != null;
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 20, 14, 20),
      child: Column(children: [
        Stack(alignment: Alignment.bottomRight, children: [
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [AC.navy, AC.navyLight],
                  begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: AC.gold.withOpacity(0.35), width: 2.5),
              boxShadow: [
                BoxShadow(color: AC.navy.withOpacity(0.5), blurRadius: 32),
                BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 24, offset: const Offset(0, 8)),
              ],
            ),
            child: hasImage
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.file(File(c.imagePath!), fit: BoxFit.cover))
                : Center(
                    child: Text(
                      '${c.firstName.isNotEmpty ? c.firstName[0] : ''}${c.lastName.isNotEmpty ? c.lastName[0] : ''}'.toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: 1),
                    ),
                  ),
          ),
          Positioned(
            bottom: -4, right: -4,
            child: Container(
              width: 22, height: 22,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: isDark ? AC.bg : AL.bgCard, width: 2),
              ),
              child: const Icon(Icons.people, color: Colors.white, size: 11),
            ),
          ),
        ]),
        const SizedBox(height: 12),
        Text('${c.firstName} ${c.lastName}',
            style: TextStyle(color: isDark ? Colors.white : AL.textPrimary, fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -0.3)),
        if (c.jobTitle.isNotEmpty || c.company.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            [if (c.jobTitle.isNotEmpty) c.jobTitle, if (c.company.isNotEmpty) c.company].join(' · '),
            style: TextStyle(color: isDark ? AC.textSec : AL.textSec, fontSize: 12),
          ),
        ],
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.13),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withOpacity(0.27)),
          ),
          child: Text(_localizedCategory(l, c.category),
              style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
        ),
        const SizedBox(height: 14),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          _quickAction(Icons.phone, l.call, AC.success, () => _callContact(c)),
          const SizedBox(width: 8),
          _quickAction(Icons.email_outlined, l.sendEmail, AC.cyan, () => _emailContact(c)),
          const SizedBox(width: 8),
          _quickAction(Icons.message_outlined, l.sendSms, AC.gold, () => _smsContact(c)),
          const SizedBox(width: 8),
          _quickAction(Icons.chat, l.openWhatsapp, const Color(0xFF25D366), () => _whatsappContact(c)),
        ]),
      ]),
    );
  }

  Widget _quickAction(IconData icon, String label, Color color, VoidCallback onTap) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.06),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withOpacity(0.16)),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 5),
            Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600)),
          ]),
        ),
      );

  Widget _buildTrackingCard(Contact c, AppLocalizations l) {
    final now = DateTime.now();
    final diff = now.difference(c.lastContactDate ?? now).inDays;
    final isLate = diff >= c.contactFrequency;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: (isLate ? AC.warning : AC.success).withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: (isLate ? AC.warning : AC.success).withOpacity(0.2)),
      ),
      child: Row(children: [
        Icon(isLate ? Icons.warning_amber_rounded : Icons.check_circle_outline,
            color: isLate ? AC.warning : AC.success, size: 20),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(isLate ? l.trackingLate : l.trackingGood,
              style: TextStyle(
                  color: isLate ? AC.warning : AC.success,
                  fontSize: 12, fontWeight: FontWeight.w700)),
          Text(l.daysSinceLastContact(diff),
              style: const TextStyle(color: AC.textMuted, fontSize: 10)),
        ])),
      ]),
    );
  }

  Widget _infoCard(IconData icon, String label, String value, Color color) {
    return GlassCard(
      tint: GlassTint.navy,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.09),
              borderRadius: BorderRadius.circular(11),
              border: Border.all(color: color.withOpacity(0.19)),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(child: Builder(builder: (context) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label, style: TextStyle(color: isDark ? AC.textMuted : AL.textMuted, fontSize: 10, fontWeight: FontWeight.w500)),
              const SizedBox(height: 2),
              Text(value,
                  style: TextStyle(color: isDark ? Colors.white : AL.textPrimary, fontSize: 13, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis),
            ]);
          })),
          Builder(builder: (context) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return Icon(Icons.chevron_right, color: isDark ? Colors.white24 : AL.textMuted, size: 16);
          }),
        ]),
      ),
    );
  }

  Widget _sectionLabel(String label) => Builder(
    builder: (context) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      return Padding(
        padding: const EdgeInsets.only(left: 2, bottom: 0),
        child: Text(label.toUpperCase(),
            style: TextStyle(
                color: isDark ? const Color(0x73FFFFFF) : AL.textMuted, fontSize: 11,
                fontWeight: FontWeight.w600, letterSpacing: 0.8)),
      );
    },
  );
}
