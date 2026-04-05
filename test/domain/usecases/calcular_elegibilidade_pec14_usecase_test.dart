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
