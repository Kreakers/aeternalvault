import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hakkında')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Column(
                children: [
                  Icon(Icons.shield, size: 80, color: Colors.deepPurple),
                  SizedBox(height: 16),
                  Text(
                    'Aeterna Vault',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  Text('Sürüm 1.0.3', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 40),
            _buildSectionTitle('Veri Güvenliği'),
            const Text(
              'Aeterna Vault, verilerinizi asla herhangi bir sunucuya veya bulut servisine göndermez. Tüm rehber kayıtlarınız, şifreleriniz ve notlarınız sadece bu cihazda, şifrelenmiş bir veritabanında saklanır.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Geliştirici'),
            const Text(
              'Bu uygulama, kişisel verilerin gizliliği ve güvenli yönetimi hedeflenerek geliştirilmiştir.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('İletişim & Geri Bildirim'),
            const Text(
              'Herhangi bir hata bildirimi veya özellik önerisi için bize ulaşabilirsiniz:',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.email),
                title: const Text('destek@aeternavault.com'),
                onTap: () {
                  // E-posta yönlendirmesi eklenebilir
                },
              ),
            ),
            const SizedBox(height: 40),
            const Center(
              child: Text(
                '© 2024 Aeterna Vault. Tüm hakları saklıdır.',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
      ),
    );
  }
}
