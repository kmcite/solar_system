import '../../main.dart';

final batteryBloc = BatteryBloc();

class BatteryBloc {}

class BatteryPage extends UI {
  @override
  Widget build(context) {
    return FScaffold(
      header: FHeader(title: Text('Battery Status')),
      content: Container(
        padding: EdgeInsets.all(16),
        child: Column(children: []),
      ),
    );
  }
}
