import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bem-vindo - PEC 14/21'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.health_and_safety,
                size: 100,
                color: Colors.green[700],
              ),
              const SizedBox(height: 20),
              const Text(
                'Guia e Calculadora para ACS e ACE',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 50),
              ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/quiz'),
                icon: const Icon(Icons.menu_book),
                label: const Text('Quiz PEC 14/21'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 60),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/calculadora'),
                icon: const Icon(Icons.calculate),
                label: const Text('Calculadora de Aposentadoria'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[600],
                  minimumSize: const Size(double.infinity, 60),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
