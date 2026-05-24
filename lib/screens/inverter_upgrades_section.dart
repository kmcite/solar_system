import 'package:flutter/cupertino.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:solar_system/business/inverter_upgrades.dart';
import 'package:solar_system/business/money.dart';

class InverterUpgradesSection extends StatelessWidget {
  const InverterUpgradesSection();

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final current = currentInverterUpgrade.value;
      final nextUpgrade = nextInverterUpgrade.value;
      final moneyState = money();
      final canUpgrade = nextUpgrade != null && moneyState >= nextUpgrade.cost;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Icon(
              CupertinoIcons.bolt,
              size: 20,
              color: CupertinoColors.systemYellow,
            ),
            const SizedBox(width: 8),
            Text(
              '${current.watt.toStringAsFixed(0)}W ${current.tier.label}',
              style: const TextStyle(fontSize: 12),
            ),
            if (nextUpgrade != null) ...[
              const SizedBox(width: 8),
              Icon(
                CupertinoIcons.arrow_right,
                size: 14,
                color: CupertinoColors.systemGrey,
              ),
              const SizedBox(width: 8),
              Text(
                '${nextUpgrade.watt.toStringAsFixed(0)}W ${nextUpgrade.tier.label}',
                style: TextStyle(
                  fontSize: 12,
                  color: CupertinoColors.systemGreen,
                ),
              ),
              const Spacer(),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: canUpgrade
                    ? () {
                        purchaseInverterUpgrade(nextUpgrade.id);
                        money.debit(nextUpgrade.cost.toDouble());
                      }
                    : null,
                child: Text('₨${nextUpgrade.cost}'),
              ),
            ] else ...[
              const Spacer(),
              Text(
                'MAX',
                style: TextStyle(
                  fontSize: 12,
                  color: CupertinoColors.systemGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      );
    });
  }
}
