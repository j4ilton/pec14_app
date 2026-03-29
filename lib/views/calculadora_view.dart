// lib/views/calculadora_view.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../domain/enums/genero.dart';
import '../viewmodels/calculadora_controller.dart';
import '../widgets/date_picker_form_field.dart';
import '../widgets/resultado_card.dart';

class CalculadoraView extends StatefulWidget {
  const CalculadoraView({Key? key}) : super(key: key);

  @override
  State<CalculadoraView> createState() => _CalculadoraViewState();
}

class _CalculadoraViewState extends State<CalculadoraView> {
  late final CalculadoraController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CalculadoraController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora PEC 14'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Limpar dados',
            onPressed: _controller.limparCalculo,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              if (_controller.erroMensagem != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_controller.erroMensagem!),
                      backgroundColor: Colors.red.shade800,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                });
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Parâmetros Obrigatórios de Cálculo',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // Campo 1: Gênero (Obrigatório)
                  Text(
                    'Gênero',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SegmentedButton<Genero>(
                    // DECISÃO TÉCNICA: Permitir seleção vazia inicial para forçar
                    // a escolha ativa do usuário, evitando cálculos incorretos por desatenção.
                    emptySelectionAllowed: true,
                    segments: Genero.values
                        .map(
                          (g) =>
                              ButtonSegment(value: g, label: Text(g.descricao)),
                        )
                        .toList(),
                    selected: _controller.genero != null
                        ? {_controller.genero!}
                        : <Genero>{},
                    onSelectionChanged: (newSelection) {
                      if (newSelection.isNotEmpty) {
                        _controller.setGenero(newSelection.first);
                      }
                    },
                    style: SegmentedButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Campo 2: Data de Nascimento (Obrigatório)
                  DatePickerFormField(
                    label: 'Data de Nascimento',
                    hintText: '',
                    initialDate: _controller.dataNascimento,
                    onDateSelected: _controller.setDataNascimento,
                  ),
                  const SizedBox(height: 16),

                  // Campo 3: Início ACS/ACE (Obrigatório - PEC 14)
                  DatePickerFormField(
                    label: 'Início do Exercício ACS/ACE',
                    hintText: '',
                    initialDate: _controller.dataInicioAcsAce,
                    onDateSelected: _controller.setDataInicioAcsAce,
                  ),
                  const SizedBox(height: 24),

                  // Campo 4: Outros Tempos (Obrigatório para Pontos)
                  Text(
                    'Tempo de Contribuição em OUTRAS profissões',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: _controller.anosOutroTempo > 0
                              ? _controller.anosOutroTempo.toString()
                              : '',
                          decoration: const InputDecoration(
                            labelText: 'Anos',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (v) => _controller.setOutroTempo(
                            int.tryParse(v) ?? 0,
                            null,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          initialValue: _controller.mesesOutroTempo > 0
                              ? _controller.mesesOutroTempo.toString()
                              : '',
                          decoration: const InputDecoration(
                            labelText: 'Meses',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (v) => _controller.setOutroTempo(
                            null,
                            int.tryParse(v) ?? 0,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Botão de Cálculo
                  ElevatedButton.icon(
                    onPressed: _controller.calcular,
                    icon: const Icon(Icons.calculate),
                    label: const Text(
                      'CALCULAR ELEGIBILIDADE',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Exibição Condicional do Resultado
                  if (_controller.hasResultado)
                    ResultadoCard(resultado: _controller.resultado!),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
