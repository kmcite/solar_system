/// Power balance calculation result
class PowerBalance {
  final double generation;
  final double consumption;
  final double netPower;
  final double batteryCurrent;
  final bool shouldChargeBattery;
  final bool shouldDischargeBattery;

  const PowerBalance({
    required this.generation,
    required this.consumption,
    required this.netPower,
    required this.batteryCurrent,
    required this.shouldChargeBattery,
    required this.shouldDischargeBattery,
  });

  @override
  String toString() {
    return 'PowerBalance(gen: ${generation.toStringAsFixed(1)}W, '
        'cons: ${consumption.toStringAsFixed(1)}W, '
        'net: ${netPower.toStringAsFixed(1)}W, '
        'battery: ${batteryCurrent.toStringAsFixed(2)}A)';
  }
}
