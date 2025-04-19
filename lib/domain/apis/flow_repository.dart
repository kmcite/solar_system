import 'dart:async';
import 'dart:math';
import 'package:solar_system/main.dart';

class FlowRepository with ChangeNotifier {
  Timer? timer;
  FlowRepository() {
    timer = Timer.periodic(
      1.seconds,
      flow,
    );
  }

  void flow(_) {
    final random = Random();
    final sixtyToHundred = random.nextInt(40) + 60;
    final value = sixtyToHundred / 100;
    if (flowing) {
      this
        ..unusable = 0
        ..percentage = value;
    } else {
      this
        ..unusable = value
        ..percentage = 0;
    }
    notifyListeners();
  }

  bool flowing = true;
  double percentage = 0;
  void toggle() {
    flowing = !flowing;
    notifyListeners();
  }

  double unusable = 0;
  double get currentPercentage => percentage;
}

final flowRepository = FlowRepository();
