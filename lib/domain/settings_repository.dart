import 'dart:async';

import 'package:solar_system/utils/persist_repository.dart';

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

class SettingsRepository extends PersistRepository<Settings> {
  SettingsRepository() : super(Settings());
  @override
  Future<void> init() {
    final from = fromCache();
    if (from != null) {
      emit(from);
    }
    // print(from?.toJson());
    return super.init();
  }

  void restoreApp() {
    emit(value..isRestored = true);
  }

  Future<void> toggleDark() async {
    emit(value..dark = !value.dark);
  }

  Future<void> setMoney(double newMoney) async {
    emit(value..money = newMoney);
  }

  Future<void> addMoney(double more) async {
    setMoney(value.money + more);
  }

  @override
  Settings fromJson(Map<String, dynamic> json) => Settings.fromJson(json);

  @override
  String get key => 'settings';

  @override
  Map<String, dynamic> toJson(Settings value) => value.toJson();
}
