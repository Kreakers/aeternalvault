import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:open_filex/open_filex.dart';
import '../providers/app_provider.dart';
import '../models/contact.dart';
import '../models/vault_item.dart';
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
  final Map<int, bool> _visiblePasswords = {}; 

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _openFile(String? path) async {
    if (path == null || path.isEmpty) return;
    try {
      final file = File(path);
      if (await file.exists()) {
        await OpenFilex.open(path);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Dosya bulunamadı!')));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Dosya açılırken hata oluştu.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dijital Kasa'),
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
        foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.lock_reset),
            onPressed: () {
              Provider.of<AppProvider>(context, listen: false).lockVault();
              Navigator.pop(context);
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.people_alt), text: 'Gizli Kişiler'),
            Tab(icon: Icon(Icons.description), text: 'Belgeler & Şifreler'),
          ],
          indicatorColor: Colors.white,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCategorizedPrivateContacts(context),
          _buildCategorizedVaultItems(context),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.error,
        foregroundColor: Colors.white,
        onPressed: () {
          if (_tabController.index == 0) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AddContactScreen(isInitiallyPrivate: true)));
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AddVaultItemScreen()));
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCategorizedPrivateContacts(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final privateContacts = provider.contacts.where((c) => c.isPrivate).toList();
        if (privateContacts.isEmpty) return const Center(child: Text('Gizli kişi yok.'));

        final Map<String, List<Contact>> grouped = {};
        for (var c in privateContacts) {
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
              child: ExpansionTile(
                title: Text(cat, style: const TextStyle(fontWeight: FontWeight.bold)),
                leading: const Icon(Icons.folder_shared, color: Colors.orange),
                children: items.map((c) => ListTile(
                  leading: CircleAvatar(child: Text(c.firstName[0])),
                  title: Text('${c.firstName} ${c.lastName}'),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ContactDetailScreen(contact: c))),
                )).toList(),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCategorizedVaultItems(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final items = provider.vaultItems;
        if (items.isEmpty) return const Center(child: Text('Kasa boş.'));

        final Map<String, List<VaultItem>> grouped = {};
        for (var item in items) {
          grouped.putIfAbsent(item.category, () => []).add(item);
        }
        final cats = grouped.keys.toList()..sort();

        return ListView.builder(
          itemCount: cats.length,
          itemBuilder: (context, index) {
            final cat = cats[index];
            final catItems = grouped[cat]!;
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ExpansionTile(
                title: Text(cat, style: const TextStyle(fontWeight: FontWeight.bold)),
                leading: const Icon(Icons.enhanced_encryption, color: Colors.redAccent),
                children: catItems.map((item) {
                  final isPassword = item.category == 'Şifre';
                  final bool isVisible = _visiblePasswords[item.id] ?? false;
                  
                  Map<String, dynamic> data = {};
                  try {
                    data = jsonDecode(item.secretContent);
                  } catch (e) {
                    data = {'f1': item.secretContent};
                  }

                  return ExpansionTile(
                    leading: Icon(_getIconForCategory(item.category)),
                    title: Text(item.title),
                    subtitle: Text(item.category, style: const TextStyle(fontSize: 11)),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddVaultItemScreen(vaultItem: item))),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDetailRow(context, 'Bilgi 1:', data['f1'] ?? '-', false),
                            if (data['f2'] != null)
                              _buildDetailRow(context, isPassword ? 'Şifre:' : 'Bilgi 2:', data['f2'], isPassword && !isVisible),
                            if (data['f3'] != null)
                              _buildDetailRow(context, 'Bilgi 3:', data['f3'], false),
                            if (item.note.isNotEmpty)
                              _buildDetailRow(context, 'Not:', item.note, false),
                            if (item.filePath != null)
                              ListTile(
                                leading: const Icon(Icons.file_present, color: Colors.blue),
                                title: const Text('Ekli Dosyayı Aç', style: TextStyle(color: Colors.blue)),
                                onTap: () => _openFile(item.filePath),
                              ),
                            if (isPassword)
                              TextButton.icon(
                                icon: Icon(isVisible ? Icons.visibility_off : Icons.visibility),
                                label: Text(isVisible ? 'Şifreyi Gizle' : 'Şifreyi Göster'),
                                onPressed: () => setState(() => _visiblePasswords[item.id!] = !isVisible),
                              ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value, bool obscure) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(width: 8),
          Expanded(child: SelectableText(obscure ? '●●●●●●●●' : value, style: const TextStyle(fontFamily: 'monospace'))),
        ],
      ),
    );
  }

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'Şifre': return Icons.password;
      case 'Banka': return Icons.account_balance;
      case 'Belge': return Icons.description;
      default: return Icons.security;
    }
  }
}
