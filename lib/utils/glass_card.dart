import 'package:flutter/material.dart';
import 'ui_helpers.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final Color? glowColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Gradient? gradient;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.glowColor,
    this.padding,
    this.margin,
    this.borderRadius = AppSpacing.cardRadius,
    this.gradient,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient:
            gradient ??
            (isDark
                ? LinearGradient(
                    colors: [
                      AppColors.cardDark.withValues(alpha: 0.85),
                      AppColors.cardDark.withValues(alpha: 0.65),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null),
        color: isDark ? null : theme.colorScheme.surfaceContainerLow,
        border: Border.all(
          color:
              glowColor?.withValues(alpha: 0.2) ??
              (isDark
                  ? AppColors.cardDarkBorder.withValues(alpha: 0.5)
                  : Colors.grey.withValues(alpha: 0.15)),
          width: 1,
        ),
        boxShadow: glowColor != null
            ? AppShadows.glowSmall(glowColor!)
            : (isDark
                  ? AppShadows.cardShadow
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ]),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(AppSpacing.cardPadding),
            child: child,
          ),
        ),
      ),
    );
  }
}
