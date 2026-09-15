/// Altersstatus der echten Person am Gerät.
///
/// **Nicht zu verwechseln mit dem Spielfiguren-Alter** (`startAgeYears`,
/// steuert Job-Level und Lebenskosten). Hier geht es ausschließlich um die
/// Frage, ob der Unterstützen-Bereich überhaupt existieren darf.
///
/// Hintergrund: Googles Familienrichtlinie verbietet nicht die
/// Trinkgeld-Funktion, wohl aber einen für Kinder frei erreichbaren Weg aus
/// der App heraus zu einem Zahlungsanbieter. Der Bereich ist deshalb nur für
/// [AgeState.adult] vorhanden — bei [AgeState.minor] UND bei
/// [AgeState.unknown], denn „keine Angabe" ist kein Nachweis von Volljährigkeit.
enum AgeState {
  /// Noch keine Angabe gemacht (oder bewusst übersprungen).
  unknown,

  /// Errechnetes Alter unter 18.
  minor,

  /// Errechnetes Alter 18 oder darüber.
  adult,
}

/// Kleinstes plausibles Geburtsjahr: [currentYear] − 120.
int minPlausibleBirthYear(int currentYear) => currentYear - 120;

/// Ob [year] als Geburtsjahr überhaupt in Frage kommt. Fängt Tippfehler wie
/// „19999" oder ein Jahr in der Zukunft ab.
bool isPlausibleBirthYear(int year, {required int currentYear}) =>
    year >= minPlausibleBirthYear(currentYear) && year <= currentYear;

/// Leitet den Status bei JEDEM Zugriff neu aus dem aktuellen Jahr ab — wer
/// einmal als minderjährig eingetragen wurde, wird mit der Zeit von selbst
/// volljährig, ohne dass irgendwo ein Datum nachgeführt werden muss.
///
/// Gerechnet wird jahresgenau (`currentYear - birthYear`), nicht auf den Tag.
/// Das ist bewusst: ein volles Geburtsdatum wäre eine personenbezogene Angabe
/// mehr, als für diese Entscheidung nötig ist. Die Unschärfe geht damit
/// höchstens um ein paar Monate zugunsten des Nutzers aus, und die
/// Elternschranke vor der Zahlung fängt den Rest ab.
AgeState ageStateFor(int? birthYear, {required int currentYear}) {
  if (birthYear == null) return AgeState.unknown;
  if (!isPlausibleBirthYear(birthYear, currentYear: currentYear)) {
    return AgeState.unknown;
  }
  return currentYear - birthYear >= 18 ? AgeState.adult : AgeState.minor;
}

/// Ob die Eingabe eines Geburtsjahrs hinter die Eltern-Rechenaufgabe gehört.
///
/// **Nachholen ist frei, Ändern nicht.** Steht noch nichts da
/// ([AgeState.unknown] — übersprungen oder unplausibel), ist die Eingabe
/// bloß die nachgeholte Antwort auf eine Frage, die beim ersten Start schon
/// ohne Schranke gestellt wurde. Eine Aufgabe davor hielte niemanden auf: Wer
/// sie hier löst, löst auch die vor dem Zahlungsanbieter — es ist dieselbe
/// Multiplikation. Aufgehalten würde nur der Erwachsene, der die Frage
/// übersprungen hat und nun zweimal rechnen müsste, obwohl die zweite
/// Aufgabe direkt vor dem Verlassen der App ohnehin kommt.
///
/// Steht bereits ein Jahr da, bleibt die Änderung geschützt. Sonst wäre eine
/// einmal gemachte Altersangabe mit zwei Tipps in den Einstellungen wieder
/// zurückgedreht, und die Sichtbarkeitsregel des Unterstützen-Bereichs liefe
/// ins Leere.
///
/// Die tragende Schranke bleibt in beiden Fällen dieselbe: die Rechenaufgabe
/// unmittelbar vor dem Sprung zum Zahlungsanbieter.
bool birthYearEntryNeedsParentGate(int? birthYear, {required int currentYear}) =>
    ageStateFor(birthYear, currentYear: currentYear) != AgeState.unknown;
