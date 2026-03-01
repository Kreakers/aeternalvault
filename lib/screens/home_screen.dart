import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/contact.dart';
import '../providers/app_provider.dart';
import '../services/auth_service.dart';
import 'add_contact_screen.dart';
import 'contact_detail_screen.dart';
import 'vault_screen.dart';
import 'vault_setup_screen.dart';
import 'security_settings_screen.dart';
import 'settings_screen.dart';
import 'about_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  Future<void> _unlockAndGo(BuildContext context, String key) async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final unlocked = await provider.unlockVault(key);
    if (unlocked && context.mounted) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const VaultScreen()));
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Kasa kilidi açılamadı!')));
    }
  }

  void _handleVaultNavigation(BuildContext context, AppProvider provider) async {
    if (!provider.isVaultSetupComplete) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const VaultSetupScreen()));
      return;
    }
    if (provider.useBiometrics) {
      bool authenticated = await AuthService().authenticate();
      if (authenticated && context.mounted && provider.vaultMasterKey != null) {
        await _unlockAndGo(context, provider.vaultMasterKey!);
      }
    } else {
      _showUnlockDialog(context);
    }
  }

  void _showUnlockDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Kasa Kilidi'),
        content: TextField(controller: controller, obscureText: true, autofocus: true, decoration: const InputDecoration(hintText: 'Master Key')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('İptal')),
          ElevatedButton(onPressed: () {
            Navigator.pop(ctx);
            _unlockAndGo(context, controller.text);
          }, child: const Text('Giriş')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: _isSearching 
          ? TextField(
              controller: _searchController,
              autofocus: true,
              decoration: const InputDecoration(hintText: 'İsim veya telefon ara...', border: InputBorder.none),
              onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
            )
          : const Text('Aeterna CRM'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _searchQuery = '';
                }
              });
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context, provider),
      body: Column(
        children: [
          if (!_isSearching) _buildDashboard(context, provider),
          Expanded(child: _buildCategorizedContactList(context, provider)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddContactScreen())),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, AppProvider provider) {
    final now = DateTime.now();
    List<String> alerts = [];

    final Map<String, int> categoryStats = {};
    for (var c in provider.contacts) {
      if (!c.isPrivate) {
        categoryStats[c.category] = (categoryStats[c.category] ?? 0) + 1;
      }
      
      if (c.birthday != null && c.birthday!.month == now.month && c.birthday!.day == now.day) {
        alerts.add('Bugün ${c.firstName} ${c.lastName}\'ın doğum günü! 🎂');
      }
      if (c.contactFrequency > 0 && c.lastContactDate != null) {
        final diff = now.difference(c.lastContactDate!).inDays;
        if (diff >= c.contactFrequency) {
          alerts.add('${c.firstName} ile görüşme zamanı gelmiş. 📞');
        }
      }
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.2),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: ExpansionTile(
        initiallyExpanded: false,
        title: const Text('Dashboard & İstatistikler', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        subtitle: Text('${provider.totalContacts} Kişi | ${provider.totalVaultItems} Kasa Öğesi', style: const TextStyle(fontSize: 12)),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (categoryStats.isNotEmpty)
                  SizedBox(
                    height: 150,
                    child: PieChart(
                      PieChartData(
                        sections: categoryStats.entries.map((e) {
                          final index = categoryStats.keys.toList().indexOf(e.key);
                          return PieChartSectionData(
                            color: Colors.primaries[index % Colors.primaries.length],
                            value: e.value.toDouble(),
                            title: '${e.value}',
                            radius: 40,
                            titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                          );
                        }).toList(),
                        sectionsSpace: 2,
                        centerSpaceRadius: 30,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                if (alerts.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: alerts.map((a) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(children: [const Icon(Icons.notifications_active, size: 16, color: Colors.orange), const SizedBox(width: 8), Expanded(child: Text(a, style: const TextStyle(fontSize: 12)))]),
                      )).toList(),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorizedContactList(BuildContext ctx, AppProvider provider) {
    var contacts = provider.contacts.where((c) => !c.isPrivate).toList();
    if (_searchQuery.isNotEmpty) {
      contacts = contacts.where((c) => c.firstName.toLowerCase().contains(_searchQuery) || c.lastName.toLowerCase().contains(_searchQuery) || c.phone.contains(_searchQuery)).toList();
    }
    if (contacts.isEmpty) return const Center(child: Text('Kişi bulunamadı.'));

    final Map<String, List<Contact>> grouped = {};
    for (var c in contacts) {
      grouped.putIfAbsent(c.category, () => []).add(c);
    }
    final cats = grouped.keys.toList()..sort();

    return ListView.builder(
      itemCount: cats.length,
      itemBuilder: (context, index) {
        final cat = cats[index];
        final items = grouped[cat]!;
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.1))),
          child: ExpansionTile(
            initiallyExpanded: _isSearching,
            title: Text(cat, style: const TextStyle(fontWeight: FontWeight.bold)),
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              child: Text(items.length.toString(), style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSecondaryContainer)),
            ),
            children: items.map((c) => ListTile(
              leading: CircleAvatar(child: Text(c.firstName[0])),
              title: Text('${c.firstName} ${c.lastName}'),
              subtitle: Text(c.phone),
              onTap: () => Navigator.push(ctx, MaterialPageRoute(builder: (_) => ContactDetailScreen(contact: c))),
            )).toList(),
          ),
        );
      },
    );
  }

  Widget _buildDrawer(BuildContext ctx, AppProvider provider) => Drawer(child: Column(children: [
    UserAccountsDrawerHeader(accountName: const Text('Aeterna Vault'), accountEmail: const Text('Güvenli CRM & Kasa'), currentAccountPicture: CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.shield, color: provider.themeColor, size: 40)), decoration: BoxDecoration(color: provider.themeColor)),
    ListTile(leading: const Icon(Icons.people), title: const Text('Kişiler'), onTap: () => Navigator.pop(ctx)),
    ListTile(leading: Icon(provider.isVaultSetupComplete ? Icons.lock : Icons.security, color: provider.isVaultSetupComplete ? Colors.redAccent : Colors.green), title: Text(provider.isVaultSetupComplete ? 'Dijital Kasa' : 'Kasayı Aktif Et'), onTap: () { Navigator.pop(ctx); _handleVaultNavigation(ctx, provider); }),
    const Divider(),
    ListTile(leading: const Icon(Icons.security_update_good), title: const Text('Güvenlik Ayarları'), onTap: () { Navigator.pop(ctx); Navigator.push(ctx, MaterialPageRoute(builder: (_) => const SecuritySettingsScreen())); }),
    ListTile(leading: const Icon(Icons.settings), title: const Text('Genel Ayarlar'), onTap: () { Navigator.pop(ctx); Navigator.push(ctx, MaterialPageRoute(builder: (_) => const SettingsScreen())); }),
    const Spacer(),
    const Divider(),
    ListTile(leading: const Icon(Icons.info_outline), title: const Text('Hakkında'), onTap: () { Navigator.pop(ctx); Navigator.push(ctx, MaterialPageRoute(builder: (_) => const AboutScreen())); }),
    const SizedBox(height: 16),
  ]));
}
