import 'package:flutter/material.dart';
import '../../../../design_system/app_theme.dart';

class ResultPanel extends StatelessWidget {
  final int score;
  final int total;
  final VoidCallback onRestart;
  final VoidCallback onExit;

  const ResultPanel({
    super.key,
    required this.score,
    required this.total,
    required this.onRestart,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percent = total == 0 ? 0.0 : score / total;
    final isGood = percent >= 0.6;

    final chartSize = (MediaQuery.of(context).size.width * 0.45).clamp(
      140.0,
      200.0,
    );

    return Center(
      child: Column(
        children: [
          Icon(
            isGood ? Icons.emoji_events : Icons.thumb_up,
            size: context.dsSpacing(80),
            color: AppColors.secondary,
          ),
          SizedBox(height: context.dsSpacing(16)),
          Text(
            'Você acertou $score de $total',
            style: theme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.dsSpacing(24)),
          SizedBox(
            height: chartSize,
            width: chartSize,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: percent,
                  strokeWidth: 14,
                  backgroundColor: AppColors.danger.withValues(alpha: 0.25),
                  color: AppColors.success,
                ),
                Center(
                  child: Text(
                    '${(percent * 100).toStringAsFixed(0)}%',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: context.dsSpacing(20)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.dsSpacing(24)),
            child: Text(
              'Continue consolidando seus conhecimentos para garantir seus direitos na prática.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.muted,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: context.dsSpacing(24)),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onExit,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.colorScheme.primary,
                    side: BorderSide(color: theme.colorScheme.primary),
                    padding: EdgeInsets.symmetric(
                      vertical: context.dsSpacing(14),
                    ),
                  ),
                  child: const Text('Voltar ao Menu'),
                ),
              ),
              SizedBox(width: context.dsSpacing(12)),
              Expanded(
                child: ElevatedButton(
                  onPressed: onRestart,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: context.dsSpacing(14),
                    ),
                  ),
                  child: const Text('Refazer Quiz'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
