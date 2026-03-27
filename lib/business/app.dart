import 'package:signals/signals.dart';

// =============================================================================
// STATE
// =============================================================================
final darkMode = signal(true);
final money = signal(15000.0);
final appLoading = signal(true);
final appError = signal<String?>(null);
final appIndex = signal(0);

// =============================================================================
// ACTIONS
// =============================================================================
void toggleDarkMode() => darkMode.value = !darkMode.value;

void creditMoney(double amount) => money.value += amount;

void debitMoney(double amount) => money.value -= amount;

void setAppIndex(int index) => appIndex.value = index;

void initializeApp() {
  // FlutterNativeSplash.remove() will be called from main.dart
  appLoading.value = false;
}
