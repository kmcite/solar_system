import 'package:signals_flutter/signals_flutter.dart';
import 'package:solar_system/v3/bloc.dart';

final utility = Utility();

class StartUtilityUsage {}

class StopUtilityUsage {}

class Utility extends Bloc {
  Utility() {
    on<StartUtilityUsage>(
      (event) {
        isRunning.set(true);
      },
    );
    on<StopUtilityUsage>(
      (event) {
        isRunning.set(false);
      },
    );
  }

  final isRunning = signal(false);
}
