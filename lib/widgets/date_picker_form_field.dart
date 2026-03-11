import 'package:flutter/material.dart';

class DatePickerFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData icon;
  final VoidCallback onTap;
  final VoidCallback onClear;

  const DatePickerFormField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.icon,
    required this.onTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    // Using a ValueListenableBuilder is efficient as it only rebuilds
    // this small part of the UI when the controller's text changes.
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, child) {
        return TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (value.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: onClear,
                    tooltip: 'Limpar data',
                  ),
                Icon(icon),
              ],
            ),
          ),
          readOnly: true,
          onTap: onTap,
          validator: (val) {
            if (val == null || val.isEmpty) {
              return 'Por favor, selecione a data.';
            }
            return null;
          },
        );
      },
    );
  }
}
