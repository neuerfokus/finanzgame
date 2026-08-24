import 'package:flutter/services.dart';

/// Brücke zum nativen Storage-Access-Framework-Handler (MainActivity.kt,
/// Channel `finanzgame/saf`). Der Nutzer wählt EINMAL einen Backup-Ordner
/// (System-Picker), wir nehmen eine persistente URI-Berechtigung und
/// schreiben/lesen die `autosave.fgsave` dort — ohne die heikle
/// MANAGE_EXTERNAL_STORAGE-Berechtigung, und der Ordner überlebt Deinstall.
///
/// Auf Nicht-Android (oder ohne registrierten Handler) liefert alles `null` /
/// `false` — `MissingPluginException` wird verschluckt.
class SafBackupChannel {
  SafBackupChannel._();

  static const MethodChannel _channel = MethodChannel('finanzgame/saf');

  /// Öffnet den System-Ordner-Picker. Liefert die persistierte Tree-URI als
  /// String oder `null` bei Abbruch/Fehler.
  static Future<String?> pickFolder() async {
    try {
      return await _channel.invokeMethod<String>('pickBackupFolder');
    } catch (_) {
      return null;
    }
  }

  /// True wenn die App weiterhin (persistente) Lese+Schreib-Rechte auf
  /// [treeUri] hat (nach Deinstall sind sie weg → false).
  static Future<bool> hasAccess(String treeUri) async {
    try {
      return await _channel.invokeMethod<bool>(
            'hasFolderAccess',
            {'treeUri': treeUri},
          ) ??
          false;
    } catch (_) {
      return false;
    }
  }

  /// Schreibt [bytes] als [fileName] in den Ordner [treeUri] (überschreibt).
  static Future<bool> write(
    String treeUri,
    String fileName,
    Uint8List bytes,
  ) async {
    try {
      return await _channel.invokeMethod<bool>('writeBackup', {
            'treeUri': treeUri,
            'fileName': fileName,
            'bytes': bytes,
          }) ??
          false;
    } catch (_) {
      return false;
    }
  }

  /// Liest [fileName] aus [treeUri]. `null` wenn nicht vorhanden/lesbar.
  static Future<Uint8List?> read(String treeUri, String fileName) async {
    try {
      return await _channel.invokeMethod<Uint8List>('readBackup', {
        'treeUri': treeUri,
        'fileName': fileName,
      });
    } catch (_) {
      return null;
    }
  }

  /// Liefert (modified-Epoch-ms, size-Bytes) der Datei oder `null`.
  static Future<({int modified, int size})?> info(
    String treeUri,
    String fileName,
  ) async {
    try {
      final m = await _channel.invokeMapMethod<String, dynamic>('backupInfo', {
        'treeUri': treeUri,
        'fileName': fileName,
      });
      if (m == null) return null;
      return (
        modified: (m['modified'] as num).toInt(),
        size: (m['size'] as num).toInt(),
      );
    } catch (_) {
      return null;
    }
  }
}
