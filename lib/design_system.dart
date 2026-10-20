import 'package:flutter/material.dart';

abstract final class GlicColors {
  static const primary = Color(0xFFAB2958);
  static const primaryDark = Color(0xFF9F2C5B);
  static const accent = Color(0xFFBE3C6D);
  static const coral = Color(0xFFDF646E);
  static const lavender = Color(0xFFE0DCEF);
  static const background = Color(0xFFF9F7FC);
  static const ink = Color(0xFF191C1B);
  static const muted = Color(0xFF49454F);
  static const neutral = Color(0xFFD9D9D9);
}
abstract final class GlicSpace {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
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
      colorScheme: scheme,
      scaffoldBackgroundColor: GlicColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: GlicColors.background,
        foregroundColor: GlicColors.ink,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(fontSize: 29, fontWeight: FontWeight.w800, color: GlicColors.ink),
        headlineSmall: TextStyle(fontSize: 23, fontWeight: FontWeight.w700, color: GlicColors.ink),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: GlicColors.ink),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: GlicColors.ink),
        bodyMedium: TextStyle(fontSize: 14, color: GlicColors.muted),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
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
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class GlicCard extends StatelessWidget {
  const GlicCard({super.key, required this.child, this.padding = const EdgeInsets.all(20)});
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
