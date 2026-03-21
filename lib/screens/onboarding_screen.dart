import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import 'vault_setup_screen.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  void _skip() => _finish();

  Future<void> _finish() async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    await provider.completeOnboarding();
    if (!mounted) return;
    if (provider.isVaultSetupComplete) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const VaultSetupScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B4B),
      body: Stack(
        children: [
          // Arka plan gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0D1B4B), Color(0xFF050D24)],
              ),
            ),
          ),

          // Sayfalar
          PageView(
            controller: _pageController,
            onPageChanged: (i) => setState(() => _currentPage = i),
            children: [
              _Page1(l: AppLocalizations.of(context)),
              _Page2(l: AppLocalizations.of(context)),
              _Page3(l: AppLocalizations.of(context)),
            ],
          ),

          // Geri butonu
          if (_currentPage > 0)
            Positioned(
              top: 52,
              left: 20,
              child: GestureDetector(
                onTap: () => _pageController.previousPage(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.15)),
                  ),
                  child: const Icon(Icons.arrow_back, color: Colors.white70, size: 16),
                ),
              ),
            ),

          // Atla butonu (her zaman görünür)
          Positioned(
            top: 52,
            right: 20,
            child: GestureDetector(
              onTap: _skip,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.15)),
                ),
                child: Text(AppLocalizations.of(context).onbSkip,
                    style: const TextStyle(color: Colors.white70, fontSize: 13)),
              ),
            ),
          ),

          // Alt kontroller: dots + buton
          Positioned(
            bottom: 48,
            left: 24,
            right: 24,
            child: Column(
              children: [
                // Dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (i) {
                    final active = i == _currentPage;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: active ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: active ? AC.gold : Colors.white24,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24),

                // Buton
                GestureDetector(
                  onTap: _next,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AC.gold, Color(0xFFFFB300)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AC.gold.withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Text(
                      _currentPage < 2 ? AppLocalizations.of(context).onbContinue : AppLocalizations.of(context).onbStart,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Sayfa 1 ────────────────────────────────────────────────────────────────
class _Page1 extends StatelessWidget {
  const _Page1({required this.l});
  final AppLocalizations l;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          const SizedBox(height: 80),
          Expanded(child: Image.asset('assets/images/splash.png', fit: BoxFit.contain)),
          const SizedBox(height: 32),
          Text(l.onbTitle1,
              style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
          const SizedBox(height: 12),
          Text(l.onbDesc1,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white60, fontSize: 15, height: 1.6)),
          const SizedBox(height: 160),
        ],
      ),
    );
  }
}

// ─── Sayfa 2 ────────────────────────────────────────────────────────────────
class _Page2 extends StatelessWidget {
  const _Page2({required this.l});
  final AppLocalizations l;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 80),
          Container(
            width: 120, height: 120,
            decoration: BoxDecoration(
              color: AC.gold.withOpacity(0.1), shape: BoxShape.circle,
              border: Border.all(color: AC.gold.withOpacity(0.3), width: 2),
              boxShadow: [BoxShadow(color: AC.gold.withOpacity(0.2), blurRadius: 40, spreadRadius: 10)],
            ),
            child: const Icon(Icons.shield_outlined, color: AC.gold, size: 56),
          ),
          const SizedBox(height: 40),
          Text(l.onbTitle2,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: -0.3)),
          const SizedBox(height: 16),
          Text(l.onbDesc2,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white60, fontSize: 15, height: 1.7)),
          const SizedBox(height: 40),
          _row(Icons.lock_outline, AC.gold, l.onbFeat2a),
          const SizedBox(height: 12),
          _row(Icons.fingerprint, AC.gold, l.onbFeat2b),
          const SizedBox(height: 12),
          _row(Icons.no_accounts_outlined, AC.gold, l.onbFeat2c),
          const SizedBox(height: 160),
        ],
      ),
    );
  }

  Widget _row(IconData icon, Color color, String label) => Row(children: [
    Container(width: 36, height: 36,
        decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: color, size: 18)),
    const SizedBox(width: 14),
    Text(label, style: TextStyle(color: color.withOpacity(0.85), fontSize: 13, fontWeight: FontWeight.w600)),
  ]);
}

// ─── Sayfa 3 ────────────────────────────────────────────────────────────────
class _Page3 extends StatelessWidget {
  const _Page3({required this.l});
  final AppLocalizations l;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 80),
          Container(
            width: 120, height: 120,
            decoration: BoxDecoration(
              color: AC.navyLight.withOpacity(0.15), shape: BoxShape.circle,
              border: Border.all(color: AC.navyLight.withOpacity(0.4), width: 2),
              boxShadow: [BoxShadow(color: AC.navyLight.withOpacity(0.2), blurRadius: 40, spreadRadius: 10)],
            ),
            child: const Icon(Icons.people_outline, color: AC.navyLight, size: 56),
          ),
          const SizedBox(height: 40),
          Text(l.onbTitle3,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: -0.3)),
          const SizedBox(height: 16),
          Text(l.onbDesc3,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white60, fontSize: 15, height: 1.7)),
          const SizedBox(height: 40),
          _row(Icons.person_outline, AC.navyLight, l.onbFeat3a),
          const SizedBox(height: 12),
          _row(Icons.notifications_outlined, AC.navyLight, l.onbFeat3b),
          const SizedBox(height: 12),
          _row(Icons.save_alt_outlined, AC.navyLight, l.onbFeat3c),
          const SizedBox(height: 160),
        ],
      ),
    );
  }

  Widget _row(IconData icon, Color color, String label) => Row(children: [
    Container(width: 36, height: 36,
        decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: color, size: 18)),
    const SizedBox(width: 14),
    Text(label, style: TextStyle(color: color.withOpacity(0.85), fontSize: 13, fontWeight: FontWeight.w600)),
  ]);
}
