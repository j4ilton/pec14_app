import 'package:flutter/material.dart';
import '../utils/responsive.dart';

class QuizView extends StatefulWidget {
  const QuizView({super.key});

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  int _indiceAtual = 0;
  int _pontuacao = 0;
  int? _respostaSelecionada;
  bool _respondido = false;

  // Banco de 20 questões (Mantenha a lista _perguntas que geramos anteriormente aqui)
  final List<Map<String, dynamic>> _perguntas = [
    {
      'texto':
          'Qual é a classificação da atividade dos Agentes Comunitários de Saúde e Agentes de Combate às Endemias segundo a proposta legislativa?',
      'opcoes': [
        'Atividade de suporte administrativo temporário.',
        'Atividade essencial ao sistema único de saúde e exclusiva de Estado.',
        'Atividade terceirizada de apoio logístico.',
        'Atividade de livre nomeação e exoneração.',
      ],
      'resposta': 1,
      'explicacao':
          'A atividade é definida como essencial ao sistema único de saúde e exclusiva de Estado. [cite: 106]',
    },
    {
      'texto':
          'Como deve ser realizada a admissão desses profissionais pelos gestores locais da saúde?',
      'opcoes': [
        'Por meio de contratação temporária anual.',
        'Através de indicação direta do gestor local.',
        'Por meio de concurso público na sua forma específica de processo seletivo público.',
        'Mediante convênio com organizações não governamentais.',
      ],
      'resposta': 2,
      'explicacao':
          'Os gestores devem admitir os agentes por meio de concurso público na sua forma específica de processo seletivo público, de provimento efetivo. [cite: 422]',
    },
    {
      'texto':
          'Qual é a regra geral estabelecida sobre a contratação temporária ou terceirizada de agentes?',
      'opcoes': [
        'É permitida em qualquer circunstância para reduzir custos.',
        'É vedada, salvo na hipótese de emergências em saúde pública.',
        'É a forma prioritária de contratação no sistema de saúde.',
        'É permitida apenas para municípios com menos de 50 mil habitantes.',
      ],
      'resposta': 1,
      'explicacao':
          'É vedada a contratação temporária ou terceirizada, salvo a hipótese de emergências em saúde pública na forma da lei. [cite: 110]',
    },
    {
      'texto':
          'Qual é o tempo mínimo de efetivo exercício na atividade exigido para que o agente tenha direito à aposentadoria com requisitos diferenciados?',
      'opcoes': ['15 anos.', '20 anos.', '25 anos.', '30 anos.'],
      'resposta': 2,
      'explicacao':
          'É exigida a comprovação de no mínimo 25 anos de tempo de contribuição e de efetivo exercício na respectiva atividade profissional. [cite: 121]',
    },
    {
      'texto':
          'Como serão calculados os proventos da aposentadoria especial para os agentes que cumprirem os requisitos exclusivos de tempo de serviço?',
      'opcoes': [
        'Serão proporcionais ao tempo de contribuição.',
        'Garantirão a integralidade e a paridade salarial.',
        'Serão limitados ao teto do regime geral sem garantias extras.',
        'Corresponderão a 70% da última remuneração.',
      ],
      'resposta': 1,
      'explicacao':
          'Os profissionais terão direito à aposentadoria especial e a pensão de forma integral e paritária. [cite: 436]',
    },
    {
      'texto':
          'Além da aposentadoria diferenciada, qual outro adicional financeiro é expressamente garantido aos agentes devido aos riscos inerentes à função?',
      'opcoes': [
        'Adicional noturno.',
        'Adicional de insalubridade.',
        'Gratificação por tempo de serviço.',
        'Auxílio-moradia.',
      ],
      'resposta': 1,
      'explicacao':
          'Os agentes terão direito, em razão dos riscos inerentes às funções desempenhadas, ao adicional de insalubridade. [cite: 112]',
    },
    {
      'texto':
          'Qual é a responsabilidade da União em relação ao pagamento do piso salarial dos agentes?',
      'opcoes': [
        'Pagar integralmente o salário de todos os agentes.',
        'Prestar assistência financeira complementar aos Estados, Distrito Federal e Municípios.',
        'Apenas definir o valor, sem obrigação de repasse financeiro.',
        'Financiar 50% do salário exclusivamente nos estados mais pobres.',
      ],
      'resposta': 1,
      'explicacao':
          'Compete à União prestar assistência financeira complementar para o cumprimento do referido piso salarial. [cite: 433]',
    },
    {
      'texto':
          'Como o piso salarial nacional dos agentes deve ser enquadrado na estrutura do plano de carreira?',
      'opcoes': [
        'Como o teto máximo da categoria.',
        'Como o vencimento inicial da carreira.',
        'Como uma gratificação variável por desempenho.',
        'Como um valor de referência apenas para o setor privado.',
      ],
      'resposta': 1,
      'explicacao':
          'A lei federal deve dispor sobre a fixação do piso salarial profissional nacional como vencimento inicial da carreira. [cite: 429]',
    },
    {
      'texto':
          'O repasse financeiro feito pela União para auxiliar no pagamento dos agentes pode ser contabilizado nos limites de despesas de pessoal do município?',
      'opcoes': [
        'Sim, em sua totalidade.',
        'Sim, mas apenas em anos não eleitorais.',
        'Não, é expressamente vedada a inclusão dessa assistência nos limites de despesas de pessoal.',
        'Apenas a parcela referente aos encargos sociais entra no limite.',
      ],
      'resposta': 2,
      'explicacao':
          'É vedada a inclusão da assistência financeira complementar repassada pela União em limites de despesas de pessoal de qualquer espécie. [cite: 434]',
    },
    {
      'texto':
          'O que acontece com o gestor local que não comprovar a regularidade do vínculo efetivo dos agentes na gestão da saúde?',
      'opcoes': [
        'Paga uma multa de 10% do orçamento municipal.',
        'Ficará impedido de firmar convênios e aderir a novas estratégias que impliquem repasses de recursos da União.',
        'É automaticamente afastado do cargo público.',
        'Sofre apenas uma advertência administrativa formal.',
      ],
      'resposta': 1,
      'explicacao':
          'O gestor local ficará impedido de firmar convênio e aderir às novas estratégias de ações públicas que impliquem repasses de recursos da União. [cite: 455]',
    },
    {
      'texto':
          'O tempo de afastamento do agente para o exercício de mandato classista ou sindical conta para a aposentadoria especial?',
      'opcoes': [
        'Não, o tempo é suspenso durante o mandato.',
        'Sim, apenas para fins de contribuição, mas não como efetivo exercício.',
        'Sim, deve ser considerado para fins de cômputo do tempo de contribuição e de efetivo exercício.',
        'Apenas se o agente continuar trabalhando meio período na unidade de saúde.',
      ],
      'resposta': 2,
      'explicacao':
          'Deve-se considerar o período em que o agente estiver afastado em razão do desempenho de mandato classista da categoria. [cite: 125]',
    },
    {
      'texto':
          'O tempo em que o agente atua na condição de readaptado em outra função por motivo de saúde é contabilizado para a aposentadoria especial?',
      'opcoes': [
        'Sim, desde que a readaptação tenha decorrido de acidente de trabalho, doença profissional ou doença do trabalho.',
        'Sim, em qualquer hipótese de readaptação.',
        'Não, a readaptação interrompe a contagem do tempo especial.',
        'Apenas se a readaptação durar menos de dois anos.',
      ],
      'resposta': 0,
      'explicacao':
          'Conta-se o tempo laborado na condição de readaptado, desde que a readaptação tenha decorrido de acidente de trabalho ou doença ocupacional. [cite: 125]',
    },
    {
      'texto':
          'De acordo com as faixas progressivas até 31 de dezembro de 2030, qual é a idade mínima exigida para a aposentadoria de mulheres e homens, respectivamente?',
      'opcoes': [
        '45 anos (mulher) e 50 anos (homem).',
        '50 anos (mulher) e 52 anos (homem).',
        '52 anos (mulher) e 55 anos (homem).',
        '55 anos (mulher) e 60 anos (homem).',
      ],
      'resposta': 1,
      'explicacao':
          'Até 31 de dezembro de 2030, a idade mínima é de 50 anos, se mulher, e 52 anos, se homem. [cite: 135]',
    },
    {
      'texto':
          'Na regra de transição final permanente (válida a partir de 2041), qual passa a ser a idade mínima exigida para a aposentadoria de mulheres e homens?',
      'opcoes': [
        '55 anos (mulher) e 58 anos (homem).',
        '57 anos (mulher) e 60 anos (homem).',
        '60 anos (mulher) e 65 anos (homem).',
        '62 anos (mulher) e 65 anos (homem).',
      ],
      'resposta': 1,
      'explicacao':
          'A partir de 1º de janeiro de 2041, a idade exigida será de 57 anos para mulher e 60 anos para homem. [cite: 141]',
    },
    {
      'texto':
          'O que ocorre com a exigência de idade mínima se o agente possuir mais de 25 anos de efetivo exercício na atividade?',
      'opcoes': [
        'Não há alteração na idade mínima.',
        'A idade mínima é reduzida em 1 ano para cada ano de serviço excedente, até o limite máximo de redução de 5 anos.',
        'A idade mínima é reduzida pela metade.',
        'O agente pode se aposentar imediatamente independentemente da idade.',
      ],
      'resposta': 1,
      'explicacao':
          'As idades mínimas serão reduzidas em 1 ano para cada ano que exceder os 25, observado o limite máximo de 5 anos de redução. [cite: 144]',
    },
    {
      'texto':
          'Na regra do sistema de pontos, qual é a pontuação total exigida (soma da idade com o tempo de contribuição) para mulheres e homens, respectivamente?',
      'opcoes': [
        '80 pontos (mulher) e 85 pontos (homem).',
        '83 pontos (mulher) e 86 pontos (homem).',
        '85 pontos (mulher) e 90 pontos (homem).',
        '90 pontos (mulher) e 100 pontos (homem).',
      ],
      'resposta': 1,
      'explicacao':
          'O somatório deve ser equivalente a 83 pontos, se mulher, e a 86 pontos, se homem. [cite: 25]',
    },
    {
      'texto':
          'Para utilizar a regra do sistema de pontos, além dos 15 anos de contribuição geral, qual é o tempo mínimo exigido de efetivo exercício na atividade profissional de agente?',
      'opcoes': ['5 anos.', '10 anos.', '15 anos.', '20 anos.'],
      'resposta': 1,
      'explicacao':
          'Para a regra de pontos, exige-se cumulativamente 10 anos de efetivo exercício na respectiva atividade profissional. [cite: 24]',
    },
    {
      'texto':
          'Além das funções clássicas de campo, quais outras atividades desempenhadas pelos agentes contam como tempo válido para a aposentadoria especial?',
      'opcoes': [
        'Apenas atividades de plantão em hospitais regionais.',
        'Atividades em desvio de função no setor de recursos humanos.',
        'Atividades relacionadas à coordenação, supervisão ou representação dos profissionais.',
        'Atividades de motorista de ambulância vinculadas à unidade básica.',
      ],
      'resposta': 2,
      'explicacao':
          'Terão direito à aposentadoria especial os que exercerem atividades de campo, nas unidades de saúde, bem como coordenação, supervisão ou representação dos profissionais. [cite: 436]',
    },
    {
      'texto':
          'De quem é a responsabilidade de garantir a regularidade do vínculo empregatício direto desses profissionais de saúde?',
      'opcoes': [
        'Do Ministério da Saúde exclusivamente.',
        'Do Governo Federal em conjunto com o Tribunal de Contas da União.',
        'Do gestor local do Sistema Único de Saúde (Município, Estado ou Distrito Federal).',
        'Das Organizações Sociais de Saúde contratadas.',
      ],
      'resposta': 2,
      'explicacao':
          'A proposta fixa a responsabilidade do gestor local do SUS pela regularidade do vínculo empregatício desses profissionais. [cite: 415]',
    },
    {
      'texto':
          'Qual é a obrigação legal da União em relação ao desenvolvimento da carreira e aprimoramento técnico dos agentes?',
      'opcoes': [
        'Financiar graduações em medicina para todos os agentes.',
        'Promover a implantação da qualificação profissional na área de atuação.',
        'Fornecer bolsas de estudo exclusivamente para o exterior.',
        'Criar universidades federais específicas para agentes de saúde.',
      ],
      'resposta': 1,
      'explicacao':
          'Compete à União promover a implantação da qualificação profissional na área de atuação como forma de desenvolvimento e valorização da carreira. [cite: 433]',
    },
  ];

  void _selecionarResposta(int index) {
    if (_respondido) return;

    setState(() {
      _respostaSelecionada = index;
      _respondido = true;
      if (index == _perguntas[_indiceAtual]['resposta']) {
        _pontuacao++;
      }
    });
  }

  void _proximaPergunta() {
    setState(() {
      _indiceAtual++;
      _respostaSelecionada = null;
      _respondido = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ==========================================
    // TELA DE RESULTADOS (COM GRÁFICO)
    // ==========================================
    if (_indiceAtual >= _perguntas.length) {
      // Cálculos para o gráfico
      int totalPerguntas = _perguntas.length;
      int erros = totalPerguntas - _pontuacao;
      double porcentagemAcertos = _pontuacao / totalPerguntas;

      return Scaffold(
        appBar: AppBar(title: const Text('Resultado Final')),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 1. Ícone do Troféu
                Icon(
                  _pontuacao > (totalPerguntas / 2)
                      ? Icons.emoji_events
                      : Icons.thumb_up,
                  size: context.rspIcon(100),
                  color: Colors.orange[600],
                ),
                SizedBox(height: context.rspSpacing(16)),

                // 2. Texto de Felicitações
                Text(
                  'Acertou $_pontuacao de $totalPerguntas!',
                  style: TextStyle(
                    fontSize: context.rsp(28),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: context.rspSpacing(30)),

                // 3. Gráfico Circular de Desempenho
                Builder(
                  builder: (context) {
                    final chartSize = (context.screenWidth * 0.4).clamp(
                      120.0,
                      180.0,
                    );
                    return SizedBox(
                      height: chartSize,
                      width: chartSize,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CircularProgressIndicator(
                            value: porcentagemAcertos,
                            strokeWidth: 15,
                            backgroundColor:
                                Colors.red.shade400, // Cor para os erros
                            color: Colors.green.shade600, // Cor para os acertos
                          ),
                          Center(
                            child: Text(
                              '${(porcentagemAcertos * 100).toStringAsFixed(0)}%',
                              style: TextStyle(
                                fontSize: context.rsp(32),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // 4. Legenda do Gráfico
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _construirLegenda(
                      context,
                      Colors.green.shade600,
                      'Acertos: $_pontuacao',
                    ),
                    const SizedBox(width: 20),
                    _construirLegenda(
                      context,
                      Colors.red.shade400,
                      'Erros: $erros',
                    ),
                  ],
                ),
                SizedBox(height: context.rspSpacing(30)),

                // 5. Mensagem Motivacional
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.rspSpacing(24.0),
                  ),
                  child: Text(
                    'Continue consolidando os seus conhecimentos sobre as proteções trabalhistas e previdenciárias para garantir todos os seus direitos na prática!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: context.rsp(16)),
                  ),
                ),
                SizedBox(height: context.rspSpacing(40)),

                // 6. Botão de Retorno
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.home),
                  label: const Text('Voltar ao Menu Principal'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(
                      context.screenWidth * 0.6,
                      context.rspSpacing(52),
                    ),
                    backgroundColor: Colors.green.shade700,
                    foregroundColor: Colors.white,
                    textStyle: TextStyle(fontSize: context.rsp(16)),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      );
    }

    // ==========================================
    // TELA DO QUIZ (PERGUNTAS)
    // ==========================================
    final pergunta = _perguntas[_indiceAtual];
    final opcoes = pergunta['opcoes'] as List<String>;
    final respostaCorreta = pergunta['resposta'] as int;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Estudo Dirigido - ${_indiceAtual + 1}/${_perguntas.length}',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ... (Mantenha o resto do código da tela de perguntas igual ao anterior)
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(context.rspSpacing(20.0)),
                child: Text(
                  pergunta['texto'],
                  style: TextStyle(
                    fontSize: context.rsp(18),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ...opcoes.asMap().entries.map((entry) {
              final index = entry.key;
              final textoOpcao = entry.value;

              Color corFundo = Colors.white;
              Color corBorda = Colors.grey.shade300;
              Color corTexto = Colors.black87;

              if (_respondido) {
                if (index == respostaCorreta) {
                  corFundo = Colors.green.shade50;
                  corBorda = Colors.green;
                  corTexto = Colors.green.shade900;
                } else if (index == _respostaSelecionada &&
                    index != respostaCorreta) {
                  corFundo = Colors.red.shade50;
                  corBorda = Colors.red;
                  corTexto = Colors.red.shade900;
                }
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: InkWell(
                  onTap: () => _selecionarResposta(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: corFundo,
                      border: Border.all(color: corBorda, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(context.rspSpacing(16.0)),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            textoOpcao,
                            style: TextStyle(
                              fontSize: context.rsp(16),
                              color: corTexto,
                            ),
                          ),
                        ),
                        if (_respondido && index == respostaCorreta)
                          const Icon(Icons.check_circle, color: Colors.green),
                        if (_respondido &&
                            index == _respostaSelecionada &&
                            index != respostaCorreta)
                          const Icon(Icons.cancel, color: Colors.red),
                      ],
                    ),
                  ),
                ),
              );
            }),
            if (_respondido) ...[
              const SizedBox(height: 10),
              Card(
                color: Colors.blue.shade50,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.blue.shade200),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue.shade800),
                          const SizedBox(width: 8),
                          Text(
                            'Por que essa é a resposta?',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade800,
                              fontSize: context.rsp(14),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        pergunta['explicacao'],
                        style: TextStyle(
                          color: Colors.blue.shade900,
                          fontSize: context.rsp(15),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _proximaPergunta,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  textStyle: TextStyle(fontSize: context.rsp(16)),
                ),
                child: const Text('Próxima Pergunta'),
              ),
              const SizedBox(height: 20),
            ],
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para criar a legenda de cores do gráfico
  Widget _construirLegenda(BuildContext context, Color cor, String texto) {
    return Row(
      children: [
        Container(
          width: context.rspIcon(16),
          height: context.rspIcon(16),
          decoration: BoxDecoration(color: cor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          texto,
          style: TextStyle(
            fontSize: context.rsp(16),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
