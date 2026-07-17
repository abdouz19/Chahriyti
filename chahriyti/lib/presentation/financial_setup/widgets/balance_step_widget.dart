import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import 'amount_input_field.dart';
import 'setup_progress_bar.dart';

class BalanceStepWidget extends StatefulWidget {
  final int? initialValue;
  final ValueChanged<int> onNext;
  final VoidCallback onBack;

  const BalanceStepWidget({
    super.key,
    this.initialValue,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<BalanceStepWidget> createState() => _BalanceStepWidgetState();
}

class _BalanceStepWidgetState extends State<BalanceStepWidget> {
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
            const SetupProgressBar(currentStep: 2, totalSteps: 6),
            const SizedBox(height: 32),
            Text(
              'كم من المال لديك الآن؟',
              style: AppTypography.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'تحقق من حسابك البنكي، محفظتك، والنقد المتوفر.',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            AmountInputField(
              controller: _controller,
              hintText: 'مثال: 50000',
              validator: (v) {
                if (v == null || v.isEmpty) return 'يرجى إدخال الرصيد';
                final val = AmountInputField.parse(v);
                if (val == null || val < 0) return 'المبلغ غير صالح';
                return null;
              },
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                child: const Text('التالي'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
