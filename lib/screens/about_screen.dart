import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.aboutTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  const Icon(Icons.shield, size: 80, color: Colors.deepPurple),
                  const SizedBox(height: 16),
                  const Text(
                    'Aeterna Vault',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  Text(l.version, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 40),
            _buildSectionTitle(l.dataSafetyTitle),
            Text(
              l.dataSafetyContent,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle(l.developerTitle),
            Text(
              l.developerContent,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle(l.contactFeedbackTitle),
            Text(
              l.contactFeedbackContent,
              style: const TextStyle(fontSize: 16, height: 1.5),
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
            Center(
              child: Text(
                l.copyright,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
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
