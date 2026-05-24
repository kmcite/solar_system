import 'package:solar_system/utils/notifier.dart';

final index = IndexNotifier();

class IndexNotifier extends Notifier<int> {
  IndexNotifier() : super(0);
  void onIndexChanged(int index) {
    state = index;
  }
}
