// lib/domain/enums/genero.dart

enum Genero {
  feminino,
  masculino;

  String get descricao {
    switch (this) {
      case Genero.feminino:
        return 'Feminino';
      case Genero.masculino:
        return 'Masculino';
    }
  }
}
