import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../domain/age/parent_gate_challenge.dart';
import '../../ui/widgets/fg_snack.dart';
import '../../ui/widgets/pixel_button.dart';
import 'settings_repository.dart';

/// Elternschranke per Rechenaufgabe.
///
/// **Warum zusätzlich zum bestehenden [ParentGate] (PIN):** der PIN schützt
/// den „Gefährlichen Bereich" und die Echte-Leben-Belohnungen — er setzt aber
/// voraus, dass ein Elternteil ihn eingerichtet hat. Vor einem Weg aus der App
/// zu einem Zahlungsanbieter muss die Schranke auch dann greifen, wenn nie
/// jemand etwas eingerichtet hat. Deshalb eine Aufgabe, die ohne Einrichtung
/// funktioniert.
///
/// Der Anspruch ist ausdrücklich NICHT Sicherheit: ein entschlossener
/// 14-Jähriger rechnet 17 × 14. Es geht um eine bewusste Hürde, die ein
/// beiläufiges Antippen ausschließt — plus die sichtbare Erstattungszusage
/// darunter für den Rest.
///
/// Liefert `true`, wenn die Aufgabe gelöst wurde.
Future<bool> showParentMathGate(
  BuildContext context,
  WidgetRef ref, {
  required String purpose,
}) async {
  final repo = ref.read(settingsRepositoryProvider.notifier);
  final nowMs = DateTime.now().millisecondsSinceEpoch;
  final lockedUntil = ref.read(settingsRepositoryProvider).parentGateLockedUntilMs;

  if (ParentGateLockout.isLocked(lockedUntil, nowMs)) {
    final secs = ParentGateLockout.remainingSeconds(lockedUntil, nowMs);
    showFgSnack(
      context,
      'Zu viele Fehlversuche. Bitte in $secs Sekunden nochmal.',
      isError: true,
    );
    return false;
  }

  final passed = await showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (_) => _ParentMathGateDialog(
          purpose: purpose,
          onLockout: () => repo.setParentGateLockedUntil(
            ParentGateLockout.lockedUntilMsFrom(
              DateTime.now().millisecondsSinceEpoch,
            ),
          ),
        ),
      ) ??
      false;
  return passed;
}

class _ParentMathGateDialog extends StatefulWidget {
  const _ParentMathGateDialog({
    required this.purpose,
    required this.onLockout,
  });

  final String purpose;
  final VoidCallback onLockout;

  @override
  State<_ParentMathGateDialog> createState() => _ParentMathGateDialogState();
}

class _ParentMathGateDialogState extends State<_ParentMathGateDialog> {
  // Bei JEDEM Öffnen neu — sonst lernt man nach dem zweiten Mal die Antwort
  // auswendig statt sie zu rechnen. `Random.secure()`, weil die Aufgabe eine
  // Schranke ist und keine Spielmechanik — sie soll nicht vorhersagbar sein.
  late final ParentGateChallenge _challenge = ParentGateChallenge.generate(
    math.Random.secure(),
  );
  final _ctrl = TextEditingController();
  int _attemptsLeft = ParentGateLockout.maxAttempts;
  String? _error;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_challenge.accepts(_ctrl.text)) {
      Navigator.of(context).pop(true);
      return;
    }
    setState(() {
      _attemptsLeft -= 1;
      _ctrl.clear();
      _error = _attemptsLeft > 0
          ? 'Stimmt nicht. Noch $_attemptsLeft Versuch'
              '${_attemptsLeft == 1 ? '' : 'e'}.'
          : null;
    });
    if (_attemptsLeft <= 0) {
      widget.onLockout();
      Navigator.of(context).pop(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: FgColors.backgroundElevated,
      title: const Text('Nur für Erwachsene', style: FgTypography.bodyL),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bitte gib das Gerät einem Erwachsenen.\n\n${widget.purpose}',
            style: FgTypography.bodyM,
          ),
          const SizedBox(height: FgSpacing.m),
          Text('Wie viel ist $_challenge?', style: FgTypography.bodyL),
          const SizedBox(height: FgSpacing.s),
          TextField(
            controller: _ctrl,
            autofocus: true,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: FgTypography.bodyM,
            decoration: const InputDecoration(
              isDense: true,
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) => _submit(),
          ),
          if (_error != null) ...[
            const SizedBox(height: FgSpacing.xs),
            Text(
              _error!,
              style: FgTypography.bodyS.copyWith(color: FgColors.alert),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Abbrechen', style: FgTypography.bodyM),
        ),
        PixelButton(
          label: 'Weiter',
          background: FgColors.primary,
          foreground: FgColors.onPrimary,
          onPressed: _submit,
        ),
      ],
    );
  }
}
