import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../models/contact.dart';
import '../models/reminder.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import 'add_contact_screen.dart';

class ContactDetailScreen extends StatelessWidget {
  final Contact contact;
  const ContactDetailScreen({super.key, required this.contact});

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

  void _shareContact(Contact c, AppLocalizations l) {
    Share.share(l.shareContact(
      '${c.firstName} ${c.lastName}',
      c.phone,
      c.email,
    ));
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
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AC.bg,
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
                  _infoCard(Icons.email_outlined, l.email, c.email.isEmpty ? '-' : c.email, const Color(0xFF00BCD4)),
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
                  const SizedBox(height: 16),

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
                            child: Text(l.noPendingTasks, style: const TextStyle(color: AC.textMuted, fontSize: 12)),
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
                                      color: r.isCompleted ? AC.success : const Color(0x40FFFFFF), size: 18),
                                  const SizedBox(width: 10),
                                  Expanded(child: Text(r.title, style: TextStyle(
                                      color: r.isCompleted ? Colors.white38 : Colors.white,
                                      fontSize: 12, fontWeight: FontWeight.w500,
                                      decoration: r.isCompleted ? TextDecoration.lineThrough : null))),
                                  Text(DateFormat('dd MMM').format(r.dateTime),
                                      style: TextStyle(
                                          color: r.isCompleted ? Colors.white24 : AC.gold,
                                          fontSize: 10, fontWeight: FontWeight.w600)),
                                ]),
                              ),
                            ),
                            if (i < reminders.length - 1)
                              Divider(height: 1, color: Colors.white.withOpacity(0.04)),
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
                      child: Column(children: List.generate(logs.take(5).length, (i) {
                        final log = logs[i];
                        return Column(children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
                            child: Row(children: [
                              Container(
                                width: 34, height: 34,
                                decoration: BoxDecoration(
                                  color: AC.navyLight.withOpacity(0.09),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: AC.navyLight.withOpacity(0.17)),
                                ),
                                child: const Icon(Icons.history, color: AC.navyLight, size: 15),
                              ),
                              const SizedBox(width: 11),
                              Expanded(child: Text(log.action,
                                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600))),
                              Text(DateFormat('dd MMM').format(log.timestamp),
                                  style: const TextStyle(color: AC.textMuted, fontSize: 10)),
                            ]),
                          ),
                          if (i < logs.take(5).length - 1)
                            Divider(height: 1, color: Colors.white.withOpacity(0.04)),
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
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(11),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white70, size: 16),
          ),
        ),
        const Spacer(),
        Text(l.contactDetail,
            style: const TextStyle(color: AC.textSec, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.4)),
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
                border: Border.all(color: AC.bg, width: 2),
              ),
              child: const Icon(Icons.people, color: Colors.white, size: 11),
            ),
          ),
        ]),
        const SizedBox(height: 12),
        Text('${c.firstName} ${c.lastName}',
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -0.3)),
        if (c.jobTitle.isNotEmpty || c.company.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            [if (c.jobTitle.isNotEmpty) c.jobTitle, if (c.company.isNotEmpty) c.company].join(' · '),
            style: const TextStyle(color: AC.textSec, fontSize: 12),
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
          child: Text(c.category,
              style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
        ),
        const SizedBox(height: 14),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          _quickAction(Icons.phone, l.call, AC.success),
          const SizedBox(width: 10),
          _quickAction(Icons.email_outlined, l.write, const Color(0xFF00BCD4)),
          const SizedBox(width: 10),
          _quickAction(Icons.message_outlined, l.sms, AC.gold),
        ]),
      ]),
    );
  }

  Widget _quickAction(IconData icon, String label, Color color) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
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
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: const TextStyle(color: AC.textMuted, fontSize: 10, fontWeight: FontWeight.w500)),
            const SizedBox(height: 2),
            Text(value,
                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis),
          ])),
          const Icon(Icons.chevron_right, color: Colors.white24, size: 16),
        ]),
      ),
    );
  }

  Widget _sectionLabel(String label) => Padding(
    padding: const EdgeInsets.only(left: 2, bottom: 0),
    child: Text(label.toUpperCase(),
        style: const TextStyle(
            color: Color(0x73FFFFFF), fontSize: 11,
            fontWeight: FontWeight.w600, letterSpacing: 0.8)),
  );
}
