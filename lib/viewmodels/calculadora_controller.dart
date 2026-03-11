class CalculadoraInput {
  final String sexo;
  final int idade;
  final int tempoFuncao;
  final int tempoOutrasFuncoes;
  final int tempoContribuicao;

  CalculadoraInput({
    required this.sexo,
    required this.idade,
    required this.tempoFuncao,
    required this.tempoOutrasFuncoes,
    required this.tempoContribuicao,
  });
}

class CalculadoraController {
  int _getIdadeMinimaR1(int ano, String sexo) {
    if (ano <= 2030) return sexo == 'F' ? 50 : 52;
    if (ano <= 2035) return sexo == 'F' ? 52 : 54;
    if (ano <= 2040) return sexo == 'F' ? 54 : 56;
    return sexo == 'F' ? 57 : 60;
  }

  Map<String, dynamic> calcularRegras(CalculadoraInput input) {
    // 1. Obter o ano atual dinamicamente
    int anoAtual = DateTime.now().year;

    // ---------------------------------------------------------
    // REGRA 1: Idade Mínima Progressiva (Baseada no ano atual)
    // ---------------------------------------------------------
    int idadeMinimaR1 = _getIdadeMinimaR1(anoAtual, input.sexo);

    bool regra1Apto =
        (input.tempoFuncao >= 25) && (input.idade >= idadeMinimaR1);

    // Tempo restante Regra 1
    int tempoRestanteR1 = 0;
    if (!regra1Apto) {
      for (int n = 1; n <= 50; n++) {
        int futIdadeMin = _getIdadeMinimaR1(anoAtual + n, input.sexo);
        if (input.tempoFuncao + n >= 25 && input.idade + n >= futIdadeMin) {
          tempoRestanteR1 = n;
          break;
        }
      }
    }

    // ---------------------------------------------------------
    // REGRA 2: Redução de Idade com Mais Tempo de Serviço
    // ---------------------------------------------------------
    bool regra2Apto = false;
    // A regra 2 parte da idade mínima estabelecida pela regra 1 no ano atual
    int idadeNecessariaR2 = idadeMinimaR1;
    int bonusAplicado = 0;

    if (input.tempoFuncao >= 25) {
      bonusAplicado = input.tempoFuncao - 25;
      if (bonusAplicado > 5) {
        bonusAplicado = 5; // Trava o limite de bónus em 5 anos
      }

      idadeNecessariaR2 -= bonusAplicado;
      regra2Apto = (input.idade >= idadeNecessariaR2);
    }

    // Tempo restante Regra 2
    int tempoRestanteR2 = 0;
    if (!regra2Apto) {
      for (int n = 1; n <= 50; n++) {
        int futIdadeMin = _getIdadeMinimaR1(anoAtual + n, input.sexo);
        int futTempoFuncao = input.tempoFuncao + n;
        int futIdade = input.idade + n;
        int futBonus = 0;
        if (futTempoFuncao >= 25) {
          futBonus = futTempoFuncao - 25;
          if (futBonus > 5) futBonus = 5;
        }
        int futIdadeNecessaria = futIdadeMin - futBonus;
        if (futTempoFuncao >= 25 && futIdade >= futIdadeNecessaria) {
          tempoRestanteR2 = n;
          break;
        }
      }
    }

    // ---------------------------------------------------------
    // REGRA 3: Sistema de Pontos
    // ---------------------------------------------------------
    int idadeMinimaR3 = input.sexo == 'F' ? 60 : 63;
    int pontosNecessarios = input.sexo == 'F' ? 83 : 86;
    int pontosAtuais = input.idade + input.tempoContribuicao;

    bool regra3Apto =
        (input.tempoFuncao >= 10) &&
        (input.tempoContribuicao >= 15) &&
        (input.idade >= idadeMinimaR3) &&
        (pontosAtuais >= pontosNecessarios);

    // Tempo restante Regra 3
    int tempoRestanteR3 = 0;
    if (!regra3Apto) {
      for (int n = 1; n <= 50; n++) {
        int futTempoFuncao = input.tempoFuncao + n;
        int futContrib = input.tempoContribuicao + n;
        int futIdade = input.idade + n;
        int futPontos = futIdade + futContrib;
        if (futTempoFuncao >= 10 &&
            futContrib >= 15 &&
            futIdade >= idadeMinimaR3 &&
            futPontos >= pontosNecessarios) {
          tempoRestanteR3 = n;
          break;
        }
      }
    }

    // ---------------------------------------------------------
    // RETORNO DOS RESULTADOS PARA A INTERFACE
    // ---------------------------------------------------------
    return {
      'regra1': {
        'apto': regra1Apto,
        'detalhe':
            'Ano: $anoAtual. Exige 25 anos na função e idade mínima de $idadeMinimaR1 anos.',
        'tempoRestante': tempoRestanteR1,
      },
      'regra2': {
        'apto': regra2Apto,
        'detalhe': bonusAplicado > 0
            ? 'Bónus de $bonusAplicado ano(s) aplicado. Idade mínima exigida cai para $idadeNecessariaR2 anos.'
            : 'Requer mais de 25 anos de função para obter bónus de redução de idade.',
        'tempoRestante': tempoRestanteR2,
      },
      'regra3': {
        'apto': regra3Apto,
        'detalhe':
            'Exige $pontosNecessarios pontos e idade mínima de $idadeMinimaR3 anos. Pontuação atual: $pontosAtuais.',
        'tempoRestante': tempoRestanteR3,
      },
    };
  }
}
