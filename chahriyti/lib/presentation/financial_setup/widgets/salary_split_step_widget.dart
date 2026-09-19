import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/extensions/l10n_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../salary_split/widgets/balance_preview_card.dart';
import 'setup_progress_bar.dart';

class SalarySplitStepWidget extends StatefulWidget {
  final int salaryAmount;
  final int initialAllocation;
  final ValueChanged<int> onNext;
  final VoidCallback onSkip;
  final VoidCallback onBack;

  const SalarySplitStepWidget({
    super.key,
    required this.salaryAmount,
    this.initialAllocation = 0,
    required this.onNext,
    required this.onSkip,
    required this.onBack,
  });

  @override
  State<SalarySplitStepWidget> createState() => _SalarySplitStepWidgetState();
}

class _SalarySplitStepWidgetState extends State<SalarySplitStepWidget> {
  late final TextEditingController _controller;
  late int _allocation;
  late int _remaining;

  @override
  void initState() {
    super.initState();
    _allocation = widget.initialAllocation;
    _remaining = widget.salaryAmount - _allocation;
    _controller = TextEditingController(
      text: _allocation > 0 ? _allocation.toString() : '0',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    final amount = (int.tryParse(value) ?? 0).clamp(0, widget.salaryAmount);
    setState(() {
      _allocation = amount;
      _remaining = widget.salaryAmount - amount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SetupProgressBar(currentStep: 6, totalSteps: 7),
          const SizedBox(height: 32),
          Text(
            'كم تريد أن تدخر من راتبك؟',
            style: AppTypography.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'حدد المبلغ الذي تريد تحويله مباشرة إلى المدخرات.',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          BalancePreviewCard(
            salaryAmount: widget.salaryAmount,
            allocationAmount: _allocation,
            remainingBalance: _remaining,
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textAlign: TextAlign.center,
            style: AppTypography.amountLarge.copyWith(
              color: AppColors.primary,
            ),
            decoration: InputDecoration(
              hintText: '0',
              suffixText: context.l10n.currencySymbol,
              suffixStyle: AppTypography.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppColors.primary, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            onChanged: _onChanged,
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.onSkip,
                  child: const Text('تخطي'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => widget.onNext(_allocation),
                  child: const Text('التالي'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
