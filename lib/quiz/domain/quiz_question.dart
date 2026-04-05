import 'quiz_source.dart';

class QuizQuestion {
  final String texto;
  final List<String> opcoes;
  final int respostaCorreta;
  final String explicacao;
  final QuizSource fonte;

  const QuizQuestion({
    required this.texto,
    required this.opcoes,
    required this.respostaCorreta,
    required this.explicacao,
    required this.fonte,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      texto: json['texto'] as String,
      opcoes: List<String>.from(json['opcoes'] as List),
      respostaCorreta: json['resposta'] as int,
      explicacao: json['explicacao'] as String,
      fonte: QuizSource.fromJson(json['fonte'] as Map<String, dynamic>),
    );
  }
}
