import 'package:flutter/material.dart';

class ResultadoCard extends StatelessWidget {
  final String titulo;
  final bool isApto;
  final String detalhe;

  const ResultadoCard({
    super.key,
    required this.titulo,
    required this.isApto,
    required this.detalhe,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      color: isApto ? Colors.green.shade50 : Colors.red.shade50,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: isApto ? Colors.green.shade300 : Colors.red.shade300,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: Icon(
            isApto ? Icons.check_circle : Icons.cancel,
            color: isApto ? Colors.green.shade700 : Colors.red.shade700,
            size: 36,
          ),
          title: Text(
            titulo,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(detalhe, style: const TextStyle(fontSize: 14)),
          ),
          trailing: Text(
            isApto ? 'APTO' : 'INAPTO',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isApto ? Colors.green.shade800 : Colors.red.shade800,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
