import 'dart:async';

import 'package:solar_system/main.dart';

class Settings {
  bool dark = false;
  bool isRestored = true;
  double money = 12000;

  Settings();
  Settings.fromJson(Map<String, dynamic> json) {
    dark = json['dark'] ?? false;
    isRestored = json['isRestored'] ?? true;
    money = json['money'] ?? 12000;
  }

  Map<String, dynamic> toJson() => {
    'dark': dark,
    'isRestored': isRestored,
    'money': money,
  };
}

class SettingsRepository extends Repository<Settings> {
  SettingsRepository() : super(Settings());
  // @override
  // Future<void> init() {
  //   final from = fromCache();
  //   if (from != null) {
  //     emit(from);
  //   }
  //   // print(from?.toJson());
  //   return super.init();
  // }

  void restoreApp() {
    emit(state..isRestored = true);
  }

  Future<void> toggleDark() async {
    emit(state..dark = !state.dark);
  }

  Future<void> setMoney(double newMoney) async {
    emit(state..money = newMoney);
  }

  Future<void> addMoney(double more) async {
    setMoney(state.money + more);
  }

  // @override
  // Settings fromJson(Map<String, dynamic> json) => Settings.fromJson(json);

  // @override
  // String get key => 'settings';

  // @override
  // Map<String, dynamic> toJson(Settings value) => value.toJson();
}
