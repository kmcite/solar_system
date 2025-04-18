import 'dart:async';
import 'dart:math';

import 'package:solar_system/domain/models/utility.dart';
import 'package:solar_system/main.dart';

final utilityRepository = UtilityRepository();

class UtilityRepository extends ChangeNotifier {
  Timer? timer;
  UtilityRepository() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      updateUtility,
    );
  }
  Utility utility = Utility();
  void update(Utility utility) {
    this.utility = utility;
    notifyListeners();
  }

  int get voltage => status ? utility.voltage : 0;

  bool get status => utility.status;
  void toggle() {
    update(utility..status = !status);
    notifyListeners();
  }

  void updateUtility(_) {
    utility.voltage = Random().nextInt(40) + 190;
    notifyListeners();
  }
}
