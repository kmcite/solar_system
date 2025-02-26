import 'package:equatable/equatable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:solar_system/main.dart';
import 'package:solar_system/navigator.dart';

final inverterBloc = InverterBloc();

class InverterState extends Equatable {
  final bool status;
  final int usage; // in Units
  const InverterState({this.status = false, this.usage = 0});

  InverterState copyWith({bool? status, int? usage}) {
    return InverterState(
      status: status ?? this.status,
      usage: usage ?? this.usage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'status': status, 'usage': usage};
  }

  factory InverterState.fromMap(Map<String, dynamic> map) {
    return InverterState(
      status: (map['status'] ?? false) as bool,
      usage: (map['usage'] ?? 0) as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory InverterState.fromJson(String source) =>
      InverterState.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [status, usage];
}

class InverterBloc {
  InverterState get state => inverterRM.state;
  final inverterRM = RM.inject(() => InverterState());
  bool get status => state.status;
  int get usage => state.usage;
  int get capacity {
    return inverterRepository.capacity;
  }

  bool get upgradable => inverterRepository.upgradable;
  void upgrade() {
    inverterRepository.upgradeCapacity(100);
  }

  void toggleInverter() =>
      inverterRM.state = state.copyWith(status: !status);
}

class InverterPage extends UI {
  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        prefixActions: [FHeaderAction.back(onPress: navigator.back)],
        suffixActions: [
          FHeaderAction(
            onPress: () {
              inverterBloc.toggleInverter();
            },
            icon:
                inverterBloc.status
                    ? FAssets.icons.toggleLeft()
                    : FAssets.icons.toggleRight(),
          ),
        ],
        title: Text('Inverter Status'),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FaIcon(FontAwesomeIcons.plugCircleBolt, size: 150).pad(),
          "capacity: ${inverterBloc.capacity} watts"
              .text(
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              )
              .pad(),
          "usage: ${inverterBloc.usage} Units"
              .text(
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              )
              .pad(),
          Row(
            children: [
              FButton.icon(
                onPress: () {
                  inverterBloc.toggleInverter();
                },
                child:
                    inverterBloc.status
                        ? FAssets.icons.toggleLeft(width: 60)
                        : FAssets.icons.toggleRight(height: 60),
              ).pad(),
              FButton.icon(
                onPress:
                    inverterBloc.upgradable
                        ? () => inverterBloc.upgrade()
                        : null,
                child: FAssets.icons.userPlus(width: 60),
              ).pad(),
            ],
          ),
        ],
      ),
    );
  }
}
