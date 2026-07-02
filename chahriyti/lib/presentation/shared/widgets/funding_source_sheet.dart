import 'package:flutter/material.dart';

import '../../../core/extensions/money_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

/// Shows a bottom sheet that lets the user split a payment between
/// their current balance and savings.
///
/// Returns a [FundingResult] on confirm, or null if dismissed.
Future<FundingResult?> showFundingSourceSheet(
  BuildContext context, {
  required int amount,
  required int availableBalance,
  required int availableSavings,
}) {
  // Guard: can we even afford this?
  if (amount > availableBalance + availableSavings) return Future.value(null);

  return showModalBottomSheet<FundingResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.card,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => _FundingSourceSheet(
      amount: amount,
      availableBalance: availableBalance,
      availableSavings: availableSavings,
    ),
  );
}

class FundingResult {
  /// Portion paid from savings (0 = all from balance).
  final int savingsAmount;

  /// True only when the ENTIRE amount is paid from savings.
  bool get fromSavings => savingsAmount > 0 && savingsAmount >= _amount;

  final int _amount;

  const FundingResult({required int amount, required this.savingsAmount})
      : _amount = amount;
}

class _FundingSourceSheet extends StatefulWidget {
  final int amount;
  final int availableBalance;
  final int availableSavings;

  const _FundingSourceSheet({
    required this.amount,
    required this.availableBalance,
    required this.availableSavings,
  });

  @override
  State<_FundingSourceSheet> createState() => _FundingSourceSheetState();
}

class _FundingSourceSheetState extends State<_FundingSourceSheet> {
  late int _savingsAmount;

  int get _balanceAmount => widget.amount - _savingsAmount;

  @override
  void initState() {
    super.initState();
    // Default: pay as much from balance as possible, rest from savings
    final fromBalance = widget.availableBalance.clamp(0, widget.amount);
    _savingsAmount = widget.amount - fromBalance;
  }

  void _onSliderChanged(double value) {
    setState(() => _savingsAmount = value.round());
  }

  @override
  Widget build(BuildContext context) {
    final maxFromSavings = widget.availableSavings.clamp(0, widget.amount);
    final minFromSavings =
        (widget.amount - widget.availableBalance).clamp(0, widget.amount);

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('مصدر الدفع', style: AppTypography.headlineSmall),
          const SizedBox(height: 4),
          Text(
            'الإجمالي: ${widget.amount.toDZDString()}',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),

          // Balance row
          _SourceRow(
            icon: Icons.account_balance_wallet_rounded,
            label: 'من الرصيد',
            available: widget.availableBalance,
            amount: _balanceAmount,
            color: AppColors.positive,
          ),
          const SizedBox(height: 12),

          // Savings row
          _SourceRow(
            icon: Icons.savings_rounded,
            label: 'من المدخرات',
            available: widget.availableSavings,
            amount: _savingsAmount,
            color: AppColors.primary,
          ),

          // Slider — only show when split is possible
          if (maxFromSavings > 0 && maxFromSavings > minFromSavings) ...[
            const SizedBox(height: 8),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: AppColors.primary,
                thumbColor: AppColors.primary,
                inactiveTrackColor: AppColors.border,
                overlayColor: AppColors.primary.withValues(alpha: 0.1),
              ),
              child: Slider(
                value: _savingsAmount.toDouble(),
                min: minFromSavings.toDouble(),
                max: maxFromSavings.toDouble(),
                divisions: maxFromSavings - minFromSavings > 0
                    ? (maxFromSavings - minFromSavings).clamp(1, 100)
                    : null,
                onChanged: _onSliderChanged,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'كل من الرصيد',
                  style: AppTypography.bodySmall
                      .copyWith(color: AppColors.textSecondary),
                ),
                Text(
                  'كل من المدخرات',
                  style: AppTypography.bodySmall
                      .copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ],

          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(
                FundingResult(
                  amount: widget.amount,
                  savingsAmount: _savingsAmount,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('تأكيد'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SourceRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final int available;
  final int amount;
  final Color color;

  const _SourceRow({
    required this.icon,
    required this.label,
    required this.available,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTypography.labelSmall),
              Text(
                'متاح: ${available.toDZDString()}',
                style: AppTypography.bodySmall
                    .copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        Text(
          amount.toDZDString(),
          style: AppTypography.labelLarge.copyWith(color: color),
        ),
      ],
    );
  }
}
