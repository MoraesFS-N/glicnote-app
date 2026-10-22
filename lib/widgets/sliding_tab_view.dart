import 'package:flutter/material.dart';

/// Mantém as abas montadas e anima a entrada e a saída lateralmente.
class SlidingTabView extends StatefulWidget {
  const SlidingTabView({
    super.key,
    required this.index,
    required this.children,
    this.duration = const Duration(milliseconds: 300),
  }) : assert(index >= 0 && index < children.length);

  final int index;
  final List<Widget> children;
  final Duration duration;

  @override
  State<SlidingTabView> createState() => _SlidingTabViewState();
}

class _SlidingTabViewState extends State<SlidingTabView> {
  int? outgoing;

  @override
  void didUpdateWidget(covariant SlidingTabView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index) outgoing = oldWidget.index;
  }

  @override
  Widget build(BuildContext context) => ClipRect(
    child: Stack(children: [
      for (var i = 0; i < widget.children.length; i++)
        Positioned.fill(
          child: Offstage(
            offstage: i != widget.index && i != outgoing,
            child: TickerMode(
              enabled: i == widget.index || i == outgoing,
              child: IgnorePointer(
                ignoring: i != widget.index,
                child: ExcludeFocus(
                  excluding: i != widget.index,
                  child: ExcludeSemantics(
                    excluding: i != widget.index,
                    child: AnimatedSlide(
                      offset: Offset(i == widget.index ? 0 : (i < widget.index ? -1 : 1), 0),
                      duration: MediaQuery.disableAnimationsOf(context) ? Duration.zero : widget.duration,
                      curve: Curves.easeInOutCubic,
                      onEnd: () {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted && i == widget.index && outgoing != null) {
                            setState(() => outgoing = null);
                          }
                        });
                      },
                      child: widget.children[i],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
    ]),
  );
}
