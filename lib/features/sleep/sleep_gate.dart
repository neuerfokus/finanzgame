import '../../domain/economy/money.dart';

/// Spec-33: anti-glitch policy for the Schlafen-Button.
///
/// Sleep-spam would let the player advance plant growth and asset price
/// rolls "for free" since the in-game cost is only 0.10 €. The gate
/// escalates the cost geometrically inside an 8-hour real-world window
/// and refuses outright after the fourth sleep until the cooldown clears.
class SleepGate {
  const SleepGate({this.now});

  /// Injectable clock for tests. Defaults to [DateTime.now].
  final DateTime Function()? now;

  /// Length of the rolling window after which the counter resets.
  static const Duration windowDuration = Duration(hours: 8);

  /// Maximum sleeps allowed inside the window.
  static const int maxSleepsInWindow = 3;

  /// Returns (cost, allowed). Cost rises with [countSoFar]:
  /// 1st = 50 ¢, 2nd = 200 ¢, 3rd = 800 ¢. The 4th request inside the
  /// window is blocked entirely.
  static Money costForNthSleep(int countSoFar) {
    final n = countSoFar.clamp(0, maxSleepsInWindow - 1);
    return Money.cents(50 * (1 << (n * 2))); // 50, 200, 800
  }

  /// Returns the next state to persist after a successful sleep, given
  /// the prior [lastEpochMs] + [count]. Resets the count if the window
  /// has elapsed.
  (int nextEpochMs, int nextCount, Money cost, bool allowed) tryAdvance({
    required int lastEpochMs,
    required int count,
  }) {
    final clock = now ?? DateTime.now;
    final nowMs = clock().millisecondsSinceEpoch;
    final windowMs = windowDuration.inMilliseconds;
    final inWindow = lastEpochMs != 0 && nowMs - lastEpochMs < windowMs;
    final effectiveCount = inWindow ? count : 0;
    if (effectiveCount >= maxSleepsInWindow) {
      return (lastEpochMs, count, Money.zero, false);
    }
    final cost = costForNthSleep(effectiveCount);
    return (nowMs, effectiveCount + 1, cost, true);
  }
}
