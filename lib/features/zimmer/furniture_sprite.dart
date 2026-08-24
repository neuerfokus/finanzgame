import 'package:flutter/material.dart';

import 'furniture_catalog.dart';

/// Rendert Furniture-Item als Twemoji-PNG (asset). Fällt auf Text-Emoji
/// zurück wenn PNG fehlt (z.B. Hot-Reload vor Asset-Bundle).
///
/// PNGs kommen via `tools/fetch_furniture_sprites.py` (Twemoji CC-BY 4.0).
class FurnitureSprite extends StatelessWidget {
  const FurnitureSprite({
    required this.item,
    this.size = 32,
    super.key,
  });

  final FurnitureItem item;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      item.assetPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.medium,
      errorBuilder: (_, _, _) =>
          Text(item.emoji, style: TextStyle(fontSize: size)),
    );
  }
}
