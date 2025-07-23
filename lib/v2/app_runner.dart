// import 'dart:async';
// import 'package:faker/faker.dart';
// import 'package:solar_system/v2/panels.dart';
// import 'package:solar_system/v2/sunlight_flow.dart';

// final appRunner = AppRunner();

// class AppRunner {
//   void initState() {
//     flowTimer = Timer.periodic(
//       Duration(seconds: 10),
//       (_) => flow(),
//     );
//     autoRemovePanelTimer = Timer.periodic(
//       Duration(seconds: 10),
//       (_) => autoRemovePanel(),
//     );
//   }

//   Timer? autoRemovePanelTimer;

//   void autoRemovePanel() {
//     panels.removeWhere((key, value) => value.power() <= 50);
//   }

//   Timer? flowTimer;

//   void flow() {
//     final sixtyToHundred = faker.randomGenerator.decimal(scale: 40, min: 60);

//     final value = sixtyToHundred / 100;

//     if (isFlowing()) {
//       flowPercentage.set(value);
//     } else {
//       flowPercentage.set(0);
//     }
//   }

//   void dispose() {
//     flowTimer?.cancel();
//   }
// }
