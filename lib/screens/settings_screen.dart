import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // Profesyonel ve Ağırbaşlı Renk Paleti (Material 3 Seed Colors)
  final List<Color> _professionalColors = const [
    Color(0xFF1A237E), // Midnight Navy (Güven ve Otorite)
    Color(0xFF004D40), // Deep Teal (Huzur ve Stabilite)
    Color(0xFF37474F), // Slate Grey (Modern ve Minimalist)
    Color(0xFF4E342E), // Coffee Brown (Geleneksel ve Sağlam)
    Color(0xFF880E4F), // Maroon (Lüks ve Gizlilik)
    Color(0xFF311B92), // Deep Purple (Özgün ve Premium)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Genel Ayarlar')),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _buildSectionTitle('Görünüm Modu'),
              Card(
                child: SwitchListTile(
                  title: Text(provider.isDarkMode ? 'Karanlık Tema Aktif' : 'Aydınlık Tema Aktif'),
                  subtitle: const Text('Göz yorgunluğunu azaltmak için mod değiştirin.'),
                  secondary: Icon(provider.isDarkMode ? Icons.dark_mode : Icons.light_mode, color: provider.themeColor),
                  value: provider.isDarkMode,
                  onChanged: (val) => provider.toggleDarkMode(val),
                ),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Uygulama Kimliği (Renk)'),
              const Padding(
                padding: EdgeInsets.only(bottom: 12.0),
                child: Text('Uygulamanın tüm tonları seçtiğiniz renge göre otomatik uyarlanır.', style: TextStyle(fontSize: 13, color: Colors.grey)),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.5,
                ),
                itemCount: _professionalColors.length,
                itemBuilder: (context, index) {
                  final color = _professionalColors[index];
                  final isSelected = provider.themeColor.value == color.value;
                  return GestureDetector(
                    onTap: () => provider.updateThemeColor(color),
                    child: Container(
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(12),
                        border: isSelected ? Border.all(color: Theme.of(context).colorScheme.outline, width: 4) : null,
                        boxShadow: [
                          if (isSelected) BoxShadow(color: color.withOpacity(0.4), blurRadius: 10, spreadRadius: 2)
                        ],
                      ),
                      child: isSelected ? const Icon(Icons.check_circle, color: Colors.white) : null,
                    ),
                  );
                },
              ),
              const Divider(height: 60),
              _buildSectionTitle('Veri ve Güvenlik'),
              Card(
                color: Colors.red.withOpacity(0.05),
                child: ListTile(
                  leading: const Icon(Icons.delete_forever, color: Colors.red),
                  title: const Text('Fabrika Ayarlarına Dön', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  subtitle: const Text('Tüm rehber, kasa ve ayarları kalıcı olarak temizler.'),
                  onTap: () => _showResetConfirm(context, provider),
                ),
              ),
              const SizedBox(height: 40),
              const Center(
                child: Text('Aeterna Vault v1.0.3', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(title.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.2, color: Colors.grey)),
    );
  }

  void _showResetConfirm(BuildContext context, AppProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Verileri Kalıcı Olarak Sil?'),
        content: const Text('Bu işlem geri alınamaz. Kasanızdaki tüm gizli belgeler ve CRM kayıtlarınız yok olacaktır.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('İPTAL')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () async {
              await provider.performFactoryReset();
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Uygulama başarıyla sıfırlandı.')));
              }
            },
            child: const Text('SİL VE SIFIRLA'),
          ),
        ],
      ),
    );
  }
}
