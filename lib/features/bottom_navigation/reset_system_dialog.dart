import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:manager/manager.dart';
import 'package:solar_system/domain/repositories/home_repository.dart';

class ResetSystemProvider extends ChangeNotifier {
  late final IHomeRepository _homeRepository = find();

  Future<void> resetDevices() => _homeRepository.resetDevices();
}

class ResetSystemDialog extends StatelessWidget {
  const ResetSystemDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Feature(
      created: () => ResetSystemProvider(),
      builder: (_, provider) {
        return AlertDialog(
          title: const Text('Reset System'),
          content: const Text(
            'Are you sure you want to reset all system data?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Reset home provider devices
                await provider.resetDevices();
                context.pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }
}
