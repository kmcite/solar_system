import 'package:objectbox/objectbox.dart';

@Entity()
class Load {
  @Id()
  int id = 0;
  int powerUsage = 0;
  String name = 'Unknown';
}
