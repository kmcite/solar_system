import 'dart:async';
import 'package:signals/signals.dart';
import 'loads.dart' as loads_state;
import 'inverter.dart' as inverter_state;
import 'app.dart' as app_state;

// =============================================================================
// STATE
// =============================================================================
final revenueIsRunning = signal(false);
final currentRevenuePerSecond = signal(0.0);
final totalEarned = signal(0.0);

// =============================================================================
// INTERNAL
// =============================================================================
Timer? _revenueTimer;

// =============================================================================
// ACTIONS
// =============================================================================
void startRevenue() {
  _revenueTimer?.cancel();
  _revenueTimer = Timer.periodic(
    const Duration(seconds: 1),
    (_) => _tickRevenue(),
  );
  revenueIsRunning.value = true;
}

void stopRevenue() {
  _revenueTimer?.cancel();
  batch(() {
    revenueIsRunning.value = false;
    currentRevenuePerSecond.value = 0;
  });
}

void _tickRevenue() {
  if (!inverter_state.inverterStatus.value) {
    currentRevenuePerSecond.value = 0;
    return;
  }
  final revenue = loads_state.totalActiveRevenue.value;
  if (revenue > 0) {
    app_state.creditMoney(revenue);
    batch(() {
      currentRevenuePerSecond.value = revenue;
      totalEarned.value += revenue;
    });
  } else {
    currentRevenuePerSecond.value = 0;
  }
}

void disposeRevenue() {
  _revenueTimer?.cancel();
}
