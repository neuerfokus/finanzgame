import 'package:flutter/material.dart';

import '../../core/design_tokens.dart';

/// Spec-25: legible save/info snackbar with pixel-panel styling.
///
/// Uses a floating snack with high-contrast background, large body text,
/// and a bottom margin so the message never hides under the HomeBar.
void showFgSnack(
  BuildContext context,
  String message, {
  Duration duration = const Duration(milliseconds: 1500),
  bool isError = false,
}) {
  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger == null) return;
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor:
            isError ? FgColors.alert : FgColors.backgroundElevated,
        margin: const EdgeInsets.fromLTRB(
          FgSpacing.l,
          FgSpacing.l,
          FgSpacing.l,
          80,
        ),
        elevation: 6,
        duration: duration,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(FgRadius.card)),
          side: BorderSide(color: FgColors.primary, width: 2),
        ),
        content: Text(
          message,
          style: FgTypography.bodyL.copyWith(
            color: FgColors.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
}
