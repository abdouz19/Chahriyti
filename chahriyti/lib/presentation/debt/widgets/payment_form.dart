import 'package:flutter/material.dart';

import '../../../core/extensions/l10n_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class PaymentFormWidget extends StatefulWidget {
  final int remainingBalance; // in centimes
  final void Function(int amount) onSubmit;
  final bool isLoading;

  const PaymentFormWidget({
    required this.remainingBalance,
    required this.onSubmit,
    this.isLoading = false,
    super.key,
  });

  @override
  State<PaymentFormWidget> createState() => _PaymentFormWidgetState();
}

class _PaymentFormWidgetState extends State<PaymentFormWidget> {
  late final TextEditingController _amountController;
  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final amount = int.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.enterValidAmount)),
      );
      return;
    }

    if (amount > widget.remainingBalance) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.amountExceedsRemaining('${widget.remainingBalance}')),
          backgroundColor: AppColors.negative,
        ),
      );
      return;
    }

    widget.onSubmit(amount);
    _amountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.addPayment,
              style: AppTypography.labelLarge,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              enabled: !widget.isLoading,
              decoration: InputDecoration(
                hintText: context.l10n.enterAmount,
                suffixText: context.l10n.currencySymbol,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return context.l10n.amountRequired;
                }
                if (int.tryParse(value) == null) {
                  return context.l10n.enterNumber;
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.isLoading ? null : _submit,
                child: widget.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(context.l10n.addPayment),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
