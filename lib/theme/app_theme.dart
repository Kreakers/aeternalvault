import 'dart:ui';
import 'package:flutter/material.dart';

// ── Karanlık Tema Renk Paleti ─────────────────────────────────
class AC {
  static const bg        = Color(0xFF0D0D1A);
  static const bgCard    = Color(0xFF111128);
  static const navy      = Color(0xFF1A237E);
  static const navyMid   = Color(0xFF283593);
  static const navyLight = Color(0xFF3949AB);
  static const gold      = Color(0xFFFFB300);
  static const goldLight = Color(0xFFFFD54F);
  static const goldDim   = Color(0xFFCC8F00);
  static const success   = Color(0xFF00E676);
  static const danger    = Color(0xFFFF1744);
  static const warning   = Color(0xFFFF9100);

  static const textSec   = Color(0x99FFFFFF); // 60%
  static const textMuted = Color(0x59FFFFFF); // 35%

  // Glass helpers
  static Color glass([double opacity = 0.05])        => Colors.white.withOpacity(opacity);
  static Color glassBorder([double opacity = 0.09])  => Colors.white.withOpacity(opacity);
  static Color navyGlass([double opacity = 0.18])    => const Color(0xFF1A237E).withOpacity(opacity);
  static Color navyBorder([double opacity = 0.5])    => const Color(0xFF1A237E).withOpacity(opacity);
  static Color goldGlass([double opacity = 0.10])    => const Color(0xFFFFB300).withOpacity(opacity);
  static Color goldBorder([double opacity = 0.25])   => const Color(0xFFFFB300).withOpacity(opacity);
}

// ── Aydınlık Tema Renk Paleti ─────────────────────────────────
class AL {
  static const bg        = Color(0xFFF0F2FF); // çok açık lavender
  static const bgCard    = Color(0xFFFFFFFF);
  static const navy      = Color(0xFF1A237E);
  static const navyMid   = Color(0xFF283593);
  static const navyLight = Color(0xFF3949AB);
  static const gold      = Color(0xFFFFB300);
  static const goldDim   = Color(0xFFCC8F00);
  static const success   = Color(0xFF00C853);
  static const danger    = Color(0xFFD32F2F);
  static const warning   = Color(0xFFE65100);
  static const divider   = Color(0xFFE0E4FF);

  static const textPrimary = Color(0xFF0D0D1A);
  static const textSec     = Color(0xFF555577);
  static const textMuted   = Color(0xFF8888AA);

  // Glass helpers
  static Color glass([double opacity = 0.6])         => Colors.white.withOpacity(opacity);
  static Color glassBorder([double opacity = 0.35])  => const Color(0xFF1A237E).withOpacity(opacity);
  static Color navyGlass([double opacity = 0.06])    => const Color(0xFF1A237E).withOpacity(opacity);
  static Color navyBorder([double opacity = 0.18])   => const Color(0xFF1A237E).withOpacity(opacity);
  static Color goldGlass([double opacity = 0.10])    => const Color(0xFFFFB300).withOpacity(opacity);
  static Color goldBorder([double opacity = 0.35])   => const Color(0xFFFFB300).withOpacity(opacity);
}

// ── ThemeData ─────────────────────────────────────────────────
class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AL.bg,
    colorScheme: const ColorScheme.light(
      surface:          AL.bgCard,
      primary:          AL.navy,
      secondary:        AL.navyLight,
      error:            AL.danger,
      onSurface:        AL.textPrimary,
      onPrimary:        Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF0F2FF),
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: AL.textPrimary,
        fontSize: 17,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
      iconTheme: IconThemeData(color: AL.navy),
    ),
    cardTheme: CardThemeData(
      color: AL.bgCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        side: BorderSide(color: AL.divider),
      ),
    ),
    dividerColor: AL.divider,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AC.gold,
      foregroundColor: Colors.black,
      elevation: 8,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((s) =>
          s.contains(WidgetState.selected) ? AL.success : Colors.white),
      trackColor: WidgetStateProperty.resolveWith((s) =>
          s.contains(WidgetState.selected)
              ? AL.success.withOpacity(0.35)
              : Colors.black.withOpacity(0.12)),
      trackOutlineColor: WidgetStateProperty.resolveWith((s) =>
          s.contains(WidgetState.selected)
              ? AL.success
              : Colors.black.withOpacity(0.15)),
    ),
    textTheme: const TextTheme(
      bodyLarge:   TextStyle(color: AL.textPrimary),
      bodyMedium:  TextStyle(color: AL.textSec),
      bodySmall:   TextStyle(color: AL.textMuted),
      titleLarge:  TextStyle(color: AL.textPrimary, fontWeight: FontWeight.w700),
      titleMedium: TextStyle(color: AL.textPrimary, fontWeight: FontWeight.w600),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AL.divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AL.divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AL.navy, width: 1.5),
      ),
      hintStyle: const TextStyle(color: AL.textMuted),
      labelStyle: const TextStyle(color: AL.textSec),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AL.bgCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: AL.divider),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AL.navy,
      contentTextStyle: const TextStyle(color: Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      behavior: SnackBarBehavior.floating,
    ),
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AC.bg,
    colorScheme: const ColorScheme.dark(
      surface:          AC.bgCard,
      primary:          AC.gold,
      secondary:        AC.navyLight,
      error:            AC.danger,
      onSurface:        Colors.white,
      onPrimary:        Colors.black,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xCC0D0D1A),
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 17,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    cardTheme: CardThemeData(
      color: Color(0x0DFFFFFF),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        side: BorderSide(color: Color(0x17FFFFFF)),
      ),
    ),
    dividerColor: Color(0x0FFFFFFF),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AC.gold,
      foregroundColor: Colors.black,
      elevation: 8,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((s) =>
          s.contains(WidgetState.selected) ? AC.success : Colors.white38),
      trackColor: WidgetStateProperty.resolveWith((s) =>
          s.contains(WidgetState.selected)
              ? AC.success.withOpacity(0.25)
              : Colors.white.withOpacity(0.08)),
      trackOutlineColor: WidgetStateProperty.resolveWith((s) =>
          s.contains(WidgetState.selected)
              ? AC.success
              : Colors.white.withOpacity(0.12)),
    ),
    textTheme: const TextTheme(
      bodyLarge:   TextStyle(color: Colors.white),
      bodyMedium:  TextStyle(color: AC.textSec),
      bodySmall:   TextStyle(color: AC.textMuted),
      titleLarge:  TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
      titleMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withOpacity(0.06),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AC.gold),
      ),
      hintStyle: const TextStyle(color: AC.textMuted),
      labelStyle: const TextStyle(color: AC.textSec),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: const Color(0xFF111128),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.white.withOpacity(0.08)),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: const Color(0xFF1A1A35),
      contentTextStyle: const TextStyle(color: Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

// ── Glass Kartı ───────────────────────────────────────────────
enum GlassTint { defaultTint, navy, gold }

class GlassCard extends StatelessWidget {
  final Widget child;
  final GlassTint tint;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const GlassCard({
    super.key,
    required this.child,
    this.tint = GlassTint.defaultTint,
    this.padding,
    this.borderRadius,
  });

  Color _bg(bool isDark) {
    if (isDark) {
      switch (tint) {
        case GlassTint.navy: return AC.navyGlass(0.18);
        case GlassTint.gold: return AC.goldGlass(0.08);
        case GlassTint.defaultTint: return AC.glass(0.05);
      }
    } else {
      switch (tint) {
        case GlassTint.navy: return AL.navyGlass(0.06);
        case GlassTint.gold: return AL.goldGlass(0.08);
        case GlassTint.defaultTint: return AL.glass(0.7);
      }
    }
  }

  Color _border(bool isDark) {
    if (isDark) {
      switch (tint) {
        case GlassTint.navy: return AC.navyBorder(0.5);
        case GlassTint.gold: return AC.goldBorder(0.2);
        case GlassTint.defaultTint: return AC.glassBorder(0.09);
      }
    } else {
      switch (tint) {
        case GlassTint.navy: return AL.navyBorder(0.18);
        case GlassTint.gold: return AL.goldBorder(0.25);
        case GlassTint.defaultTint: return AL.glassBorder(0.18);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final br = borderRadius ?? BorderRadius.circular(16);
    return ClipRRect(
      borderRadius: br,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          decoration: BoxDecoration(
            color: _bg(isDark),
            borderRadius: br,
            border: Border.all(color: _border(isDark)),
          ),
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}

// ── Section Header (ayarlar için) ────────────────────────────
class SectionLabel extends StatelessWidget {
  final String label;
  const SectionLabel(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(left: 2, top: 6, bottom: 2),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: isDark ? const Color(0x61FFFFFF) : AL.textMuted,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

// ── Avatar ────────────────────────────────────────────────────
class AeternaAvatar extends StatelessWidget {
  final String name;
  final double size;

  const AeternaAvatar({super.key, required this.name, this.size = 38});

  String get _initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  Color get _color {
    const palette = [AC.navy, AC.navyMid, Color(0xFF0D47A1), Color(0xFF1565C0)];
    return palette[name.codeUnitAt(0) % palette.length];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_color, AC.navyLight],
        ),
        borderRadius: BorderRadius.circular(size * 0.32),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.5),
      ),
      alignment: Alignment.center,
      child: Text(
        _initials,
        style: TextStyle(
          color: Colors.white,
          fontSize: size * 0.35,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ── Gold FAB ──────────────────────────────────────────────────
class GoldFab extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;

  const GoldFab({super.key, required this.onPressed, this.icon = Icons.add});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onPressed,
    child: Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AC.gold, AC.goldDim],
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
      child: Icon(icon, color: Colors.black, size: 24),
    ),
  );
}
