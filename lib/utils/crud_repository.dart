import 'dart:async';
import 'package:objectbox/objectbox.dart';
import 'package:solar_system/main.dart';

abstract class CrudRepository<T> extends Repository<Iterable<T>> {
  CrudRepository() : super([]);

  int getId(T item);
  @override
  Future<void> init() async {
    emit(box.getAll());
  }

  Future<void> put(T item) async {
    await box.putAsync(item);
    emit(await box.getAllAsync());
  }

  Future<void> remove(T item) async {
    await box.removeAsync(getId(item));
    emit(await box.getAllAsync());
  }

  Future<void> removeAll() async {
    await box.removeAllAsync();
    emit(await box.getAllAsync());
  }

  late final store = serve<Store>();
  late final box = store.box<T>();
}
