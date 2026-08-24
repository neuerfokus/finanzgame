import 'package:flutter/services.dart';

/// Brücke zum nativen `VIEW`-Intent-Handler (MainActivity.kt). Wenn der
/// Nutzer eine `.fgsave`-Datei aus WhatsApp/Dateien/Drive mit "Öffnen" an
/// Finanzgame schickt, kopiert MainActivity den (content://-)Stream in den
/// App-Cache und liefert den Datei-Pfad hier herein:
///
/// - [getInitialImportFile] beim Kaltstart (App war nicht offen),
/// - [setHandler] für `onImportFile`, wenn die App schon lief (onNewIntent).
///
/// Auf Nicht-Android (oder ohne registrierten Handler) liefert alles `null` /
/// no-op — `MissingPluginException` wird verschluckt.
class ImportIntentChannel {
  ImportIntentChannel._();

  static const MethodChannel _channel = MethodChannel('finanzgame/import');

  /// Holt den Pfad der Datei, mit der die App kalt gestartet wurde (oder
  /// null). Verbraucht den Wert nativ-seitig (nur einmal geliefert).
  static Future<String?> getInitialImportFile() async {
    try {
      return await _channel.invokeMethod<String>('getInitialImportFile');
    } catch (_) {
      return null;
    }
  }

  /// Registriert einen Callback für Dateien, die ankommen während die App
  /// schon läuft.
  static void setHandler(void Function(String path) onFile) {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onImportFile' && call.arguments is String) {
        onFile(call.arguments as String);
      }
      return null;
    });
  }
}
