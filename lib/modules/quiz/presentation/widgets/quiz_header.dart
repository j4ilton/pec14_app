import 'package:flutter/material.dart';
import '../../../../design_system/app_theme.dart';

class QuizHeader extends StatelessWidget {
  final int current;
  final int total;

  const QuizHeader({super.key, required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : current / total;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Estudo Dirigido', style: Theme.of(context).textTheme.titleLarge),
        SizedBox(height: context.dsSpacing(6)),
        Text(
          'Questão $current de $total',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
        ),
        SizedBox(height: context.dsSpacing(10)),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadii.sm),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: Colors.grey.shade200,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
