class TempoRestante {
  final int anos;
  final int meses;
  final int dias;

  const TempoRestante(this.anos, this.meses, this.dias);

  bool get isZero => anos == 0 && meses == 0 && dias == 0;

  String formatar() {
    final List<String> partes = [];
    if (anos > 0) partes.add('$anos ano${anos != 1 ? "s" : ""}');
    if (meses > 0) partes.add('$meses ${meses != 1 ? "meses" : "mês"}');
    if (dias > 0) partes.add('$dias dia${dias != 1 ? "s" : ""}');
    return partes.join(', ');
  }
}

class CalculadoraInput {
  final String sexo;
  final int idade;
  final int tempoFuncao;
  final int tempoOutrasFuncoes;
  final int tempoContribuicao;
  final DateTime dataNascimento;
  final DateTime dataAdmissao;

  CalculadoraInput({
    required this.sexo,
    required this.idade,
    required this.tempoFuncao,
    required this.tempoOutrasFuncoes,
    required this.tempoContribuicao,
    required this.dataNascimento,
    required this.dataAdmissao,
  });
}

class CalculadoraController {
  int _getIdadeMinimaR1(int ano, String sexo) {
    if (ano <= 2030) return sexo == 'F' ? 50 : 52;
    if (ano <= 2035) return sexo == 'F' ? 52 : 54;
    if (ano <= 2040) return sexo == 'F' ? 54 : 56;
    return sexo == 'F' ? 57 : 60;
  }

  /// Adiciona [years] anos a [date], respeitando o último dia do mês.
  DateTime _addYears(DateTime date, int years) {
    final int newYear = date.year + years;
    final int lastDay = DateTime(newYear, date.month + 1, 0).day;
    return DateTime(
      newYear,
      date.month,
      date.day > lastDay ? lastDay : date.day,
    );
  }

  /// Anos completos de [birthDate] até [atDate].
  int _ageAt(DateTime birthDate, DateTime atDate) {
    int age = atDate.year - birthDate.year;
    if (atDate.month < birthDate.month ||
        (atDate.month == birthDate.month && atDate.day < birthDate.day)) {
      age--;
    }
    return age < 0 ? 0 : age;
  }

  /// Anos completos desde [startDate] até [atDate].
  int _yearsAt(DateTime startDate, DateTime atDate) {
    int years = atDate.year - startDate.year;
    if (atDate.month < startDate.month ||
        (atDate.month == startDate.month && atDate.day < startDate.day)) {
      years--;
    }
    return years < 0 ? 0 : years;
  }

  /// Diferença de [hoje] até [targetDate] em anos, meses e dias.
  TempoRestante _calcularDiff(DateTime hoje, DateTime targetDate) {
    if (!targetDate.isAfter(hoje)) return const TempoRestante(0, 0, 0);
    int anos = targetDate.year - hoje.year;
    int meses = targetDate.month - hoje.month;
    int dias = targetDate.day - hoje.day;
    if (dias < 0) {
      meses--;
      dias += DateTime(targetDate.year, targetDate.month, 0).day;
    }
    if (meses < 0) {
      anos--;
      meses += 12;
    }
    return TempoRestante(anos, meses, dias);
  }

  /// Data exata em que a Regra 1 será satisfeita.
  DateTime _eligibilityR1(DateTime hoje, CalculadoraInput input) {
    final DateTime dateFunc = _addYears(input.dataAdmissao, 25);
    final DateTime start = dateFunc.isAfter(hoje) ? dateFunc : hoje;

    if (_ageAt(input.dataNascimento, start) >=
        _getIdadeMinimaR1(start.year, input.sexo)) {
      return start;
    }

    final int ageAtStart = _ageAt(input.dataNascimento, start);
    for (int a = ageAtStart + 1; a <= ageAtStart + 60; a++) {
      final DateTime birthday = _addYears(input.dataNascimento, a);
      if (a >= _getIdadeMinimaR1(birthday.year, input.sexo)) {
        return birthday;
      }
    }
    return _addYears(hoje, 50);
  }

  /// Data exata em que a Regra 2 será satisfeita.
  DateTime _eligibilityR2(DateTime hoje, CalculadoraInput input) {
    final DateTime minFuncDate = _addYears(input.dataAdmissao, 25);
    final int baseAge = _ageAt(input.dataNascimento, hoje);
    final int baseFuncYears = _yearsAt(input.dataAdmissao, hoje);

    final List<DateTime> keyDates = [];
    for (int a = baseAge; a <= baseAge + 60; a++) {
      keyDates.add(_addYears(input.dataNascimento, a));
    }
    final int startFunc = baseFuncYears < 25 ? 25 : baseFuncYears;
    for (int y = startFunc; y <= startFunc + 60; y++) {
      keyDates.add(_addYears(input.dataAdmissao, y));
    }
    keyDates.sort((a, b) => a.compareTo(b));

    for (final DateTime d in keyDates) {
      if (!d.isAfter(hoje)) continue;
      if (d.isBefore(minFuncDate)) continue;
      final int funcYears = _yearsAt(input.dataAdmissao, d);
      if (funcYears < 25) continue;
      final int bonus = (funcYears - 25).clamp(0, 5);
      final int idadeNecessaria = _getIdadeMinimaR1(d.year, input.sexo) - bonus;
      if (_ageAt(input.dataNascimento, d) >= idadeNecessaria) return d;
    }
    return _addYears(hoje, 50);
  }

  /// Data exata em que a Regra 3 será satisfeita.
  DateTime _eligibilityR3(DateTime hoje, CalculadoraInput input) {
    final int idadeMinimaR3 = input.sexo == 'F' ? 60 : 63;
    final int pontosNecessarios = input.sexo == 'F' ? 83 : 86;
    final int baseAge = _ageAt(input.dataNascimento, hoje);
    final int baseFuncYears = _yearsAt(input.dataAdmissao, hoje);

    final List<DateTime> keyDates = [];
    for (int a = baseAge; a <= baseAge + 60; a++) {
      keyDates.add(_addYears(input.dataNascimento, a));
    }
    for (int y = baseFuncYears; y <= baseFuncYears + 60; y++) {
      keyDates.add(_addYears(input.dataAdmissao, y));
    }
    keyDates.sort((a, b) => a.compareTo(b));

    for (final DateTime d in keyDates) {
      if (!d.isAfter(hoje)) continue;
      final int funcYears = _yearsAt(input.dataAdmissao, d);
      final int ageAtD = _ageAt(input.dataNascimento, d);
      final int contribAtD = input.tempoOutrasFuncoes + funcYears;
      final int pontosAtD = ageAtD + contribAtD;
      if (funcYears >= 10 &&
          contribAtD >= 15 &&
          ageAtD >= idadeMinimaR3 &&
          pontosAtD >= pontosNecessarios) {
        return d;
      }
    }
    return _addYears(hoje, 50);
  }

  Map<String, dynamic> calcularRegras(CalculadoraInput input) {
    final DateTime hoje = DateTime.now();
    final int anoAtual = hoje.year;

    // ---------------------------------------------------------
    // REGRA 1: Idade Mínima Progressiva (Baseada no ano atual)
    // ---------------------------------------------------------
    final int idadeMinimaR1 = _getIdadeMinimaR1(anoAtual, input.sexo);
    final bool regra1Apto =
        (input.tempoFuncao >= 25) && (input.idade >= idadeMinimaR1);
    final TempoRestante tempoRestanteR1 = regra1Apto
        ? const TempoRestante(0, 0, 0)
        : _calcularDiff(hoje, _eligibilityR1(hoje, input));

    // ---------------------------------------------------------
    // REGRA 2: Redução de Idade com Mais Tempo de Serviço
    // ---------------------------------------------------------
    bool regra2Apto = false;
    int idadeNecessariaR2 = idadeMinimaR1;
    int bonusAplicado = 0;
    if (input.tempoFuncao >= 25) {
      bonusAplicado = (input.tempoFuncao - 25).clamp(0, 5);
      idadeNecessariaR2 -= bonusAplicado;
      regra2Apto = (input.idade >= idadeNecessariaR2);
    }
    final TempoRestante tempoRestanteR2 = regra2Apto
        ? const TempoRestante(0, 0, 0)
        : _calcularDiff(hoje, _eligibilityR2(hoje, input));

    // ---------------------------------------------------------
    // REGRA 3: Sistema de Pontos
    // ---------------------------------------------------------
    final int idadeMinimaR3 = input.sexo == 'F' ? 60 : 63;
    final int pontosNecessarios = input.sexo == 'F' ? 83 : 86;
    final int pontosAtuais = input.idade + input.tempoContribuicao;
    final bool regra3Apto =
        (input.tempoFuncao >= 10) &&
        (input.tempoContribuicao >= 15) &&
        (input.idade >= idadeMinimaR3) &&
        (pontosAtuais >= pontosNecessarios);
    final TempoRestante tempoRestanteR3 = regra3Apto
        ? const TempoRestante(0, 0, 0)
        : _calcularDiff(hoje, _eligibilityR3(hoje, input));

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
