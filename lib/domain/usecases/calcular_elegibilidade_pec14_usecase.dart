import 'dart:math';

import '../enums/genero.dart';

class ResultadoAposentadoria {
  final DateTime dataElegibilidade;
  final String regraAplicada;
  final int anosFaltantes;
  final int mesesFaltantes;
  final int diasFaltantes;

  ResultadoAposentadoria({
    required this.dataElegibilidade,
    required this.regraAplicada,
    required this.anosFaltantes,
    required this.mesesFaltantes,
    required this.diasFaltantes,
  });
}

class CalcularElegibilidadePec14UseCase {
  ResultadoAposentadoria call({
    required DateTime dataNascimento,
    required DateTime dataInicioAcsAce,
    required int anosOutroTempo,
    required int mesesOutroTempo,
    required Genero genero,
    DateTime? dataReferencia,
  }) {
    final hoje = _DateUtils.dateOnly(dataReferencia ?? DateTime.now());

    final opcao1 = _simularRegra1e2(dataNascimento, dataInicioAcsAce, genero);
    final opcao2 = _simularRegra3(
      dataNascimento,
      dataInicioAcsAce,
      anosOutroTempo,
      mesesOutroTempo,
      genero,
    );

    _CandidatoAposentadoria melhorOpcao = opcao1;
    if (opcao2 != null && opcao2.data.isBefore(opcao1.data)) {
      melhorOpcao = opcao2;
    }

    final dataElegibilidade = _DateUtils.dateOnly(melhorOpcao.data);
    final restante = dataElegibilidade.isAfter(hoje)
        ? _DateUtils.diffYmd(hoje, dataElegibilidade)
        : const _DateYmdDifference.zero();

    return ResultadoAposentadoria(
      dataElegibilidade: dataElegibilidade,
      regraAplicada: melhorOpcao.nomeRegra,
      anosFaltantes: restante.anos,
      mesesFaltantes: restante.meses,
      diasFaltantes: restante.dias,
    );
  }

  double _obterIdadeMinimaPorAno(int ano, Genero genero) {
    if (ano <= 2030) {
      return genero == Genero.feminino ? 50.0 : 52.0;
    } else if (ano <= 2035) {
      return genero == Genero.feminino ? 52.0 : 54.0;
    } else if (ano <= 2040) {
      return genero == Genero.feminino ? 54.0 : 56.0;
    } else {
      return genero == Genero.feminino ? 57.0 : 60.0;
    }
  }

  _CandidatoAposentadoria _simularRegra1e2(
    DateTime nascimento,
    DateTime inicioAcsAce,
    Genero genero,
  ) {
    final nascimentoBase = _DateUtils.dateOnly(nascimento);
    final inicioAcsAceBase = _DateUtils.dateOnly(inicioAcsAce);

    // Avaliação em datas exatas (aniversários), com anos completos.
    var dataServico = _DateUtils.addYears(inicioAcsAceBase, 25);
    var dataNascimento = nascimentoBase;

    while (true) {
      final dataTeste =
          dataServico.isBefore(dataNascimento) ? dataServico : dataNascimento;

      final anosTrabalhados =
          _DateUtils.diffYmd(inicioAcsAceBase, dataTeste).anos;
      final anosIdade = _DateUtils.diffYmd(nascimentoBase, dataTeste).anos;

      var bonus = anosTrabalhados - 25;
      if (bonus > 5) bonus = 5;
      if (bonus < 0) bonus = 0;

      final idadeMinimaAtual = _obterIdadeMinimaPorAno(dataTeste.year, genero);
      final idadeMinimaReduzida = idadeMinimaAtual - bonus;

      if (anosTrabalhados >= 25 && anosIdade >= idadeMinimaReduzida) {
        final descricao = bonus > 0
            ? 'Regras 1 e 2: Idade mínima de $idadeMinimaAtual reduzida para ${idadeMinimaReduzida.toStringAsFixed(0)} pelo bônus de tempo de serviço excedente.'
            : 'Regra 1: Aposentadoria alcançada pela Idade Mínima Progressiva.';

        return _CandidatoAposentadoria(data: dataTeste, nomeRegra: descricao);
      }

      if (dataServico.isAtSameMomentAs(dataNascimento)) {
        dataServico = _DateUtils.addYears(dataServico, 1);
        dataNascimento = _DateUtils.addYears(dataNascimento, 1);
      } else if (dataServico.isBefore(dataNascimento)) {
        dataServico = _DateUtils.addYears(dataServico, 1);
      } else {
        dataNascimento = _DateUtils.addYears(dataNascimento, 1);
      }

      if (dataTeste.year > 2100) {
        return _CandidatoAposentadoria(
          data: DateTime(2100),
          nomeRegra: 'Inatingível',
        );
      }
    }
  }

  _CandidatoAposentadoria? _simularRegra3(
    DateTime nascimento,
    DateTime inicioAcsAce,
    int anosOutros,
    int mesesOutros,
    Genero genero,
  ) {
    final nascimentoBase = _DateUtils.dateOnly(nascimento);
    final inicioAcsAceBase = _DateUtils.dateOnly(inicioAcsAce);

    final outrosAnos = anosOutros + (mesesOutros / 12.0);

    if (outrosAnos < 15.0) {
      return null;
    }

    final idadeExigida = genero == Genero.feminino ? 60 : 63;
    final pontosExigidos = genero == Genero.feminino ? 83.0 : 86.0;

    final data10AnosAcs = _DateUtils.addYears(inicioAcsAceBase, 10);
    final dataIdadeMinima = _DateUtils.addYears(nascimentoBase, idadeExigida);

    var dataTeste = data10AnosAcs.isAfter(dataIdadeMinima)
        ? data10AnosAcs
        : dataIdadeMinima;

    while (true) {
      final diffIdade = _DateUtils.diffYmd(nascimentoBase, dataTeste);
      final idadeReal = _DateUtils.toDecimalYears(
        anchorDate: nascimentoBase,
        difference: diffIdade,
      );

      final diffTempoAcs = _DateUtils.diffYmd(inicioAcsAceBase, dataTeste);
      final tempoAcsReal = _DateUtils.toDecimalYears(
        anchorDate: inicioAcsAceBase,
        difference: diffTempoAcs,
      );

      final tempoTotal = tempoAcsReal + outrosAnos;
      final pontosAtuais = idadeReal + tempoTotal;

      if (pontosAtuais >= pontosExigidos) {
        return _CandidatoAposentadoria(
          data: dataTeste,
          nomeRegra:
              'Regra 3: Sistema de Pontos (Soma da Idade e Tempo de Contribuição atingiu a exigência).',
        );
      }

      dataTeste = dataTeste.add(const Duration(days: 1));
      if (dataTeste.year > 2100) return null;
    }
  }
}

class _DateUtils {
  static DateTime dateOnly(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  static DateTime addYears(DateTime date, int years) => addMonths(date, years * 12);

  static DateTime addMonths(DateTime date, int monthsToAdd) {
    final normalized = dateOnly(date);
    final totalMonths = (normalized.year * 12) + (normalized.month - 1) + monthsToAdd;
    final year = totalMonths ~/ 12;
    final month = (totalMonths % 12) + 1;
    final day = min(normalized.day, _daysInMonth(year, month));
    return DateTime(year, month, day);
  }

  static _DateYmdDifference diffYmd(DateTime from, DateTime to) {
    var inicio = dateOnly(from);
    var fim = dateOnly(to);

    if (fim.isBefore(inicio)) {
      return const _DateYmdDifference.zero();
    }

    var anos = fim.year - inicio.year;
    var cursor = addYears(inicio, anos);
    if (cursor.isAfter(fim)) {
      anos -= 1;
      cursor = addYears(inicio, anos);
    }

    var meses = 0;
    while (meses < 12) {
      final proximo = addMonths(cursor, meses + 1);
      if (proximo.isAfter(fim)) break;
      meses += 1;
    }

    cursor = addMonths(cursor, meses);
    final dias = fim.difference(cursor).inDays;

    return _DateYmdDifference(anos: anos, meses: meses, dias: dias);
  }

  static double toDecimalYears({
    required DateTime anchorDate,
    required _DateYmdDifference difference,
  }) {
    final intermediate = addMonths(
      addYears(dateOnly(anchorDate), difference.anos),
      difference.meses,
    );

    final diasNoMesAtual = _daysInMonth(intermediate.year, intermediate.month);

    return difference.anos +
        (difference.meses / 12.0) +
        (difference.dias / diasNoMesAtual / 12.0);
  }

  static int _daysInMonth(int year, int month) => DateTime(year, month + 1, 0).day;
}

class _DateYmdDifference {
  final int anos;
  final int meses;
  final int dias;

  const _DateYmdDifference({
    required this.anos,
    required this.meses,
    required this.dias,
  });

  const _DateYmdDifference.zero()
      : anos = 0,
        meses = 0,
        dias = 0;
}

class _CandidatoAposentadoria {
  final DateTime data;
  final String nomeRegra;

  _CandidatoAposentadoria({required this.data, required this.nomeRegra});
}
