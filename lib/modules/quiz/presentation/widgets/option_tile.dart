import 'package:flutter/material.dart';
import '../../../../design_system/app_theme.dart';

class OptionTile extends StatelessWidget {
  final String text;
  final bool isCorrect;
  final bool isSelected;
  final bool showFeedback;
  final VoidCallback onTap;

  const OptionTile({
    super.key,
    required this.text,
    required this.isCorrect,
    required this.isSelected,
    required this.showFeedback,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color border = Colors.grey.shade300;
    Color background = Colors.white;
    Color textColor = theme.colorScheme.onSurface;
    IconData? icon;
    Color? iconColor;

    if (showFeedback) {
      if (isCorrect) {
        border = AppColors.success;
        background = AppColors.success.withValues(alpha: 0.08);
        textColor = AppColors.success;
        icon = Icons.check_circle;
        iconColor = AppColors.success;
      } else if (isSelected) {
        border = AppColors.danger;
        background = AppColors.danger.withValues(alpha: 0.08);
        textColor = AppColors.danger;
        icon = Icons.cancel;
        iconColor = AppColors.danger;
      }
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadii.md),
      child: Ink(
        padding: EdgeInsets.all(context.dsSpacing(16)),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(AppRadii.md),
          border: Border.all(color: border, width: 1.5),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: theme.textTheme.bodyLarge?.copyWith(color: textColor),
              ),
            ),
            if (icon != null)
              Icon(icon, color: iconColor, size: context.dsSpacing(20)),
          ],
        ),
      ),
    );
  }
}
