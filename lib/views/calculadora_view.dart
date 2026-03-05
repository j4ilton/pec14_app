import 'package:flutter/material.dart';
import '../viewmodels/calculadora_controller.dart';

class CalculadoraView extends StatefulWidget {
  const CalculadoraView({super.key});

  @override
  _CalculadoraViewState createState() => _CalculadoraViewState();
}

class _CalculadoraViewState extends State<CalculadoraView> {
  final _controller = CalculadoraController();
  String _sexo = 'F';
  final _idadeCtrl = TextEditingController();
  final _tempoFuncaoCtrl = TextEditingController();
  final _tempoContribCtrl = TextEditingController();
  Map<String, dynamic>? _resultados;

  void _calcular() {
    setState(() {
      _resultados = _controller.calcularRegras(
        sexo: _sexo,
        idade: int.tryParse(_idadeCtrl.text) ?? 0,
        tempoFuncao: int.tryParse(_tempoFuncaoCtrl.text) ?? 0,
        tempoContribuicao: int.tryParse(_tempoContribCtrl.text) ?? 0,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculadora PEC 14/21')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              initialValue: _sexo,
              decoration: const InputDecoration(labelText: 'Sexo'),
              items: const [
                DropdownMenuItem(value: 'F', child: Text('Feminino')),
                DropdownMenuItem(value: 'M', child: Text('Masculino')),
              ],
              onChanged: (val) => setState(() => _sexo = val!),
            ),
            TextField(
              controller: _idadeCtrl,
              decoration: const InputDecoration(labelText: 'Idade (anos)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _tempoFuncaoCtrl,
              decoration: const InputDecoration(
                labelText: 'Tempo na Função ACS/ACE (anos)',
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _tempoContribCtrl,
              decoration: const InputDecoration(
                labelText: 'Tempo Total de Contribuição (anos)',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calcular,
              child: const Text('Verificar Status'),
            ),
            if (_resultados != null) ...[
              const SizedBox(height: 20),
              _buildResultadoCard(
                'Regra 1: Idade Progressiva',
                _resultados!['regra1'],
              ),
              _buildResultadoCard(
                'Regra 2: Redução de Idade',
                _resultados!['regra2'],
              ),
              _buildResultadoCard(
                'Regra 3: Sistema de Pontos',
                _resultados!['regra3'],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultadoCard(String titulo, Map<String, dynamic> dados) {
    bool isApto = dados['apto'];
    return Card(
      color: isApto ? Colors.green[100] : Colors.red[100],
      child: ListTile(
        leading: Icon(
          isApto ? Icons.check_circle : Icons.cancel,
          color: isApto ? Colors.green : Colors.red,
        ),
        title: Text(
          titulo,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(dados['detalhe']),
        trailing: Text(
          isApto ? 'APTO' : 'INAPTO',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isApto ? Colors.green[800] : Colors.red[800],
          ),
        ),
      ),
    );
  }
}
