import 'package:hive_flutter/hive_flutter.dart';
import 'package:solar_system/main.dart';

abstract class PersistRepository<T> extends Repository<T> {
  late final box = locator.serve<Box>();
  @override
  Future<void> init() {
    final cache = fromCache();
    if (cache != null) {
      emit(cache);
    }
    return super.init();
  }

  PersistRepository(T initialValue) : super(initialValue);

  String get key;
  T fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson(T value);

  @override
  void emit(T state) {
    super.emit(state);
    try {
      box.put(key, jsonEncode(toJson(state)));
    } catch (e) {
      print(e);
    }
  }

  T? fromCache() {
    try {
      return fromJson(jsonDecode(box.get(key)));
    } catch (e) {
      return null;
    }
  }
}
