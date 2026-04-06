import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../domain/quiz_question.dart';
import 'quiz_repository.dart';

class AssetsQuizRepository implements QuizRepository {
  final String assetPath;

  const AssetsQuizRepository({
    this.assetPath = 'assets/quizzes/quiz_questions.json',
  });

  @override
  Future<List<QuizQuestion>> fetchQuestions() async {
    final jsonString = await rootBundle.loadString(assetPath);
    final decoded = jsonDecode(jsonString);

    final List<dynamic> rawQuestions;
    if (decoded is List) {
      rawQuestions = decoded;
    } else if (decoded is Map<String, dynamic> &&
        decoded['questions'] is List) {
      rawQuestions = decoded['questions'] as List<dynamic>;
    } else {
      throw const FormatException(
        'Formato inválido do arquivo de quiz. Esperado: List ou { "questions": [...] }.',
      );
    }

    return rawQuestions
        .map(
          (item) =>
              QuizQuestion.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .toList();
  }

  Future<List<QuizQuestion>> loadQuiz() {
    return fetchQuestions();
  }
}
