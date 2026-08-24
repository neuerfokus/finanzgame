import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../core/design_tokens.dart';
import '../../features/glossar/glossar_entries.dart';

/// Spec-43 v4: Text mit klickbaren Glossar-Begriffen.
///
/// Scannt [text] nach Wörtern aus [kGlossar.term] (case-insensitive, ganze
/// Wörter). Treffer werden unterstrichen + tap öffnet ein Bottom-Sheet mit
/// Definition + Beispiel.
class GlossarText extends StatelessWidget {
  const GlossarText(
    this.text, {
    required this.style,
    super.key,
    this.textAlign,
  });

  final String text;
  final TextStyle style;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final spans = _buildSpans(context, text, style);
    if (spans.length == 1 && spans.first is TextSpan) {
      // Kein Glossar-Treffer — normal rendern.
      return Text(text, style: style, textAlign: textAlign);
    }
    return RichText(
      textAlign: textAlign ?? TextAlign.start,
      text: TextSpan(style: style, children: spans),
    );
  }

  List<InlineSpan> _buildSpans(
      BuildContext context, String src, TextStyle baseStyle) {
    // Regex: Wort-Grenzen, case-insensitive Match auf Glossar-Begriffe.
    final terms = kGlossar.map((e) => e.term).toList()
      ..sort((a, b) => b.length.compareTo(a.length)); // longest first
    final pattern = RegExp(
      r'\b(' + terms.map(RegExp.escape).join('|') + r')\b',
      caseSensitive: false,
    );
    final spans = <InlineSpan>[];
    var lastEnd = 0;
    for (final m in pattern.allMatches(src)) {
      if (m.start > lastEnd) {
        spans.add(TextSpan(text: src.substring(lastEnd, m.start)));
      }
      final matched = src.substring(m.start, m.end);
      final entry = kGlossar.firstWhere(
        (e) => e.term.toLowerCase() == matched.toLowerCase(),
        orElse: () => kGlossar.first,
      );
      spans.add(TextSpan(
        text: matched,
        style: baseStyle.copyWith(
          color: FgColors.primary,
          decoration: TextDecoration.underline,
          decorationColor: FgColors.primary,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () => _showEntry(context, entry),
      ));
      lastEnd = m.end;
    }
    if (lastEnd < src.length) {
      spans.add(TextSpan(text: src.substring(lastEnd)));
    }
    return spans;
  }

  void _showEntry(BuildContext context, GlossarEntry entry) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: FgColors.backgroundElevated,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(FgSpacing.l),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Spec-43 v8: einheitliche Schriftgrößen — gleich wie auf
            // Glossar-Page (bodyL bold für Term, bodyM für Def).
            Text(
              entry.term,
              style: FgTypography.bodyL.copyWith(
                fontWeight: FontWeight.bold,
                color: FgColors.primary,
              ),
            ),
            const SizedBox(height: FgSpacing.s),
            Text(entry.definition, style: FgTypography.bodyM),
            if (entry.example != null) ...[
              const SizedBox(height: FgSpacing.s),
              Text(
                'Beispiel: ${entry.example!}',
                style: FgTypography.bodyS
                    .copyWith(color: FgColors.info),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
