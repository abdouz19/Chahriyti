import 'package:flutter/material.dart';

import '../../../application/use_cases/statistics/get_financial_classification_use_case.dart';
import '../../../core/theme/app_typography.dart';

class ClassificationBadge extends StatelessWidget {
  final FinancialTier tier;

  const ClassificationBadge({
    super.key,
    required this.tier,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _tierColor.withValues(alpha: 0.9),
            _tierColor,
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _tierColor.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            tier.emoji,
            style: const TextStyle(fontSize: 48),
          ),
          const SizedBox(height: 8),
          Text(
            tier.arabicLabel,
            style: AppTypography.headlineLarge.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _tierDescription,
            style: AppTypography.bodyMedium.copyWith(
              color: Colors.white.withValues(alpha: 0.85),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color get _tierColor {
    switch (tier) {
      case FinancialTier.legendary:
        return const Color(0xFFD4A017); // Gold
      case FinancialTier.smart:
        return const Color(0xFF0D6E6E); // Teal
      case FinancialTier.balanced:
        return const Color(0xFF3B82F6); // Blue
      case FinancialTier.spender:
        return const Color(0xFFF59E0B); // Orange
      case FinancialTier.danger:
        return const Color(0xFFEF4444); // Red
      case FinancialTier.earlyBankrupt:
        return const Color(0xFF991B1B); // Dark red
    }
  }

  String get _tierDescription {
    switch (tier) {
      case FinancialTier.legendary:
        return 'أداء مالي استثنائي! وفّرت أكثر من 30%';
      case FinancialTier.smart:
        return 'إدارة ذكية للمال. وفّرت بين 15% و 30%';
      case FinancialTier.balanced:
        return 'إنفاق متوازن. وفّرت بين 5% و 15%';
      case FinancialTier.spender:
        return 'إنفاقك مرتفع. حاول التوفير أكثر';
      case FinancialTier.danger:
        return 'تجاوزت ميزانيتك! راجع مصاريفك';
      case FinancialTier.earlyBankrupt:
        return 'إنفاق سريع جداً مع بداية الشهر';
    }
  }
}
