import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/design_tokens.dart';
import '../../ui/widgets/phone_frame.dart';
import '../../ui/widgets/pixel_button.dart';
import '../../ui/widgets/pixel_panel.dart';

/// Über- und Lizenzseite (spec-46).
///
/// Zwei Gründe für diese Seite, einer davon zwingend:
///
/// 1. **Pflicht.** Die Möbel-Sprites sind Twemoji unter CC-BY 4.0. Diese
///    Lizenz verlangt eine sichtbare Namensnennung — ohne sie darf die App
///    nicht verteilt werden, weder im Store noch bei F-Droid.
/// 2. Kür: Kenney-Assets sind CC0 und bräuchten keine Nennung. Wir nennen
///    sie trotzdem — ohne diese Sammlung gäbe es das Spiel nicht.
///
/// Wer ein Asset ergänzt, trägt es in `ASSETS.md` ein und — falls
/// attributionspflichtig — zusätzlich hier. `about_page_test.dart` hält die
/// Pflicht-Nennungen fest.
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PhoneFrame(
      appName: 'Über & Lizenzen',
      onBack: () => Navigator.of(context).pop(),
      child: const SingleChildScrollView(
        padding: EdgeInsets.all(FgSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _AppBlock(),
            SizedBox(height: FgSpacing.m),
            _LicenseBlock(),
            SizedBox(height: FgSpacing.m),
            _CreditsBlock(),
            SizedBox(height: FgSpacing.m),
            _DisclaimerBlock(),
            SizedBox(height: FgSpacing.m),
            _PackageLicensesButton(),
            SizedBox(height: FgSpacing.l),
          ],
        ),
      ),
    );
  }
}

class _AppBlock extends StatelessWidget {
  const _AppBlock();

  @override
  Widget build(BuildContext context) {
    return PixelPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Finanzgame', style: FgTypography.bodyL),
          const SizedBox(height: FgSpacing.xs),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (ctx, snap) {
              final v = snap.data;
              return Text(
                v == null ? 'Version lädt …' : 'Version ${v.version}+${v.buildNumber}',
                style: FgTypography.bodyS,
              );
            },
          ),
          const SizedBox(height: FgSpacing.s),
          const Text(
            'Ein Lernspiel über Geld: sparen, anlegen, Geduld. '
            'Alles im Spiel ist erfunden — keine echten Marken, keine '
            'echten Aktien, kein echtes Geld.',
            style: FgTypography.bodyS,
          ),
        ],
      ),
    );
  }
}

class _LicenseBlock extends StatelessWidget {
  const _LicenseBlock();

  @override
  Widget build(BuildContext context) {
    return const PixelPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Lizenz', style: FgTypography.bodyM),
          SizedBox(height: FgSpacing.xs),
          Text(
            'Finanzgame ist freie Software: Quelltext unter der '
            'GNU General Public License, Version 3 oder später. '
            'Du darfst die App weitergeben und verändern — wer sie '
            'weitergibt, muss den Quelltext mitgeben.',
            style: FgTypography.bodyS,
          ),
          SizedBox(height: FgSpacing.xs),
          Text(
            'Die eigenen Inhalte (Quests, Glossar, App-Icon) stehen unter '
            'CC-BY-SA 4.0.',
            style: FgTypography.bodyS,
          ),
          SizedBox(height: FgSpacing.xs),
          Text(
            'Es gibt keine Garantie, soweit das Gesetz es zulässt.',
            style: FgTypography.bodyS,
          ),
        ],
      ),
    );
  }
}

class _CreditsBlock extends StatelessWidget {
  const _CreditsBlock();

  @override
  Widget build(BuildContext context) {
    return const PixelPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Verwendete Werke', style: FgTypography.bodyM),
          SizedBox(height: FgSpacing.xs),
          // CC-BY 4.0 — Namensnennung ist hier Lizenzbedingung, nicht Kür.
          Text(
            '• Möbel-Symbole: Twemoji von Twitter, Inc. und Mitwirkenden, '
            'lizenziert unter CC-BY 4.0.',
            style: FgTypography.bodyS,
          ),
          SizedBox(height: FgSpacing.xs),
          Text(
            '• Grafik, Schriften, Geräusche und Musik: Kenney (kenney.nl), '
            'gemeinfrei unter CC0.',
            style: FgTypography.bodyS,
          ),
          SizedBox(height: FgSpacing.xs),
          Text(
            '• Gebaut mit Flutter und Dart.',
            style: FgTypography.bodyS,
          ),
        ],
      ),
    );
  }
}

class _DisclaimerBlock extends StatelessWidget {
  const _DisclaimerBlock();

  @override
  Widget build(BuildContext context) {
    return const PixelPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Wichtig', style: FgTypography.bodyM),
          SizedBox(height: FgSpacing.xs),
          Text(
            'Finanzgame ist eine Simulation zum Lernen und keine '
            'Anlageberatung. Kurse, Firmen und Renditen im Spiel sind '
            'erfunden. Echtes Geld verhält sich anders.',
            style: FgTypography.bodyS,
          ),
          SizedBox(height: FgSpacing.xs),
          Text(
            'Die App speichert alles nur auf diesem Gerät. Sie sendet nichts '
            'ins Internet und sammelt keine Daten über dich.',
            style: FgTypography.bodyS,
          ),
        ],
      ),
    );
  }
}

class _PackageLicensesButton extends StatelessWidget {
  const _PackageLicensesButton();

  @override
  Widget build(BuildContext context) {
    return PixelButton(
      label: '📜 Lizenzen der Bausteine',
      semanticLabel: 'Lizenzen der verwendeten Programm-Bausteine',
      background: FgColors.backgroundElevated,
      foreground: FgColors.onSurface,
      onPressed: () => showLicensePage(
        context: context,
        applicationName: 'Finanzgame',
        applicationLegalese: 'GPL-3.0-or-later · Inhalte CC-BY-SA-4.0',
      ),
    );
  }
}
