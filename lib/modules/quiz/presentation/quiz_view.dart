import 'package:flutter/material.dart';

import '../../../design_system/app_theme.dart';
import 'quiz_controller.dart';
import 'widgets/explanation_card.dart';
import 'widgets/option_tile.dart';
import 'widgets/question_card.dart';
import 'widgets/quiz_header.dart';
import 'widgets/result_panel.dart';

class QuizView extends StatefulWidget {
  const QuizView({super.key});

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  late final QuizController _controller;

  @override
  void initState() {
    super.initState();
    _controller = QuizController()..load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz PEC 14')),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            if (_controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (_controller.errorMessage != null) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(context.dsSpacing(24)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _controller.errorMessage!,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: context.dsSpacing(16)),
                      ElevatedButton(
                        onPressed: _controller.load,
                        child: const Text('Tentar novamente'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (_controller.totalQuestions == 0) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(context.dsSpacing(24)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Nenhuma questão disponível no momento.'),
                      SizedBox(height: context.dsSpacing(16)),
                      ElevatedButton(
                        onPressed: _controller.load,
                        child: const Text('Recarregar'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (_controller.isFinished) {
              return Padding(
                padding: EdgeInsets.all(context.dsSpacing(24)),
                child: ResultPanel(
                  score: _controller.score,
                  total: _controller.totalQuestions,
                  onRestart: _controller.restart,
                  onExit: () => Navigator.pop(context),
                ),
              );
            }

            final question = _controller.currentQuestion!;

            return SingleChildScrollView(
              padding: EdgeInsets.all(context.dsSpacing(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  QuizHeader(
                    current: _controller.currentIndex + 1,
                    total: _controller.totalQuestions,
                  ),
                  SizedBox(height: context.dsSpacing(18)),
                  QuestionCard(text: question.texto),
                  SizedBox(height: context.dsSpacing(18)),
                  ...question.opcoes.asMap().entries.map((entry) {
                    final index = entry.key;
                    return Padding(
                      padding: EdgeInsets.only(bottom: context.dsSpacing(12)),
                      child: OptionTile(
                        text: entry.value,
                        isCorrect: index == question.respostaCorreta,
                        isSelected: index == _controller.selectedIndex,
                        showFeedback: _controller.answered,
                        onTap: () => _controller.selectAnswer(index),
                      ),
                    );
                  }),
                  if (_controller.answered) ...[
                    SizedBox(height: context.dsSpacing(10)),
                    ExplanationCard(
                      explanation: question.explicacao,
                      source: question.fonte,
                    ),
                    SizedBox(height: context.dsSpacing(20)),
                    ElevatedButton(
                      onPressed: _controller.nextQuestion,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: context.dsSpacing(14),
                        ),
                      ),
                      child: const Text('Próxima Pergunta'),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
