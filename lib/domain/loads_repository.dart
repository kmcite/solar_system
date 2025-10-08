import 'package:faker/faker.dart';
import 'package:objectbox/objectbox.dart';
import 'package:solar_system/utils/crud_repository.dart';

@Entity()
class Load {
  var power = 50.0; // in Watts
  var isRunning = true;
  var name = faker.food.dish();

  @Id()
  int id = 0;
}

class LoadsRepository extends CrudRepository<Load> {
  int getId(Load item) => item.id;

  double get totalLoads {
    return value.fold(0.0, (sum, load) => sum + load.power);
  }

  double get runningLoads {
    return value.fold(0.0, (sum, load) {
      return sum + (load.isRunning ? load.power : 0);
    });
  }
}
