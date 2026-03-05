class CalculadoraController {
  Map<String, dynamic> calcularRegras({
    required String sexo,
    required int idade,
    required int tempoFuncao,
    required int tempoContribuicao,
  }) {
    // 1. Obter o ano atual dinamicamente
    int anoAtual = DateTime.now().year;

    // ---------------------------------------------------------
    // REGRA 1: Idade Mínima Progressiva (Baseada no ano atual)
    // ---------------------------------------------------------
    int idadeMinimaR1 = 0;

    if (anoAtual <= 2030) {
      idadeMinimaR1 = sexo == 'F' ? 50 : 52;
    } else if (anoAtual <= 2035) {
      idadeMinimaR1 = sexo == 'F' ? 52 : 54;
    } else if (anoAtual <= 2040) {
      idadeMinimaR1 = sexo == 'F' ? 54 : 56;
    } else {
      // 2041 em diante
      idadeMinimaR1 = sexo == 'F' ? 57 : 60;
    }

    bool regra1Apto = (tempoFuncao >= 25) && (idade >= idadeMinimaR1);

    // ---------------------------------------------------------
    // REGRA 2: Redução de Idade com Mais Tempo de Serviço
    // ---------------------------------------------------------
    bool regra2Apto = false;
    // A regra 2 parte da idade mínima estabelecida pela regra 1 no ano atual
    int idadeNecessariaR2 = idadeMinimaR1;
    int bonusAplicado = 0;

    if (tempoFuncao >= 25) {
      bonusAplicado = tempoFuncao - 25;
      if (bonusAplicado > 5)
        bonusAplicado = 5; // Trava o limite de bónus em 5 anos

      idadeNecessariaR2 -= bonusAplicado;
      regra2Apto = (idade >= idadeNecessariaR2);
    }

    // ---------------------------------------------------------
    // REGRA 3: Sistema de Pontos
    // ---------------------------------------------------------
    int idadeMinimaR3 = sexo == 'F' ? 60 : 63;
    int pontosNecessarios = sexo == 'F' ? 83 : 86;
    int pontosAtuais = idade + tempoContribuicao;

    bool regra3Apto =
        (tempoFuncao >= 10) &&
        (tempoContribuicao >= 15) &&
        (idade >= idadeMinimaR3) &&
        (pontosAtuais >= pontosNecessarios);

    // ---------------------------------------------------------
    // RETORNO DOS RESULTADOS PARA A INTERFACE
    // ---------------------------------------------------------
    return {
      'regra1': {
        'apto': regra1Apto,
        'detalhe':
            'Ano: $anoAtual. Exige 25 anos na função e idade mínima de $idadeMinimaR1 anos.',
      },
      'regra2': {
        'apto': regra2Apto,
        'detalhe': bonusAplicado > 0
            ? 'Bónus de $bonusAplicado ano(s) aplicado. Idade mínima exigida cai para $idadeNecessariaR2 anos.'
            : 'Requer mais de 25 anos de função para obter bónus de redução de idade.',
      },
      'regra3': {
        'apto': regra3Apto,
        'detalhe':
            'Exige $pontosNecessarios pontos e idade mínima de $idadeMinimaR3 anos. Pontuação atual: $pontosAtuais.',
      },
    };
  }
}
