import 'package:flutter/material.dart';

import '../../../core/extensions/l10n_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import 'amount_input_field.dart';
import 'setup_progress_bar.dart';

class SavingsStepWidget extends StatefulWidget {
  final int? initialValue;
  final ValueChanged<int> onNext;
  final VoidCallback onSkip;
  final VoidCallback onBack;

  const SavingsStepWidget({
    super.key,
    this.initialValue,
    required this.onNext,
    required this.onSkip,
    required this.onBack,
  });

  @override
  State<SavingsStepWidget> createState() => _SavingsStepWidgetState();
}

class _SavingsStepWidgetState extends State<SavingsStepWidget> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialValue != null && widget.initialValue! > 0
          ? widget.initialValue.toString()
          : '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final amount = AmountInputField.parse(_controller.text) ?? 0;
    widget.onNext(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SetupProgressBar(currentStep: 3, totalSteps: 7),
            const SizedBox(height: 32),
            Text(
              context.l10n.savingsStepTitle,
              style: AppTypography.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.savingsStepDesc,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            AmountInputField(
              controller: _controller,
              hintText: context.l10n.amountHint,
              validator: (v) {
                if (v == null || v.isEmpty) return null;
                final val = AmountInputField.parse(v);
                if (val != null && val < 0) return context.l10n.invalidAmount;
                return null;
              },
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: widget.onSkip,
                    child: Text(context.l10n.skip),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submit,
                    child: Text(context.l10n.next),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
