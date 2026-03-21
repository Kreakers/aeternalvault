import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/contact.dart';
import '../providers/app_provider.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import '../services/notification_service.dart';
import 'add_contact_screen.dart';
import 'contact_detail_screen.dart';
import 'vault_screen.dart';
import 'vault_setup_screen.dart';
import 'security_settings_screen.dart';
import 'settings_screen.dart';
import 'about_screen.dart';
import 'onboarding_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _statsOpen = true;
  DateTime? _backgroundedAt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkOnboarding();
      NotificationService().requestPermissions();
    });
  }

  void _checkOnboarding() {
    final provider = Provider.of<AppProvider>(context, listen: false);
    if (!provider.onboardingDone) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final provider = Provider.of<AppProvider>(context, listen: false);
    if (state == AppLifecycleState.paused) {
      _backgroundedAt = DateTime.now();
    } else if (state == AppLifecycleState.resumed) {
      if (provider.autoLockEnabled && _backgroundedAt != null) {
        final elapsed = DateTime.now().difference(_backgroundedAt!).inMinutes;
        if (elapsed >= provider.autoLockMinutes) {
          provider.lockVault();
        }
      }
      _backgroundedAt = null;
    }
  }

  // ── Vault navigation ─────────────────────────────────────
  Future<void> _unlockAndGo(String key) async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final l = AppLocalizations.of(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: AC.gold),
      ),
    );
    final unlocked = await provider.unlockVault(key);
    if (!mounted) return;
    Navigator.pop(context);
    if (unlocked) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const VaultScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.vaultUnlockFailed)),
      );
    }
  }

  void _handleVaultNavigation(AppProvider provider) async {
    if (!provider.isVaultSetupComplete) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const VaultSetupScreen()));
      return;
    }
    if (provider.useBiometrics) {
      final l = AppLocalizations.of(context);
      final authenticated = await AuthService().authenticate(reason: l.biometricReason);
      if (!mounted) return;
      if (authenticated) {
        final storedKey = await const FlutterSecureStorage().read(key: 'vault_master_key');
        if (storedKey != null) {
          await _unlockAndGo(storedKey);
          return;
        }
      }
      _showUnlockDialog();
    } else {
      _showUnlockDialog();
    }
  }

  void _showUnlockDialog() {
    final l = AppLocalizations.of(context);
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              color: AC.goldGlass(),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AC.goldBorder()),
            ),
            child: const Icon(Icons.lock_outline, color: AC.gold, size: 16),
          ),
          const SizedBox(width: 10),
          Text(l.vaultLock),
        ]),
        content: TextField(
          controller: ctrl,
          obscureText: true,
          autofocus: true,
          decoration: InputDecoration(hintText: l.masterKey),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l.cancel)),
          ElevatedButton(
            onPressed: () { Navigator.pop(ctx); _unlockAndGo(ctrl.text); },
            style: ElevatedButton.styleFrom(backgroundColor: AC.gold, foregroundColor: Colors.black),
            child: Text(l.login),
          ),
        ],
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = Provider.of<AppProvider>(context);
    return Scaffold(
      backgroundColor: isDark ? AC.bg : AL.bg,
      appBar: _buildAppBar(),
      drawer: _buildDrawer(provider),
      body: Column(children: [
        if (!_isSearching) _buildDashboard(provider),
        Expanded(child: _buildContactList(provider)),
      ]),
      floatingActionButton: GoldFab(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddContactScreen())),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final l = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xCC0D0D1A) : AL.bgCard,
          border: Border(bottom: BorderSide(color: isDark ? Colors.white.withOpacity(0.06) : AL.divider)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(children: [
              Builder(builder: (ctx) => GestureDetector(
                onTap: () => Scaffold.of(ctx).openDrawer(),
                child: Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [AC.navy, AC.navyLight]),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AC.gold.withOpacity(0.3)),
                    boxShadow: [BoxShadow(color: AC.navy.withOpacity(0.5), blurRadius: 16)],
                  ),
                  child: const Icon(Icons.bolt, color: AC.gold, size: 18),
                ),
              )),
              const SizedBox(width: 10),
              Expanded(
                child: _isSearching
                    ? TextField(
                        controller: _searchController,
                        autofocus: true,
                        style: TextStyle(color: isDark ? Colors.white : AL.textPrimary, fontSize: 15),
                        decoration: InputDecoration(
                          hintText: l.searchHint,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                        ),
                        onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
                      )
                    : Text('Aeterna Vault',
                        style: TextStyle(color: isDark ? Colors.white : AL.textPrimary, fontSize: 17, fontWeight: FontWeight.w700, letterSpacing: -0.3)),
              ),
              const SizedBox(width: 6),
              _appBarBtn(
                icon: _isSearching ? Icons.close : Icons.search,
                color: isDark ? Colors.white70 : AL.textSec,
                bg: isDark ? Colors.white.withOpacity(0.06) : AL.bg,
                border: isDark ? Colors.white.withOpacity(0.1) : AL.divider,
                onTap: () => setState(() {
                  _isSearching = !_isSearching;
                  if (!_isSearching) { _searchController.clear(); _searchQuery = ''; }
                }),
              ),
              const SizedBox(width: 6),
              Consumer<AppProvider>(builder: (_, p, __) => _appBarBtn(
                icon: Icons.lock_outline,
                color: AC.gold,
                bg: AC.goldGlass(),
                border: AC.goldBorder(),
                onTap: () => _handleVaultNavigation(p),
              )),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _appBarBtn({
    required IconData icon,
    required Color color,
    required Color bg,
    required Color border,
    required VoidCallback onTap,
  }) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: border),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
      );

  // ── Dashboard ─────────────────────────────────────────────
  Widget _buildDashboard(AppProvider provider) {
    final l = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final now = DateTime.now();
    final Map<String, int> catStats = {};
    final List<String> alerts = [];

    for (var c in provider.contacts.where((c) => !c.isPrivate)) {
      catStats[c.category] = (catStats[c.category] ?? 0) + 1;
      if (c.birthday != null && c.birthday!.month == now.month && c.birthday!.day == now.day) {
        alerts.add(l.birthdayAlert('${c.firstName} ${c.lastName}'));
      }
      if (c.contactFrequency > 0 && c.lastContactDate != null) {
        final diff = now.difference(c.lastContactDate!).inDays;
        if (diff >= c.contactFrequency) {
          alerts.add(l.meetingAlert(c.firstName));
        }
      }
    }

    return GlassCard(
      tint: GlassTint.navy,
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
      child: Column(children: [
        GestureDetector(
          onTap: () => setState(() => _statsOpen = !_statsOpen),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            child: Row(children: [
              Text(l.overview,
                  style: TextStyle(color: isDark ? AC.textSec : AL.textSec, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.8)),
              const Spacer(),
              Text('${provider.totalContacts} ${l.contacts} · ${provider.totalVaultItems} ${l.digitalVault}',
                  style: TextStyle(color: isDark ? AC.textMuted : AL.textMuted, fontSize: 10)),
              const SizedBox(width: 6),
              Icon(_statsOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: isDark ? Colors.white38 : AL.textMuted, size: 18),
            ]),
          ),
        ),

        if (_statsOpen) ...[
          Divider(height: 1, color: isDark ? Colors.white.withOpacity(0.06) : AL.divider),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 16),
            child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Expanded(child: Column(children: [
                _statPill('👤', l.totalContacts(provider.totalContacts), l.totalContactsSub, AC.navyLight),
                const SizedBox(height: 8),
                _statPill('🔐', l.vaultItems(provider.totalVaultItems), l.encryptedRecord, AC.gold),
              ])),
              const SizedBox(width: 16),
              if (catStats.isNotEmpty) _buildDonut(catStats),
            ]),
          ),
          if (alerts.isNotEmpty) _buildAlerts(alerts),
        ],
      ]),
    );
  }

  Widget _statPill(String emoji, String label, String sub, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.04) : AL.bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.13)),
      ),
      child: Row(children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 10),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: TextStyle(color: isDark ? Colors.white : AL.textPrimary, fontSize: 13, fontWeight: FontWeight.w700)),
          Text(sub, style: TextStyle(color: isDark ? AC.textMuted : AL.textMuted, fontSize: 10)),
        ]),
      ]),
    );
  }

  Widget _buildDonut(Map<String, int> stats) {
    final colors = [AC.navyLight, AC.gold, AC.success, AC.warning, Colors.cyan];
    final entries = stats.entries.toList();
    return SizedBox(
      width: 80, height: 80,
      child: PieChart(PieChartData(
        sections: List.generate(entries.length, (i) => PieChartSectionData(
          color: colors[i % colors.length],
          value: entries[i].value.toDouble(),
          title: '${entries[i].value}',
          radius: 24,
          titleStyle: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.white),
        )),
        centerSpaceRadius: 22,
        sectionsSpace: 2,
      )),
    );
  }

  Widget _buildAlerts(List<String> alerts) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AC.warning.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AC.warning.withOpacity(0.2)),
      ),
      child: Column(
        children: alerts.map((a) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Row(children: [
            const Icon(Icons.notifications_active, size: 14, color: AC.warning),
            const SizedBox(width: 8),
            Expanded(child: Text(a, style: TextStyle(color: isDark ? Colors.white70 : AL.textSec, fontSize: 11))),
          ]),
        )).toList(),
      ),
    );
  }

  // ── Contact list ──────────────────────────────────────────
  Widget _buildContactList(AppProvider provider) {
    final l = AppLocalizations.of(context);
    var contacts = provider.contacts.where((c) => !c.isPrivate).toList();
    if (_searchQuery.isNotEmpty) {
      contacts = contacts.where((c) =>
          '${c.firstName} ${c.lastName}'.toLowerCase().contains(_searchQuery) ||
          c.phone.contains(_searchQuery) ||
          c.email.toLowerCase().contains(_searchQuery) ||
          c.company.toLowerCase().contains(_searchQuery) ||
          c.tags.toLowerCase().contains(_searchQuery)).toList();
    }
    if (contacts.isEmpty) {
      final isDarkEmpty = Theme.of(context).brightness == Brightness.dark;
      return Center(
        child: Text(l.contactNotFound, style: TextStyle(color: isDarkEmpty ? AC.textMuted : AL.textMuted)),
      );
    }

    final Map<String, List<Contact>> grouped = {};
    for (var c in contacts) {
      grouped.putIfAbsent(c.category, () => []).add(c);
    }
    final cats = grouped.keys.toList()..sort();

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 80),
      itemCount: cats.length,
      itemBuilder: (context, i) => _ContactGroup(
        category: cats[i],
        contacts: grouped[cats[i]]!,
        initiallyExpanded: _isSearching || i == 0,
        onContactTap: (c) => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ContactDetailScreen(contact: c)),
        ),
      ),
    );
  }

  // ── Drawer ─────────────────────────────────────────────────
  Widget _buildDrawer(AppProvider provider) {
    final l = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Drawer(
      backgroundColor: isDark ? AC.bgCard : AL.bgCard,
      child: Column(children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AC.navy, AC.navyMid],
            ),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                shape: BoxShape.circle,
                border: Border.all(color: AC.gold.withOpacity(0.4), width: 2),
              ),
              child: const Icon(Icons.shield, color: AC.gold, size: 28),
            ),
            const SizedBox(height: 14),
            const Text('Aeterna Vault', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
            Text(l.appSubtitle, style: const TextStyle(color: AC.textSec, fontSize: 12)),
          ]),
        ),
        const SizedBox(height: 8),
        _drawerItem(Icons.people_outline, l.contacts, () => Navigator.pop(context), isDark: isDark),
        _drawerItem(
          provider.isVaultSetupComplete ? Icons.lock_outline : Icons.security,
          provider.isVaultSetupComplete ? l.digitalVault : l.activateVault,
          () { Navigator.pop(context); _handleVaultNavigation(provider); },
          color: provider.isVaultSetupComplete ? AC.gold : AC.success,
          isDark: isDark,
        ),
        Divider(height: 24, color: isDark ? Colors.white.withOpacity(0.06) : AL.divider),
        _drawerItem(Icons.security_outlined, l.securitySettings, () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (_) => const SecuritySettingsScreen()));
        }, isDark: isDark),
        _drawerItem(Icons.settings_outlined, l.generalSettings, () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
        }, isDark: isDark),
        const Spacer(),
        Divider(color: isDark ? Colors.white.withOpacity(0.06) : AL.divider),
        _drawerItem(Icons.info_outline, l.about, () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutScreen()));
        }, isDark: isDark),
        const SizedBox(height: 16),
      ]),
    );
  }

  Widget _drawerItem(IconData icon, String label, VoidCallback onTap, {Color? color, bool isDark = true}) {
    return ListTile(
      leading: Icon(icon, color: color ?? (isDark ? Colors.white70 : AL.textSec), size: 20),
      title: Text(label, style: TextStyle(color: color ?? (isDark ? Colors.white : AL.textPrimary), fontSize: 14, fontWeight: FontWeight.w500)),
      onTap: onTap,
      dense: true,
      horizontalTitleGap: 8,
    );
  }
}

// ── Contact Group Widget ──────────────────────────────────────
class _ContactGroup extends StatefulWidget {
  final String category;
  final List<Contact> contacts;
  final bool initiallyExpanded;
  final void Function(Contact) onContactTap;

  const _ContactGroup({
    required this.category,
    required this.contacts,
    required this.initiallyExpanded,
    required this.onContactTap,
  });

  @override
  State<_ContactGroup> createState() => _ContactGroupState();
}

class _ContactGroupState extends State<_ContactGroup> {
  late bool _open;

  @override
  void initState() {
    super.initState();
    _open = widget.initiallyExpanded;
  }

  static const _catColors = {
    'İş': AC.navyLight,
    'Aile': AC.gold,
    'Arkadaş': AC.success,
    'Work': AC.navyLight,
    'Family': AC.gold,
    'Friend': AC.success,
    'Arbeit': AC.navyLight,
    'Familie': AC.gold,
    'Freund': AC.success,
    'Lavoro': AC.navyLight,
    'Famiglia': AC.gold,
    'Amico': AC.success,
  };

  Color get _color => _catColors[widget.category] ?? AC.navyLight;

  String _localizedCategory(AppLocalizations l, String cat) {
    switch (cat) {
      case 'Müşteri':   return l.categoryCustomer;
      case 'Aile':      return l.categoryFamily;
      case 'Arkadaş':   return l.categoryFriend;
      case 'İş':        return l.categoryWork;
      case 'Tedarikçi': return l.categorySupplier;
      case 'Diğer':     return l.categoryOther;
      default:          return cat;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        GestureDetector(
          onTap: () => setState(() => _open = !_open),
          child: Row(children: [
            Container(
              width: 22, height: 22,
              decoration: BoxDecoration(
                color: _color.withOpacity(0.13),
                borderRadius: BorderRadius.circular(7),
                border: Border.all(color: _color.withOpacity(0.27)),
              ),
              child: Icon(Icons.folder_outlined, size: 12, color: _color),
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(_localizedCategory(l, widget.category),
                style: TextStyle(color: isDark ? Colors.white70 : AL.textSec, fontSize: 12, fontWeight: FontWeight.w700))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: _color.withOpacity(0.13),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _color.withOpacity(0.27)),
              ),
              child: Text('${widget.contacts.length}',
                  style: TextStyle(color: _color, fontSize: 10, fontWeight: FontWeight.w700)),
            ),
            const SizedBox(width: 4),
            Icon(_open ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: isDark ? Colors.white30 : AL.textMuted, size: 16),
          ]),
        ),

        if (_open) ...[
          const SizedBox(height: 6),
          GlassCard(
            child: Column(
              children: List.generate(widget.contacts.length, (i) {
                final c = widget.contacts[i];
                return Column(children: [
                  GestureDetector(
                    onTap: () => widget.onContactTap(c),
                    child: Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                      child: Row(children: [
                        AeternaAvatar(name: '${c.firstName} ${c.lastName}', size: 38),
                        const SizedBox(width: 12),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${c.firstName} ${c.lastName}',
                                style: TextStyle(color: isDark ? Colors.white : AL.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 2),
                            Row(children: [
                              Icon(Icons.phone, size: 10, color: isDark ? Colors.white30 : AL.textMuted),
                              const SizedBox(width: 4),
                              Text(c.phone, style: TextStyle(color: isDark ? AC.textMuted : AL.textMuted, fontSize: 11)),
                            ]),
                          ],
                        )),
                        Icon(Icons.chevron_right, size: 16, color: isDark ? Colors.white24 : AL.textMuted),
                      ]),
                    ),
                  ),
                  if (i < widget.contacts.length - 1)
                    Divider(height: 1, color: isDark ? Colors.white.withOpacity(0.04) : AL.divider, indent: 63),
                ]);
              }),
            ),
          ),
        ],
      ]),
    );
  }
}
