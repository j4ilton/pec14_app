import 'package:flutter_test/flutter_test.dart';
import 'package:pec14_app/domain/enums/genero.dart';
import 'package:pec14_app/domain/usecases/calcular_elegibilidade_pec14_usecase.dart';

void main() {
  group('CalcularElegibilidadePec14UseCase - calendário real', () {
    final useCase = CalcularElegibilidadePec14UseCase();

    test('Regra 1/2 inicia após 25 anos exatos respeitando fim de mês', () {
      final resultado = useCase(
        dataNascimento: DateTime(1960, 1, 1),
        dataInicioAcsAce: DateTime(2000, 1, 31),
        anosOutroTempo: 0,
        mesesOutroTempo: 0,
        genero: Genero.feminino,
        dataReferencia: DateTime(2024, 1, 1),
      );

      expect(resultado.dataElegibilidade, DateTime(2025, 1, 31));
    });

    test('Regra 1/2 usa anos completos e aniversários (masculino)', () {
      final resultado = useCase(
        dataNascimento: DateTime(1982, 9, 28),
        dataInicioAcsAce: DateTime(2008, 10, 9),
        anosOutroTempo: 0,
        mesesOutroTempo: 0,
        genero: Genero.masculino,
        dataReferencia: DateTime(2026, 1, 1),
      );

      expect(resultado.dataElegibilidade, DateTime(2035, 9, 28));
    });

    test('Regra 1/2 usa anos completos e aniversários (feminino)', () {
      final resultado = useCase(
        dataNascimento: DateTime(1982, 1, 3),
        dataInicioAcsAce: DateTime(2002, 7, 1),
        anosOutroTempo: 0,
        mesesOutroTempo: 0,
        genero: Genero.feminino,
        dataReferencia: DateTime(2026, 1, 1),
      );

      expect(resultado.dataElegibilidade, DateTime(2030, 1, 3));
    });

    test(
      'Regra 1/2 elegível no aniversário de serviço quando idade já atende',
      () {
        final resultado = useCase(
          dataNascimento: DateTime(1960, 1, 1),
          dataInicioAcsAce: DateTime(2000, 6, 1),
          anosOutroTempo: 0,
          mesesOutroTempo: 0,
          genero: Genero.feminino,
          dataReferencia: DateTime(2024, 1, 1),
        );

        expect(resultado.dataElegibilidade, DateTime(2025, 6, 1));
      },
    );

    test('Regra 3 usa aniversário exato da idade mínima em 29/02', () {
      final resultado = useCase(
        dataNascimento: DateTime(1964, 2, 29),
        dataInicioAcsAce: DateTime(2010, 1, 1),
        anosOutroTempo: 15,
        mesesOutroTempo: 0,
        genero: Genero.feminino,
        dataReferencia: DateTime(2024, 1, 1),
      );

      expect(resultado.regraAplicada, contains('Regra 3'));
      expect(resultado.dataElegibilidade, DateTime(2024, 2, 29));
    });

    test('Regra 3 não pode retornar data antes de 10 anos de ACS/ACE', () {
      final resultado = useCase(
        dataNascimento: DateTime(1970, 1, 1),
        dataInicioAcsAce: DateTime(2015, 6, 1),
        anosOutroTempo: 20,
        mesesOutroTempo: 0,
        genero: Genero.feminino,
        dataReferencia: DateTime(2024, 1, 1),
      );

      expect(resultado.dataElegibilidade, isNotNull);
      expect(
        resultado.dataElegibilidade.isBefore(DateTime(2025, 6, 1)),
        isFalse,
      );
    });

    test('Regra 3 mantém requisito de 15 anos só em outros tempos', () {
      final resultado = useCase(
        dataNascimento: DateTime(1970, 1, 1),
        dataInicioAcsAce: DateTime(2000, 1, 1),
        anosOutroTempo: 14,
        mesesOutroTempo: 11,
        genero: Genero.feminino,
        dataReferencia: DateTime(2024, 1, 1),
      );

      expect(resultado.regraAplicada, isNot(contains('Regra 3')));
    });

    test('Regra 3 calcula pontos em dias (valor numérico esperado)', () {
      final resultado = useCase(
        dataNascimento: DateTime(1960, 1, 1),
        dataInicioAcsAce: DateTime(2000, 1, 1),
        anosOutroTempo: 15,
        mesesOutroTempo: 0,
        genero: Genero.feminino,
        dataReferencia: DateTime(2019, 1, 1),
      );

      final dataElegibilidade = resultado.dataElegibilidade;
      expect(dataElegibilidade, DateTime(2020, 1, 1));

      final diasIdade = dataElegibilidade
          .difference(DateTime(1960, 1, 1))
          .inDays;
      final diasAcs = dataElegibilidade.difference(DateTime(2000, 1, 1)).inDays;
      final anchor = DateTime(2000, 1, 1);
      final dataOutros = DateTime(2015, 1, 1);
      final diasOutros = dataOutros.difference(anchor).inDays;

      final pontos = (diasIdade + diasAcs + diasOutros) / 365.0;

      expect(pontos, closeTo(95.06, 0.05));
      expect(pontos, greaterThanOrEqualTo(83.0));
    });

    test('Diff de calendário calcula 1 dia na virada de ano', () {
      final resultado = useCase(
        dataNascimento: DateTime(1960, 1, 1),
        dataInicioAcsAce: DateTime(2002, 1, 1),
        anosOutroTempo: 0,
        mesesOutroTempo: 0,
        genero: Genero.feminino,
        dataReferencia: DateTime(2026, 12, 31),
      );

      expect(resultado.dataElegibilidade, DateTime(2027, 1, 1));
      expect(resultado.anosFaltantes, 0);
      expect(resultado.mesesFaltantes, 0);
      expect(resultado.diasFaltantes, 1);
    });

    test('Diff de calendário respeita fim de mês (31/01 -> 28/02)', () {
      final resultado = useCase(
        dataNascimento: DateTime(1960, 1, 1),
        dataInicioAcsAce: DateTime(2001, 2, 28),
        anosOutroTempo: 0,
        mesesOutroTempo: 0,
        genero: Genero.feminino,
        dataReferencia: DateTime(2026, 1, 31),
      );

      expect(resultado.dataElegibilidade, DateTime(2026, 2, 28));
      expect(resultado.anosFaltantes, 0);
      expect(resultado.mesesFaltantes, 0);
      expect(resultado.diasFaltantes, 28);
    });
  });
}
