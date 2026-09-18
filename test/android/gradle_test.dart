import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Wächter für `android/app/build.gradle.kts`.
///
/// F-Droids `check apk` lehnt den Signaturblock „Dependency metadata" ab, den
/// das Android-Gradle-Plugin sonst in jede APK schreibt (Pipeline 2857673110,
/// 17.09.2026). Kein anderer Test berührt die Gradle-Datei — fehlt der Block,
/// fällt das erst im F-Droid-Bau auf.
void main() {
  final gradle = File('android/app/build.gradle.kts');
  late String ohneKommentare;

  setUpAll(() {
    ohneKommentare = gradle
        .readAsStringSync()
        .replaceAll(RegExp(r'/\*.*?\*/', dotAll: true), '')
        .replaceAll(RegExp('//.*'), '');
  });

  test('dependenciesInfo schaltet den Metadaten-Block für APK und Bundle ab',
      () {
    final block = RegExp(r'dependenciesInfo\s*\{([^}]*)\}')
        .firstMatch(ohneKommentare);
    expect(block, isNotNull, reason: 'dependenciesInfo-Block fehlt');
    final rumpf = block!.group(1)!;
    expect(rumpf, matches(RegExp(r'includeInApk\s*=\s*false')));
    expect(rumpf, matches(RegExp(r'includeInBundle\s*=\s*false')));
  });
}
