import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Wächter für `AndroidManifest.xml`.
///
/// Die Datei wird von keinem Widget-Test angefasst: Ein kaputtes Manifest
/// fällt erst in `flutter build apk` auf, nach mehreren Minuten Gradle. Genau
/// das ist am 15.09.2026 passiert — ein `--` in einem Kommentar ist in XML
/// verboten, der Manifest-Merger brach ab, und die ganze Testsuite war grün.
void main() {
  final manifest = File('android/app/src/main/AndroidManifest.xml');
  late String inhalt;

  /// Manifest ohne Kommentare. Die Berechtigungs-Prüfungen müssen darauf
  /// laufen: Der Kommentar über dem Berechtigungsblock nennt
  /// `MANAGE_EXTERNAL_STORAGE` absichtlich beim Namen, damit niemand sie
  /// versehentlich wieder einträgt. Eine Suche im Rohtext würde genau diese
  /// Erklärung für eine Deklaration halten.
  late String ohneKommentare;

  setUpAll(() {
    inhalt = manifest.readAsStringSync();
    ohneKommentare =
        inhalt.replaceAll(RegExp(r'<!--.*?-->', dotAll: true), '');
  });

  test('Manifest liegt am erwarteten Ort', () {
    expect(manifest.existsSync(), isTrue);
  });

  test('kein "--" innerhalb eines XML-Kommentars', () {
    // XML verbietet die Zeichenfolge im Kommentar-Rumpf. Der Kommentar selbst
    // wird über die Begrenzer zerlegt, damit `<!--` und `-->` nicht anschlagen.
    final kommentare = RegExp(r'<!--(.*?)-->', dotAll: true)
        .allMatches(inhalt)
        .map((m) => m.group(1)!);
    for (final rumpf in kommentare) {
      expect(
        rumpf.contains('--'),
        isFalse,
        reason: 'Kommentar enthält "--" und macht das Manifest ungültig:\n'
            '${rumpf.trim()}',
      );
    }
  });

  test('keine INTERNET-Berechtigung', () {
    // Die Zusage aus README und PRIVACY.md: Das Release-APK kann gar nicht
    // ins Netz, weil die Berechtigung fehlt.
    expect(ohneKommentare.contains('android.permission.INTERNET'), isFalse);
  });

  test('kein MANAGE_EXTERNAL_STORAGE', () {
    // Entfernt am 11.09.2026. Die Sicherung läuft über das Storage Access
    // Framework; „Zugriff auf alle Dateien" soll nicht zurückkommen.
    expect(ohneKommentare.contains('MANAGE_EXTERNAL_STORAGE'), isFalse);
  });

  test('allowBackup bleibt aus', () {
    // Googles Auto-Backup würde nach einem Reinstall eine veraltete Cloud-DB
    // einspielen und den eigenen Restore-Flow umgehen.
    expect(ohneKommentare.contains('android:allowBackup="false"'), isTrue);
  });
}
