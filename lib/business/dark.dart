import 'package:solar_system/utils/notifier.dart';

final dark = DarkNotifier();

class DarkNotifier extends Notifier<bool> {
  DarkNotifier() : super(false);
  void onDarkChanged(bool dark) {
    value = dark;
  }

  void toggleDark() => onDarkChanged(!value);
}
