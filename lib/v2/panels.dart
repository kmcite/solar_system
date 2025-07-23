// import 'dart:async';

// import 'package:faker/faker.dart';
// import 'package:signals_flutter/signals_core.dart';

// final panels = mapSignal<String, Panel>({});
// final maximumNumberOfPanels = signal(6);
// final currentPanelId = signal<String?>(null);

// final powerCapacityOfPanels = computed(
//   () => panels.values.fold(
//     0,
//     (p, n) => p + n.power(),
//   ),
//   debugLabel: 'powerCapacityOfPanels',
// );

// final getPanel = computed<Panel?>(
//   () {
//     if (currentPanelId() == null) return null;
//     return panels[currentPanelId()];
//   },
//   debugLabel: currentPanelId(),
// );

// class Panel {
//   String id = faker.guid.guid();
//   String company = faker.company.name();
//   final power = signal(580);
//   Timer? timer;
//   Panel() {
//     timer = Timer.periodic(
//       Duration(seconds: 1),
//       (_) {
//         power.value--;
//       },
//     );
//   }
// }

// void put_panel(Panel panel) {
//   batch(
//     () {
//       if (panels.containsKey(panel.id)) {
//         panels[panel.id] = panel;
//       } else if (panels.length >= maximumNumberOfPanels()) {
//         throw Exception('Max panels capacity reached');
//       } else {
//         panels[panel.id] = panel;
//       }
//     },
//   );
// }

// Panel? get_panel(String id) {
//   return panels()[id];
// }

// void remove_panel(Panel panel) {
//   panels.remove(panel.id);
//   print("${panel.id} removed");
// }
