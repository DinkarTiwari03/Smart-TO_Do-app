import 'package:flutter/material.dart';
import '../theme/app_dimensions.dart';

class AcademicButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isPrimary;
  final bool isLoading;

  const AcademicButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isPrimary = true,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: SizedBox(
          height: AppDimensions.minTouchTarget,
          width: AppDimensions.minTouchTarget,
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.space12),
            child: CircularProgressIndicator(strokeWidth: 2.5),
          ),
        ),
      );
    }

    if (isPrimary) {
      if (icon != null) {
        return ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: 20),
          label: Text(label),
        );
      }
      return ElevatedButton(
        onPressed: onPressed,
        child: Text(label),
      );
    }

    if (icon != null) {
      return OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(label),
      );
    }
    return OutlinedButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
