import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'app_localizations.dart';

extension GlicLocalization on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this) ?? lookupAppLocalizations(
    Locale(['en', 'pt', 'es'].contains(Localizations.localeOf(this).languageCode)
        ? Localizations.localeOf(this).languageCode : 'en'));

  String get formatLocale {
    final locale = Localizations.localeOf(this);
    return Intl.verifiedLocale(locale.toString(), DateFormat.localeExists,
      onFailure: (_) => locale.languageCode) ?? 'en';
  }

  String number(num value) => NumberFormat.decimalPattern(formatLocale).format(value);
  String readingDate(DateTime date) => DateUtils.isSameDay(date.toLocal(), DateTime.now())
    ? l10n.today : shortDate(date);
  String shortDate(DateTime date) => DateFormat.Md(formatLocale).format(date);
  String fullDate(DateTime date) => MaterialLocalizations.of(this).formatCompactDate(date);
  String time(DateTime date) => MaterialLocalizations.of(this).formatTimeOfDay(
    TimeOfDay.fromDateTime(date), alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(this));

  String diabetesTypeLabel(String type) => switch (type) {
    'type_1' => l10n.diabetesTypeOne,
    'type_2' => l10n.diabetesTypeTwo,
    _ => l10n.notProvided,
  };

  String momentLabel(String moment) => switch (moment) {
    'Todos' => l10n.all,
    'Jejum' => l10n.fasting,
    'Após café' => l10n.afterBreakfast,
    'Após almoço' => l10n.afterLunch,
    'Após lanche' => l10n.afterSnack,
    'Após janta' => l10n.afterDinner,
    'Outro' => l10n.other,
    _ => moment,
  };
}
