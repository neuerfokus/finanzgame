package com.finanzgame.finanzgame

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import androidx.documentfile.provider.DocumentFile
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.util.concurrent.Executors

/// Zwei native Brücken:
///
/// 1. `finanzgame/import` — empfängt `.fgsave`-Dateien, die der Nutzer aus
///    WhatsApp/Dateien/Drive mit "Öffnen" an Finanzgame schickt (ACTION_VIEW).
///    Die Datei kommt meist als `content://`-URI — wir kopieren den Stream
///    einmal in den App-Cache und reichen den lokalen Pfad herein.
///
/// 2. `finanzgame/saf` — Storage Access Framework für die Auto-Sicherung.
///    Der Nutzer wählt EINMAL per System-Picker einen Ordner (z.B. Downloads);
///    wir nehmen eine persistente URI-Berechtigung und schreiben/lesen die
///    `autosave.fgsave` dort hinein. Vorteil gegenüber MANAGE_EXTERNAL_STORAGE:
///    keine heikle „Zugriff auf alle Dateien"-Sonderberechtigung nötig, und der
///    Ordner liegt außerhalb des App-Sandbox → überlebt Deinstall.
class MainActivity : FlutterActivity() {
    private val importChannelName = "finanzgame/import"
    private val safChannelName = "finanzgame/saf"
    private val openTreeRequestCode = 0xF6A5

    private var pendingImportPath: String? = null
    private var importChannel: MethodChannel? = null
    private var pendingFolderResult: MethodChannel.Result? = null

    // SAF-I/O läuft NICHT auf dem Main-Thread: dir.findFile() iteriert per
    // ContentProvider-Query über alle Ordner-Einträge, danach Multi-MB-Write —
    // das feuert nach jedem Schlafen/Zeitsprung und wäre sonst ANR-Risiko.
    private val ioExecutor = Executors.newSingleThreadExecutor()
    private val mainHandler = Handler(Looper.getMainLooper())

    private fun <T> runOnIo(result: MethodChannel.Result, block: () -> T?) {
        ioExecutor.execute {
            val value = try {
                block()
            } catch (e: Exception) {
                null
            }
            mainHandler.post { result.success(value) }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Kaltstart: App wurde durch das Öffnen der Datei erst gestartet.
        pendingImportPath = extractImportPath(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        val path = extractImportPath(intent)
        if (path != null) {
            // App lief bereits → direkt nach Flutter pushen.
            val ch = importChannel
            if (ch != null) {
                ch.invokeMethod("onImportFile", path)
            } else {
                pendingImportPath = path
            }
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val messenger = flutterEngine.dartExecutor.binaryMessenger

        val imp = MethodChannel(messenger, importChannelName)
        importChannel = imp
        imp.setMethodCallHandler { call, result ->
            when (call.method) {
                "getInitialImportFile" -> {
                    result.success(pendingImportPath)
                    pendingImportPath = null
                }
                else -> result.notImplemented()
            }
        }

        val saf = MethodChannel(messenger, safChannelName)
        saf.setMethodCallHandler { call, result ->
            when (call.method) {
                "pickBackupFolder" -> pickBackupFolder(result)
                "hasFolderAccess" -> {
                    val uri = call.argument<String>("treeUri")
                    result.success(uri != null && hasFolderAccess(uri))
                }
                "writeBackup" -> {
                    val uri = call.argument<String>("treeUri")
                    val name = call.argument<String>("fileName")
                    val bytes = call.argument<ByteArray>("bytes")
                    if (uri == null || name == null || bytes == null) {
                        result.success(false)
                    } else {
                        runOnIo(result) { writeBackup(uri, name, bytes) }
                    }
                }
                "readBackup" -> {
                    val uri = call.argument<String>("treeUri")
                    val name = call.argument<String>("fileName")
                    if (uri == null || name == null) {
                        result.success(null)
                    } else {
                        runOnIo(result) { readBackup(uri, name) }
                    }
                }
                "backupInfo" -> {
                    val uri = call.argument<String>("treeUri")
                    val name = call.argument<String>("fileName")
                    if (uri == null || name == null) {
                        result.success(null)
                    } else {
                        runOnIo(result) { backupInfo(uri, name) }
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    // -------------------------------------------------------------------------
    // SAF: Ordnerwahl + persistente Berechtigung
    // -------------------------------------------------------------------------

    private fun pickBackupFolder(result: MethodChannel.Result) {
        // Doppel-Aufruf abräumen (Nutzer tippt zweimal): alten Result schließen.
        val prev = pendingFolderResult
        pendingFolderResult = result
        if (prev != null) {
            try {
                prev.success(null)
            } catch (_: Exception) { /* schon geliefert */ }
        }
        try {
            val intent = Intent(Intent.ACTION_OPEN_DOCUMENT_TREE).apply {
                addFlags(
                    Intent.FLAG_GRANT_READ_URI_PERMISSION or
                        Intent.FLAG_GRANT_WRITE_URI_PERMISSION or
                        Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION,
                )
            }
            startActivityForResult(intent, openTreeRequestCode)
        } catch (e: Exception) {
            pendingFolderResult = null
            result.success(null)
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode != openTreeRequestCode) return
        val res = pendingFolderResult ?: return
        pendingFolderResult = null
        val uri = if (resultCode == Activity.RESULT_OK) data?.data else null
        if (uri != null) {
            try {
                val flags = Intent.FLAG_GRANT_READ_URI_PERMISSION or
                    Intent.FLAG_GRANT_WRITE_URI_PERMISSION
                contentResolver.takePersistableUriPermission(uri, flags)
            } catch (_: Exception) { /* trotzdem URI zurückgeben */ }
            res.success(uri.toString())
        } else {
            res.success(null)
        }
    }

    private fun hasFolderAccess(treeUri: String): Boolean {
        return try {
            val uri = Uri.parse(treeUri)
            contentResolver.persistedUriPermissions.any {
                it.uri == uri && it.isReadPermission && it.isWritePermission
            }
        } catch (e: Exception) {
            false
        }
    }

    // -------------------------------------------------------------------------
    // SAF: Datei schreiben / lesen / Info
    // -------------------------------------------------------------------------

    private fun treeDir(treeUri: String): DocumentFile? {
        return try {
            DocumentFile.fromTreeUri(this, Uri.parse(treeUri))
        } catch (e: Exception) {
            null
        }
    }

    private fun writeBackup(treeUri: String, fileName: String, bytes: ByteArray): Boolean {
        return try {
            val dir = treeDir(treeUri) ?: return false
            // Reihenfolge: neue Datei VOLLSTAENDIG als .tmp schreiben, die
            // alte als .old zur Seite schieben, dann tauschen, dann die .old
            // wegraeumen. Zu jedem Zeitpunkt existiert mindestens eine
            // vollstaendige Sicherung -- Prozess-Kill mid-write (Kind swiped
            // die App nach dem Zeitsprung weg) kann keine truncaten und keine
            // loeschen. `readBackup` findet die Reste ueber `findBackupFile`.
            val tmpName = "$fileName.tmp"
            dir.findFile(tmpName)?.delete()
            val tmp = dir.createFile("application/octet-stream", tmpName)
                ?: return false
            val wrote = contentResolver.openOutputStream(tmp.uri, "wt")?.use { out ->
                out.write(bytes)
                out.flush()
                true
            } ?: false
            if (!wrote) {
                tmp.delete()
                return false
            }
            // Die alte Sicherung wird zur Seite GESCHOBEN, nicht geloescht.
            // Vorher stand hier `dir.findFile(fileName)?.delete()` direkt vor
            // dem rename: schlug danach irgendetwas fehl, war die einzige
            // Deinstall-ueberlebende Sicherung weg -- und weil `tmp.delete()`
            // auch im Fehlerfall lief, blieb nicht einmal die Zwischendatei.
            // Der Kommentar oben behauptete "atomar wie der Legacy-Pfad";
            // der Legacy-Pfad loescht sein Ziel gerade NICHT.
            val altName = "$fileName.old"
            dir.findFile(altName)?.delete()
            val alt = dir.findFile(fileName)
            val altGesichert = alt == null || alt.renameTo(altName)
            if (!altGesichert) {
                // Laesst sich die alte nicht wegbenennen, wird sie auch nicht
                // angefasst: lieber diese eine Sicherung auslassen als die
                // vorhandene gute gegen eine ungewisse neue tauschen.
                tmp.delete()
                return false
            }
            if (tmp.renameTo(fileName)) {
                dir.findFile(altName)?.delete()
                return true
            }
            // Provider ohne rename-Support: Ziel neu anlegen + Bytes kopieren.
            val target = dir.createFile("application/octet-stream", fileName)
            val copied = target != null &&
                (contentResolver.openOutputStream(target.uri, "wt")?.use { out ->
                    out.write(bytes)
                    out.flush()
                    true
                } ?: false)
            if (copied) {
                dir.findFile(altName)?.delete()
                tmp.delete()
                return true
            }
            // Fehlgeschlagen: erst den halben Versuch wegraeumen, dann die
            // alte Sicherung zurueckholen. Sie ist ab hier wieder die gueltige.
            target?.delete()
            dir.findFile(altName)?.renameTo(fileName)
            tmp.delete()
            false
        } catch (e: Exception) {
            false
        }
    }

    /// Sucht die Sicherung unter dem kanonischen Namen -- und faellt auf die
    /// Reste eines abgebrochenen Schreibvorgangs zurueck (`.old` = die vorige
    /// gueltige Sicherung, `.tmp` = die fertig geschriebene neue). Wird der
    /// Prozess mitten im Tausch beendet, liegt genau eine davon da; ohne
    /// diesen Rueckfall waere sie unauffindbar, obwohl sie vollstaendig ist.
    private fun findBackupFile(dir: DocumentFile, fileName: String): DocumentFile? {
        for (name in listOf(fileName, "$fileName.tmp", "$fileName.old")) {
            val f = dir.findFile(name)
            if (f != null && f.exists() && f.length() > 0) return f
        }
        return null
    }

    private fun readBackup(treeUri: String, fileName: String): ByteArray? {
        return try {
            val dir = treeDir(treeUri) ?: return null
            val file = findBackupFile(dir, fileName) ?: return null
            contentResolver.openInputStream(file.uri)?.use { it.readBytes() }
        } catch (e: Exception) {
            null
        }
    }

    private fun backupInfo(treeUri: String, fileName: String): Map<String, Any>? {
        return try {
            val dir = treeDir(treeUri) ?: return null
            val file = findBackupFile(dir, fileName) ?: return null
            mapOf("modified" to file.lastModified(), "size" to file.length())
        } catch (e: Exception) {
            null
        }
    }

    // -------------------------------------------------------------------------
    // Datei-Öffnen-Intent (WhatsApp → "Öffnen")
    // -------------------------------------------------------------------------

    /// Holt aus einem ACTION_VIEW-Intent die Daten-URI, kopiert den Inhalt in
    /// eine Cache-Datei + liefert deren absoluten Pfad. null wenn kein
    /// passender Intent / nicht lesbar.
    private fun extractImportPath(intent: Intent?): String? {
        if (intent == null || intent.action != Intent.ACTION_VIEW) return null
        val uri: Uri = intent.data ?: return null
        return try {
            // Alte Import-Kopien aufräumen — sonst akkumuliert jeder
            // "Öffnen mit"-Vorgang eine Datei im Cache.
            cacheDir.listFiles { f ->
                f.name.startsWith("incoming_") && f.name.endsWith(".fgsave")
            }?.forEach { it.delete() }
            val outFile = File(cacheDir, "incoming_${System.currentTimeMillis()}.fgsave")
            contentResolver.openInputStream(uri)?.use { input ->
                outFile.outputStream().use { output -> input.copyTo(output) }
            } ?: return null
            outFile.absolutePath
        } catch (e: Exception) {
            null
        }
    }
}
