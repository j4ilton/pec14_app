// lib/domain/usecases/calcular_elegibilidade_pec14_usecase.dart
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
  }) {
    final hoje = DateTime.now();

    // Calcula os possíveis cenários
    final opcao1 = _simularRegra1e2(dataNascimento, dataInicioAcsAce, genero);
    final opcao2 = _simularRegra3(
      dataNascimento,
      dataInicioAcsAce,
      anosOutroTempo,
      mesesOutroTempo,
      genero,
    );

    // O direito trabalhista sempre prioriza a regra mais benéfica (a que ocorre primeiro)
    _CandidatoAposentadoria melhorOpcao = opcao1;
    if (opcao2 != null && opcao2.data.isBefore(opcao1.data)) {
      melhorOpcao = opcao2;
    }

    // Calcula o tempo restante
    Duration restante = melhorOpcao.data.difference(hoje);
    if (restante.isNegative) restante = Duration.zero;

    return ResultadoAposentadoria(
      dataElegibilidade: melhorOpcao.data,
      regraAplicada: melhorOpcao.nomeRegra,
      anosFaltantes: (restante.inDays / 365).floor(),
      mesesFaltantes: ((restante.inDays % 365) / 30).floor(),
      diasFaltantes: (restante.inDays % 365) % 30,
    );
  }

  // Lógica da Tabela de Escalonamento (Regra 1 pura)
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

  // Simulação unificada da Regra 1 (Idade) com a Regra 2 (Bônus)
  _CandidatoAposentadoria _simularRegra1e2(
    DateTime nascimento,
    DateTime inicioAcsAce,
    Genero genero,
  ) {
    // O marco zero para iniciar a verificação é quando o servidor completa 25 anos na função
    DateTime dataTeste = inicioAcsAce.add(const Duration(days: 25 * 365));

    while (true) {
      int anoAtual = dataTeste.year;
      double idadeMinimaAtual = _obterIdadeMinimaPorAno(anoAtual, genero);

      double diasTrabalhados = dataTeste
          .difference(inicioAcsAce)
          .inDays
          .toDouble();
      double anosTrabalhados = diasTrabalhados / 365.25;

      // Bloco de Bônus
      double bonus = anosTrabalhados - 25.0;
      if (bonus > 5.0) bonus = 5.0;
      if (bonus < 0.0) bonus = 0.0;

      double idadeMinimaReduzida = idadeMinimaAtual - bonus;
      double idadeReal = dataTeste.difference(nascimento).inDays / 365.25;

      // Verificação de Elegibilidade
      if (idadeReal >= idadeMinimaReduzida) {
        String descricao = bonus > 0
            ? 'Regras 1 e 2: Idade mínima de $idadeMinimaAtual reduzida para ${idadeMinimaReduzida.toStringAsFixed(1)} pelo bônus de tempo de serviço excedente.'
            : 'Regra 1: Aposentadoria alcançada pela Idade Mínima Progressiva.';

        return _CandidatoAposentadoria(data: dataTeste, nomeRegra: descricao);
      }

      dataTeste = dataTeste.add(
        const Duration(days: 1),
      ); // Avança a linha do tempo em 1 dia

      // Failsafe arquitetural para evitar loops infinitos caso os dados inseridos sejam absurdos
      if (dataTeste.year > 2100)
        return _CandidatoAposentadoria(
          data: DateTime(2100),
          nomeRegra: 'Inatingível',
        );
    }
  }

  // Simulação da Regra 3 (Sistema de Pontos Rígido)
  _CandidatoAposentadoria? _simularRegra3(
    DateTime nascimento,
    DateTime inicioAcsAce,
    int anosOutros,
    int mesesOutros,
    Genero genero,
  ) {
    double outrosAnos = anosOutros + (mesesOutros / 12.0);

    // Trava estrutural: A Regra 3 exige categoricamente 15 anos em outras funções.
    if (outrosAnos < 15.0) {
      return null;
    }

    double idadeExigida = genero == Genero.feminino ? 60.0 : 63.0;
    double pontosExigidos = genero == Genero.feminino ? 83.0 : 86.0;

    // Define o marco inicial como a data em que os requisitos fixos de tempo (10 anos de ACS) e idade são atingidos
    DateTime data10AnosAcs = inicioAcsAce.add(const Duration(days: 10 * 365));
    DateTime dataIdadeMinima = nascimento.add(
      Duration(days: (idadeExigida * 365.25).toInt()),
    );

    DateTime dataTeste = data10AnosAcs.isAfter(dataIdadeMinima)
        ? data10AnosAcs
        : dataIdadeMinima;

    while (true) {
      double idadeReal = dataTeste.difference(nascimento).inDays / 365.25;
      double tempoAcsReal = dataTeste.difference(inicioAcsAce).inDays / 365.25;
      double tempoTotal = tempoAcsReal + outrosAnos;

      double pontosAtuais = idadeReal + tempoTotal;

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

// Classe de transferência de dados (DTO) interna
class _CandidatoAposentadoria {
  final DateTime data;
  final String nomeRegra;

  _CandidatoAposentadoria({required this.data, required this.nomeRegra});
}
