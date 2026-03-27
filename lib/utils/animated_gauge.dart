import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedGauge extends StatelessWidget {
  final double value; // 0.0 to 1.0
  final double size;
  final double strokeWidth;
  final Color activeColor;
  final Color? inactiveColor;
  final Widget? center;
  final Color? glowColor;

  const AnimatedGauge({
    super.key,
    required this.value,
    this.size = 120,
    this.strokeWidth = 10,
    this.activeColor = const Color(0xFF10B981),
    this.inactiveColor,
    this.center,
    this.glowColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor =
        inactiveColor ??
        (isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.grey.withValues(alpha: 0.15));

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value.clamp(0.0, 1.0)),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (context, animatedValue, child) {
        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(size, size),
                painter: _GaugePainter(
                  value: animatedValue,
                  strokeWidth: strokeWidth,
                  activeColor: activeColor,
                  inactiveColor: bgColor,
                  glowColor: glowColor ?? activeColor,
                ),
              ),
              if (center != null) center!,
            ],
          ),
        );
      },
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double value;
  final double strokeWidth;
  final Color activeColor;
  final Color inactiveColor;
  final Color glowColor;

  _GaugePainter({
    required this.value,
    required this.strokeWidth,
    required this.activeColor,
    required this.inactiveColor,
    required this.glowColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    const startAngle = -pi * 0.75; // Start from bottom-left (225 degrees)
    const sweepAngle = pi * 1.5; // Sweep 270 degrees

    // Background arc
    final bgPaint = Paint()
      ..color = inactiveColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      bgPaint,
    );

    // Active arc
    if (value > 0) {
      final activePaint = Paint()
        ..shader = SweepGradient(
          startAngle: startAngle,
          endAngle: startAngle + sweepAngle * value,
          colors: [activeColor.withValues(alpha: 0.7), activeColor],
        ).createShader(Rect.fromCircle(center: center, radius: radius))
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      // Glow effect
      final glowPaint = Paint()
        ..color = glowColor.withValues(alpha: 0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + 6
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle * value,
        false,
        glowPaint,
      );

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle * value,
        false,
        activePaint,
      );
    }
  }

  @override
  bool shouldRepaint(_GaugePainter oldDelegate) =>
      value != oldDelegate.value || activeColor != oldDelegate.activeColor;
}
