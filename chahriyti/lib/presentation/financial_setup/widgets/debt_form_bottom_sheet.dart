import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import 'amount_input_field.dart';

class DebtFormResult {
  final String creditorName;
  final int totalAmount;
  final bool isSpent;

  const DebtFormResult({
    required this.creditorName,
    required this.totalAmount,
    required this.isSpent,
  });
}

class DebtFormBottomSheet extends StatefulWidget {
  final String? initialName;
  final int? initialAmount;
  final bool initialIsSpent;
  final VoidCallback? onDelete;

  const DebtFormBottomSheet({
    super.key,
    this.initialName,
    this.initialAmount,
    this.initialIsSpent = true,
    this.onDelete,
  });

  static Future<DebtFormResult?> show(
    BuildContext context, {
    String? initialName,
    int? initialAmount,
    bool initialIsSpent = true,
    VoidCallback? onDelete,
  }) {
    return showModalBottomSheet<DebtFormResult>(
      context: context,
      isScrollControlled: true,
      builder: (_) => DebtFormBottomSheet(
        initialName: initialName,
        initialAmount: initialAmount,
        initialIsSpent: initialIsSpent,
        onDelete: onDelete,
      ),
    );
  }

  @override
  State<DebtFormBottomSheet> createState() => _DebtFormBottomSheetState();
}

class _DebtFormBottomSheetState extends State<DebtFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _amountController;
  late bool _isSpent;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _amountController = TextEditingController(
      text: widget.initialAmount != null && widget.initialAmount! > 0
          ? widget.initialAmount.toString()
          : '',
    );
    _isSpent = widget.initialIsSpent;
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
      DebtFormResult(
        creditorName: _nameController.text.trim(),
        totalAmount: amount,
        isSpent: _isSpent,
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
                  widget.initialName != null ? 'تعديل الدَّيْن' : 'إضافة دَيْن',
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
            Text('الاسم / الجهة', style: AppTypography.labelMedium),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              textAlign: TextAlign.start,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(hintText: 'مثال: البنك، صديق'),
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
                hintText: 'مثال: 20000',
                suffixText: 'دج',
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'يجب إدخال المبلغ';
                final val = AmountInputField.parse(v);
                if (val == null || val <= 0) return 'المبلغ يجب أن يكون أكبر من صفر';
                return null;
              },
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'هل صرفت هذا المبلغ؟',
                style: AppTypography.labelMedium,
              ),
              subtitle: Text(
                _isSpent
                    ? 'المبلغ تم صرفه ولم يعد في رصيدك'
                    : 'المبلغ لا يزال في رصيدك',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              value: _isSpent,
              onChanged: (v) => setState(() => _isSpent = v),
            ),
            const SizedBox(height: 16),
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
