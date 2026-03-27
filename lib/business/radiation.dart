import 'dart:async';
import 'dart:math';
import 'package:signals/signals.dart';

// =============================================================================
// STATE
// =============================================================================
final radiation = signal(0.0);
final cycleDuration = signal(60);
final elapsedSeconds = signal(0);

// =============================================================================
// INTERNAL
// =============================================================================
Timer? _radiationTimer;
int _elapsed = 0;

// =============================================================================
// ACTIONS
// =============================================================================
void startRadiation() {
  _radiationTimer?.cancel();
  _radiationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
    _elapsed++;
    // Compute radiation using sine wave: peaks at 1.0 during "noon", 0 during "night"
    // max(0, ...) clamps negative values (night half of sine wave) to 0
    final sineValue = sin(2 * pi * _elapsed / cycleDuration.value);
    radiation.value = max(0.0, sineValue);
    elapsedSeconds.value = _elapsed % cycleDuration.value;
  });
}

void stopRadiation() {
  _radiationTimer?.cancel();
  radiation.value = 0.0;
}

void configureRadiationCycle(int duration) {
  cycleDuration.value = duration;
  _elapsed = 0;
  elapsedSeconds.value = 0;
}

void disposeRadiation() {
  _radiationTimer?.cancel();
}
