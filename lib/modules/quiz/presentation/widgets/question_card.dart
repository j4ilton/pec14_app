import 'package:flutter/material.dart';
import '../../../../design_system/app_theme.dart';

class QuestionCard extends StatelessWidget {
  final String text;

  const QuestionCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: EdgeInsets.all(context.dsSpacing(20)),
        child: Text(
          text,
          style: theme.textTheme.titleMedium?.copyWith(height: 1.35),
        ),
      ),
    );
  }
}
