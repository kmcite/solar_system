import 'package:solar_system/main.dart';
import 'package:solar_system/features/dashboard/appBar/dark_mode_toggle.dart';
import 'package:solar_system/features/dashboard/appBar/flow_toggle.dart';
import 'package:solar_system/features/settings/settings.dart';

Widget appBar() {
  return FHeader(
    title: 'Solar+'.text(),
    suffixes: [
      FlowTogglesView(),
      DarkModeToggle(),
      FHeaderAction(
        icon: Icon(FIcons.settings),
        onPress: () => navigator.to(SettingsPage()),
      ),
    ],
  );
}
