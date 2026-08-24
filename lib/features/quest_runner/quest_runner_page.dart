import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../domain/quest/quest.dart';
import '../../ui/widgets/chat_bubble.dart';
import '../../ui/widgets/compound_chart.dart';
import '../../ui/widgets/confetti.dart';
import '../../ui/widgets/phone_frame.dart';
import '../../ui/widgets/pixel_button.dart';
import 'quest_runner_controller.dart';
import 'quest_runner_state.dart';

class QuestRunnerPage extends ConsumerStatefulWidget {
  const QuestRunnerPage({required this.quest, super.key});

  final Quest quest;

  @override
  ConsumerState<QuestRunnerPage> createState() => _QuestRunnerPageState();
}

class _QuestRunnerPageState extends ConsumerState<QuestRunnerPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Lazy chat-history hydration. Runs once per page push; subsequent
    // pushes hit the keep-alive controller's cached chat list.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref
          .read(questRunnerControllerProvider(widget.quest).notifier)
          .hydrateChatHistory();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = questRunnerControllerProvider(widget.quest);
    final state = ref.watch(ctrl);
    final notifier = ref.read(ctrl.notifier);

    _scrollToBottom();

    return PhoneFrame(
      appName: widget.quest.title,
      onBack: () => Navigator.of(context).pop(),
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(FgSpacing.l),
                  itemCount: state.chat.length,
                  itemBuilder: (_, i) => ChatBubble(entry: state.chat[i]),
                ),
              ),
              _ActionRow(
                state: state,
                onAdvance: notifier.advance,
                onQuiz: notifier.answerQuiz,
                onChoice: notifier.pickChoice,
                onDone: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          if (state.finished)
            Positioned.fill(
              child: ConfettiBurst(seed: widget.quest.id.hashCode),
            ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.state,
    required this.onAdvance,
    required this.onQuiz,
    required this.onChoice,
    required this.onDone,
  });

  final QuestRunnerState state;
  final VoidCallback onAdvance;
  final void Function(String) onQuiz;
  final void Function(String) onChoice;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final s = state;
    if (s.finished) {
      return Padding(
        padding: const EdgeInsets.all(FgSpacing.l),
        child: PixelButton(label: 'Fertig', onPressed: onDone),
      );
    }

    if (s.dialog != null) {
      return Padding(
        padding: const EdgeInsets.all(FgSpacing.l),
        child: PixelButton(label: 'Weiter →', onPressed: onAdvance),
      );
    }

    final step = s.quest.steps[s.stepIndex];
    return switch (step) {
      QuizStep(:final options, :final question) ||
      ChoiceStep(:final options, prompt: final question) =>
        // Welle-8 Round 15: Scroll-Wrapper damit Chart + Buttons bei
        // kleinen Phones nicht abgeschnitten werden.
        SingleChildScrollView(
          padding: const EdgeInsets.all(FgSpacing.l),
          child: Column(
            children: [
              // Spec-42 Welle-6: bei Zinseszins-bezogenen Fragen das
              // Vergleichs-Chart über den Antwort-Buttons einblenden.
              if (_isCompoundQuestion(question)) ...[
                const CompoundChart(height: 160),
                const SizedBox(height: FgSpacing.m),
              ],
              for (final o in _shuffleOptions(
                options,
                s.quest.id,
                s.stepIndex,
              )) ...[
                SizedBox(
                  width: double.infinity,
                  child: PixelButton(
                    label: o.label,
                    onPressed: () => step is QuizStep
                        ? onQuiz(o.id)
                        : onChoice(o.id),
                  ),
                ),
                const SizedBox(height: FgSpacing.s),
              ],
            ],
          ),
        ),
      _ => const SizedBox.shrink(),
    };
  }

  /// Spec-42 Welle-6: Heuristik — Frage zeigt Compound-Chart wenn Begriffe
  /// auf Zinseszins-Thema deuten.
  bool _isCompoundQuestion(String text) {
    final t = text.toLowerCase();
    return t.contains('zinseszins') ||
        t.contains('zinses') ||
        t.contains('compound');
  }

  List<QuestOption> _shuffleOptions(
    List<QuestOption> raw,
    String questId,
    int stepIndex,
  ) {
    final seed = questId.hashCode ^ (stepIndex * 977 + 13);
    final shuffled = [...raw];
    shuffled.shuffle(math.Random(seed));
    return shuffled;
  }
}
