# Spec 25 — Readability + UX-Fix

## Goal

Test-Feedback Quick-Wins: Schrift lesbar, Save-Label sichtbar, Back-Button verlässlich, Schlaf-Text klar, Wochentag-Setting erklärt.

## Why

Reibung im täglichen Flow. Kleinkram der nervt.

## Non-Goals

- Komplette Stilüberarbeitung (spec-28)
- Audio (spec-27)

## Tasks

### 1. Font-Hierarchie auf KenneyFutureNarrow

Body wechselt auf `KenneyFutureNarrow` (klarer als KenneyFuture bei kleinen Größen). KenneyPixel bleibt nur für Geldbeträge + Header.

`design_tokens.dart`:
- `bodyFamily = 'KenneyFutureNarrow'`
- bodyM 16→17, bodyS 13→14, bodyL 18→19
- LineHeight `height: 1.3` auf Body-Styles

`pubspec.yaml`: KenneyFutureNarrow.ttf bereits da, family-Eintrag prüfen.

### 2. Save-Snackbar lesbar

`SettingsPage._save`: SnackBar braucht hellen Hintergrund + großen pixelfont-Text. Custom Snackbar:
```dart
backgroundColor: FgColors.surface  // statt Material default dunkel
content: Text('Gespeichert ✓', style: FgTypography.bodyL bold)
behavior: floating, margin bottom 80 (nicht hinter HomeBar)
duration: 1500ms
```

Helper `showFgSnack(context, msg)` in `lib/ui/widgets/fg_snack.dart`, in allen save-Stellen einsetzen.

### 3. Back-Button verlässlich

Problem: `HomeBar.onBack = Navigator.of(context).pop()` schlägt fehl wenn Route nicht push-stacked sondern via go_router redirected.

Fix: `PhoneFrame.onBack` callback bleibt, aber Default in `home_bar.dart`:
```dart
onPressed: () {
  if (context.canPop()) { context.pop(); }
  else { context.go('/home'); }
}
```

`context.canPop()` = go_router API. Alle Pages die direkt aus HomeBar erreicht werden müssen `/home` als Fallback.

### 4. Schlaf-Snack-Text

`sleep_page.dart` (oder wo "Schlafen-Snack -0,10 €" rendert): Suchstring "Schlaf-Snack". Umbenennen zu „Schlaf-Snack: −0,10 €" mit klarer Erklärung in PixelPanel-Untertitel: „kleiner Mitternachtssnack". Falls Wert hartcodiert, in `DayEvent.allowance` oder `economy_constants.dart` ablegen.

### 5. Wochentag-Setting klar labeln

Wochentag-Dropdown bleibt, aber Label umbenennen: „Taschengeld-Auszahlungstag" mit Subtitle „An welchem Wochentag du dein Taschengeld bekommst". Tooltip-Icon (`?`) öffnet kleine ExplainBox.

## Files

- `lib/core/design_tokens.dart` — bodyFamily, Sizes, height
- `pubspec.yaml` — fonts verify
- `lib/ui/widgets/fg_snack.dart` (neu)
- `lib/features/settings/settings_page.dart` — Snack helper, Wochentag-Label, Tooltip
- `lib/features/sleep/*` — Snack-Text
- `lib/ui/widgets/home_bar.dart` — canPop-Logik
- Alle Stellen `Navigator.of(context).pop()` mit `Routenname` prüfen → ggf. go_router

## Tests

- Widget: `fg_snack` rendert mit FgTypography
- Widget: Settings save zeigt Snack
- Widget: HomeBar back fällt auf /home wenn !canPop

## Acceptance

- [ ] Body-Schrift KenneyFutureNarrow, größer, mehr Zeilenabstand
- [ ] Save-Snack klar lesbar, alle save-Stellen nutzen Helper
- [ ] Back-Button funktioniert von allen Seiten (Fallback /home)
- [ ] Schlafen-Snack-Text klar formuliert
- [ ] Wochentag-Label erklärt Zweck
- [ ] Tests grün
- [ ] `flutter analyze --fatal-infos` clean
- [ ] Commit: `feat(ux): readability + back-button + save-snack + labels`

## Done When

Tippe durch alle Hauptseiten → Schrift überall klar, Back geht immer, Save sichtbar.
