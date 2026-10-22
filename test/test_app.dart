import 'package:flutter/material.dart';
import 'package:glicnote_app/l10n/app_localizations.dart';

Widget localizedTestApp({required Widget home, ThemeData? theme}) => MaterialApp(
  locale: const Locale('pt', 'BR'),
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  theme: theme,
  home: home,
);
