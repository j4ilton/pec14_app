import 'package:flutter/material.dart';

/// Extensão que fornece helpers de responsividade baseados na largura da tela.
/// Largura de referência: 375 dp (iPhone SE / padrão de design mobile).
extension ResponsiveExt on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Escala tamanho de fonte. Limitado entre 85% e 130% do valor base.
  double rsp(double size) {
    final scale = screenWidth / 375.0;
    return (size * scale).clamp(size * 0.85, size * 1.3);
  }

  /// Escala espaçamentos, padding e alturas de UI.
  double rspSpacing(double size) {
    final scale = screenWidth / 375.0;
    return (size * scale).clamp(size * 0.7, size * 1.4);
  }

  /// Escala tamanho de ícones.
  double rspIcon(double size) {
    final scale = screenWidth / 375.0;
    return (size * scale).clamp(size * 0.75, size * 1.4);
  }
}
