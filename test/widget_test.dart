import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:aeternavault/main.dart';
import 'package:aeternavault/providers/app_provider.dart';

void main() {
  testWidgets('Uygulama başlatma testi', (WidgetTester tester) async {
    // Uygulamayı MultiProvider ile sarmalayarak başlatıyoruz (main.dart'taki gibi)
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppProvider()),
        ],
        child: const AeternaVaultApp(),
      ),
    );

    // Uygulama başlığının ekranda olduğunu doğrulayalım
    expect(find.text('Aeterna CRM'), findsOneWidget);
    
    // Başlangıçta listenin boş olduğunu belirten metni kontrol edelim (GÜNCEL METİN)
    expect(find.text('Henüz kimse yok.\nSağ alttaki butondan yeni bir kişi ekleyin.'), findsOneWidget);
  });
}
