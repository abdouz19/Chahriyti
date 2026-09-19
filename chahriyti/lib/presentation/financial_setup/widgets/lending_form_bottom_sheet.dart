import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/extensions/l10n_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import 'amount_input_field.dart';

class LendingFormResult {
  final String borrowerName;
  final int totalAmount;

  const LendingFormResult({
    required this.borrowerName,
    required this.totalAmount,
  });
}

class LendingFormBottomSheet extends StatefulWidget {
  final String? initialName;
  final int? initialAmount;
  final VoidCallback? onDelete;

  const LendingFormBottomSheet({
    super.key,
    this.initialName,
    this.initialAmount,
    this.onDelete,
  });

  static Future<LendingFormResult?> show(
    BuildContext context, {
    String? initialName,
    int? initialAmount,
    VoidCallback? onDelete,
  }) {
    return showModalBottomSheet<LendingFormResult>(
      context: context,
      isScrollControlled: true,
      builder: (_) => LendingFormBottomSheet(
        initialName: initialName,
        initialAmount: initialAmount,
        onDelete: onDelete,
      ),
    );
  }

  @override
  State<LendingFormBottomSheet> createState() => _LendingFormBottomSheetState();
}

class _LendingFormBottomSheetState extends State<LendingFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _amountController = TextEditingController(
      text: widget.initialAmount != null && widget.initialAmount! > 0
          ? widget.initialAmount.toString()
          : '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final amount = AmountInputField.parse(_amountController.text) ?? 0;
    Navigator.of(context).pop(
      LendingFormResult(
        borrowerName: _nameController.text.trim(),
        totalAmount: amount,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.initialName != null ? context.l10n.editLending : context.l10n.newLending,
                  style: AppTypography.headlineSmall,
                ),
                if (widget.onDelete != null)
                  IconButton(
                    icon: const Icon(Icons.delete_outline,
                        color: AppColors.negative),
                    onPressed: () {
                      widget.onDelete!();
                      Navigator.of(context).pop();
                    },
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(context.l10n.borrowerName, style: AppTypography.labelMedium),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              textAlign: TextAlign.start,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(hintText: context.l10n.borrowerNameHint),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? context.l10n.nameRequired : null,
            ),
            const SizedBox(height: 16),
            Text(context.l10n.amount, style: AppTypography.labelMedium),
            const SizedBox(height: 8),
            TextFormField(
              controller: _amountController,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                hintText: context.l10n.amountHint,
                suffixText: context.l10n.currencySymbol,
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return context.l10n.amountRequired;
                final val = AmountInputField.parse(v);
                if (val == null || val <= 0) return context.l10n.amountMustBePositive;
                return null;
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                child: Text(context.l10n.save),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
