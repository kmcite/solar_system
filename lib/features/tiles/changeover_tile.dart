import 'dart:async';

import 'package:flutter/material.dart';
import 'package:manager/manager.dart';
import 'package:solar_system/domain/entities/changeover.dart';
import '../../domain/repositories/changeover_repository.dart';
import '../common/base_tile.dart';
import '../controls/changeover_control.dart';

class ChangeoverTileProvider extends ChangeNotifier {
  late final IChangeoverRepository _changeoverRepository =
      find<IChangeoverRepository>();
  StreamSubscription<Changeover>? _subscription;

  ChangeoverTileProvider() {
    _subscription = _changeoverRepository.watch().listen(
      (changeover) {
        this.changeover = changeover;
        notifyListeners();
      },
    );
  }

  Changeover changeover = Changeover(id: 'id');

  @override
  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    super.dispose();
  }
}

class ChangeoverTile extends StatelessWidget {
  const ChangeoverTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Feature(
      created: () => ChangeoverTileProvider(),
      builder: (_, changeoverProvider) {
        final changeover = changeoverProvider.changeover;
        final currentSource = changeover.currentState;
        final isAutoMode = changeover.isAutoMode;

        return BaseTile(
          title: 'Power Source',
          icon: currentSource.icon,
          iconColor: currentSource.color,
          action: ChangeoverControl(),
          children: [
            Text('Source: ${currentSource.displayName}'),
            Text('Mode: ${isAutoMode ? 'Automatic' : 'Manual'}'),
            if (changeover.recentlySwitched)
              const Text(
                'Recently switched',
                style: TextStyle(color: Colors.orange, fontSize: 12),
              ),
            Container(
              height: 12,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.grey[300],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: currentSource.progress,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    currentSource.color,
                  ),
                  minHeight: 12,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
