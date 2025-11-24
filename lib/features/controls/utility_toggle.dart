import 'dart:async';

import 'package:flutter/material.dart';
import 'package:manager/manager.dart';
import '../../domain/entities/utility.dart';
import '../../domain/repositories/utility_repository.dart';

class UtilityToggleProvider extends ChangeNotifier {
  late final IUtilityRepository _utilityRepository = find<IUtilityRepository>();
  StreamSubscription<Utility>? _subscription;

  Utility _utility = Utility(id: 'main_utility');

  UtilityToggleProvider() {
    _subscription = _utilityRepository.watchUtility().listen((utility) {
      _utility = utility;
      notifyListeners();
    });
  }

  bool get isOnline => _utility.isOnline;

  void setStatus(bool value) {
    _utilityRepository.setOnlineStatus(value);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

class UtilityToggle extends StatelessWidget {
  const UtilityToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return Feature(
      created: () => UtilityToggleProvider(),
      builder: (_, provider) {
        final isOnline = provider.isOnline;

        return Switch(
          value: isOnline,
          onChanged: (value) {
            provider.setStatus(value);
          },
          activeColor: Colors.blue,
        );
      },
    );
  }
}
