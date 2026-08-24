import 'package:freezed_annotation/freezed_annotation.dart';

import '../economy/money.dart';
import '../economy/money_json_converter.dart';

part 'wish_item.freezed.dart';
part 'wish_item.g.dart';

/// Category of a wish-list item. Drives the per-category inflation jitter
/// and the section grouping on the wishlist page.
enum WishCategory { sneaker, social, snack, game }

/// One item the player can lust after. `currentPrice` drifts up via the
/// inflation pipeline; `owned` records the day it was bought (null = still
/// available).
@freezed
abstract class WishItem with _$WishItem {
  const factory WishItem({
    required String id,
    required String name,
    required WishCategory category,
    @MoneyConverter() required Money basePrice,
    @MoneyConverter() required Money currentPrice,
    required String emoji,
    int? ownedOnDayIndex,
    /// Welle-8 Round 16: User-Foto-Pfad statt Emoji. Null = Emoji.
    String? photoPath,
  }) = _WishItem;

  factory WishItem.fromJson(Map<String, dynamic> json) =>
      _$WishItemFromJson(json);
}

/// Phase-1 wishlist. **Fictive brands only** — hardregel.
final List<WishItem> kWishCatalog = [
  const WishItem(
    id: 'sneaker_quantum_x',
    name: 'SnipeShot Quantum X',
    category: WishCategory.sneaker,
    basePrice: Money.cents(8000),
    currentPrice: Money.cents(8000),
    emoji: '👟',
  ),
  const WishItem(
    id: 'sneaker_pulse',
    name: 'SnipeShot Pulse',
    category: WishCategory.sneaker,
    basePrice: Money.cents(4500),
    currentPrice: Money.cents(4500),
    emoji: '👟',
  ),
  const WishItem(
    id: 'sneaker_apex',
    name: 'SnipeShot Apex (Limited)',
    category: WishCategory.sneaker,
    basePrice: Money.cents(15000),
    currentPrice: Money.cents(15000),
    emoji: '👟',
  ),
  const WishItem(
    id: 'social_premium',
    name: 'DropTok Plus 1M',
    category: WishCategory.social,
    basePrice: Money.cents(900),
    currentPrice: Money.cents(900),
    emoji: '✨',
  ),
  const WishItem(
    id: 'snack_xxl',
    name: 'XXL Snack-Box',
    category: WishCategory.snack,
    basePrice: Money.cents(300),
    currentPrice: Money.cents(300),
    emoji: '🍫',
  ),
  const WishItem(
    id: 'game_seasonpass',
    name: 'Game Season-Pass',
    category: WishCategory.game,
    basePrice: Money.cents(2000),
    currentPrice: Money.cents(2000),
    emoji: '🎮',
  ),
  // Spec-43 v3: mehr Items auf Inflations-Atoll.
  const WishItem(
    id: 'sneaker_retro',
    name: 'SnipeShot Retro 89',
    category: WishCategory.sneaker,
    basePrice: Money.cents(6500),
    currentPrice: Money.cents(6500),
    emoji: '👟',
  ),
  const WishItem(
    id: 'sneaker_air',
    name: 'SnipeShot AirCloud',
    category: WishCategory.sneaker,
    basePrice: Money.cents(12000),
    currentPrice: Money.cents(12000),
    emoji: '👟',
  ),
  const WishItem(
    id: 'social_creator',
    name: 'DropTok Creator-Boost',
    category: WishCategory.social,
    basePrice: Money.cents(1500),
    currentPrice: Money.cents(1500),
    emoji: '🔥',
  ),
  const WishItem(
    id: 'social_filter',
    name: 'DropTok Pro-Filter-Pack',
    category: WishCategory.social,
    basePrice: Money.cents(450),
    currentPrice: Money.cents(450),
    emoji: '🎨',
  ),
  const WishItem(
    id: 'snack_energy',
    name: 'Energy-Drink 6-Pack',
    category: WishCategory.snack,
    basePrice: Money.cents(800),
    currentPrice: Money.cents(800),
    emoji: '🥤',
  ),
  const WishItem(
    id: 'snack_pizza',
    name: 'Mega-Pizza-Lieferung',
    category: WishCategory.snack,
    basePrice: Money.cents(1800),
    currentPrice: Money.cents(1800),
    emoji: '🍕',
  ),
  const WishItem(
    id: 'snack_burger',
    name: 'Burger-Menü XXL',
    category: WishCategory.snack,
    basePrice: Money.cents(1200),
    currentPrice: Money.cents(1200),
    emoji: '🍔',
  ),
  const WishItem(
    id: 'game_console',
    name: 'Konsole "Plaxbox 6"',
    category: WishCategory.game,
    basePrice: Money.cents(45000),
    currentPrice: Money.cents(45000),
    emoji: '🎮',
  ),
  const WishItem(
    id: 'game_controller',
    name: 'Pro-Controller Wireless',
    category: WishCategory.game,
    basePrice: Money.cents(7500),
    currentPrice: Money.cents(7500),
    emoji: '🕹️',
  ),
  const WishItem(
    id: 'game_headset',
    name: 'Gaming-Headset RGB',
    category: WishCategory.game,
    basePrice: Money.cents(9500),
    currentPrice: Money.cents(9500),
    emoji: '🎧',
  ),
  const WishItem(
    id: 'tech_phone',
    name: 'Smartphone "Pixil 12"',
    category: WishCategory.game,
    basePrice: Money.cents(85000),
    currentPrice: Money.cents(85000),
    emoji: '📱',
  ),
  const WishItem(
    id: 'tech_tablet',
    name: 'Tablet "Slate Air"',
    category: WishCategory.game,
    basePrice: Money.cents(55000),
    currentPrice: Money.cents(55000),
    emoji: '📲',
  ),
  const WishItem(
    id: 'tech_watch',
    name: 'Smartwatch "Tic 5"',
    category: WishCategory.game,
    basePrice: Money.cents(28000),
    currentPrice: Money.cents(28000),
    emoji: '⌚',
  ),
  const WishItem(
    id: 'tech_earbuds',
    name: 'TrueWireless-Earbuds',
    category: WishCategory.game,
    basePrice: Money.cents(15000),
    currentPrice: Money.cents(15000),
    emoji: '🎧',
  ),
  // Optionen-Backlog #4: günstigere Items im Spar-Band <120 €, in dem das
  // Kind real spart. Fiktive/generische Namen — keine echten Marken.
  const WishItem(
    id: 'tech_powerbank',
    name: 'Powerbank "JuicePack 20k"',
    category: WishCategory.game,
    basePrice: Money.cents(2900),
    currentPrice: Money.cents(2900),
    emoji: '🔋',
  ),
  const WishItem(
    id: 'tech_bluetooth_box',
    name: 'Bluetooth-Box "BeatBox Mini"',
    category: WishCategory.game,
    basePrice: Money.cents(3900),
    currentPrice: Money.cents(3900),
    emoji: '🔊',
  ),
  const WishItem(
    id: 'game_mouse',
    name: 'Gaming-Maus "GripFlow Pro"',
    category: WishCategory.game,
    basePrice: Money.cents(4900),
    currentPrice: Money.cents(4900),
    emoji: '🖱️',
  ),
  const WishItem(
    id: 'social_concert_ticket',
    name: 'Open-Air-Festival Ticket',
    category: WishCategory.social,
    basePrice: Money.cents(5500),
    currentPrice: Money.cents(5500),
    emoji: '🎫',
  ),
  const WishItem(
    id: 'social_verein',
    name: 'Sportverein Halbjahr',
    category: WishCategory.social,
    basePrice: Money.cents(6000),
    currentPrice: Money.cents(6000),
    emoji: '⚽',
  ),
  const WishItem(
    id: 'game_skateboard',
    name: 'Skateboard "StreetRoll"',
    category: WishCategory.game,
    basePrice: Money.cents(7900),
    currentPrice: Money.cents(7900),
    emoji: '🛹',
  ),
  const WishItem(
    id: 'game_bike_kit',
    name: 'Fahrrad-Set "CityRide Kit"',
    category: WishCategory.game,
    basePrice: Money.cents(8500),
    currentPrice: Money.cents(8500),
    emoji: '🚲',
  ),
  const WishItem(
    id: 'tech_headphones',
    name: 'Over-Ear "BassNest Studio"',
    category: WishCategory.game,
    basePrice: Money.cents(11900),
    currentPrice: Money.cents(11900),
    emoji: '🎵',
  ),
];

abstract final class InflationConfig {
  /// v29: realistisch ~2 %/J Basis-Inflation (User-Vorgabe). 1,02^80 =
  /// 4,88× = +388 % über 80 Jahre. ln(1,02)/365 = 0,0000543/Tag.
  /// Vorher 0,0008/Tag = ~30 %/J = explodierte über Jahrzehnte.
  static const double dailyRate = 0.0000543;

  /// Welle-8: einheitliche Inflation für alle Gütergruppen. Real-Life
  /// gibt es Unterschiede zwischen Sneaker/Snack/Tech — für die App
  /// haben wir das vereinfacht (User-Feedback: "Inflation pro
  /// Gütergruppe sollte gleich sein").
  static const Map<WishCategory, double> categoryJitter = {
    WishCategory.sneaker: 0.0,
    WishCategory.social: 0.0,
    WishCategory.snack: 0.0,
    WishCategory.game: 0.0,
  };

  static double dailyDriftFor(WishCategory c) =>
      dailyRate + (categoryJitter[c] ?? 0);
}
