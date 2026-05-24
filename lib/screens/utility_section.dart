import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:solar_system/business/money.dart';
import 'package:solar_system/business/utility.dart';
import 'package:solar_system/screens/game_screen.dart';
import 'package:solar_system/utils/builder.dart';

const _presetAmounts = [10.0, 50.0, 100.0, 500.0];

Widget utilitySection() => listenTo(
  [utility, money],
  (context) {
    // UTILITY
    final status = utility.status;
    final remainingTime = utility.remainingTime;
    final power = utility.power;
    // MONEY
    final moneyState = money();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with title and switch
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Utility',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                Switch.adaptive(
                  value: utility.status,
                  onChanged: utility.toggleUtility,
                  activeColor: CupertinoColors.systemGreen,
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Status indicators
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: status
                    ? CupertinoColors.systemGreen.withOpacity(0.1)
                    : CupertinoColors.systemRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.power,
                    size: 20,
                    color: status
                        ? CupertinoColors.systemGreen
                        : CupertinoColors.systemRed,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    status ? 'Connected' : 'Disconnected',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: status
                          ? CupertinoColors.systemGreen
                          : CupertinoColors.systemRed,
                    ),
                  ),
                  if (status) ...[
                    const Spacer(),
                    IconValue(
                      icon: CupertinoIcons.time,
                      value: '${remainingTime}s',
                      iconColor: CupertinoColors.systemTeal,
                    ),
                    const SizedBox(width: 12),
                    IconValue(
                      icon: CupertinoIcons.bolt,
                      value: '${power.toStringAsFixed(0)}W',
                      iconColor: CupertinoColors.systemYellow,
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Purchase chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.start,
              children: _presetAmounts.map((amount) {
                final canBuy = moneyState >= amount;
                return ActionChip(
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  backgroundColor: canBuy
                      ? CupertinoColors.systemBlue.withOpacity(0.1)
                      : Colors.grey.shade200,
                  side: BorderSide.none,
                  onPressed: canBuy
                      ? () {
                          purchaseUtility(amount);
                          money.debit(amount);
                        }
                      : null,
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.add,
                        size: 16,
                        color: canBuy
                            ? CupertinoColors.systemBlue
                            : Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${amount.toStringAsFixed(0)}₨',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: canBuy
                              ? CupertinoColors.systemBlue
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  },
);
