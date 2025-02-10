import 'package:manager/manager.dart';

/// UtilityBloc refactored
class UtilityBloc {
  final utilityRM = RM.inject(
    () => Utility(),
    persist: () => PersistState(
      key: 'utility',
      toJson: (s) => jsonEncode(s.toJson()),
      fromJson: (json) => Utility.fromJson(jsonDecode(json)),
    ),
  );

  set utility(Utility value) => utilityRM
    ..state = value
    ..notify();

  Utility get utility => utilityRM.state;

  void toggle() {
    utility = utility..isPoweringLoads = !utility.isPoweringLoads;
  }
}

final utilityBloc = UtilityBloc();

class Utility {
  bool isPoweringLoads = false;
  int energyToPowerLoads = 10;

  Map<String, dynamic> toJson() {
    return {
      "isPoweringLoads": isPoweringLoads,
      "energyToPowerLoads": energyToPowerLoads,
    };
  }

  Utility.fromJson(Map<String, dynamic> json) {
    isPoweringLoads = json['isPoweringLoads'] ?? false;
    energyToPowerLoads = json['energyToPowerLoads'] ?? 10;
  }
  Utility();
}
