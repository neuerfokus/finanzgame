import 'package:flutter/material.dart';

import '../../core/design_tokens.dart';

/// Phase of the sleep cutscene state machine.
enum _CutscenePhase { fadeBlack, moon, sunrise, done }

/// Full-screen cutscene that plays when the player goes to sleep.
///
/// State machine: fadeBlack (800ms) → moon (1200ms) → sunrise (800ms) → done.
/// Total duration: ~2800ms.
///
/// Calls [onComplete] once the cutscene finishes. Uses [AnimationController]
/// for precise phase control — no [Timer] of any kind.
class SleepCutsceneWidget extends StatefulWidget {
  const SleepCutsceneWidget({
    required this.onComplete,
    super.key,
  });

  final VoidCallback onComplete;

  @override
  State<SleepCutsceneWidget> createState() => _SleepCutsceneWidgetState();
}

class _SleepCutsceneWidgetState extends State<SleepCutsceneWidget>
    with TickerProviderStateMixin {
  late final AnimationController _fadeBlackCtrl;
  late final AnimationController _moonCtrl;
  late final AnimationController _sunriseCtrl;

  _CutscenePhase _phase = _CutscenePhase.fadeBlack;

  @override
  void initState() {
    super.initState();

    _fadeBlackCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _moonCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _sunriseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _startCutscene();
  }

  Future<void> _startCutscene() async {
    // Phase 1 — fade to black.
    await _fadeBlackCtrl.forward();
    if (!mounted) return;

    setState(() => _phase = _CutscenePhase.moon);

    // Phase 2 — moon rotation.
    await _moonCtrl.forward();
    if (!mounted) return;

    setState(() => _phase = _CutscenePhase.sunrise);

    // Phase 3 — sunrise gradient.
    await _sunriseCtrl.forward();
    if (!mounted) return;

    setState(() => _phase = _CutscenePhase.done);
    widget.onComplete();
  }

  @override
  void dispose() {
    _fadeBlackCtrl.dispose();
    _moonCtrl.dispose();
    _sunriseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FgColors.backgroundDeep,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Phase 2 — moon visible while in moon or sunrise phase.
          if (_phase == _CutscenePhase.moon)
            Center(child: _MoonWidget(controller: _moonCtrl)),

          // Phase 3 — sunrise gradient.
          if (_phase == _CutscenePhase.sunrise)
            _SunriseWidget(controller: _sunriseCtrl),

          // Phase 1 — black overlay fades in over the starting background.
          if (_phase == _CutscenePhase.fadeBlack)
            AnimatedBuilder(
              animation: _fadeBlackCtrl,
              builder: (context, _) => Opacity(
                opacity: _fadeBlackCtrl.value,
                child: const ColoredBox(
                  color: Colors.black,
                  child: SizedBox.expand(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// White circle that rotates 360° over the moon phase.
class _MoonWidget extends StatelessWidget {
  const _MoonWidget({required this.controller});

  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) => Transform.rotate(
        angle: controller.value * 2 * 3.141592653589793,
        child: child,
      ),
      child: Container(
        width: 60,
        height: 60,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

/// Sunrise gradient that fades in over the sunrise phase.
class _SunriseWidget extends StatelessWidget {
  const _SunriseWidget({required this.controller});

  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) => Opacity(
        opacity: controller.value,
        child: child,
      ),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Color(0xFFFF8C00), // orange
              Color(0xFFFFD700), // gold
              Color(0xFF87CEEB), // sky blue
            ],
          ),
        ),
      ),
    );
  }
}
