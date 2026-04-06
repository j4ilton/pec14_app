import 'package:flutter/material.dart';
import '../data/assets_quiz_repository.dart';
import '../data/quiz_repository.dart';
import '../domain/quiz_question.dart';

class QuizController extends ChangeNotifier {
  final QuizRepository _repository;

  QuizController({QuizRepository? repository})
    : _repository = repository ?? const AssetsQuizRepository();

  List<QuizQuestion> _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  int? _selectedIndex;
  bool _answered = false;
  bool _loading = true;
  String? _errorMessage;

  List<QuizQuestion> get questions => _questions;
  int get currentIndex => _currentIndex;
  int get score => _score;
  int? get selectedIndex => _selectedIndex;
  bool get answered => _answered;
  bool get isLoading => _loading;
  String? get errorMessage => _errorMessage;

  QuizQuestion? get currentQuestion =>
      _questions.isNotEmpty ? _questions[_currentIndex] : null;

  int get totalQuestions => _questions.length;
  bool get isFinished => _questions.isNotEmpty && _currentIndex >= _questions.length;

  Future<void> load() async {
    _loading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _questions = await _repository.fetchQuestions();
      _currentIndex = 0;
      _score = 0;
      _selectedIndex = null;
      _answered = false;
    } catch (e) {
      _errorMessage = 'Não foi possível carregar o quiz.';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void selectAnswer(int index) {
    if (_answered || isFinished) return;
    _selectedIndex = index;
    _answered = true;

    final correct = currentQuestion?.respostaCorreta ?? -1;
    if (index == correct) {
      _score++;
    }
    notifyListeners();
  }

  void nextQuestion() {
    if (!_answered) return;
    if (_currentIndex < _questions.length) {
      _currentIndex++;
    }
    _selectedIndex = null;
    _answered = false;
    notifyListeners();
  }

  void restart() {
    _currentIndex = 0;
    _score = 0;
    _selectedIndex = null;
    _answered = false;
    notifyListeners();
  }
}
