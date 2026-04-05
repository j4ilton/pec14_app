import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'design_system/app_theme.dart';
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
      title: 'App PEC 14',
      locale: const Locale('pt', 'BR'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt', 'BR')],
      theme: AppTheme.light(),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeView(),
        '/quiz': (context) => const QuizView(),
        '/calculadora': (context) => const CalculadoraView(),
      },
    );
  }
}
