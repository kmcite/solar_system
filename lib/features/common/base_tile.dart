import 'package:flutter/material.dart';

/// Base tile widget used throughout the dashboard
class BaseTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Widget? action;
  final List<Widget> children;
  final VoidCallback? onTap;

  const BaseTile({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor,
    this.action,
    this.children = const [],
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    color: iconColor,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (action != null) action!,
                ],
              ),
              if (children.isNotEmpty) ...[
                const SizedBox(height: 12),
                ...children,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
