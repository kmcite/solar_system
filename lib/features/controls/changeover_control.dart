import 'dart:async';

import 'package:flutter/material.dart';
import 'package:manager/manager.dart';
import 'package:solar_system/domain/repositories/changeover_repository.dart';
import 'package:solar_system/domain/entities/changeover.dart';

class ChangeoverControlProvider extends ChangeNotifier {
  late final IChangeoverRepository _changeoverRepository =
      find<IChangeoverRepository>();
  StreamSubscription<Changeover>? _subscription;

  Changeover _changeover = Changeover(id: 'main_changeover');

  ChangeoverControlProvider() {
    _subscription = _changeoverRepository.watchChangeover().listen((
      changeover,
    ) {
      _changeover = changeover;
      notifyListeners();
    });
  }

  bool get isAutoMode => _changeover.isAutoMode;

  void setAutomaticMode(bool value) {
    if (value != _changeover.isAutoMode) {
      _changeoverRepository.toggleAutoMode();
    }
  }

  void switchToState(ChangeoverState state) {
    _changeoverRepository.switchToState(state);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

class ChangeoverControl extends StatelessWidget {
  const ChangeoverControl({super.key});

  @override
  Widget build(BuildContext context) {
    return Feature(
      created: () => ChangeoverControlProvider(),
      builder: (_, provider) {
        final isAutoMode = provider.isAutoMode;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Switch(
              value: isAutoMode,
              onChanged: (value) {
                provider.setAutomaticMode(value);
              },
              activeColor: Colors.blue,
            ),
            const SizedBox(width: 4),
            PopupMenuButton<ChangeoverState>(
              icon: const Icon(Icons.more_vert, size: 16),
              onSelected: (state) {
                provider.switchToState(state);
              },
              itemBuilder: (context) => ChangeoverState.values.map((state) {
                return PopupMenuItem(
                  value: state,
                  child: Row(
                    children: [
                      Icon(state.icon),
                      const SizedBox(width: 8),
                      Text(state.displayName),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
