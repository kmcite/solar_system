import 'package:flutter/material.dart';
import 'package:manager/manager.dart';
import '../../domain/entities/panels.dart';
import '../../domain/repositories/panels_repository.dart';
import '../../utils/router.dart';

/// Provider for managing add panel dialog state
class AddPanelDialogProvider extends ChangeNotifier {
  late final IPanelsRepository _panelsRepository;

  AddPanelDialogProvider() {
    _panelsRepository = find<IPanelsRepository>();
  }

  Future<void> addPanel({
    required String id,
    required double maxOutput,
    required double currentOutput,
  }) async {
    // Ensure current output doesn't exceed max output
    final adjustedCurrentOutput = currentOutput > maxOutput
        ? maxOutput
        : currentOutput;

    final panel = Panel(
      id: id.trim(),
      maxOutput: maxOutput,
      currentOutput: adjustedCurrentOutput,
      isActive: true,
      lastUpdated: DateTime.now(),
    );

    await _panelsRepository.addPanel(panel);
  }
}

/// Dialog for adding a new solar panel
class AddPanelDialog extends StatelessWidget {
  const AddPanelDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Feature(
      created: () => AddPanelDialogProvider(),
      builder: (_, provider) {
        return _AddPanelDialogContent(provider: provider);
      },
    );
  }
}

class _AddPanelDialogContent extends StatefulWidget {
  final AddPanelDialogProvider provider;

  const _AddPanelDialogContent({required this.provider});

  @override
  State<_AddPanelDialogContent> createState() => _AddPanelDialogContentState();
}

class _AddPanelDialogContentState extends State<_AddPanelDialogContent> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _maxOutputController = TextEditingController(text: '1000');
  final _currentOutputController = TextEditingController(text: '0');

  PanelType _selectedType = PanelType.monocrystalline;
  int _wattage = 400; // Standard panel wattage

  @override
  void dispose() {
    _idController.dispose();
    _maxOutputController.dispose();
    _currentOutputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Solar Panel'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Panel ID
              TextFormField(
                controller: _idController,
                decoration: const InputDecoration(
                  labelText: 'Panel ID',
                  hintText: 'e.g., P001, Rooftop-1',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a panel ID';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Panel Type Selection
              Text(
                'Panel Type',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              ...PanelType.values.map(
                (type) => RadioListTile<PanelType>(
                  title: Text(type.displayName),
                  subtitle: Text(type.description),
                  value: type,
                  groupValue: _selectedType,
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value!;
                      // Update default wattage based on type
                      _wattage = type.defaultWattage;
                      _maxOutputController.text = _wattage.toString();
                    });
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Wattage Selection
              Text(
                'Panel Wattage',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [250, 300, 350, 400, 450, 500, 550, 600].map((
                  wattage,
                ) {
                  return FilterChip(
                    label: Text('${wattage}W'),
                    selected: _wattage == wattage,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _wattage = wattage;
                          _maxOutputController.text = wattage.toString();
                        });
                      }
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              // Max Output (editable)
              TextFormField(
                controller: _maxOutputController,
                decoration: const InputDecoration(
                  labelText: 'Maximum Output (W)',
                  hintText: 'e.g., 1000',
                  border: OutlineInputBorder(),
                  helperText: 'Maximum power this panel can generate',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final maxOutput = double.tryParse(value ?? '');
                  if (maxOutput == null || maxOutput <= 0) {
                    return 'Please enter a valid maximum output';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Current Output
              TextFormField(
                controller: _currentOutputController,
                decoration: const InputDecoration(
                  labelText: 'Current Output (W)',
                  hintText: 'e.g., 800',
                  border: OutlineInputBorder(),
                  helperText:
                      'Current power generation (leave 0 for new panels)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final currentOutput = double.tryParse(value ?? '');
                  if (currentOutput == null || currentOutput < 0) {
                    return 'Please enter a valid current output';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _addPanel,
          child: const Text('Add Panel'),
        ),
      ],
    );
  }

  void _addPanel() async {
    if (_formKey.currentState!.validate()) {
      final maxOutput = double.parse(_maxOutputController.text);
      final currentOutput = double.parse(_currentOutputController.text);

      await widget.provider.addPanel(
        id: _idController.text.trim(),
        maxOutput: maxOutput,
        currentOutput: currentOutput,
      );

      Navigator.of(context).pop();
    }
  }
}

/// Panel types with their characteristics
enum PanelType {
  monocrystalline('Monocrystalline', 'High efficiency, premium panels', 400),
  polycrystalline('Polycrystalline', 'Good efficiency, cost-effective', 350),
  thinFilm('Thin-Film', 'Flexible, lower efficiency', 250),
  bifacial('Bifacial', 'Dual-sided generation', 450),
  perc('PERC', 'Passivated emitter rear cell', 420)
  ;

  const PanelType(this.displayName, this.description, this.defaultWattage);

  final String displayName;
  final String description;
  final int defaultWattage;
}

/// Function to show the add panel dialog
void showAddPanelDialog(BuildContext context) {
  context.toDialog(const AddPanelDialog());
}
