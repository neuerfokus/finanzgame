import 'package:flutter/material.dart';

import '../../core/design_tokens.dart';
import '../../ui/widgets/pixel_button.dart';
import '../../ui/widgets/pixel_panel.dart';
import 'island_identity.dart';

/// Spec-16: identity strip shown above every island page body.
/// Spec-17: extended with the "Was ist das?" button — opens a bottom-sheet
/// with the [IslandIdentity.lesson] longform finance explanation.
///
/// Renders: glyph + label / `Schwerpunkt: {focus}` / `Asset: {assetClass}` /
/// one-liner. Keys the focus and asset-class lines with stable text so
/// widget tests can `find.textContaining('Schwerpunkt:')`.
class IslandHeader extends StatelessWidget {
  const IslandHeader({required this.identity, super.key});

  factory IslandHeader.forId(String id, {Key? key}) =>
      IslandHeader(identity: islandIdentityFor(id), key: key);

  final IslandIdentity identity;

  void _showLesson(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: FgColors.backgroundElevated,
      isScrollControlled: true,
      builder: (sheetCtx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(FgSpacing.l),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      identity.glyph,
                      style: const TextStyle(fontSize: 28),
                    ),
                    const SizedBox(width: FgSpacing.m),
                    Expanded(
                      child: Text(
                        identity.label,
                        style: FgTypography.display,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: FgSpacing.m),
                Text(identity.lesson, style: FgTypography.bodyM),
                const SizedBox(height: FgSpacing.l),
                Align(
                  alignment: Alignment.centerRight,
                  child: PixelButton(
                    label: 'Schließen',
                    background: FgColors.primary,
                    foreground: FgColors.onPrimary,
                    onPressed: () => Navigator.of(sheetCtx).pop(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        FgSpacing.l,
        FgSpacing.s,
        FgSpacing.l,
        FgSpacing.s,
      ),
      child: PixelPanel(
        padding: const EdgeInsets.all(FgSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: identity.color,
                    border: Border.all(color: FgColors.outline, width: 2),
                  ),
                  child: Text(
                    identity.glyph,
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
                const SizedBox(width: FgSpacing.m),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(identity.label, style: FgTypography.display),
                      const SizedBox(height: FgSpacing.xs),
                      Text(
                        'Schwerpunkt: ${identity.focus}',
                        style: FgTypography.bodyM,
                      ),
                      Text(
                        'Asset: ${identity.assetClass}',
                        style: FgTypography.bodyM,
                      ),
                      const SizedBox(height: FgSpacing.xs),
                      Text(identity.oneLiner, style: FgTypography.bodyS),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: FgSpacing.s),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: FgColors.info,
                  padding: const EdgeInsets.symmetric(
                    horizontal: FgSpacing.s,
                    vertical: FgSpacing.xs,
                  ),
                  minimumSize: const Size(0, 32),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () => _showLesson(context),
                child: const Text(
                  'Was ist das?',
                  style: FgTypography.bodyM,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
