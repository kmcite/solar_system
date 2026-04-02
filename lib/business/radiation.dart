import 'dart:async';
import 'package:signals/signals.dart';

// =============================================================================
// STATE
// =============================================================================
final radiation = signal(0.0);
final cycleDuration = signal(60); // Total cycle duration in seconds
final elapsedSeconds = signal(0);
final dayProgress = signal(0.0); // 0.0 to 1.0 representing full day cycle

// =============================================================================
// ENUM
// =============================================================================
enum TimeOfDay {
  night,
  dawn,
  day,
  dusk,
}

// =============================================================================
// COMPUTED
// =============================================================================
final currentTimeOfDay = computed(() {
  final progress = dayProgress.value;
  // 0.0-0.2: Night
  // 0.2-0.3: Dawn
  // 0.3-0.7: Day
  // 0.7-0.8: Dusk
  // 0.8-1.0: Night
  if (progress < 0.2 || progress >= 0.8) return TimeOfDay.night;
  if (progress < 0.3) return TimeOfDay.dawn;
  if (progress < 0.7) return TimeOfDay.day;
  return TimeOfDay.dusk;
});

final isDaytime = computed(() {
  final tod = currentTimeOfDay.value;
  return tod == TimeOfDay.day || tod == TimeOfDay.dawn || tod == TimeOfDay.dusk;
});

final isNighttime = computed(() => !isDaytime.value);

final timeOfDayLabel = computed(() {
  switch (currentTimeOfDay.value) {
    case TimeOfDay.night:
      return 'NIGHT';
    case TimeOfDay.dawn:
      return 'DAWN';
    case TimeOfDay.day:
      return 'DAY';
    case TimeOfDay.dusk:
      return 'DUSK';
  }
});

// Cycle progress as percentage (0-100)
final cycleProgressPercent = computed(() {
  return (dayProgress.value * 100).toStringAsFixed(0);
});

// Time remaining until next day/night change
final timeUntilNextPhase = computed(() {
  final progress = dayProgress.value;
  if (progress < 0.2) {
    // Night to dawn
    return ((0.2 - progress) * cycleDuration.value).toStringAsFixed(0);
  } else if (progress < 0.3) {
    // Dawn to day
    return ((0.3 - progress) * cycleDuration.value).toStringAsFixed(0);
  } else if (progress < 0.7) {
    // Day to dusk
    return ((0.7 - progress) * cycleDuration.value).toStringAsFixed(0);
  } else if (progress < 0.8) {
    // Dusk to night
    return ((0.8 - progress) * cycleDuration.value).toStringAsFixed(0);
  } else {
    // Night
    return ((1.0 - progress) * cycleDuration.value).toStringAsFixed(0);
  }
});

// =============================================================================
// INTERNAL
// =============================================================================
Timer? _radiationTimer;
int _elapsed = 0;
int _fullDays = 0;

// =============================================================================
// ACTIONS
// =============================================================================
void startRadiation() {
  _radiationTimer?.cancel();
  _radiationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
    _elapsed++;

    // Calculate full day progress (0.0 to 1.0)
    final totalSeconds = cycleDuration.value;
    final cycleProgress = _elapsed % totalSeconds;
    dayProgress.value = cycleProgress / totalSeconds;

    // Track full days
    _fullDays = _elapsed ~/ totalSeconds;

    // Compute radiation synchronized with time phases
    // Night (0.0-0.2): 0% radiation
    // Dawn (0.2-0.3): 0% → 100% (linear ramp up)
    // Day (0.3-0.7): 100% radiation (full sun)
    // Dusk (0.7-0.8): 100% → 0% (linear ramp down)
    // Night (0.8-1.0): 0% radiation
    final progress = dayProgress.value;
    double rad;
    if (progress < 0.2) {
      rad = 0.0; // Night
    } else if (progress < 0.3) {
      // Dawn: linear ramp from 0 to 1
      rad = (progress - 0.2) / 0.1;
    } else if (progress < 0.7) {
      rad = 1.0; // Full day
    } else if (progress < 0.8) {
      // Dusk: linear ramp from 1 to 0
      rad = 1.0 - (progress - 0.7) / 0.1;
    } else {
      rad = 0.0; // Night
    }
    radiation.value = rad;
    elapsedSeconds.value = cycleProgress;
  });
}

void stopRadiation() {
  _radiationTimer?.cancel();
  radiation.value = 0.0;
}

void configureRadiationCycle(int duration) {
  cycleDuration.value = duration;
  _elapsed = 0;
  _fullDays = 0;
  elapsedSeconds.value = 0;
  dayProgress.value = 0.0;
  radiation.value = 0.0;
}

void disposeRadiation() {
  _radiationTimer?.cancel();
}

/// Get day count (for tracking purposes)
int getCurrentDay() => _fullDays;

/// Get radiation multiplier for current time of day
/// Returns 0-100 based on actual radiation value
int getRadiationMultiplier() {
  return (radiation.value * 100).round();
}
