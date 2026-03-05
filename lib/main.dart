import 'package:flutter/material.dart';
import 'views/home_view.dart';
import 'views/quiz_view.dart';
import 'views/calculadora_view.dart';

void main() {
  runApp(const Pec14App());
}

class Pec14App extends StatelessWidget {
  const Pec14App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App PEC 14/21',
      theme: ThemeData(
        primaryColor: Colors.green[700],
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.green[700],
          secondary: Colors.orange[600],
        ),
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeView(),
        '/quiz': (context) => const QuizView(),
        '/calculadora': (context) => const CalculadoraView(),
      },
    );
  }
}
