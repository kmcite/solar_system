import 'package:solar_system/main.dart';

final darkRepository = DarkRepository();

class DarkRepository {
  final darkRM = true.inj();
  bool get dark => darkRM.state;
  late final toggleDark = darkRM.toggle;
}
