import 'package:flutter/material.dart';
import '../../../design_system/app_theme.dart';
import '../../domain/quiz_source.dart';

class ExplanationCard extends StatelessWidget {
  final String explanation;
  final QuizSource source;

  const ExplanationCard({
    super.key,
    required this.explanation,
    required this.source,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: AppColors.info.withValues(alpha: 0.08),
      child: Padding(
        padding: EdgeInsets.all(context.dsSpacing(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.info),
                SizedBox(width: context.dsSpacing(8)),
                Text(
                  'Por que essa é a resposta?',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: AppColors.info,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(height: context.dsSpacing(8)),
            Text(
              explanation,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                height: 1.4,
              ),
            ),
            SizedBox(height: context.dsSpacing(10)),
            Text(
              _formatSource(),
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatSource() {
    final obs = source.observacao;
    if (obs != null && obs.isNotEmpty) {
      return 'Fonte: ${source.documento}, p. ${source.pagina} ($obs)';
    }
    return 'Fonte: ${source.documento}, p. ${source.pagina}';
  }
}
