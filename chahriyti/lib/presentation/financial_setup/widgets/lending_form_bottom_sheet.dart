import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
                  widget.initialName != null ? 'تعديل السلفة' : 'إضافة سلفة',
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
            Text('اسم المقترض', style: AppTypography.labelMedium),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              textAlign: TextAlign.start,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(hintText: 'مثال: أحمد، خالد'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'يجب إدخال الاسم' : null,
            ),
            const SizedBox(height: 16),
            Text('المبلغ', style: AppTypography.labelMedium),
            const SizedBox(height: 8),
            TextFormField(
              controller: _amountController,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                hintText: 'مثال: 5000',
                suffixText: 'دج',
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'يجب إدخال المبلغ';
                final val = AmountInputField.parse(v);
                if (val == null || val <= 0) return 'المبلغ يجب أن يكون أكبر من صفر';
                return null;
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                child: const Text('حفظ'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
