import 'package:flutter/material.dart';

import '../../domain/sim/day_summary.dart';
import 'day_summary_screen.dart';
import 'sleep_cutscene_widget.dart';

enum _FlowPhase { cutscene, summary }

/// Orchestrates [SleepCutsceneWidget] → [DaySummaryScreen] → [onDone].
///
/// Rendered by [SchlafenButton] as a full-screen dialog route.
class SleepFlow extends StatefulWidget {
  const SleepFlow({
    required this.summary,
    required this.onDone,
    super.key,
  });

  final DaySummary summary;
  final VoidCallback onDone;

  @override
  State<SleepFlow> createState() => _SleepFlowState();
}

class _SleepFlowState extends State<SleepFlow> {
  _FlowPhase _phase = _FlowPhase.cutscene;

  void _onCutsceneComplete() {
    if (!mounted) return;
    setState(() => _phase = _FlowPhase.summary);
  }

  @override
  Widget build(BuildContext context) {
    return switch (_phase) {
      _FlowPhase.cutscene => SleepCutsceneWidget(
          onComplete: _onCutsceneComplete,
        ),
      _FlowPhase.summary => DaySummaryScreen(
          summary: widget.summary,
          onContinue: widget.onDone,
        ),
    };
  }
}
