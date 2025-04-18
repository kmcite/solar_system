import 'package:objectbox/objectbox.dart';

@Entity()
class Panel {
  @Id()
  int id = 0;
  int powerCapacity = 580;
}
