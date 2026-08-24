import '../../domain/economy/money.dart';

/// Spec-29: which functional slot of the room an item occupies. Only one
/// item per slot is active at a time; buying a replacement displaces the
/// previous occupant (sold back at 50 %).
enum FurnitureSlot { bed, desk, chair, tech, decor, lamp }

/// One furniture item the player can buy in the Zimmer-Shop.
class FurnitureItem {
  const FurnitureItem({
    required this.id,
    required this.name,
    required this.slot,
    required this.price,
    required this.emoji,
    required this.expReward,
  });

  final String id;
  final String name;
  final FurnitureSlot slot;
  final Money price;
  final String emoji;
  final int expReward;

  /// Twemoji-PNG-Pfad. UI versucht Image.asset, fällt auf Emoji zurück
  /// wenn nicht vorhanden. PNG kommt von tools/fetch_furniture_sprites.py
  /// (Twemoji CC-BY 4.0).
  String get assetPath => 'assets/images/furniture/$id.png';
}

/// Spec-29: 12-item starter catalog. Emojis stand in for real
/// kenney_furniture-kit sprites — those land when the asset extraction
/// pass commits the PNGs into `assets/images/furniture/`.
abstract final class FurnitureCatalog {
  static const items = <FurnitureItem>[
    FurnitureItem(
      id: 'bed_basic',
      name: 'Einfaches Bett',
      slot: FurnitureSlot.bed,
      price: Money.cents(5000),
      emoji: '🛏',
      expReward: 20,
    ),
    FurnitureItem(
      id: 'bed_premium',
      name: 'Boxspringbett',
      slot: FurnitureSlot.bed,
      price: Money.cents(20000),
      emoji: '🛌',
      expReward: 60,
    ),
    FurnitureItem(
      id: 'desk_basic',
      name: 'Schreibtisch',
      slot: FurnitureSlot.desk,
      price: Money.cents(8000),
      emoji: '🖋',
      expReward: 25,
    ),
    FurnitureItem(
      id: 'desk_premium',
      name: 'Gaming-Desk',
      slot: FurnitureSlot.desk,
      price: Money.cents(25000),
      emoji: '🖱',
      expReward: 70,
    ),
    FurnitureItem(
      id: 'chair_basic',
      name: 'Sitzbank',
      slot: FurnitureSlot.chair,
      price: Money.cents(3000),
      emoji: '🪑',
      expReward: 15,
    ),
    FurnitureItem(
      id: 'chair_gaming',
      name: 'Gaming-Stuhl',
      slot: FurnitureSlot.chair,
      price: Money.cents(18000),
      emoji: '💺',
      expReward: 50,
    ),
    FurnitureItem(
      id: 'tech_pc',
      name: 'Spiel-PC',
      slot: FurnitureSlot.tech,
      price: Money.cents(40000),
      emoji: '🖥',
      expReward: 100,
    ),
    FurnitureItem(
      id: 'tech_tv',
      name: 'Smart-TV',
      slot: FurnitureSlot.tech,
      price: Money.cents(30000),
      emoji: '📺',
      expReward: 80,
    ),
    FurnitureItem(
      id: 'decor_plant',
      name: 'Zimmerpflanze',
      slot: FurnitureSlot.decor,
      price: Money.cents(1500),
      emoji: '🪴',
      expReward: 10,
    ),
    FurnitureItem(
      id: 'decor_picture',
      name: 'Wandbild',
      slot: FurnitureSlot.decor,
      price: Money.cents(2500),
      emoji: '🖼',
      expReward: 12,
    ),
    FurnitureItem(
      id: 'lamp_basic',
      name: 'Tischlampe',
      slot: FurnitureSlot.lamp,
      price: Money.cents(2000),
      emoji: '💡',
      expReward: 10,
    ),
    FurnitureItem(
      id: 'lamp_neon',
      name: 'Neon-LED',
      slot: FurnitureSlot.lamp,
      price: Money.cents(6000),
      emoji: '🌈',
      expReward: 30,
    ),
    // spec-32: extended catalogue.
    FurnitureItem(
      id: 'tech_console',
      name: 'Spielkonsole',
      slot: FurnitureSlot.tech,
      price: Money.cents(50000),
      emoji: '🎮',
      expReward: 120,
    ),
    FurnitureItem(
      id: 'tech_headphones',
      name: 'Kopfhörer',
      slot: FurnitureSlot.tech,
      price: Money.cents(12000),
      emoji: '🎧',
      expReward: 40,
    ),
    FurnitureItem(
      id: 'decor_poster',
      name: 'Musik-Poster',
      slot: FurnitureSlot.decor,
      price: Money.cents(1800),
      emoji: '🎶',
      expReward: 10,
    ),
    FurnitureItem(
      id: 'decor_aquarium',
      name: 'Aquarium',
      slot: FurnitureSlot.decor,
      price: Money.cents(15000),
      emoji: '🐠',
      expReward: 55,
    ),
    FurnitureItem(
      id: 'desk_standing',
      name: 'Steh-Schreibtisch',
      slot: FurnitureSlot.desk,
      price: Money.cents(35000),
      emoji: '🧑‍💻',
      expReward: 90,
    ),
    FurnitureItem(
      id: 'lamp_lava',
      name: 'Lavalampe',
      slot: FurnitureSlot.lamp,
      price: Money.cents(4500),
      emoji: '🕯',
      expReward: 20,
    ),
    FurnitureItem(
      id: 'bed_loft',
      name: 'Hochbett',
      slot: FurnitureSlot.bed,
      price: Money.cents(35000),
      emoji: '🪜',
      expReward: 90,
    ),
    FurnitureItem(
      id: 'chair_beanbag',
      name: 'Sitzsack',
      slot: FurnitureSlot.chair,
      price: Money.cents(9000),
      emoji: '🛋',
      expReward: 35,
    ),
    // spec-33: massive catalogue expansion — Spielekonsolen-Fokus + Hi-End-Tech.
    FurnitureItem(
      id: 'tech_handheld',
      name: 'Handheld-Konsole',
      slot: FurnitureSlot.tech,
      price: Money.cents(28000),
      emoji: '🕹',
      expReward: 75,
    ),
    FurnitureItem(
      id: 'tech_vr',
      name: 'VR-Brille',
      slot: FurnitureSlot.tech,
      price: Money.cents(55000),
      emoji: '🥽',
      expReward: 140,
    ),
    FurnitureItem(
      id: 'tech_phone',
      name: 'Smartphone',
      slot: FurnitureSlot.tech,
      price: Money.cents(80000),
      emoji: '📱',
      expReward: 180,
    ),
    FurnitureItem(
      id: 'tech_tablet',
      name: 'Tablet',
      slot: FurnitureSlot.tech,
      price: Money.cents(45000),
      emoji: '📲',
      expReward: 110,
    ),
    FurnitureItem(
      id: 'tech_speaker',
      name: 'Bluetooth-Box',
      slot: FurnitureSlot.tech,
      price: Money.cents(8000),
      emoji: '🔊',
      expReward: 30,
    ),
    FurnitureItem(
      id: 'tech_hifi',
      name: 'Hi-Fi-Anlage',
      slot: FurnitureSlot.tech,
      price: Money.cents(40000),
      emoji: '📻',
      expReward: 100,
    ),
    FurnitureItem(
      id: 'tech_camera',
      name: 'DSLR-Kamera',
      slot: FurnitureSlot.tech,
      price: Money.cents(60000),
      emoji: '📷',
      expReward: 160,
    ),
    FurnitureItem(
      id: 'tech_drone',
      name: 'Foto-Drohne',
      slot: FurnitureSlot.tech,
      price: Money.cents(35000),
      emoji: '📹',
      expReward: 90,
    ),
    FurnitureItem(
      id: 'tech_guitar',
      name: 'E-Gitarre',
      slot: FurnitureSlot.tech,
      price: Money.cents(45000),
      emoji: '🎸',
      expReward: 110,
    ),
    FurnitureItem(
      id: 'tech_drumset',
      name: 'E-Drumset',
      slot: FurnitureSlot.tech,
      price: Money.cents(70000),
      emoji: '🥁',
      expReward: 170,
    ),
    FurnitureItem(
      id: 'tech_keyboard',
      name: 'Keyboard',
      slot: FurnitureSlot.tech,
      price: Money.cents(30000),
      emoji: '🎹',
      expReward: 80,
    ),
    FurnitureItem(
      id: 'tech_microscope',
      name: 'Mikroskop',
      slot: FurnitureSlot.tech,
      price: Money.cents(25000),
      emoji: '🔬',
      expReward: 70,
    ),
    FurnitureItem(
      id: 'tech_telescope',
      name: 'Teleskop',
      slot: FurnitureSlot.tech,
      price: Money.cents(38000),
      emoji: '🔭',
      expReward: 95,
    ),
    FurnitureItem(
      id: 'decor_basketball',
      name: 'Basketball-Korb',
      slot: FurnitureSlot.decor,
      price: Money.cents(7000),
      emoji: '🏀',
      expReward: 25,
    ),
    FurnitureItem(
      id: 'decor_skateboard',
      name: 'Skateboard',
      slot: FurnitureSlot.decor,
      price: Money.cents(12000),
      emoji: '🛹',
      expReward: 40,
    ),
    FurnitureItem(
      id: 'decor_dartboard',
      name: 'Dart-Scheibe',
      slot: FurnitureSlot.decor,
      price: Money.cents(4500),
      emoji: '🎯',
      expReward: 20,
    ),
    FurnitureItem(
      id: 'decor_globe',
      name: 'Leucht-Globus',
      slot: FurnitureSlot.decor,
      price: Money.cents(8000),
      emoji: '🌐',
      expReward: 30,
    ),
    FurnitureItem(
      id: 'lamp_disco',
      name: 'Disco-Kugel',
      slot: FurnitureSlot.lamp,
      price: Money.cents(11000),
      emoji: '🪩',
      expReward: 45,
    ),
    FurnitureItem(
      id: 'lamp_starlight',
      name: 'Sternen-Projektor',
      slot: FurnitureSlot.lamp,
      price: Money.cents(13000),
      emoji: '✨',
      expReward: 50,
    ),
    FurnitureItem(
      id: 'desk_drafting',
      name: 'Zeichen-Tisch',
      slot: FurnitureSlot.desk,
      price: Money.cents(22000),
      emoji: '📐',
      expReward: 60,
    ),
    FurnitureItem(
      id: 'chair_office',
      name: 'Bürostuhl',
      slot: FurnitureSlot.chair,
      price: Money.cents(15000),
      emoji: '💼',
      expReward: 45,
    ),
    FurnitureItem(
      id: 'bed_water',
      name: 'Wasserbett',
      slot: FurnitureSlot.bed,
      price: Money.cents(60000),
      emoji: '💦',
      expReward: 150,
    ),
  ];

  static FurnitureItem byId(String id) =>
      items.firstWhere((i) => i.id == id);

  static String labelForSlot(FurnitureSlot slot) => switch (slot) {
        FurnitureSlot.bed => 'Bett',
        FurnitureSlot.desk => 'Schreibtisch',
        FurnitureSlot.chair => 'Stuhl',
        FurnitureSlot.tech => 'Technik',
        FurnitureSlot.decor => 'Deko',
        FurnitureSlot.lamp => 'Lampe',
      };
}
