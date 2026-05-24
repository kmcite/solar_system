import 'dart:async';
import 'package:flutter/material.dart';
import 'package:solar_system/business/money.dart';
import 'loads.dart' as loads_state;
import 'inverter.dart' as inverter_state;

final revenue = RevenueNotifier();

class RevenueNotifier extends ChangeNotifier {
  bool status = false;
  num rate = 0;
  num total = 0;

  RevenueNotifier() {
    startRevenue();
    print(this);
  }

  Timer? _revenueTimer;
  void startRevenue() {
    _revenueTimer?.cancel();
    _revenueTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _tickRevenue(),
    );
    status = true;
    notifyListeners();
  }

  void stopRevenue() {
    _revenueTimer?.cancel();
    status = false;
    rate = 0;
    notifyListeners();
  }

  void _tickRevenue() {
    if (!inverter_state.inverterStatus.value) {
      rate = 0;
      return;
    }
    final revenue = loads_state.totalActiveRevenue.value;
    if (revenue > 0) {
      money.credit(revenue);
      rate = revenue;
      total += revenue;
    } else {
      rate = 0;
    }
    notifyListeners();
  }

  void dispose() {
    _revenueTimer?.cancel();
    super.dispose();
  }
}
