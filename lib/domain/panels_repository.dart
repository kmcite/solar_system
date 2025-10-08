import 'package:faker/faker.dart';
import 'package:objectbox/objectbox.dart';
import 'package:solar_system/utils/crud_repository.dart';

@Entity()
class Panel {
  @Id()
  int id = 0;
  var power = faker.randomGenerator.decimal(scale: 40, min: 560);
}

class PanelsRepository extends CrudRepository<Panel> {
  double get totalPower => value.fold(0.0, (i, n) => i + n.power);
  double effectivePower(double solarFlow) => solarFlow * totalPower;

  @override
  int getId(Panel item) => item.id;
}
