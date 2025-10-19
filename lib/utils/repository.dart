// import 'dart:async';

// import 'package:solar_system/main.dart';

// abstract class Repository<T> {
//   final _controller = StreamController<T>.broadcast();
//   StreamSubscription<T>? _subscription;
//   Repository(this._value) {
//     _subscription = _controller.stream.listen(
//       (event) {
//         _value = event;
//       },
//     );
//     init();
//   }

//   /// optional async setup (network, load cache, etc.)
//   Future<void> init() async {}

//   late T _value;

//   /// current snapshot
//   T get value => _value;
//   T call() => _value;

//   /// expose stream of unwrapped values
//   Stream<T> get stream => _controller.stream;

//   /// Send a new value and store it locally
//   void emit(T value) {
//     if (shouldUpdate(_value, value)) {
//       _controller.add(value);
//     }
//   }

//   /// override this if you want to skip identical updates
//   bool shouldUpdate(T oldValue, T newValue) => true;

//   /// generic DI / locator hook
//   S serve<S extends Object>() => locator.serve<S>();

//   /// cleanup
//   Future<void> close() async {
//     await _subscription?.cancel();
//     await _controller.close();
//     _subscription = null;
//   }
// }
