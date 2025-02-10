import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:manager/manager.dart';
import 'package:solar_system/main.dart';

final borderRadius = BorderRadius.circular(8);

class UtilityPage extends UI {
  const UtilityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Utility Dashboard'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                margin: const EdgeInsets.all(16),
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: borderRadius),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: const FaIcon(
                          FontAwesomeIcons.boltLightning,
                          size: 80,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'WAPDA - PESCO',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: borderRadius),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(
                        'Current Usage',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Text(
                      //   '${utilityBloc.usage()} kWh',
                      //   style: const TextStyle(
                      //     fontSize: 32,
                      //     fontWeight: FontWeight.bold,
                      //     color: Colors.blue,
                      //   ),
                      // ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Power Status',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Switch(
                            value: utilityBloc.utility.isPoweringLoads,
                            onChanged: (_) => utilityBloc.toggle(),
                            activeColor: Colors.blue,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Wrap(
                      //   // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //   children: [
                      //     _buildInfoCard(
                      //         'Voltage', '${utilityBloc.voltage()}V'),
                      //     _buildInfoCard(
                      //         'Current', '${utilityBloc.current()}A'),
                      //     _buildInfoCard(
                      //         'Power', '${utilityBloc.utility.power}W'),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildInfoCard(String title, String value) {
  //   return Container(
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: Colors.blue.shade50,
  //       borderRadius: borderRadius,
  //     ),
  //     child: Column(
  //       children: [
  //         Text(
  //           title,
  //           style: TextStyle(
  //             fontSize: 14,
  //             color: Colors.grey.shade600,
  //           ),
  //         ),
  //         const SizedBox(height: 4),
  //         Text(
  //           value,
  //           style: const TextStyle(
  //             fontSize: 18,
  //             fontWeight: FontWeight.bold,
  //             color: Colors.blue,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
