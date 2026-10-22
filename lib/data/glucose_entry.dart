import 'package:flutter/material.dart';
import '../l10n/localization.dart';

class GlucoseEntry {
  const GlucoseEntry({required this.value, required this.moment, required this.at,
    this.insulinUnits, this.id, this.version = 0, this.localDate});
  String? insulinLabel(BuildContext context) => insulinUnits == null ? null : context.l10n.insulinAmount(context.number(insulinUnits!));
  final int value;
  final double? insulinUnits;
  final String moment;
  final DateTime at;
  final String? id;
  final int version;
  final DateTime? localDate;

  bool conflictsWith(GlucoseEntry other) {
    if (moment != other.moment) return false;
    if (moment == 'Outro') return at.isAtSameMomentAs(other.at);
    final day = localDate ?? DateUtils.dateOnly(at);
    final otherDay = other.localDate ?? DateUtils.dateOnly(other.at);
    return DateUtils.isSameDay(day, otherDay) || (value == other.value && at.isAtSameMomentAs(other.at));
  }

  static const moments = {
    'Jejum': 'fasting', 'Após café': 'after_breakfast', 'Após almoço': 'after_lunch',
    'Após lanche': 'after_snack', 'Após janta': 'after_dinner', 'Outro': 'other',
  };

  factory GlucoseEntry.fromJson(Map<String, dynamic> json) => GlucoseEntry(
    localDate: json['localDate'] == null ? null : DateTime.parse(json['localDate'] as String),
    id: json['id'] as String, version: json['version'] as int,
    value: json['glucoseMgDl'] as int,
    insulinUnits: (json['insulinUnits'] as num?)?.toDouble(),
    moment: moments.entries.firstWhere((e) => e.value == json['moment']).key,
    at: DateTime.parse(json['measuredAt'] as String).toLocal(),
  );

  Map<String, dynamic> toJson({required String requestId, required String timeZone}) {
    return {'id': requestId, 'glucoseMgDl': value, 'insulinUnits': insulinUnits,
      'moment': moments[moment], 'measuredAt': at.toUtc().toIso8601String(), 'timeZone': timeZone};
  }
}
