import 'package:flutter/material.dart';
import '../utils/responsive.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final iconSize = (context.screenWidth * 0.45).clamp(100.0, 200.0);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bem-vindo - PEC 14'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(context.rspSpacing(24.0)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.health_and_safety,
                size: iconSize,
                color: Colors.green[700],
              ),
              SizedBox(height: context.rspSpacing(20)),
              Text(
                'Guia e Calculadora para ACS e ACE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: context.rsp(22),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: context.rspSpacing(50)),
              ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/quiz'),
                icon: const Icon(Icons.menu_book),
                label: const Text('Quiz PEC 14'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  textStyle: TextStyle(fontSize: context.rsp(18)),
                ),
              ),
              SizedBox(height: context.rspSpacing(20)),
              ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/calculadora'),
                icon: const Icon(Icons.calculate),
                label: const Text('Calculadora de Aposentadoria'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[600],
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  textStyle: TextStyle(fontSize: context.rsp(18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
