import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

abstract final class AppTypography {
  static TextStyle get _baseCairo => GoogleFonts.cairo(
        color: AppColors.textPrimary,
      );

  // Headings
  static TextStyle get headlineLarge => _baseCairo.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.3,
      );

  static TextStyle get headlineMedium => _baseCairo.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        height: 1.3,
      );

  static TextStyle get headlineSmall => _baseCairo.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  // Body
  static TextStyle get bodyLarge => _baseCairo.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  static TextStyle get bodyMedium => _baseCairo.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  static TextStyle get bodySmall => _baseCairo.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: AppColors.textSecondary,
      );

  // Labels
  static TextStyle get labelLarge => _baseCairo.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get labelMedium => _baseCairo.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get labelSmall => _baseCairo.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
      );

  // Amounts (for financial figures)
  static TextStyle get amountLarge => _baseCairo.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.2,
      );

  static TextStyle get amountMedium => _baseCairo.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        height: 1.2,
      );

  static TextStyle get amountSmall => _baseCairo.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.2,
      );
}
