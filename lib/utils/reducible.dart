// import 'dart:async';
// import 'dart:developer' as developer;
// import 'package:solar_system/main.dart';

// /// A type representing the result of an operation that can be in one of three states:
// /// - [Ok]: Contains a successful value of type [T]
// /// - [Error]: Contains an error and optional stack trace
// /// - [Loading]: Represents a loading/processing state
// sealed class Result<T> {
//   const Result();
//   factory Result.ok(T value) => Ok(value);
//   factory Result.error(Object error, [StackTrace? st]) => Error(error, st);
//   factory Result.loading() => Loading();

//   bool get isOk => this is Ok<T>;
//   bool get isError => this is Error<T>;
//   bool get isLoading => this is Loading<T>;

//   /// Get the value if available, otherwise null
//   T? get valueOrNull => isOk ? (this as Ok<T>).value : null;

//   /// Get the error if available, otherwise null
//   Object? get errorOrNull => isError ? (this as Error<T>).error : null;

//   /// Get the stack trace if in error state, otherwise null
//   StackTrace? get stackTraceOrNull =>
//       isError ? (this as Error<T>).stackTrace : null;

//   /// Get the value or throw if not available
//   T get requireValue {
//     if (isOk) return (this as Ok<T>).value;
//     if (isError) throw (this as Error<T>).error;
//     throw StateError('Value not available - still loading');
//   }

//   /// Pattern matching for the result
//   R when<R>({
//     required R Function() loading,
//     required R Function(T value) ok,
//     required R Function(Object error, StackTrace? stackTrace) error,
//   }) {
//     return switch (this) {
//       Ok(value: final value) => ok(value),
//       Error(error: final e, stackTrace: final s) => error(e, s),
//       Loading() => loading(),
//     };
//   }

//   Widget build({
//     required Widget Function(T value) ok,
//     Widget Function()? loading,
//     Widget Function(Object error, StackTrace? stackTrace)? error,
//   }) {
//     return when(
//       loading: () =>
//           loading?.call() ??
//           Center(
//             child: CircularProgressIndicator(),
//           ),
//       ok: ok,
//       error: (e, st) => error?.call(e, st) ?? Text(e.toString()),
//     );
//   }

//   /// Pattern matching with optional callbacks
//   void whenOrNull({
//     void Function()? loading,
//     void Function(T value)? ok,
//     void Function(Object error, StackTrace? stackTrace)? error,
//   }) {
//     switch (this) {
//       case Ok(value: final value):
//         ok?.call(value);
//       case Error(error: final e, stackTrace: final s):
//         error?.call(e, s);
//       case Loading():
//         loading?.call();
//     }
//   }

//   /// Transform the value if this is an Ok result
//   Result<R> mapOk<R>(R Function(T) transform) {
//     return when(
//       loading: () => const Loading(),
//       ok: (value) => Ok(transform(value)),
//       error: (error, stackTrace) => Error(error, stackTrace),
//     );
//   }
// }

// /// Represents a successful result containing a value
// class Ok<T> extends Result<T> {
//   final T value;
//   const Ok(this.value);
// }

// /// Represents a failed result containing an error
// class Error<T> extends Result<T> {
//   final Object error;
//   final StackTrace? stackTrace;
//   const Error(this.error, [this.stackTrace]);
// }

// /// Represents a loading/processing state
// class Loading<T> extends Result<T> {
//   const Loading();
// }

// /// Base class for state management with message handling
// abstract class Reducible<Message, State> {
//   final _stateStream = StreamController<Result<State>>.broadcast();
//   final _messageStream = StreamController<Message>.broadcast();

//   /// Current state
//   Result<State> _state = const Loading();
//   Result<State> get state => _state;

//   /// Stream of state updates
//   Stream<Result<State>> get watch => _stateStream.stream;

//   /// Initialize the state
//   Future<void> initialize() async {
//     try {
//       _emit(const Loading());
//       final initialState = await init();
//       _emit(Ok(initialState));
//     } catch (error, stack) {
//       _emit(Error(error, stack));
//       developer.log('Initialization failed', error: error, stackTrace: stack);
//     }

//     _messageStream.stream.listen(_processMessage);
//   }

//   /// Process an incoming message
//   Future<void> _processMessage(Message message) async {
//     try {
//       final newState = await reduce(message);
//       _emit(Ok(newState));
//     } catch (error, stack) {
//       _emit(Error(error, stack));
//       developer.log('Error processing message',
//           error: error, stackTrace: stack);
//     }
//   }

//   /// Emit a new state
//   void _emit(Result<State> result) {
//     _state = result;
//     _stateStream.add(result);
//   }

//   /// Send a message to be processed
//   void send(Message message) {
//     _messageStream.add(message);
//   }

//   /// Initialize the state
//   Future<State> init();

//   /// Process a message and return a new state
//   Future<State> reduce(Message message);

//   /// Clean up resources
//   Future<void> dispose() async {
//     await _stateStream.close();
//     await _messageStream.close();
//   }
// }

// /// Extension for handling results in a more functional style
// extension ResultX<T> on Result<T> {
//   /// Handle errors
//   Result<T> handleError(Result<T> Function(Object, StackTrace?) handler) {
//     if (isError) {
//       return handler(errorOrNull!, stackTraceOrNull);
//     }
//     return this;
//   }
// }

// /// A complete MVI implementation with support for side effects
// abstract class EffectiveReducible<Message, State, Effect> {
//   final _stateStream = StreamController<Result<State>>.broadcast();
//   final _messageStream = StreamController<Message>.broadcast();
//   final _effectStream = StreamController<Effect>.broadcast();

//   /// Current state
//   Result<State> _state = const Loading();
//   Result<State> get state => _state;

//   /// Stream of state updates
//   Stream<Result<State>> get watch => _stateStream.stream;

//   /// Stream of effects
//   Stream<Effect> get effects => _effectStream.stream;

//   /// Initialize the state
//   Future<void> initialize() async {
//     try {
//       _emit(const Loading());
//       final initialState = await init();
//       _emit(Ok(initialState));
//     } catch (error, stack) {
//       _emit(Error(error, stack));
//       developer.log('Initialization failed', error: error, stackTrace: stack);
//     }

//     _messageStream.stream.listen(_processMessage);
//   }

//   /// Process an incoming message
//   Future<void> _processMessage(Message message) async {
//     try {
//       final newState = await reduce(message);
//       _emit(Ok(newState));
//     } catch (error, stack) {
//       _emit(Error(error, stack));
//       developer.log('Error processing message',
//           error: error, stackTrace: stack);
//     }
//   }

//   /// Emit a new state
//   void _emit(Result<State> result) {
//     _state = result;
//     _stateStream.add(result);
//   }

//   /// Emit a side effect
//   void emitEffect(Effect effect) {
//     _effectStream.add(effect);
//   }

//   /// Send a message to be processed
//   void send(Message message) {
//     _messageStream.add(message);
//   }

//   /// Initialize the state
//   @mustCallSuper
//   Future<State> init() async {
//     throw UnimplementedError('init() must be implemented');
//   }

//   /// Process a message and return a new state
//   @mustCallSuper
//   Future<State> reduce(Message message) async {
//     throw UnimplementedError('reduce() must be implemented');
//   }

//   /// Clean up resources
//   @mustCallSuper
//   Future<void> dispose() async {
//     await _stateStream.close();
//     await _messageStream.close();
//     await _effectStream.close();
//   }
// }
