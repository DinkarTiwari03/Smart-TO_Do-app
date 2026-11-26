import 'package:flutter/material.dart';
import '../theme/app_dimensions.dart';

class AcademicCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final BorderSide? borderSide;

  const AcademicCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.backgroundColor,
    this.borderSide,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final card = Card(
      color: backgroundColor ?? theme.cardTheme.color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        side: borderSide ??
            BorderSide(
              color: theme.colorScheme.outline,
              width: AppDimensions.cardBorderWidth,
            ),
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(AppDimensions.space16),
        child: child,
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        child: card,
      );
    }

    return card;
  }
}
