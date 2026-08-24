import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../domain/age/age_state.dart';
import '../../ui/widgets/pixel_button.dart';
import 'settings_repository.dart';

/// Neutrale Geburtsjahr-Abfrage.
///
/// **Die Gestaltung ist hier keine Geschmacksfrage.** Google verlangt für
/// Apps mit Kindern in der Zielgruppe eine „neutrale Altersabfrage": sie darf
/// nicht verraten, was von der Antwort abhängt, und keine Antwort attraktiver
/// aussehen lassen. Deshalb steht hier nur die Frage nach dem Jahr — kein
/// „Bist du über 18?", kein Hinweis auf gesperrte Inhalte, und nach der
/// Eingabe auch keine Rückmeldung wie „dafür bist du zu jung". Es geht
/// kommentarlos weiter.
///
/// Überspringen ist ausdrücklich erlaubt: das Spiel darf niemals hinter dieser
/// Frage eingesperrt sein. Wer überspringt, bleibt `unknown` — dann fehlt
/// lediglich der Unterstützen-Bereich, von dem er ohnehin nie erfahren hat.
Future<void> showBirthYearPrompt(
  BuildContext context,
  WidgetRef ref, {
  bool markAskedOnSkip = true,
}) async {
  final year = await showDialog<int>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const _BirthYearDialog(),
  );
  if (year != null) {
    ref.read(settingsRepositoryProvider.notifier).setBirthYear(
          year,
          currentYear: DateTime.now().year,
        );
  } else if (markAskedOnSkip) {
    ref.read(settingsRepositoryProvider.notifier).markBirthYearAsked();
  }
}

class _BirthYearDialog extends StatefulWidget {
  const _BirthYearDialog();

  @override
  State<_BirthYearDialog> createState() => _BirthYearDialogState();
}

class _BirthYearDialogState extends State<_BirthYearDialog> {
  final _ctrl = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _submit() {
    final currentYear = DateTime.now().year;
    final parsed = int.tryParse(_ctrl.text.trim());
    if (parsed == null ||
        !isPlausibleBirthYear(parsed, currentYear: currentYear)) {
      // Rein formale Rückmeldung — sie verrät nichts über Folgen, sondern
      // sagt nur, dass die Zahl kein Jahr sein kann.
      setState(() => _error = 'Bitte eine Jahreszahl zwischen '
          '${minPlausibleBirthYear(currentYear)} und $currentYear eingeben.');
      return;
    }
    Navigator.of(context).pop(parsed);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: FgColors.backgroundElevated,
      title: const Text('Kurze Frage', style: FgTypography.bodyL),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'In welchem Jahr bist du geboren?',
            style: FgTypography.bodyM,
          ),
          const SizedBox(height: FgSpacing.s),
          TextField(
            controller: _ctrl,
            autofocus: true,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(4),
            ],
            style: FgTypography.bodyM,
            decoration: const InputDecoration(
              isDense: true,
              hintText: 'z. B. 1985',
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
          const SizedBox(height: FgSpacing.s),
          const Text(
            'Bleibt auf diesem Gerät. Wird nicht verschickt.',
            style: FgTypography.bodyS,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Überspringen', style: FgTypography.bodyM),
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
