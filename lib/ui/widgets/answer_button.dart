import 'package:flutter/material.dart';

import '../../core/design_tokens.dart';
import 'pixel_button.dart';

/// Ergebnis-Zustand einer Antwort.
enum AnswerFeedback {
  /// Noch offen bzw. nach dem Auflösen unbeteiligt.
  none,

  /// Erster Versuch war falsch, die Frage ist aber noch nicht aufgelöst.
  wrongTry,

  /// Aufgelöst: das ist die richtige Antwort.
  correct,

  /// Aufgelöst: diese Antwort wurde gewählt und war falsch.
  wrong,
}

/// Leitet den [AnswerFeedback] einer Quiz-Antwort aus dem Zwei-Versuche-
/// Ablauf ab (Frage des Tages + Wissens-Quiz).
AnswerFeedback answerFeedbackFor({
  required bool isCorrect,
  required bool wasWrong,
  required bool isPicked,
  required bool finalised,
}) {
  if (finalised) {
    if (isCorrect) return AnswerFeedback.correct;
    if (wasWrong || isPicked) return AnswerFeedback.wrong;
    return AnswerFeedback.none;
  }
  return wasWrong ? AnswerFeedback.wrongTry : AnswerFeedback.none;
}

/// Gemeinsamer Antwort-Button für Quest-Runner, Frage des Tages und
/// Wissens-Quiz.
///
/// Play-Test-Feedback: die Antworten sahen in den Quests gelb (PixelButton)
/// und im Quiz lila (rohe Kachel) aus. Jetzt ist es überall derselbe gelbe
/// PixelButton; nur das Richtig/Falsch-Feedback färbt grün bzw. rot.
///
/// Das Ergebnis steht zusätzlich als Präfix im Text („✓ Richtig: …"),
/// damit es nicht allein an der Farbe hängt (Farbenblindheit, TalkBack).
class AnswerButton extends StatelessWidget {
  const AnswerButton({
    required this.label,
    required this.onPressed,
    this.feedback = AnswerFeedback.none,
    this.selected,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final AnswerFeedback feedback;

  /// Nur im Quiz gesetzt: ob diese Antwort gewählt wurde (Semantics).
  final bool? selected;

  /// Fehlversuch: halbtransparentes Rot auf dem Seitenhintergrund,
  /// vorgemischt, damit die Kontrast-Selbstheilung von [PixelButton] eine
  /// deckende Farbe rechnet.
  static final Color wrongTryColor = Color.alphaBlend(
    FgColors.alert.withValues(alpha: 0.6),
    FgColors.backgroundPrimary,
  );

  String get _praefix => switch (feedback) {
        AnswerFeedback.none => '',
        AnswerFeedback.wrongTry => '✗ ',
        AnswerFeedback.correct => '✓ Richtig: ',
        AnswerFeedback.wrong => '✗ Falsch: ',
      };

  Color? get _feedbackColor => switch (feedback) {
        AnswerFeedback.none => null,
        AnswerFeedback.wrongTry => wrongTryColor,
        AnswerFeedback.correct => FgColors.success,
        AnswerFeedback.wrong => FgColors.alert,
      };

  @override
  Widget build(BuildContext context) {
    final text = '$_praefix$label';
    final feedbackColor = _feedbackColor;
    return SizedBox(
      width: double.infinity,
      child: PixelButton(
        label: text,
        semanticLabel: text,
        selected: selected,
        onPressed: onPressed,
        background: feedbackColor ?? FgColors.primary,
        foreground: FgColors.onPrimary,
        disabledBackground: feedbackColor,
      ),
    );
  }
}
