import 'package:flutter/material.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/value_objects/money.dart';

class MoneyText extends StatelessWidget {
  final Money amount;
  final TextStyle? style;
  final Color? color;
  final bool showSign;

  const MoneyText({
    super.key,
    required this.amount,
    this.style,
    this.color,
    this.showSign = false,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = (style ?? AppTypography.amountMedium).copyWith(
      color: color ?? _defaultColor,
    );
    final prefix = showSign && amount.isPositive ? '+' : '';
    final text = '$prefix${amount.formatWithSymbol(context.l10n.currencySymbol)}';

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Text(
        text,
        style: textStyle,
      ),
    );
  }

  Color get _defaultColor {
    if (amount.isNegative) return AppColors.negative;
    if (amount.isPositive) return AppColors.textPrimary;
    return AppColors.textSecondary;
  }
}
