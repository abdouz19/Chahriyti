import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/extensions/l10n_extension.dart';

class AmountInputField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? Function(String?)? validator;

  const AmountInputField({
    super.key,
    required this.controller,
    this.hintText,
    this.validator,
  });

  /// Parses the display text back to a raw int.
  static int? parse(String text) {
    return text.isEmpty ? null : int.tryParse(text);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textAlign: TextAlign.start,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      decoration: InputDecoration(
        hintText: hintText ?? 'مثال: 50000',
        suffixText: context.l10n.currencySymbol,
      ),
      validator: validator,
    );
  }
}

