import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:open_filex/open_filex.dart';
import '../providers/app_provider.dart';
import '../models/contact.dart';
import '../models/vault_item.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import 'add_vault_item_screen.dart';
import 'contact_detail_screen.dart';
import 'add_contact_screen.dart';

class VaultScreen extends StatefulWidget {
  const VaultScreen({super.key});

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Set<int> _visiblePasswords = {};
  final Set<int> _copiedItems = {};
  String _filter = 'all';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<(String, String)> _getFilters(AppLocalizations l) => [
    ('all', l.filterAll),
    ('Şifre', l.filterPasswords),
    ('Banka', l.filterBank),
    ('Belge', l.filterDocuments),
  ];

  Future<void> _openFile(String? path) async {
    if (path == null || path.isEmpty) return;
    final l = AppLocalizations.of(context);
    try {
      final file = File(path);
      if (await file.exists()) {
        await OpenFilex.open(path);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.fileNotFound)));
      }
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.fileOpenError)));
    }
  }

  void _copyToClipboard(String value, int id) {
    Clipboard.setData(ClipboardData(text: value));
    setState(() => _copiedItems.add(id));
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) setState(() => _copiedItems.remove(id));
    });
    Future.delayed(const Duration(seconds: 30), () {
      Clipboard.setData(const ClipboardData(text: ''));
    });
  }

  Future<void> _deleteVaultItem(BuildContext context, VaultItem item, AppLocalizations l) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              color: AC.danger.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AC.danger.withOpacity(0.25)),
            ),
            child: const Icon(Icons.delete_outline, color: AC.danger, size: 16),
          ),
          const SizedBox(width: 10),
          Text(l.deleteVaultItem),
        ]),
        content: Text(l.deleteVaultItemConfirm(item.title)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: AC.danger, foregroundColor: Colors.white),
            child: Text(l.delete),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await Provider.of<AppProvider>(context, listen: false).deleteVaultItem(item.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final filters = _getFilters(l);
    return Scaffold(
      backgroundColor: AC.bg,
      body: Column(children: [
        _buildHeader(l),
        _buildTabBar(l),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildPrivateContactsTab(l),
              _buildVaultItemsTab(l, filters),
            ],
          ),
        ),
      ]),
      floatingActionButton: GoldFab(
        icon: Icons.add,
        onPressed: () {
          if (_tabController.index == 0) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AddContactScreen(isInitiallyPrivate: true)));
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AddVaultItemScreen()));
          }
        },
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────
  Widget _buildHeader(AppLocalizations l) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 16, right: 16, bottom: 14,
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
            color: AC.goldGlass(),
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: AC.goldBorder()),
            boxShadow: [BoxShadow(color: AC.gold.withOpacity(0.2), blurRadius: 20)],
          ),
          child: const Icon(Icons.lock_outline, color: AC.gold, size: 17),
        ),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(l.vaultScreenTitle,
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
          Consumer<AppProvider>(builder: (_, p, __) =>
              Text(l.encryptedRecordsCount(p.vaultItems.length),
                  style: const TextStyle(color: AC.textMuted, fontSize: 10))),
        ])),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AC.success.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AC.success.withOpacity(0.25)),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: 6, height: 6,
              decoration: BoxDecoration(
                color: AC.success,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: AC.success, blurRadius: 6)],
              ),
            ),
            const SizedBox(width: 5),
            Text(l.protected, style: const TextStyle(color: AC.success, fontSize: 10, fontWeight: FontWeight.w700)),
          ]),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {
            Provider.of<AppProvider>(context, listen: false).lockVault();
            Navigator.pop(context);
          },
          child: Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: AC.danger.withOpacity(0.08),
              borderRadius: BorderRadius.circular(11),
              border: Border.all(color: AC.danger.withOpacity(0.2)),
            ),
            child: const Icon(Icons.lock_reset, color: AC.danger, size: 18),
          ),
        ),
      ]),
    );
  }

  Widget _buildTabBar(AppLocalizations l) {
    return Container(
      color: const Color(0xCC0D0D1A),
      child: TabBar(
        controller: _tabController,
        tabs: [
          Tab(icon: const Icon(Icons.people_alt, size: 18), text: l.hiddenContacts),
          Tab(icon: const Icon(Icons.description, size: 18), text: l.documentsPasswords),
        ],
        labelColor: AC.gold,
        unselectedLabelColor: Colors.white38,
        indicatorColor: AC.gold,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        dividerColor: Colors.white.withOpacity(0.06),
      ),
    );
  }

  // ── Private Contacts Tab ──────────────────────────────────
  Widget _buildPrivateContactsTab(AppLocalizations l) {
    return Consumer<AppProvider>(builder: (context, provider, _) {
      final privateContacts = provider.contacts.where((c) => c.isPrivate).toList();
      if (privateContacts.isEmpty) {
        return _emptyState(Icons.people_outline, l.noHiddenContacts, l.addWithPlusButton);
      }

      final Map<String, List<Contact>> grouped = {};
      for (var c in privateContacts) {
        grouped.putIfAbsent(c.category, () => []).add(c);
      }
      final cats = grouped.keys.toList()..sort();

      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 80),
        itemCount: cats.length,
        itemBuilder: (_, i) {
          final cat = cats[i];
          final items = grouped[cat]!;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GlassCard(
              child: ExpansionTile(
                leading: const Icon(Icons.folder_shared, color: AC.gold, size: 20),
                title: Text(cat, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
                iconColor: Colors.white38,
                collapsedIconColor: Colors.white38,
                children: items.map((c) => ListTile(
                  leading: AeternaAvatar(name: '${c.firstName} ${c.lastName}', size: 36),
                  title: Text('${c.firstName} ${c.lastName}',
                      style: const TextStyle(color: Colors.white, fontSize: 13)),
                  trailing: const Icon(Icons.chevron_right, color: Colors.white24, size: 16),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ContactDetailScreen(contact: c))),
                )).toList(),
              ),
            ),
          );
        },
      );
    });
  }

  // ── Vault Items Tab ───────────────────────────────────────
  Widget _buildVaultItemsTab(AppLocalizations l, List<(String, String)> filters) {
    return Consumer<AppProvider>(builder: (context, provider, _) {
      var items = provider.vaultItems;
      if (items.isEmpty) {
        return _emptyState(Icons.enhanced_encryption, l.vaultEmpty, l.addWithPlusButton);
      }

      final displayed = _filter == 'all' ? items : items.where((i) => i.category == _filter).toList();

      return Column(children: [
        SizedBox(
          height: 48,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            children: filters.map((f) {
              final active = _filter == f.$1;
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: GestureDetector(
                  onTap: () => setState(() => _filter = f.$1),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: active ? AC.gold.withOpacity(0.15) : Colors.white.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: active ? AC.gold : Colors.white.withOpacity(0.1)),
                    ),
                    child: Text(f.$2,
                        style: TextStyle(
                          color: active ? AC.gold : Colors.white54,
                          fontSize: 11,
                          fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                        )),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(14, 4, 14, 80),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.82,
            ),
            itemCount: displayed.length,
            itemBuilder: (_, i) => _VaultCard(
              item: displayed[i],
              isVisible: _visiblePasswords.contains(displayed[i].id),
              isCopied: _copiedItems.contains(displayed[i].id),
              openFileLabel: l.openFile,
              onToggleVisible: () => setState(() {
                if (_visiblePasswords.contains(displayed[i].id)) {
                  _visiblePasswords.remove(displayed[i].id);
                } else {
                  _visiblePasswords.add(displayed[i].id!);
                }
              }),
              onCopy: (val) => _copyToClipboard(val, displayed[i].id!),
              onEdit: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => AddVaultItemScreen(vaultItem: displayed[i]))),
              onOpenFile: () => _openFile(displayed[i].filePath),
              onDelete: () => _deleteVaultItem(context, displayed[i], l),
            ),
          ),
        ),
      ]);
    });
  }

  Widget _emptyState(IconData icon, String title, String sub) {
    return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, color: Colors.white12, size: 56),
      const SizedBox(height: 12),
      Text(title, style: const TextStyle(color: Colors.white38, fontSize: 15, fontWeight: FontWeight.w600)),
      const SizedBox(height: 4),
      Text(sub, style: const TextStyle(color: AC.textMuted, fontSize: 12)),
    ]));
  }
}

// ── Vault Card ────────────────────────────────────────────────
class _VaultCard extends StatelessWidget {
  final VaultItem item;
  final bool isVisible;
  final bool isCopied;
  final String openFileLabel;
  final VoidCallback onToggleVisible;
  final void Function(String) onCopy;
  final VoidCallback onEdit;
  final VoidCallback onOpenFile;
  final VoidCallback onDelete;

  const _VaultCard({
    required this.item,
    required this.isVisible,
    required this.isCopied,
    required this.openFileLabel,
    required this.onToggleVisible,
    required this.onCopy,
    required this.onEdit,
    required this.onOpenFile,
    required this.onDelete,
  });

  static const _catMeta = {
    'Şifre':  (Icons.password,     Color(0xFFEA4335), Color(0x3FEA4335)),
    'Banka':  (Icons.account_balance, Color(0xFF1A73E8), Color(0x3F1A73E8)),
    'Belge':  (Icons.description,  AC.gold,           Color(0x3FFFB300)),
    'Kimlik': (Icons.person,       Color(0xFF00BCD4), Color(0x3F00BCD4)),
  };

  (IconData, Color, Color) get _meta {
    final m = _catMeta[item.category];
    return m ?? (Icons.security, AC.navyLight, AC.navyLight.withOpacity(0.25));
  }

  @override
  Widget build(BuildContext context) {
    final (icon, color, glow) = _meta;

    Map<String, dynamic> data = {};
    try { data = jsonDecode(item.secretContent); } catch (_) { data = {'f1': item.secretContent}; }

    final secret = data['f2'] ?? data['f1'] ?? '';
    final isPassword = item.category == 'Şifre';

    return GestureDetector(
      onTap: onEdit,
      onLongPress: onDelete,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AC.navyGlass(0.22), AC.bg.withOpacity(0.5)],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.19)),
        ),
        child: Stack(children: [
          Positioned(
            top: -20, right: -20,
            child: Container(
              width: 70, height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [glow, Colors.transparent]),
              ),
            ),
          ),
          Positioned(
            bottom: 0, left: 14, right: 14,
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.transparent, color.withOpacity(0.5), Colors.transparent,
                ]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(color: color.withOpacity(0.22)),
                    boxShadow: [BoxShadow(color: glow, blurRadius: 12)],
                  ),
                  child: Icon(icon, color: color, size: 17),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onEdit,
                  child: Container(
                    width: 26, height: 26,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.edit_outlined, color: Colors.white54, size: 13),
                  ),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    width: 26, height: 26,
                    decoration: BoxDecoration(
                      color: AC.danger.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.delete_outline, color: AC.danger, size: 13),
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              Text(item.title,
                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              Text(data['f1'] ?? '-',
                  style: const TextStyle(color: AC.textMuted, fontSize: 10),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(children: [
                  Expanded(
                    child: Text(
                      isVisible ? secret : '••••••••••',
                      style: TextStyle(
                        color: isVisible ? Colors.white : Colors.white54,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: isVisible ? 0 : 1,
                        fontFamily: 'monospace',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isPassword || secret.isNotEmpty) ...[
                    _iconBtn(
                      isVisible ? Icons.visibility_off : Icons.visibility,
                      Colors.white54, onToggleVisible,
                    ),
                    const SizedBox(width: 4),
                    _iconBtn(
                      isCopied ? Icons.check : Icons.copy,
                      isCopied ? AC.success : Colors.white54,
                      () => onCopy(secret),
                    ),
                  ],
                ]),
              ),
              if (item.filePath != null) ...[
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: onOpenFile,
                  child: Row(children: [
                    const Icon(Icons.file_present, color: Colors.blue, size: 12),
                    const SizedBox(width: 4),
                    Text(openFileLabel, style: const TextStyle(color: Colors.blue, fontSize: 10)),
                  ]),
                ),
              ],
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _iconBtn(IconData icon, Color color, VoidCallback onTap) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          width: 22, height: 22,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.07),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 11, color: color),
        ),
      );
}
