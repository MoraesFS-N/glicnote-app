import '../l10n/localization.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../design_system.dart';

class ScrollableFilterBar extends StatefulWidget {
  const ScrollableFilterBar({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
    this.labelBuilder,
  });

  final List<String> options;
  final String selected;
  final String Function(String)? labelBuilder;
  final ValueChanged<String> onSelected;

  @override
  State<ScrollableFilterBar> createState() => _ScrollableFilterBarState();
}

class _ScrollableFilterBarState extends State<ScrollableFilterBar> {
  final controller = ScrollController();
  bool hasMore = false;

  @override
  void initState() {
    super.initState();
    controller.addListener(updateIndicator);
  }

  void updateIndicator() {
    if (!mounted || !controller.hasClients || !controller.position.hasContentDimensions) return;
    final more = controller.position.extentAfter > 1;
    if (more != hasMore) setState(() => hasMore = more);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => NotificationListener<ScrollMetricsNotification>(
    onNotification: (_) {
      WidgetsBinding.instance.addPostFrameCallback((_) => updateIndicator());
      return false;
    },
    child: Stack(alignment: Alignment.centerRight, children: [
      SingleChildScrollView(
        controller: controller,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(right: 52),
        child: Row(children: [
          for (final option in widget.options)
            Padding(
              padding: EdgeInsets.only(right: 8),
              child: ChoiceChip(
                selected: widget.selected == option,
                label: Text(widget.labelBuilder?.call(option) ?? option),
                selectedColor: GlicColors.lavender,
                onSelected: (_) => widget.onSelected(option),
              ),
            ),
        ]),
      ),
      if (hasMore)
        Container(
          width: 56,
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(gradient: LinearGradient(colors: [
            GlicColors.background.withValues(alpha: 0),
            GlicColors.background,
          ])),
          child: IconButton.filledTonal(
            tooltip: context.l10n.moreFilters,
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: GlicColors.primary,
              elevation: 3,
              shadowColor: Colors.black26,
            ),
            onPressed: () {
              final target = math.min(controller.offset + controller.position.viewportDimension * .7,
                  controller.position.maxScrollExtent);
              controller.animateTo(target,
                duration: MediaQuery.disableAnimationsOf(context) ? Duration.zero : Duration(milliseconds: 250),
                curve: Curves.easeOut);
            },
            icon: Icon(Icons.chevron_right),
          ),
        ),
    ]),
  );
}
