import 'package:flutter/material.dart';
import '../utils/responsive.dart';
import '../viewmodels/calculadora_controller.dart';
import '../widgets/date_picker_form_field.dart';
import '../widgets/resultado_card.dart';

class CalculadoraView extends StatefulWidget {
  const CalculadoraView({super.key});

  @override
  State<CalculadoraView> createState() => _CalculadoraViewState();
}

class _CalculadoraViewState extends State<CalculadoraView> {
  final _formKey = GlobalKey<FormState>();
  final _controller = CalculadoraController();

  DateTime? _dataNascimento;
  DateTime? _dataAdmissao;
  String _sexo = 'F';

  // Controladores de texto para exibir os resultados calculados
  final _dataNascimentoCtrl = TextEditingController();
  final _dataAdmissaoCtrl = TextEditingController();
  final _idadeCtrl = TextEditingController();
  final _tempoFuncaoCtrl = TextEditingController();
  final _tempoOutrasFuncoesCtrl = TextEditingController(text: '0');
  final _tempoContribCtrl = TextEditingController();

  Map<String, dynamic>? _resultados;

  @override
  void initState() {
    super.initState();
    // Adiciona listener para recalcular quando o tempo de outras funções mudar
    _tempoOutrasFuncoesCtrl.addListener(_calcularTempoContribuicaoTotal);
  }

  @override
  void dispose() {
    _dataNascimentoCtrl.dispose();
    _dataAdmissaoCtrl.dispose();
    _idadeCtrl.dispose();
    _tempoFuncaoCtrl.dispose();
    _tempoOutrasFuncoesCtrl.dispose();
    _tempoContribCtrl.dispose();
    super.dispose();
  }

  // Função para calcular o tempo total de contribuição
  void _calcularTempoContribuicaoTotal() {
    int tempoFuncao = int.tryParse(_tempoFuncaoCtrl.text) ?? 0;
    int tempoOutrasFuncoes = int.tryParse(_tempoOutrasFuncoesCtrl.text) ?? 0;
    int tempoTotal = tempoFuncao + tempoOutrasFuncoes;

    setState(() {
      _tempoContribCtrl.text = tempoTotal.toString();
    });
  }

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
    // Use a data já selecionada como data inicial, ou um padrão caso contrário.
    final DateTime dataInicial =
        (isNascimento ? _dataNascimento : _dataAdmissao) ??
        (isNascimento
            ? DateTime(dataAtual.year - 40)
            : DateTime(dataAtual.year - 15));

    final DateTime? dataEscolhida = await showDatePicker(
      context: context,
      initialDate: dataInicial,
      firstDate: DateTime(1940), // Limite mínimo
      lastDate: dataAtual, // Limite máximo (hoje)
      helpText: isNascimento
          ? 'SELECIONE A DATA DE NASCIMENTO'
          : 'SELECIONE A DATA DE ADMISSÃO',
      // Otimizações de UX:
      initialDatePickerMode: isNascimento
          ? DatePickerMode.year
          : DatePickerMode.day,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
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
          // Recalcula o tempo total de contribuição
          _calcularTempoContribuicaoTotal();
        }
      });
    }
  }

  void _limparData(bool isNascimento) {
    setState(() {
      if (isNascimento) {
        _dataNascimento = null;
        _dataNascimentoCtrl.clear();
        _idadeCtrl.clear();
      } else {
        _dataAdmissao = null;
        _dataAdmissaoCtrl.clear();
        _tempoFuncaoCtrl.clear();
        // Recalcula o tempo total de contribuição, pois um de seus componentes foi zerado
        _calcularTempoContribuicaoTotal();
      }
      _resultados = null; // Limpa os resultados ao alterar os dados
    });
  }

  void _novoCalculo() {
    setState(() {
      _dataNascimento = null;
      _dataAdmissao = null;
      _sexo = 'F';
      _dataNascimentoCtrl.clear();
      _dataAdmissaoCtrl.clear();
      _idadeCtrl.clear();
      _tempoFuncaoCtrl.clear();
      _tempoOutrasFuncoesCtrl.text = '0';
      _tempoContribCtrl.clear();
      _resultados = null;
    });
  }

  void _calcular() {
    // Dispara a validação do formulário
    if (_formKey.currentState!.validate()) {
      // Se o formulário for válido, prossiga com o cálculo.
      setState(() {
        final input = CalculadoraInput(
          sexo: _sexo,
          idade: int.tryParse(_idadeCtrl.text) ?? 0,
          tempoFuncao: int.tryParse(_tempoFuncaoCtrl.text) ?? 0,
          tempoOutrasFuncoes: int.tryParse(_tempoOutrasFuncoesCtrl.text) ?? 0,
          tempoContribuicao: int.tryParse(_tempoContribCtrl.text) ?? 0,
          dataNascimento: _dataNascimento!,
          dataAdmissao: _dataAdmissao!,
        );

        _resultados = _controller.calcularRegras(input);
      });
    } else {
      // Opcional: Mostrar uma mensagem genérica. Os campos já exibirão seus erros.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, corrija os erros e tente novamente.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculadora PEC 14/21')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(context.rspSpacing(16)),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUnfocus,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Divider(),
              const Text(
                'Dados a Preencher Manualmente:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 10),

              // 1. Data de Nascimento
              DatePickerFormField(
                controller: _dataNascimentoCtrl,
                labelText: 'Data de Nascimento',
                icon: Icons.calendar_today,
                onTap: () => _selecionarData(context, true),
                onClear: () => _limparData(true),
              ),
              const SizedBox(height: 12),

              // 2. Sexo
              DropdownButtonFormField<String>(
                initialValue: _sexo,
                decoration: const InputDecoration(labelText: 'Sexo'),
                items: const [
                  DropdownMenuItem(value: 'F', child: Text('Feminino')),
                  DropdownMenuItem(value: 'M', child: Text('Masculino')),
                ],
                onChanged: (val) => setState(() => _sexo = val!),
              ),
              const SizedBox(height: 12),

              // 3. Data de Admissão
              DatePickerFormField(
                controller: _dataAdmissaoCtrl,
                labelText: 'Data de Admissão',
                icon: Icons.calendar_today,
                onTap: () => _selecionarData(context, false),
                onClear: () => _limparData(false),
              ),
              const SizedBox(height: 12),

              // 4. Tempo de Outras Funções
              TextFormField(
                controller: _tempoOutrasFuncoesCtrl,
                decoration: const InputDecoration(
                  labelText: 'Tempo de Outras Funções (anos)',
                  helperText:
                      'Digite o tempo total de outras profissões antes de ser ACS/ACE.',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, preencha este campo.';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Por favor, insira um número válido.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              const Divider(),
              const Text(
                'Dados Calculados Automaticamente:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 10),

              // 1. Idade Atual
              TextField(
                controller: _idadeCtrl,
                decoration: const InputDecoration(
                  labelText: 'Idade Atual (anos)',
                  filled: true,
                ),
                enabled: false,
              ),
              const SizedBox(height: 12),

              // 2. Tempo na Função ACS/ACE
              TextField(
                controller: _tempoFuncaoCtrl,
                decoration: const InputDecoration(
                  labelText: 'Tempo na Função ACS/ACE (anos)',
                  filled: true,
                ),
                enabled: false,
              ),
              const SizedBox(height: 12),

              // 3. Tempo de Contribuição Total
              TextField(
                controller: _tempoContribCtrl,
                decoration: const InputDecoration(
                  labelText:
                      'Tempo Total de Contribuição INSS/Regime Próprio (anos)',
                  filled: true,
                ),
                enabled: false,
              ),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _calcular,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  backgroundColor: Colors.green.shade700,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: TextStyle(fontSize: context.rsp(16)),
                ),
                child: const Text('Verificar Status de Aposentadoria'),
              ),
              if (_resultados != null) ...[
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: _novoCalculo,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    side: BorderSide(color: Colors.grey.shade600),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Novo Cálculo',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],

              if (_resultados != null) ...[
                const SizedBox(height: 30),
                Text(
                  'RESULTADOS:',
                  style: TextStyle(
                    fontSize: context.rsp(18),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                ResultadoCard(
                  titulo: 'Regra 1: Idade Progressiva',
                  isApto: _resultados!['regra1']['apto'],
                  detalhe: _resultados!['regra1']['detalhe'],
                  tempoRestante: _resultados!['regra1']['tempoRestante'],
                  dataElegibilidade:
                      _resultados!['regra1']['dataElegibilidade'],
                  idadeEstimada: _resultados!['regra1']['idadeEstimada'],
                ),
                ResultadoCard(
                  titulo: 'Regra 2: Redução de Idade',
                  isApto: _resultados!['regra2']['apto'],
                  detalhe: _resultados!['regra2']['detalhe'],
                  tempoRestante: _resultados!['regra2']['tempoRestante'],
                  dataElegibilidade:
                      _resultados!['regra2']['dataElegibilidade'],
                  idadeEstimada: _resultados!['regra2']['idadeEstimada'],
                ),
                ResultadoCard(
                  titulo: 'Regra 3: Sistema de Pontos',
                  isApto: _resultados!['regra3']['apto'],
                  detalhe: _resultados!['regra3']['detalhe'],
                  tempoRestante: _resultados!['regra3']['tempoRestante'],
                  dataElegibilidade:
                      _resultados!['regra3']['dataElegibilidade'],
                  idadeEstimada: _resultados!['regra3']['idadeEstimada'],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
