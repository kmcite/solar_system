import 'package:solar_system/main.dart';

final darkRepository = DarkRepository();

class DarkRepository {
  final darkRM = false.inj();
  bool get dark => darkRM.state;
  late final toggleDark = darkRM.toggle;
}
