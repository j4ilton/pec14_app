import '../domain/quiz_question.dart';

abstract class QuizRepository {
  Future<List<QuizQuestion>> fetchQuestions();
}
