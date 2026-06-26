import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color primary = Color(0xFF0D6E6E);       // Deep Teal
  static const Color primaryLight = Color(0xFF1A9494);
  static const Color primaryDark = Color(0xFF084E4E);
  static const Color positive = Color(0xFF22C55E);       // Emerald Green (income/balance)
  static const Color negative = Color(0xFFEF4444);       // Coral Red (expenses)
  static const Color surface = Color(0xFFF8F9FA);        // Warm White
  static const Color card = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1A1A2E);    // Charcoal
  static const Color textSecondary = Color(0xFF94A3B8);  // Cool Gray
  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFF1F5F9);
  static const Color warning = Color(0xFFF59E0B);        // Amber for mid-range
  static const Color background = Color(0xFFF8F9FA);

  // Consumption bar thresholds
  static const Color consumptionLow = positive;     // < 50%
  static const Color consumptionMid = warning;      // 50-75%
  static const Color consumptionHigh = negative;    // > 75%
}
