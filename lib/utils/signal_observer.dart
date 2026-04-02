import 'package:signals/signals.dart';

/// Observes all signals and computeds in the app, printing only non-Widget ones.
class SignalObserver extends SignalsObserver {
  @override
  void onComputedCreated<T>(Computed<T> instance) {
    // Filter out Widget-related computeds by checking the type/name
    final computedName = instance.runtimeType.toString();
    if (!_isWidgetRelated(computedName)) {
      print('[Computed Created] $computedName');
    }
  }

  @override
  void onComputedUpdated<T>(Computed<T> instance, T value) {
    final computedName = instance.runtimeType.toString();
    if (!_isWidgetRelated(computedName)) {
      print('[Computed Updated] $computedName = $value');
    }
  }

  @override
  void onSignalCreated<T>(Signal<T> instance, T value) {
    final signalName = instance.runtimeType.toString();
    if (!_isWidgetRelated(signalName)) {
      print('[Signal Created] $signalName = $value');
    }
  }

  @override
  void onSignalUpdated<T>(Signal<T> instance, T value) {
    final signalName = instance.runtimeType.toString();
    if (!_isWidgetRelated(signalName)) {
      print('[Signal Updated] $signalName = $value');
    }
  }

  /// Checks if a signal/computed is related to Flutter Widgets.
  /// Returns true for Widget types that should be filtered out.
  bool _isWidgetRelated(String typeName) {
    // Common Flutter Widget-related patterns to filter out
    const widgetPatterns = [
      'Watch',
      'Effect',
      'Widget',
      'Stateless',
      'Stateful',
      'BuildContext',
      'InheritedWidget',
    ];

    return widgetPatterns.any(
      (pattern) => typeName.contains(pattern),
    );
  }
}
