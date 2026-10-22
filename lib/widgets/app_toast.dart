import 'dart:async';
import 'package:flutter/material.dart';
import '../design_system.dart';

enum ToastKind { success, warning, error }

/// One accessible, dismissible toast above routes and bottom sheets.
abstract final class AppToast {
  static OverlayEntry? _entry;

  static void dismiss() {
    _entry?.remove();
    _entry = null;
  }

  static void show(BuildContext context, String message, {ToastKind kind = ToastKind.success}) {
    dismiss();
    final (foreground, background, icon) = switch (kind) {
      ToastKind.success => (GlicColors.toastSuccess, GlicColors.toastSuccessSurface, Icons.check_circle_outline),
      ToastKind.warning => (GlicColors.toastWarning, GlicColors.toastWarningSurface, Icons.warning_amber_rounded),
      ToastKind.error => (GlicColors.toastError, GlicColors.toastErrorSurface, Icons.error_outline),
    };
    final closeLabel = MaterialLocalizations.of(context).closeButtonTooltip;
    final entry = OverlayEntry(builder: (_) => _ToastLifetime(
      duration: Duration(seconds: kind == ToastKind.success ? 4 : 6), onElapsed: dismiss, child: Positioned(
      top: 0, left: GlicSpace.md, right: GlicSpace.md,
      child: SafeArea(child: Align(alignment: Alignment.topCenter,
        child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 520),
          child: Semantics(liveRegion: true, child: Material(
            elevation: 6, color: background, borderRadius: BorderRadius.circular(20),
            child: Padding(padding: const EdgeInsets.fromLTRB(16, 8, 4, 8),
              child: Row(children: [
                Icon(icon, color: foreground),
                const SizedBox(width: GlicSpace.compact),
                Expanded(child: Text(message, style: TextStyle(color: foreground, fontSize: 14, fontWeight: FontWeight.w700))),
                IconButton(tooltip: closeLabel, onPressed: dismiss, icon: Icon(Icons.close, color: foreground)),
              ])),
          )),
        ),
      )),
    )));
    _entry = entry;
    Overlay.of(context, rootOverlay: true).insert(entry);
  }
}

class _ToastLifetime extends StatefulWidget {
  const _ToastLifetime({required this.duration, required this.onElapsed, required this.child});
  final Duration duration;
  final VoidCallback onElapsed;
  final Widget child;
  @override
  State<_ToastLifetime> createState() => _ToastLifetimeState();
}
class _ToastLifetimeState extends State<_ToastLifetime> {
  late final Timer timer;
  @override
  void initState() { super.initState(); timer = Timer(widget.duration, widget.onElapsed); }
  @override
  void dispose() { timer.cancel(); super.dispose(); }
  @override
  Widget build(BuildContext context) => widget.child;
}
