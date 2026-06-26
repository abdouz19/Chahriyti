import 'package:flutter/material.dart';
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

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Text(
        _formattedText,
        style: textStyle,
      ),
    );
  }

  Color get _defaultColor {
    if (amount.isNegative) return AppColors.negative;
    if (amount.isPositive) return AppColors.textPrimary;
    return AppColors.textSecondary;
  }

  String get _formattedText {
    final prefix = showSign && amount.isPositive ? '+' : '';
    return '$prefix${amount.formatDZD()}';
  }
}
