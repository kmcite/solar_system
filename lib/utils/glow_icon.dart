import 'package:flutter/material.dart';

class GlowIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final double glowRadius;

  const GlowIcon({
    super.key,
    required this.icon,
    required this.color,
    this.size = 24,
    this.glowRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.35),
            blurRadius: glowRadius,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Icon(icon, color: color, size: size),
    );
  }
}
