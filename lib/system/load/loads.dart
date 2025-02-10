// import 'dart:math';

import 'package:manager/manager.dart';

/// LoadsBloc refactored
class LoadsBloc {
  final loadsRM = RM.inject(() => Loads());

  Loads get loads => loadsRM.state;
  set loads(Loads value) => loadsRM
    ..state = value
    ..notify();

  void increaseLoad([int amount = 1]) {
    loads = loads..loads += amount;
  }

  void decreaseLoad([int amount = 1]) {
    loads = loads..loads -= amount;
  }
}

final loadsBloc = LoadsBloc();

class Loads {
  int loads = 100;
}

class LoadsPage extends UI {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
