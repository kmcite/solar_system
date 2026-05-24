import 'dart:async';
import 'package:faker/faker.dart';
import 'package:flutter/foundation.dart';
import 'package:signals/signals.dart';

final utility = UtilityNotifier();

class UtilityNotifier extends ChangeNotifier {
  Timer? utilityTimer;
  UtilityNotifier() {
    utilityTimer = Timer.periodic(
      Duration(seconds: 1),
      (_) {},
    );
  }

  var status = false;

  /// INTERNAL STATE
  num _usage = 0;
  num _power = 1000;
  num voltage = 220;

  /// PUBLIC STATE
  num remainingTime = 0;
  num get amperes => power / voltage;
  num get power => status ? _power : 0;
  num get usage => _usage;

  void startUtility() {
    status = true;
    notifyListeners();
  }

  void stopUtility() {
    status = false;
    notifyListeners();
  }

  void upgradePower() {
    _power += 1000;
    notifyListeners();
  }

  void buyUsage() {
    _usage += 1;
    notifyListeners();
  }

  void toggleUtility(bool value) {
    status = value;
    notifyListeners();
  }
}

// =============================================================================
// STATE
// =============================================================================
final utilityStatus = signal(false);
final utilityVoltage = signal<num>(0);
final utilityCurrent = signal<num>(0);
final utilityRemainingSeconds = signal(0);

// =============================================================================
// COMPUTED
// =============================================================================
final utilityPower = computed(
  () => utilityVoltage.value * utilityCurrent.value,
);

// =============================================================================
// INTERNAL
// =============================================================================
Timer? _countdownTimer;
Timer? _utilityTimer;

// =============================================================================
// ACTIONS
// =============================================================================
void startUtility() {
  _startUtilitySimulation();
  utilityStatus.value = true;
}

void stopUtility() {
  _stopTimers();
  batch(() {
    utilityStatus.value = false;
    utilityVoltage.value = 0;
    utilityCurrent.value = 0;
    utilityRemainingSeconds.value = 0;
  });
}

void purchaseUtility(double amount) {
  final seconds = amount.round(); // 1 PKR = 1 second
  final newRemaining = utilityRemainingSeconds.value + seconds;

  if (!utilityStatus.value) {
    // Start utility streaming
    startUtility();
    // Start countdown timer
    _startCountdown();
  }

  utilityRemainingSeconds.value = newRemaining;
}

void _tickCountdown() {
  if (utilityRemainingSeconds.value <= 1) {
    // Time's up, stop utility
    stopUtility();
    return;
  }
  utilityRemainingSeconds.value = utilityRemainingSeconds.value - 1;
}

void _tickUtilitySimulation() {
  final voltage = random.decimal(scale: 50, min: 180);
  final current = random.decimal(scale: 2, min: 10);
  batch(() {
    utilityVoltage.value = voltage;
    utilityCurrent.value = current;
  });
}

void _startCountdown() {
  _countdownTimer?.cancel();
  _countdownTimer = Timer.periodic(
    const Duration(seconds: 1),
    (_) => _tickCountdown(),
  );
}

void _startUtilitySimulation() {
  _utilityTimer?.cancel();
  _utilityTimer = Timer.periodic(
    const Duration(seconds: 1),
    (_) => _tickUtilitySimulation(),
  );
}

void _stopTimers() {
  _countdownTimer?.cancel();
  _countdownTimer = null;
  _utilityTimer?.cancel();
  _utilityTimer = null;
}

void disposeUtility() {
  _stopTimers();
}
