import 'package:flutter/material.dart';

abstract final class GlicColors {
  static const primary = Color(0xFFAB2958);
  static const primaryDark = Color(0xFF8C2251);
  static const accent = Color(0xFFBF3D6D);
  static const coral = Color(0xFFDF646E);
  static const lavender = Color(0xFFE0DCEF);
  static const surfaceSoft = Color(0xFFF3F1F9);
  static const background = Color(0xFFD9DEE5);
  static const ink = Color(0xFF191C1B);
  static const muted = Color(0xFF49454F);
  static const lockedSurface = Color(0xFFE3E6EC);
  static const lockedBorder = Color(0xFFC8CDD6);
  static const lockedText = Color(0xFF535B68);
  static const toastSuccess = Color(0xFF365D49);
  static const toastSuccessSurface = Color(0xFFE2EDE6);
  static const toastWarning = Color(0xFF705520);
  static const toastWarningSurface = Color(0xFFF3EAD4);
  static const toastError = Color(0xFF943D50);
  static const toastErrorSurface = Color(0xFFF6E2E6);
  static const neutral = Color(0xFFD9D9D9);
}
abstract final class GlicGradients {
  static const measurement = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [GlicColors.accent, GlicColors.primaryDark],
  );
}

abstract final class GlicSpace {
  static const xxs = 2.0;
  static const xs = 4.0;
  static const sm = 8.0;
  static const compact = 12.0;
  static const md = 16.0;
  static const inset = 20.0;
  static const lg = 24.0;
  static const xl = 32.0;
}
/// Espaçamentos compartilhados pelas telas e pelos cartões.
abstract final class GlicLayout {
  static const pagePadding = EdgeInsets.fromLTRB(
    GlicSpace.inset, GlicSpace.md, GlicSpace.inset, GlicSpace.lg);
  static const cardPadding = EdgeInsets.all(GlicSpace.lg);
  static const compactCardPadding = EdgeInsets.all(GlicSpace.md);
  static const cardGap = GlicSpace.md;
  static const columnGap = GlicSpace.compact;
  static const labelGap = GlicSpace.sm;
}

abstract final class GlicTheme {
  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: GlicColors.primary,
      primary: GlicColors.primary,
      surface: Colors.white,
      brightness: Brightness.light,
    );
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Istok Web',
      colorScheme: scheme,
      scaffoldBackgroundColor: GlicColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: GlicColors.background,
        foregroundColor: GlicColors.ink,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(fontSize: 29, fontWeight: FontWeight.w700, color: GlicColors.ink),
        headlineSmall: TextStyle(fontSize: 23, fontWeight: FontWeight.w700, color: GlicColors.ink),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: GlicColors.ink),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: GlicColors.ink),
        bodyMedium: TextStyle(fontSize: 14, color: GlicColors.muted),
      ),
      cardTheme: CardThemeData(
        color: GlicColors.surfaceSoft,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: GlicColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(0, 54),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: GlicColors.lavender),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: GlicColors.lavender,
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class GlicCard extends StatelessWidget {
  const GlicCard({super.key, required this.child, this.padding = const EdgeInsets.all(GlicSpace.inset)});
  final Widget child;
  final EdgeInsetsGeometry padding;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(padding: padding, child: child),
  );
}

class SectionHeading extends StatelessWidget {
  const SectionHeading(this.title, {super.key, this.trailing});
  final String title;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(child: Text(title, style: Theme.of(context).textTheme.titleLarge)),
      if (trailing != null) trailing!,
    ],
  );
}
