import 'package:flutter/foundation.dart';

class Notifier<T> extends ChangeNotifier {
  Notifier(this._value);
  T _value;
  T get value => _value;
  set value(T newValue) {
    _value = newValue;
    notify();
  }

  T get state => _value;
  set state(T newState) {
    _value = newState;
    notify();
  }

  T call([T Function()? setter]) {
    if (setter != null) {
      value = setter();
      notify();
    }
    return value;
  }

  void notify() => notifyListeners();
}
