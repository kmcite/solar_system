// import 'package:objectbox/objectbox.dart';
import 'package:faker/faker.dart';

// @Entity()
class Panel {
  // @Id()
  int id = faker.randomGenerator.integer(10000);
  double power = 580;
}
