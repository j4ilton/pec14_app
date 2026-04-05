class QuizSource {
  final String documento;
  final int pagina;
  final String? observacao;

  const QuizSource({
    required this.documento,
    required this.pagina,
    this.observacao,
  });

  factory QuizSource.fromJson(Map<String, dynamic> json) {
    return QuizSource(
      documento: json['documento'] as String,
      pagina: json['pagina'] as int,
      observacao: json['observacao'] as String?,
    );
  }
}
