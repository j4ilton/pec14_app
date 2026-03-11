import 'package:flutter/material.dart';
import '../viewmodels/calculadora_controller.dart';

class CalculadoraView extends StatefulWidget {
  const CalculadoraView({Key? key}) : super(key: key);

  @override
  _CalculadoraViewState createState() => _CalculadoraViewState();
}

class _CalculadoraViewState extends State<CalculadoraView> {
  final _controller = CalculadoraController();

  DateTime? _dataNascimento;
  DateTime? _dataAdmissao;
  String _sexo = 'F';

  // Controladores de texto para exibir os resultados calculados
  final _dataNascimentoCtrl = TextEditingController();
  final _dataAdmissaoCtrl = TextEditingController();
  final _idadeCtrl = TextEditingController();
  final _tempoFuncaoCtrl = TextEditingController();
  final _tempoContribCtrl = TextEditingController();

  Map<String, dynamic>? _resultados;

  // Função para calcular anos exatos entre uma data e hoje
  int _calcularAnos(DateTime dataBase) {
    DateTime hoje = DateTime.now();
    int anos = hoje.year - dataBase.year;
    if (hoje.month < dataBase.month ||
        (hoje.month == dataBase.month && hoje.day < dataBase.day)) {
      anos--; // Subtrai 1 ano se ainda não fez aniversário/aniversário de admissão este ano
    }
    return anos > 0 ? anos : 0;
  }

  // Função para abrir o calendário e escolher a data
  Future<void> _selecionarData(BuildContext context, bool isNascimento) async {
    final DateTime dataAtual = DateTime.now();
    final DateTime dataInicial = isNascimento
        ? DateTime(
            dataAtual.year - 40,
          ) // Começa há 40 anos atrás para nascimento
        : DateTime(
            dataAtual.year - 15,
          ); // Começa há 15 anos atrás para admissão

    final DateTime? dataEscolhida = await showDatePicker(
      context: context,
      initialDate: dataInicial,
      firstDate: DateTime(1940), // Limite mínimo
      lastDate: dataAtual, // Limite máximo (hoje)
      helpText: isNascimento
          ? 'SELECIONE A DATA DE NASCIMENTO'
          : 'SELECIONE A DATA DE ADMISSÃO',
    );

    if (dataEscolhida != null) {
      setState(() {
        String dataFormatada =
            "${dataEscolhida.day.toString().padLeft(2, '0')}/${dataEscolhida.month.toString().padLeft(2, '0')}/${dataEscolhida.year}";

        if (isNascimento) {
          _dataNascimento = dataEscolhida;
          _dataNascimentoCtrl.text = dataFormatada;
          // Calcula e preenche a Idade
          int idade = _calcularAnos(dataEscolhida);
          _idadeCtrl.text = idade.toString();
        } else {
          _dataAdmissao = dataEscolhida;
          _dataAdmissaoCtrl.text = dataFormatada;
          // Calcula e preenche o Tempo de Função
          int tempoFuncao = _calcularAnos(dataEscolhida);
          _tempoFuncaoCtrl.text = tempoFuncao.toString();
        }
      });
    }
  }

  void _calcular() {
    // Validação básica para garantir que as datas foram preenchidas
    if (_dataNascimento == null ||
        _dataAdmissao == null ||
        _tempoContribCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor, preencha todas as datas e o tempo de contribuição.',
          ),
        ),
      );
      return;
    }

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
            // 1. Data de Nascimento
            TextField(
              controller: _dataNascimentoCtrl,
              decoration: const InputDecoration(
                labelText: 'Data de Nascimento',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true, // O utilizador não digita, apenas clica
              onTap: () => _selecionarData(context, true),
            ),
            const SizedBox(height: 12),

            // 2. Data de Admissão
            TextField(
              controller: _dataAdmissaoCtrl,
              decoration: const InputDecoration(
                labelText: 'Data de Admissão (Como ACS/ACE)',
                suffixIcon: Icon(Icons.event_available),
              ),
              readOnly: true,
              onTap: () => _selecionarData(context, false),
            ),
            const SizedBox(height: 12),

            // 3. Sexo
            DropdownButtonFormField<String>(
              value: _sexo,
              decoration: const InputDecoration(labelText: 'Sexo'),
              items: const [
                DropdownMenuItem(value: 'F', child: Text('Feminino')),
                DropdownMenuItem(value: 'M', child: Text('Masculino')),
              ],
              onChanged: (val) => setState(() => _sexo = val!),
            ),
            const SizedBox(height: 20),

            const Divider(),
            const Text(
              'Dados Calculados Automaticamente:',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 10),

            // 4. Idade (Preenchido Automaticamente)
            TextField(
              controller: _idadeCtrl,
              decoration: const InputDecoration(
                labelText: 'Idade Atual (anos)',
                filled: true,
              ),
              readOnly: true, // Bloqueado para edição manual
            ),
            const SizedBox(height: 12),

            // 5. Tempo na Função (Preenchido Automaticamente)
            TextField(
              controller: _tempoFuncaoCtrl,
              decoration: const InputDecoration(
                labelText: 'Tempo na Função ACS/ACE (anos)',
                filled: true,
              ),
              readOnly: true, // Bloqueado para edição manual
            ),
            const SizedBox(height: 12),

            const Divider(),

            // 6. Tempo de Contribuição Total (Manual, pois pode ter trabalhado noutras áreas)
            TextField(
              controller: _tempoContribCtrl,
              decoration: const InputDecoration(
                labelText:
                    'Tempo Total de Contribuição INSS/Regime Próprio (anos)',
                helperText:
                    'Inclua o tempo de outras profissões antes de ser ACS/ACE.',
              ),
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _calcular,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.green.shade700,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Verificar Status de Aposentadoria',
                style: TextStyle(fontSize: 16),
              ),
            ),

            if (_resultados != null) ...[
              const SizedBox(height: 30),
              const Text(
                'RESULTADOS:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
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
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      color: isApto ? Colors.green.shade50 : Colors.red.shade50,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: isApto ? Colors.green.shade300 : Colors.red.shade300,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: Icon(
            isApto ? Icons.check_circle : Icons.cancel,
            color: isApto ? Colors.green.shade700 : Colors.red.shade700,
            size: 36,
          ),
          title: Text(
            titulo,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(dados['detalhe'], style: const TextStyle(fontSize: 14)),
          ),
          trailing: Text(
            isApto ? 'APTO' : 'INAPTO',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isApto ? Colors.green.shade800 : Colors.red.shade800,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
