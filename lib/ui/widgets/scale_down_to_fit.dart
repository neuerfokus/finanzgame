import 'package:flutter/widgets.dart';

/// Verkleinert den Inhalt einer festen Kachel minimal, wenn er bei großer
/// Schrift nicht mehr hineinpasst — statt mit einem RenderFlex-Overflow
/// unten herauszuragen.
///
/// Der Inhalt wird auf die volle Kachelbreite gelegt (Text bricht also
/// normal um) und darf in der Höhe natürlich wachsen; nur wenn er höher als
/// die Kachel ist, skaliert [FittedBox] alles gemeinsam herunter. Passt er,
/// bleibt die Darstellung pixelgleich.
class ScaleDownToFit extends StatelessWidget {
  const ScaleDownToFit({
    required this.child,
    this.alignment = Alignment.center,
    super.key,
  });

  final Widget child;

  /// Lage des (ggf. verkleinerten) Inhalts in der Kachel.
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (!constraints.hasBoundedWidth || !constraints.hasBoundedHeight) {
          return child;
        }
        return FittedBox(
          fit: BoxFit.scaleDown,
          alignment: alignment,
          child: SizedBox(width: constraints.maxWidth, child: child),
        );
      },
    );
  }
}
