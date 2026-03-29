// lib/viewmodels/calculadora_controller.dart
import 'package:flutter/material.dart';
import '../domain/enums/genero.dart';
import '../domain/usecases/calcular_elegibilidade_pec14_usecase.dart';

class CalculadoraController extends ChangeNotifier {
  final CalcularElegibilidadePec14UseCase _calcularElegibilidadeUseCase;

  CalculadoraController({CalcularElegibilidadePec14UseCase? useCase})
    : _calcularElegibilidadeUseCase =
          useCase ?? CalcularElegibilidadePec14UseCase();

  // Inputs da Tela
  DateTime? _dataNascimento;
  DateTime? _dataInicioAcsAce;
  Genero? _genero;
  int _anosOutroTempo = 0;
  int _mesesOutroTempo = 0;

  // Estados de Saída
  ResultadoAposentadoria? _resultado;
  String? _erroMensagem;

  // Getters
  DateTime? get dataNascimento => _dataNascimento;
  DateTime? get dataInicioAcsAce => _dataInicioAcsAce;
  Genero? get genero => _genero;
  int get anosOutroTempo => _anosOutroTempo;
  int get mesesOutroTempo => _mesesOutroTempo;

  ResultadoAposentadoria? get resultado => _resultado;
  String? get erroMensagem => _erroMensagem;
  bool get hasResultado => _resultado != null;

  // Setters com notificação
  void setDataNascimento(DateTime data) {
    _dataNascimento = data;
    _limparResultado();
    notifyListeners();
  }

  void setDataInicioAcsAce(DateTime data) {
    _dataInicioAcsAce = data;
    _limparResultado();
    notifyListeners();
  }

  void setGenero(Genero? genero) {
    _genero = genero;
    _limparResultado();
    notifyListeners();
  }

  void setOutroTempo(int? anos, int? meses) {
    if (anos != null) _anosOutroTempo = anos;
    if (meses != null) _mesesOutroTempo = meses;
    _limparResultado();
    notifyListeners();
  }

  void calcular() {
    // Validação Rigorosa de Inputs (Evita o problema da imagem)
    if (_dataNascimento == null) {
      _erroMensagem = 'A Data de Nascimento é obrigatória.';
      notifyListeners();
      return;
    }
    if (_dataInicioAcsAce == null) {
      _erroMensagem = 'A Data de Início ACS/ACE é obrigatória.';
      notifyListeners();
      return;
    }
    if (_genero == null) {
      _erroMensagem = 'A seleção de Gênero é obrigatória.';
      notifyListeners();
      return;
    }

    _erroMensagem = null;

    try {
      // Chama o Use Case com todos os dados exigidos pela PEC 14/21
      _resultado = _calcularElegibilidadeUseCase(
        dataNascimento: _dataNascimento!,
        dataInicioAcsAce: _dataInicioAcsAce!,
        anosOutroTempo: _anosOutroTempo,
        mesesOutroTempo: _mesesOutroTempo,
        genero: _genero!,
      );
    } catch (e) {
      _erroMensagem = 'Ocorreu um erro matemático ao realizar o cálculo.';
      _resultado = null;
    }

    notifyListeners();
  }

  void limparCalculo() {
    _dataNascimento = null;
    _dataInicioAcsAce = null;
    _genero = null;
    _anosOutroTempo = 0;
    _mesesOutroTempo = 0;
    _limparResultado();
    notifyListeners();
  }

  void _limparResultado() {
    _resultado = null;
    _erroMensagem = null;
  }
}
