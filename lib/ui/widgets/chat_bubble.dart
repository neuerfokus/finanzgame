import 'package:flutter/material.dart';

import '../../core/design_tokens.dart';
import '../../domain/quest/chat_entry.dart';
import 'glossar_text.dart';

/// One chat bubble in the QuestRunner stream.
class ChatBubble extends StatelessWidget {
  const ChatBubble({required this.entry, super.key});

  final ChatEntry entry;

  @override
  Widget build(BuildContext context) {
    return switch (entry) {
      // spec-31: NPC questions (marked by leading ❓) render with a gold
      // border + bold text so they stand out from regular dialog lines.
      NpcEntry(:final speaker, :final text) => _Bubble(
          alignment: Alignment.centerLeft,
          background: text.startsWith('❓')
              ? FgColors.backgroundDeep
              : FgColors.backgroundElevated,
          borderColor: text.startsWith('❓')
              ? FgColors.primary
              : FgColors.outline,
          borderWidth: text.startsWith('❓') ? 3 : 2,
          bold: text.startsWith('❓'),
          header: speaker,
          text: text,
        ),
      OwnEntry(:final text) => _Bubble(
          alignment: Alignment.centerRight,
          background: FgColors.secondary,
          text: text,
        ),
      SystemEntry(:final text) => Padding(
          padding: const EdgeInsets.symmetric(vertical: FgSpacing.xs),
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: FgSpacing.m,
                vertical: FgSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: FgColors.backgroundDeep,
                border: Border.all(color: FgColors.primary, width: 2),
              ),
              child: GlossarText(
                text,
                style: FgTypography.bodyS.copyWith(color: FgColors.primary),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
    };
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({
    required this.alignment,
    required this.background,
    required this.text,
    this.header,
    this.borderColor = FgColors.outline,
    this.borderWidth = 2,
    this.bold = false,
  });

  final Alignment alignment;
  final Color background;
  final String text;
  final String? header;
  final Color borderColor;
  final double borderWidth;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final textStyle = bold
        ? FgTypography.bodyL.copyWith(
            fontWeight: FontWeight.bold,
            color: FgColors.primary,
          )
        : FgTypography.bodyM;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: FgSpacing.xs),
      child: Align(
        alignment: alignment,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 260),
          child: Container(
            padding: const EdgeInsets.all(FgSpacing.m),
            decoration: BoxDecoration(
              color: background,
              border: Border.all(color: borderColor, width: borderWidth),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (header != null) ...[
                  Text(header!, style: FgTypography.bodyS),
                  const SizedBox(height: FgSpacing.xs),
                ],
                GlossarText(text, style: textStyle),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
