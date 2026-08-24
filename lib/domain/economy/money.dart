import 'package:intl/intl.dart';

/// Immutable monetary value stored as integer cents.
///
/// Rules:
/// - NEVER store as double. Only `Money.euros(double)` and
///   `Money.percent(double)` touch doubles; all arithmetic stays in cents.
/// - JSON: `{ "cents": 1250 }` round-trips via [Money.fromJson] / [toJson].
final class Money implements Comparable<Money> {
  // ── Constructors ────────────────────────────────────────────────────────────

  const Money._(this.cents);

  const Money.cents(int cents) : this._(cents);

  /// Creates a [Money] from a euro amount.
  /// The double is rounded to the nearest cent (banker's rounding avoided;
  /// round-half-away-from-zero via [.round()]).
  factory Money.euros(double euros) => Money._((euros * 100).round());

  factory Money.fromJson(Map<String, dynamic> json) =>
      Money._(json['cents'] as int);

  // ── Fields ──────────────────────────────────────────────────────────────────

  final int cents;

  /// The zero-value sentinel.
  static const Money zero = Money._(0);

  static final _eurFmt = NumberFormat.currency(
    locale: 'de_DE',
    symbol: '€',
    decimalDigits: 2,
  );

  // ── JSON ────────────────────────────────────────────────────────────────────

  Map<String, dynamic> toJson() => {'cents': cents};

  // ── Arithmetic ──────────────────────────────────────────────────────────────

  Money operator +(Money other) => Money._(cents + other.cents);

  Money operator -(Money other) => Money._(cents - other.cents);

  /// Multiplies by a scalar integer.
  Money operator *(int factor) => Money._(cents * factor);

  /// Returns a percentage of this amount.
  /// Example: `money.percent(0.05)` → 5 % of `money` (rounded to cent).
  Money percent(double rate) => Money._((cents * rate).round());

  bool get isZero => cents == 0;

  bool get isPositive => cents > 0;

  bool get isNegative => cents < 0;

  // ── Comparison ──────────────────────────────────────────────────────────────

  @override
  int compareTo(Money other) => cents.compareTo(other.cents);

  bool operator <(Money other) => cents < other.cents;

  bool operator <=(Money other) => cents <= other.cents;

  bool operator >(Money other) => cents > other.cents;

  bool operator >=(Money other) => cents >= other.cents;

  // ── Formatting ──────────────────────────────────────────────────────────────

  /// Returns a locale-formatted string like `"12,50 €"`.
  String formatEur() => _eurFmt.format(cents / 100);

  // ── Object ──────────────────────────────────────────────────────────────────

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Money && other.cents == cents);

  @override
  int get hashCode => cents.hashCode;

  @override
  String toString() => formatEur();
}
