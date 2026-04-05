import 'dart:convert';
import 'package:flutter/services.dart';
import '../domain/quiz_question.dart';
import 'quiz_repository.dart';

class AssetsQuizRepository implements QuizRepository {
  final String assetPath;

  const AssetsQuizRepository({this.assetPath = 'assets/quiz_questions.json'});

  @override
  Future<List<QuizQuestion>> fetchQuestions() async {
    final jsonText = await rootBundle.loadString(assetPath);
    final data = json.decode(jsonText) as List<dynamic>;
    return data
        .map((item) => QuizQuestion.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
