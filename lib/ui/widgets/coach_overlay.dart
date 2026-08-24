import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../features/settings/settings_repository.dart';

/// Welle-8 Round 15: First-Steps-Coach overlay. Pro Screen einmal sichtbar.
///
/// Wrappt einen Child + zeigt halbtransparenten Hint mit Erklärung. Tap auf
/// "Verstanden" markiert den Coach via [SettingsRepository.markCoachSeen]
/// und verschwindet dauerhaft.
class CoachOverlay extends ConsumerStatefulWidget {
  const CoachOverlay({
    required this.coachId,
    required this.title,
    required this.message,
    required this.child,
    super.key,
  });

  /// Eindeutige ID dieses Coaches (z.B. 'bank', 'etf', 'krypto').
  final String coachId;
  final String title;
  final String message;
  final Widget child;

  @override
  ConsumerState<CoachOverlay> createState() => _CoachOverlayState();
}

class _CoachOverlayState extends ConsumerState<CoachOverlay> {
  bool _dismissedLocal = false;

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsRepositoryProvider);
    final repo = ref.read(settingsRepositoryProvider.notifier);
    // Welle-8 Round 15: Coach erscheint nur nach abgeschlossenem
    // Onboarding — sonst überlagert er Test-/Onboarding-Flows.
    final alreadySeen = repo.hasSeenCoach(widget.coachId);
    final show = settings.onboardingComplete &&
        !alreadySeen &&
        !_dismissedLocal;
    return Stack(
      children: [
        widget.child,
        if (show)
          Positioned.fill(
            // Welle-8 Round 17: Material-Wrapper — sonst zeigt Flutter
            // gelbe Doppel-Unterstriche unter allen Text-Widgets (default
            // Debug-Painting bei fehlendem Material-Ancestor).
            child: Material(
              type: MaterialType.transparency,
              child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {}, // Block taps to layer below.
              child: ColoredBox(
                color: const Color(0xCC000000),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(FgSpacing.xl),
                    child: Container(
                      decoration: BoxDecoration(
                        color: FgColors.backgroundElevated,
                        border: Border.all(
                          color: FgColors.primary,
                          width: 3,
                        ),
                        borderRadius:
                            BorderRadius.circular(FgRadius.card),
                      ),
                      padding: const EdgeInsets.all(FgSpacing.l),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text('💡',
                                  style: TextStyle(fontSize: 32)),
                              const SizedBox(width: FgSpacing.s),
                              Expanded(
                                child: Text(
                                  widget.title,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: FgColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: FgSpacing.m),
                          Text(
                            widget.message,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: FgSpacing.l),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: FgColors.success,
                                foregroundColor: FgColors.onSurface,
                              ),
                              onPressed: () {
                                ref
                                    .read(settingsRepositoryProvider
                                        .notifier)
                                    .markCoachSeen(widget.coachId);
                                setState(() => _dismissedLocal = true);
                              },
                              child: const Text('Verstanden ✓'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            ),
          ),
      ],
    );
  }
}
