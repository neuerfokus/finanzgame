import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../core/game_clock.dart';
import '../../domain/economy/money.dart';
import '../../domain/sim/job_level.dart';
import '../../domain/sim/weather.dart';
import '../../ui/widgets/app_icon.dart';
import '../weather/weather_state.dart';
import '../audio/sound_service.dart';
import '../bank/bank_page.dart';
import '../bank/savings_repository.dart';
import '../daily_quiz/daily_quiz_page.dart';
import '../daily_quiz/daily_quiz_state.dart';
import '../economy/cash_state.dart';
import '../glossar/glossar_page.dart';
import '../job_action/job_action_repository.dart';
import '../newgame/new_game_state.dart';
import '../news/news_ticker.dart';
import '../stats/stats_page.dart';
import '../vorsorge/vorsorge_page.dart';
import '../xp/level_titles.dart';
import '../xp/xp_repository.dart';
import '../../ui/widgets/fg_snack.dart';
import '../../ui/widgets/money_header.dart';
import '../../ui/widgets/phone_frame.dart';
import '../../ui/widgets/pixel_button.dart';
import '../highscore/highscore_page.dart';
import '../history/zeitreise_page.dart';
import '../monetaria/monetaria_page.dart';
import '../../data/quest/quest_asset_repository.dart';
import '../quest_runner/quest_list_page.dart';
import '../quest_runner/quest_progress_repository.dart';
import '../quest_runner/quest_runner_page.dart';
import '../real_life/real_life_page.dart';
import '../settings/berichte_page.dart';
import '../settings/settings_page.dart';
import '../settings/settings_repository.dart';
import '../settings/streak_calendar_page.dart';
import '../sleep/fast_forward_flow.dart';
import '../sleep/sleep_flow.dart';
import '../daily_goal/daily_goal.dart';
import '../zimmer/achievements.dart';
import '../zimmer/achievements_repository.dart';
import '../../ui/widgets/confetti.dart';
import '../zimmer/zimmer_page.dart';

/// Phone home-screen. App grid + cash header + Schlafen action.
///
/// Spec-21: Bank + Zimmer routes wired; XP + Savings read from their repos.
class SpringboardPage extends ConsumerStatefulWidget {
  const SpringboardPage({super.key});

  @override
  ConsumerState<SpringboardPage> createState() => _SpringboardPageState();
}

class _SpringboardPageState extends ConsumerState<SpringboardPage> {
  bool _advancing = false;
  bool _quizPushScheduled = false;
  bool _tutorialPushScheduled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _maybeShowTutorial();
      _maybeShowQuiz();
    });
  }

  void _maybeShowTutorial() {
    if (!mounted || _tutorialPushScheduled) return;
    final progress = ref.read(questProgressRepositoryProvider);
    final tut = progress['q00_tutorial'];
    if (tut != null) return; // schon gestartet oder fertig
    _tutorialPushScheduled = true;
    // Quest async laden + dann Runner pushen.
    ref.read(questsProvider.future).then((quests) {
      if (!mounted) return;
      final q = quests.where((q) => q.id == 'q00_tutorial').firstOrNull;
      if (q == null) return;
      Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          fullscreenDialog: true,
          builder: (_) => QuestRunnerPage(quest: q),
        ),
      );
    });
  }

  void _maybeShowQuiz() {
    if (!mounted || _quizPushScheduled) return;
    final day = ref.read(gameClockProvider).dayIndex;
    final shouldShow =
        ref.read(dailyQuizStateProvider.notifier).shouldShow(day);
    if (!shouldShow) return;
    _quizPushScheduled = true;
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => const DailyQuizPage(),
      ),
    );
  }

  void _openQuiz() {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => const DailyQuizPage(),
      ),
    );
  }

  Future<void> _onSchlafen() async {
    if (_advancing) return;
    setState(() => _advancing = true);
    SoundService.instance.playSfx(AudioKey.sleep);
    try {
      final summary = await ref.read(gameClockProvider.notifier).advanceDay();
      if (!mounted) return;
      await Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          fullscreenDialog: true,
          builder: (_) => SleepFlow(
            summary: summary,
            onDone: () => Navigator.of(context).pop(),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _advancing = false);
    }
  }

  Future<void> _openFastForward() async {
    if (_advancing) return;
    setState(() => _advancing = true);
    try {
      await Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          fullscreenDialog: true,
          builder: (_) => FastForwardFlow(
            onDone: () => Navigator.of(context).pop(),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _advancing = false);
    }
  }

  void _openMonetaria() {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(builder: (_) => const MonetariaPage()),
    );
  }

  void _openHighscore() {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(builder: (_) => const HighscorePage()),
    );
  }

  void _openQuests() {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(builder: (_) => const QuestListPage()),
    );
  }

  void _openZeitreise() {
    // Spec-43 follow-up: Zeitreise erst nach Tag 1 erlaubt — Spieler
    // soll erst mal einen echten Tag erlebt haben bevor er springt.
    final dayIndex = ref.read(gameClockProvider).dayIndex;
    if (dayIndex < 1) {
      showFgSnack(
        context,
        '⏳ Zeitreise ab Tag 2 verfügbar. Schlafe erst einmal!',
        isError: true,
      );
      return;
    }
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(builder: (_) => const ZeitreisePage()),
    );
  }

  void _openSettings() {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(builder: (_) => const SettingsPage()),
    );
  }

  void _openBerichte() {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(builder: (_) => const BerichtePage()),
    );
  }

  void _openRealLife() {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(builder: (_) => const RealLifePage()),
    );
  }

  void _openBank() {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(builder: (_) => const BankPage()),
    );
  }

  void _openZimmer() {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(builder: (_) => const ZimmerPage()),
    );
  }

  void _openStats() {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(builder: (_) => const StatsPage()),
    );
  }

  void _openGlossar() {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(builder: (_) => const GlossarPage()),
    );
  }

  void _openVorsorge() {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(builder: (_) => const VorsorgePage()),
    );
  }

  // _openSparPlan removed in spec-37: SparplanPage now reachable via the
  // ETF-Insel only (logical grouping). Helper kept removed to avoid
  // unused-method warning.

  @override
  Widget build(BuildContext context) {
    final day = ref.watch(gameClockProvider);
    final cash = ref.watch(cashStateProvider);
    final savings = ref.watch(savingsRepositoryProvider);
    // Spec-17: red-dot badge if today's quiz hasn't fired yet.
    final lastQuiz = ref.watch(dailyQuizStateProvider);
    final quizBadge = lastQuiz < day.dayIndex;
    // Home-Screen-Cleanup: offenes Tagesziel → Badge am Quests-Icon
    // (das Ziel + Claim-Button leben jetzt oben in der Quests-Seite).
    final dailyClaimed = ref.watch(dailyGoalClaimedProvider);
    final goalBadge = !dailyClaimed.contains(day.dayIndex);
    // Spec-43 v4: Achievement-Unlock-Toast + Confetti + Sound.
    ref.listen<({String? id, int tick})>(lastAchievementUnlockProvider,
        (prev, next) {
      if (next.id == null) return;
      if (prev != null && prev.tick == next.tick) return;
      final achievement = kAchievements
          .firstWhere((a) => a.id == next.id, orElse: () => kAchievements.first);
      SoundService.instance.playSfx(AudioKey.coin);
      showFgSnack(
        context,
        '🏆 ${achievement.emoji}  ${achievement.label} freigeschaltet!',
        duration: const Duration(seconds: 4),
      );
      // Confetti via Overlay damit Animation auch über Routen lebt.
      burstConfettiOverlay(context, seed: next.tick);
    });

    // spec-37 + Round 28: Level-Up Notification inkl. Cash-Belohnung.
    // Hört auf lastLevelUpProvider (trägt Level + Belohnungs-Cents), der
    // in XpRepository.add() bei jedem Level-Übergang gefeuert wird.
    ref.listen<({int? level, int rewardCents, int tick})>(
        lastLevelUpProvider, (prev, next) {
      if (next.level == null) return;
      if (prev != null && prev.tick == next.tick) return;
      final title = LevelSystem.titleFor(next.level!);
      final reward = next.rewardCents > 0
          ? ' · +${next.rewardCents ~/ 100} € Belohnung'
          : '';
      SoundService.instance.playSfx(AudioKey.coin);
      showFgSnack(
        context,
        '🏆 Level ${next.level} erreicht — $title!$reward',
        duration: const Duration(seconds: 4),
      );
      // Juice: Level-Up ist ein großer Moment → kräftigerer Konfetti-Burst.
      burstConfettiOverlay(context, seed: 7000 + next.tick, particleCount: 40);
    });
    // Spec-40 E: Achievement-Pop bei Unlock.
    ref.listen<Map<String, int>>(achievementsRepositoryProvider,
        (prev, next) {
      if (prev == null) return;
      final newOnes =
          next.keys.where((k) => !prev.containsKey(k)).toList();
      for (final id in newOnes) {
        final ach = kAchievements.firstWhere(
          (a) => a.id == id,
          orElse: () =>
              const Achievement(id: '', emoji: '🏅', label: ''),
        );
        if (ach.id.isEmpty) continue;
        showFgSnack(
          context,
          '🏅 Trophäe: ${ach.emoji} ${ach.label}',
          duration: const Duration(seconds: 4),
        );
      }
    });
    // spec-38 follow-up: Format "Tag X · Jahr Y" + Spieler-Alter aus Settings.
    final settings = ref.watch(settingsRepositoryProvider);
    final startAge = settings.startAgeYears;
    final years = day.dayIndex ~/ 365;
    final daysInYear = day.dayIndex % 365;
    final ageYears = startAge + years;

    final streak = settings.streakCount;
    final streakLabel = streak > 0 ? '  🔥$streak' : '';
    // Spec-45 G3: NewGame+ Run-Counter im Header.
    final runCount = ref.watch(newGameStateProvider).runCount;
    final runLabel = runCount > 0 ? '  ♻${runCount + 1}' : '';
    // Spec-42 Welle-6: 80-Jahre-Lebenszeit prominent. Bei Alter > 70
    // Warn-Banner einblenden damit der Spieler weiß dass er nur bis 80
    // Zeit hat zum Investieren.
    final lifespanLeft = 80 - ageYears;
    final showLifespanWarn = ageYears >= 70 && ageYears < 80;
    // v29: Game-End-Hinweis ab Alter 80.
    final showGameEnd = ageYears >= 80;
    void openStreakCal() {
      Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (_) => const StreakCalendarPage(),
        ),
      );
    }
    // Spec-40 D: Tageszeit-Tönung über `dayIndex % 4`. Subtiler Overlay.
    final tint = switch (day.dayIndex % 4) {
      0 => const Color(0x14FFD580), // Morgen warm-orange
      1 => const Color(0x10FFF59D), // Tag hellgelb
      2 => const Color(0x18FF9E80), // Abend rosa-orange
      _ => const Color(0x205B6BA8), // Nacht blau
    };
    // Spec-43 v4: Tag/Jahr/Alter/Saison wandern in die StatusBar oben.
    // appName bleibt für Streak-Indikator + Jahres-Tag.
    return PhoneFrame(
      appName: 'Heimat · Spieltag ${daysInYear + 1}/365$streakLabel$runLabel',
      showBack: false,
      onHome: null,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
          children: [
            MoneyHeader(cash: cash, savings: savings),
            const SizedBox(height: FgSpacing.s),
            // Bug-fix v26: Job-Badge — zeigt aktuelle Berufsphase +
            // Netto-Salary, damit Spieler weiß woher Geld kommt.
            _JobBadge(dayIndex: day.dayIndex),
            const SizedBox(height: FgSpacing.xs),
            // Home-Screen-Cleanup: Wetter + Streak kompakt in EINER Zeile
            // statt zwei separater Blöcke. Tagesziel + Tagesfrage wandern
            // in Badges am Quests-/Wissen-Icon.
            _StatusRow(
              dayIndex: day.dayIndex,
              streak: streak,
              onStreakTap: openStreakCal,
            ),
            // Spec-42 Welle-6: Lebenszeit-Warnung bei Alter > 70.
            if (showLifespanWarn)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: FgSpacing.l,
                  vertical: FgSpacing.xs,
                ),
                child: Container(
                  padding: const EdgeInsets.all(FgSpacing.s),
                  decoration: BoxDecoration(
                    color: FgColors.alert.withValues(alpha: 0.2),
                    border: Border.all(
                      color: FgColors.alert,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    '⌛ Du bist $ageYears Jahre alt. Mit 80 endet das '
                    'Spiel — nur noch $lifespanLeft Jahre zum Investieren!',
                    style: FgTypography.bodyM,
                  ),
                ),
              ),
            if (showGameEnd)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: FgSpacing.l,
                  vertical: FgSpacing.xs,
                ),
                child: Container(
                  padding: const EdgeInsets.all(FgSpacing.s),
                  decoration: BoxDecoration(
                    color: FgColors.primary.withValues(alpha: 0.25),
                    border: Border.all(color: FgColors.primary, width: 2),
                  ),
                  child: const Text(
                    '🏁 SPIEL ZU ENDE — Du hast 80 erreicht. Schau dir '
                    'das Lebensresümee an + den Highscore. '
                    'Settings → "Reset" für einen neuen Versuch.',
                    style: FgTypography.bodyM,
                  ),
                ),
              ),
            const SizedBox(height: FgSpacing.s),
            const NewsTicker(),
            const SizedBox(height: FgSpacing.m),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: FgSpacing.l),
              child: GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: FgSpacing.l,
                crossAxisSpacing: FgSpacing.l,
                childAspectRatio: 0.85,
                children: [
                  AppIcon(
                    glyph: '🌀',
                    label: 'Monetaria',
                    background: FgColors.primary,
                    onTap: _openMonetaria,
                  ),
                  AppIcon(
                    glyph: '🏦',
                    label: 'Bank',
                    background: FgColors.success,
                    onTap: _openBank,
                  ),
                  AppIcon(
                    glyph: day.dayIndex < 1 ? '🔒' : '⏳',
                    label: 'Zeitreise',
                    background: day.dayIndex < 1
                        ? FgColors.neutral
                        : FgColors.info,
                    onTap: _openZeitreise,
                  ),
                  AppIcon(
                    glyph: '🛏',
                    label: 'Zimmer',
                    background: FgColors.secondary,
                    onTap: _openZimmer,
                  ),
                  AppIcon(
                    glyph: '📝',
                    label: 'Quests',
                    background: FgColors.alert,
                    onTap: _openQuests,
                    badge: goalBadge,
                  ),
                  AppIcon(
                    glyph: '📊',
                    label: 'Portfolio',
                    background: FgColors.info,
                    onTap: _openStats,
                  ),
                  AppIcon(
                    glyph: '📖',
                    label: 'Wissen',
                    background: FgColors.success,
                    // Offene Tagesfrage → Badge + direkter Quiz-Start;
                    // sonst führt das Icon ins Glossar.
                    onTap: quizBadge ? _openQuiz : _openGlossar,
                    badge: quizBadge,
                  ),
                  AppIcon(
                    glyph: '🛡',
                    label: 'Vorsorge',
                    background: FgColors.secondary,
                    onTap: _openVorsorge,
                  ),
                  AppIcon(
                    glyph: '🏆',
                    label: 'Highscore',
                    background: FgColors.primary,
                    onTap: _openHighscore,
                  ),
                  AppIcon(
                    glyph: '🌟',
                    label: 'Echtes Leben',
                    background: FgColors.primary,
                    onTap: _openRealLife,
                  ),
                  AppIcon(
                    glyph: '📤',
                    label: 'Berichte',
                    background: FgColors.info,
                    onTap: _openBerichte,
                  ),
                  AppIcon(
                    glyph: '⚙',
                    label: 'Settings',
                    background: FgColors.neutral,
                    onTap: _openSettings,
                  ),
                ],
              ),
            ),
            const SizedBox(height: FgSpacing.xl),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PixelButton(
                  label: _advancing ? '...' : 'Schlafen 😴',
                  background: FgColors.secondary,
                  foreground: FgColors.onSurface,
                  onPressed: _advancing ? null : () => _onSchlafen(),
                ),
                const SizedBox(width: FgSpacing.s),
                PixelButton(
                  label: '⏩',
                  background: FgColors.info,
                  foreground: FgColors.onSurface,
                  onPressed: _advancing ? null : _openFastForward,
                ),
              ],
            ),
            const SizedBox(height: FgSpacing.xl),
          ],
            ),
          ),
          // Spec-40 D: Tageszeit-Tönung über allem als IgnorePointer-Overlay.
          IgnorePointer(
            child: Container(color: tint),
          ),
          // Spec-40 G: Wetter-Partikel (Regen/Storm).
          // Spec-43 v3: Regen-/Wetter-Partikel-Overlay entfernt — sieht
          // auf dem Home-Screen wie Grafik-Glitch aus statt nach Regen.
          // const IgnorePointer(child: _WeatherParticles()),
        ],
      ),
    );
  }
}

/// Home-Screen-Cleanup: kompakte Statuszeile — Wetter links, Streak rechts
/// (tippbar → Streak-Kalender). Ersetzt die früher separaten Wetter-Pille
/// + Streak-Banner-Blöcke, damit die Apps wieder ohne Scrollen sichtbar
/// sind. Tagesziel + Tagesfrage signalisiert der Springboard nur noch über
/// Badges an den Quests-/Wissen-Icons.
class _StatusRow extends StatelessWidget {
  const _StatusRow({
    required this.dayIndex,
    required this.streak,
    required this.onStreakTap,
  });

  final int dayIndex;
  final int streak;
  final VoidCallback onStreakTap;

  @override
  Widget build(BuildContext context) {
    final weather = rollWeather(dayIndex);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: FgSpacing.l),
      child: Row(
        children: [
          Text(weatherEmoji(weather), style: const TextStyle(fontSize: 16)),
          const SizedBox(width: FgSpacing.xs),
          Text(weatherLabel(weather), style: FgTypography.bodyS),
          const Spacer(),
          if (streak > 0)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onStreakTap,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '🔥 $streak-Tage-Streak',
                    style: FgTypography.bodyS,
                  ),
                  const SizedBox(width: 2),
                  const Text('›', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Bug-fix v26: Job-Badge zeigt Berufsphase + Netto-Salary + Lebenskosten.
class _JobBadge extends ConsumerWidget {
  const _JobBadge({required this.dayIndex});
  final int dayIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startAge = ref.watch(
      settingsRepositoryProvider.select((s) => s.startAgeYears),
    );
    final ageYears = startAge + dayIndex ~/ 365;
    final job = JobConfig.forAge(ageYears);
    final yearsInLevel = JobConfig.yearsInLevel(ageYears);
    final jobAction = ref.watch(jobActionRepositoryProvider);
    var salary = JobConfig.monthlySalary(job, yearsInLevel: yearsInLevel);
    if (salary.cents > 0 && jobAction.careerBonusPct > 0) {
      salary = Money.cents(
        (salary.cents * (100 + jobAction.careerBonusPct)) ~/ 100,
      );
    }
    final living = JobConfig.monthlyLivingCost(job);
    final allowance = ref.watch(
      settingsRepositoryProvider.select((s) => s.allowance),
    );
    final emoji = switch (job) {
      JobLevel.none => '🎒',
      JobLevel.ferienjob => '🪣',
      JobLevel.ausbildung => '🔧',
      JobLevel.vollzeit => '💼',
      JobLevel.senior => '🧑‍💼',
      JobLevel.lead => '👑',
    };
    final label = JobConfig.jobTitle(job, variant: jobAction.jobVariantIndex);
    final raiseSuffix = (yearsInLevel > 0 && job != JobLevel.none)
        ? ' · +${(yearsInLevel.clamp(0, JobConfig.yearlyRaiseCapYears) * 2)}%'
        : '';
    final bonusSuffix = jobAction.careerBonusPct > 0
        ? ' · 💪 +${jobAction.careerBonusPct}%'
        : '';
    final isPaused = jobAction.isPaused(dayIndex);
    final detail = isPaused
        ? '⏸ Pause bis Tag ${jobAction.pauseUntilDay}'
        : job == JobLevel.none
            ? 'Taschengeld ${allowance.formatEur()}/Monat'
            : '+${salary.formatEur()}/Mo · −${living.formatEur()}/Mo$raiseSuffix$bonusSuffix';
    final canAct = job.index >= JobLevel.ausbildung.index;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: canAct
          ? () => _showJobActionSheet(context, ref, dayIndex, isPaused)
          : null,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: FgSpacing.l),
        padding: const EdgeInsets.symmetric(
          horizontal: FgSpacing.s,
          vertical: FgSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: FgColors.backgroundDeep,
          border: Border.all(
            color: isPaused ? FgColors.alert : FgColors.outline,
            width: 1,
          ),
        ),
        // v35: zweizeilig — Titel (jetzt fiktiver Pool, kann länger sein)
        // bekommt die volle Breite → kein Clip mehr; Detail darunter.
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: FgSpacing.xs),
                Expanded(
                  child: Text(
                    label,
                    style: FgTypography.bodyM,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (canAct) ...[
                  const SizedBox(width: FgSpacing.xs),
                  const Icon(Icons.more_vert,
                      size: 16, color: FgColors.onSurfaceMuted),
                ],
              ],
            ),
            const SizedBox(height: 2),
            Text(detail, style: FgTypography.bodyS),
          ],
        ),
      ),
    );
  }

  void _showJobActionSheet(
    BuildContext context,
    WidgetRef ref,
    int currentDayIndex,
    bool isPaused,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: FgColors.backgroundDeep,
      // Inhalt (Wechsel + Auszeit + Reset + Erklär-Texte) ist höher als die
      // Default-Sheet-Höhe (~½ Screen) → scrollbar + isScrollControlled,
      // sonst wird oben abgeschnitten.
      isScrollControlled: true,
      builder: (ctx) {
        final notifier = ref.read(jobActionRepositoryProvider.notifier);
        final jobState = ref.read(jobActionRepositoryProvider);
        final canSwitch = jobState.canSwitch(currentDayIndex);
        final lockYears =
            (jobState.daysUntilSwitch(currentDayIndex) / 365).ceil();
        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(ctx).size.height * 0.85,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(FgSpacing.l),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
              const Text(
                '💼 Was machst du beruflich?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: FgColors.primary,
                ),
              ),
              const SizedBox(height: FgSpacing.s),
              const Text(
                'Echte Karrieren sind nicht linear. Hier kannst du '
                'springen — mit Konsequenzen.',
                style: TextStyle(fontSize: 13, color: Colors.white),
              ),
              const SizedBox(height: FgSpacing.m),
              if (!isPaused) ...[
                if (canSwitch)
                  _ActionTile(
                    emoji: '🔁',
                    title: 'Job wechseln',
                    subtitle: 'Neuer Arbeitgeber = neue Stelle + 5 % mehr '
                        'Lohn (bis max +50 %). Dafür 30 Tage Pause ohne '
                        'Gehalt — und erst in 3-5 Jahren wieder ein Wechsel '
                        'möglich.',
                    onTap: () {
                      notifier.switchJob(currentDayIndex);
                      Navigator.of(ctx).pop();
                    },
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: FgSpacing.s),
                    child: Text(
                      '🔒 Job-Wechsel erst in ~$lockYears '
                      '${lockYears == 1 ? "Jahr" : "Jahren"} wieder möglich. '
                      'So oft wechselt man im echten Leben auch nicht.',
                      style: const TextStyle(
                        fontSize: 14,
                        color: FgColors.onSurfaceMuted,
                      ),
                    ),
                  ),
                const SizedBox(height: FgSpacing.s),
                _ActionTile(
                  emoji: '🏝',
                  title: 'Auszeit (90 Tage)',
                  subtitle: '3 Monate kein Job — Reisen, lernen, '
                      'durchatmen. ABER: Miete + Essen kosten weiter. '
                      'Genug Sparguthaben?',
                  onTap: () {
                    notifier.takeSabbatical(currentDayIndex);
                    Navigator.of(ctx).pop();
                  },
                ),
                const SizedBox(height: FgSpacing.s),
              ] else
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: FgSpacing.m),
                  child: Text(
                    'Aktuell in Pause. Warte bis sie endet, dann sind '
                    'wieder Aktionen möglich.',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              _ActionTile(
                emoji: '↩',
                title: 'Aktionen zurücksetzen',
                subtitle: 'Bonus + Pause auf 0 zurück.',
                onTap: () {
                  notifier.reset();
                  Navigator.of(ctx).pop();
                },
              ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final String emoji;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(FgSpacing.m),
        decoration: BoxDecoration(
          color: FgColors.backgroundElevated,
          border: Border.all(color: FgColors.outline, width: 1),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: FgSpacing.s),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold)),
                  Text(subtitle,
                      style: const TextStyle(
                          fontSize: 12, color: Colors.white70)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

