import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/repositories/utility_repository_impl.dart';

class UtilityToggle extends StatelessWidget {
  const UtilityToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final utilityRepo = context.watch<UtilityRepositoryImpl>();
    final isOnline = utilityRepo.status;

    return Switch(
      value: isOnline,
      onChanged: (value) {
        utilityRepo.setStatus(value);
      },
      activeColor: Colors.blue,
    );
  }
}
