import 'package:flutter/material.dart';

import '../../core/design_tokens.dart';

/// Pixel-art panel: filled rect with thick outline border.
class PixelPanel extends StatelessWidget {
  const PixelPanel({
    required this.child,
    this.padding = const EdgeInsets.all(FgSpacing.l),
    this.background = FgColors.backgroundElevated,
    super.key,
  });

  final Widget child;
  final EdgeInsets padding;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: background,
        border: Border.all(color: FgColors.outline, width: 3),
      ),
      child: child,
    );
  }
}
