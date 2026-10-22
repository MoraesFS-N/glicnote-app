import '../design_system.dart';
import '../l10n/localization.dart';
import 'package:flutter/material.dart';

class DateRangeFilter extends StatelessWidget {
  const DateRangeFilter({super.key, required this.value, required this.onChanged});
  final DateTimeRange? value;
  final ValueChanged<DateTimeRange?> onChanged;

  Future<void> selectPeriod(BuildContext context) async {
    final result = await showDateRangePicker(
      context: context,
      initialDateRange: value,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100, 12, 31),
      helpText: context.l10n.selectPeriod,
      saveText: context.l10n.apply,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          scaffoldBackgroundColor: GlicColors.surfaceSoft,
          appBarTheme: const AppBarTheme(
            backgroundColor: GlicColors.primaryDark,
            foregroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
          ),
          datePickerTheme: DatePickerThemeData(
            backgroundColor: GlicColors.surfaceSoft,
            surfaceTintColor: Colors.transparent,
            headerBackgroundColor: GlicColors.primaryDark,
            headerForegroundColor: Colors.white,
            rangePickerBackgroundColor: GlicColors.surfaceSoft,
            rangePickerSurfaceTintColor: Colors.transparent,
            rangePickerHeaderBackgroundColor: GlicColors.primaryDark,
            rangePickerHeaderForegroundColor: Colors.white,
            rangeSelectionBackgroundColor: GlicColors.lavender,
            dividerColor: GlicColors.lavender,
            todayBorder: const BorderSide(color: GlicColors.primary),
            dayBackgroundColor: WidgetStateProperty.resolveWith((states) =>
              states.contains(WidgetState.selected) ? GlicColors.primary : null),
            dayForegroundColor: WidgetStateProperty.resolveWith((states) =>
              states.contains(WidgetState.selected) ? Colors.white : null),
          ),
        ),
        child: child!,
      ),
    );
    if (context.mounted && result != null) onChanged(result);
  }

  @override
  Widget build(BuildContext context) {
    final active = value != null;
    return AnimatedContainer(
      duration: Duration(milliseconds: MediaQuery.disableAnimationsOf(context) ? 0 : 200),
      decoration: BoxDecoration(
        color: GlicColors.surfaceSoft,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: active
          ? GlicColors.primary.withValues(alpha: .3) : Colors.transparent),
      ),
      child: Material(color: Colors.transparent, borderRadius: BorderRadius.circular(24),
        clipBehavior: Clip.antiAlias,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          InkWell(
            onTap: () => selectPeriod(context),
            child: Padding(padding: const EdgeInsets.all(GlicSpace.md), child: Row(children: [
              Container(padding: const EdgeInsets.all(GlicSpace.compact),
                decoration: BoxDecoration(
                  color: active ? GlicColors.primary : GlicColors.lavender,
                  borderRadius: BorderRadius.circular(16)),
                child: Icon(Icons.calendar_month_rounded,
                  color: active ? Colors.white : GlicColors.primary)),
              const SizedBox(width: GlicSpace.compact),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(context.l10n.filterDate, style: const TextStyle(
                  fontWeight: FontWeight.w700, color: GlicColors.ink, fontSize: 16)),
                const SizedBox(height: GlicSpace.xs),
                Text(active
                  ? '${context.fullDate(value!.start)} – ${context.fullDate(value!.end)}'
                  : context.l10n.selectPeriod,
                  style: TextStyle(color: active ? GlicColors.primary : GlicColors.muted,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w400, fontSize: 13)),
              ])),
              const SizedBox(width: GlicSpace.sm),
              const Icon(Icons.expand_more_rounded, color: GlicColors.primary),
            ])),
          ),
          if (active) ...[
            const Divider(height: 1, indent: GlicSpace.md, endIndent: GlicSpace.md,
              color: GlicColors.lavender),
            Align(alignment: Alignment.centerRight, child: TextButton.icon(
              onPressed: () => onChanged(null),
              icon: const Icon(Icons.close_rounded, size: 16),
              label: Text(context.l10n.clearPeriod),
            )),
          ],
        ]),
      ),
    );
  }
}
