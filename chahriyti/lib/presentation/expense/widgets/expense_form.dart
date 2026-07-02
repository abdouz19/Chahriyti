import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class ExpenseForm extends StatefulWidget {
  /// Called when the form is valid and the user taps save.
  final Future<void> Function({
    required String itemName,
    required int amount,
    String? notes,
  }) onSave;

  /// Pre-populated item name (used by edit flow).
  final String? initialItemName;

  /// Pre-populated amount in DZD (used by edit flow).
  final int? initialAmount;

  /// Pre-populated notes (used by edit flow).
  final String? initialNotes;

  /// Whether the form is in a saving/loading state.
  final bool isSaving;

  const ExpenseForm({
    super.key,
    required this.onSave,
    this.initialItemName,
    this.initialAmount,
    this.initialNotes,
    this.isSaving = false,
  });

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _itemController;
  late final TextEditingController _amountController;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _itemController =
        TextEditingController(text: widget.initialItemName ?? '');
    _amountController = TextEditingController(
      text: widget.initialAmount != null
          ? widget.initialAmount.toString()
          : '',
    );
    _notesController =
        TextEditingController(text: widget.initialNotes ?? '');
  }

  @override
  void dispose() {
    _itemController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final amount = int.tryParse(_amountController.text.trim()) ?? 0;
    await widget.onSave(
      itemName: _itemController.text.trim(),
      amount: amount,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Amount
          _SectionLabel(label: 'السعر'),
          const SizedBox(height: 8),
          TextFormField(
            controller: _amountController,
            textAlign: TextAlign.start,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: AppTypography.bodyLarge,
            decoration: const InputDecoration(
              hintText: '0',
              suffixText: 'دج',
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return 'يرجى إدخال السعر';
              }
              final n = int.tryParse(v.trim());
              if (n == null || n <= 0) {
                return 'يجب أن يكون السعر أكبر من الصفر';
              }
              return null;
            },
          ),

          const SizedBox(height: 20),

          // Item name
          _SectionLabel(label: 'ماذا اشتريت؟'),
          const SizedBox(height: 8),
          TextFormField(
            controller: _itemController,
            textAlign: TextAlign.start,
            textDirection: TextDirection.rtl,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            style: AppTypography.bodyLarge,
            decoration: const InputDecoration(
              hintText: 'مثال: خبز، دجاج، شراب...',
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return 'يرجى إدخال اسم المنتج';
              }
              return null;
            },
          ),

          const SizedBox(height: 20),

          // Notes (optional)
          _SectionLabel(label: 'ملاحظات (اختياري)'),
          const SizedBox(height: 8),
          TextFormField(
            controller: _notesController,
            textAlign: TextAlign.start,
            textDirection: TextDirection.rtl,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.done,
            maxLines: 2,
            style: AppTypography.bodyMedium,
            decoration: const InputDecoration(
              hintText: 'أي تفاصيل إضافية...',
            ),
          ),

          const SizedBox(height: 32),

          // Save button
          ElevatedButton(
            onPressed: widget.isSaving ? null : _submit,
            child: widget.isSaving
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text('حفظ'),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Private helpers
// ---------------------------------------------------------------------------

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTypography.labelMedium.copyWith(
        color: AppColors.textSecondary,
      ),
      textAlign: TextAlign.start,
    );
  }
}
