import 'package:flutter/material.dart';

import '../modules/calculator/calculator.dart';
import '../modules/home/home.dart';
import '../modules/quiz/quiz.dart';

abstract final class AppRoutes {
  static const home = '/';
  static const quiz = '/quiz';
  static const calculadora = '/calculadora';

  static final routes = <String, WidgetBuilder>{
    home: (context) => const HomeView(),
    quiz: (context) => const QuizView(),
    calculadora: (context) => const CalculadoraView(),
  };
}
