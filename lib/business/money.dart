import 'package:solar_system/utils/notifier.dart';

final money = MoneyNotifier();

class MoneyNotifier extends Notifier<num> {
  MoneyNotifier() : super(100000);

  void onBalanceChanged(num balance) => state = balance;

  void credit(double amount) => onBalanceChanged(state + amount);
  void debit(double amount) => onBalanceChanged(state - amount);
}
