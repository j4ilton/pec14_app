import 'package:flutter/material.dart';

class QuizView extends StatefulWidget {
  const QuizView({super.key});

  @override
  _QuizViewState createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  int _indiceAtual = 0;
  int _pontuacao = 0;

  final List<Map<String, Object>> _perguntas = [
    {
      'texto': 'Quais profissionais são beneficiados pela PEC 14/21?',
      'opcoes': [
        'Apenas médicos',
        'ACS e ACE',
        'Enfermeiros',
        'Fisioterapeutas',
      ],
      'resposta': 1,
    },
    {
      'texto': 'Qual o tempo mínimo de função exigido na Regra 1?',
      'opcoes': ['15 anos', '20 anos', '25 anos', '30 anos'],
      'resposta': 2,
    },
    {
      'texto': 'Qual é o limite máximo de bónus na redução de idade (Regra 2)?',
      'opcoes': ['3 anos', '5 anos', '10 anos', 'Sem limite'],
      'resposta': 1,
    },
    {
      'texto': 'Na regra de pontos para mulheres, qual é a pontuação exigida?',
      'opcoes': ['80 pontos', '83 pontos', '86 pontos', '90 pontos'],
      'resposta': 1,
    },
  ];

  void _responder(int indexEscolhido) {
    if (indexEscolhido == _perguntas[_indiceAtual]['resposta']) {
      _pontuacao++;
    }
    setState(() {
      _indiceAtual++;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_indiceAtual >= _perguntas.length) {
      return Scaffold(
        appBar: AppBar(title: const Text('Resultado')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Acertou $_pontuacao de ${_perguntas.length}!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Voltar ao Início'),
              ),
            ],
          ),
        ),
      );
    }

    final pergunta = _perguntas[_indiceAtual];
    final opcoes = pergunta['opcoes'] as List<String>;

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz - Pergunta ${_indiceAtual + 1}/${_perguntas.length}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              pergunta['texto'] as String,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ...opcoes.asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: ElevatedButton(
                  onPressed: () => _responder(entry.key),
                  child: Text(entry.value),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
