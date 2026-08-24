import 'dart:math' as math;

/// Rechenaufgabe als Elternschranke: eine Multiplikation, die ein Erwachsener
/// im Kopf oder mit einem Blick löst und ein Grundschulkind nicht.
///
/// Bewusst KEIN zweiter PIN: der Eltern-PIN im „Gefährlichen Bereich" schützt
/// etwas anderes (Reset, Import, Belohnungen) und setzt voraus, dass ein
/// Elternteil ihn eingerichtet hat. Die Schranke hier muss auch dann greifen,
/// wenn niemand etwas eingerichtet hat — auf jedem Gerät, ab dem ersten Start.
class ParentGateChallenge {
  const ParentGateChallenge({required this.a, required this.b});

  final int a;
  final int b;

  int get answer => a * b;

  bool accepts(String input) {
    final parsed = int.tryParse(input.trim());
    return parsed != null && parsed == answer;
  }

  /// Zahlenbereich laut Spec: 12–19 × 13–19. Klein genug, dass kein
  /// Erwachsener einen Taschenrechner braucht, groß genug, dass es nicht
  /// nebenbei geraten wird.
  static ParentGateChallenge generate(math.Random rng) => ParentGateChallenge(
        a: 12 + rng.nextInt(8), // 12..19
        b: 13 + rng.nextInt(7), // 13..19
      );

  @override
  String toString() => '$a × $b';
}

/// Sperre nach zu vielen Fehlversuchen.
///
/// Rein und mit injizierbarer Zeit — `DateTime.now()` steckt nirgends in der
/// Logik, sonst wäre der Ablauf der Sperre nicht testbar.
abstract final class ParentGateLockout {
  /// So viele Fehlversuche sind pro Dialog erlaubt.
  static const int maxAttempts = 3;

  /// So lange bleibt die Schranke danach zu.
  static const Duration lockout = Duration(seconds: 60);

  /// Zeitpunkt, bis zu dem gesperrt wird, wenn jetzt der letzte Versuch
  /// verbraucht ist.
  static int lockedUntilMsFrom(int nowMs) => nowMs + lockout.inMilliseconds;

  static bool isLocked(int lockedUntilMs, int nowMs) => nowMs < lockedUntilMs;

  /// Verbleibende Sperrzeit in ganzen Sekunden, aufgerundet (0 = frei).
  static int remainingSeconds(int lockedUntilMs, int nowMs) {
    final msLeft = lockedUntilMs - nowMs;
    if (msLeft <= 0) return 0;
    return (msLeft / 1000).ceil();
  }
}
