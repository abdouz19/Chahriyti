import '../../../domain/repositories/cycle_repository.dart';
import '../../../domain/repositories/expense_repository.dart';

enum FinancialTier {
  legendary,
  smart,
  balanced,
  spender,
  danger,
  earlyBankrupt;

  String get arabicLabel {
    switch (this) {
      case FinancialTier.legendary:
        return 'أسطوري';
      case FinancialTier.smart:
        return 'ذكي';
      case FinancialTier.balanced:
        return 'متوازن';
      case FinancialTier.spender:
        return 'مسرف';
      case FinancialTier.danger:
        return 'خطر';
      case FinancialTier.earlyBankrupt:
        return 'إفلاس مبكر';
    }
  }

  String get emoji {
    switch (this) {
      case FinancialTier.legendary:
        return '\u{1F3C6}'; // 🏆
      case FinancialTier.smart:
        return '\u{1F9E0}'; // 🧠
      case FinancialTier.balanced:
        return '\u2696\uFE0F'; // ⚖️
      case FinancialTier.spender:
        return '\u{1F4B8}'; // 💸
      case FinancialTier.danger:
        return '\u26A0\uFE0F'; // ⚠️
      case FinancialTier.earlyBankrupt:
        return '\u{1F6A8}'; // 🚨
    }
  }
}

class GetFinancialClassificationUseCase {
  final CycleRepository _cycleRepository;
  final ExpenseRepository _expenseRepository;

  const GetFinancialClassificationUseCase({
    required CycleRepository cycleRepository,
    required ExpenseRepository expenseRepository,
  })  : _cycleRepository = cycleRepository,
        _expenseRepository = expenseRepository;

  Future<FinancialTier?> call() async {
    final cycle = await _cycleRepository.getActiveCycle();
    if (cycle == null) return null;

    final now = DateTime.now();
    final totalExpenses = await _expenseRepository.getTotalExpenses(cycle.id);

    final salaryAmount = cycle.salaryAmount;
    if (salaryAmount <= 0) return null;

    final savingsRatio = (salaryAmount - totalExpenses) / salaryAmount;
    final daysElapsed = cycle.daysElapsed(now);
    final totalDays = cycle.endDate.difference(cycle.startDate).inDays;

    // Early bankrupt: negative balance early in cycle (less than half elapsed)
    if (savingsRatio < 0 && totalDays > 0 && daysElapsed < totalDays * 0.5) {
      return FinancialTier.earlyBankrupt;
    }

    if (savingsRatio > 0.30) return FinancialTier.legendary;
    if (savingsRatio > 0.15) return FinancialTier.smart;
    if (savingsRatio > 0.05) return FinancialTier.balanced;
    if (savingsRatio >= 0) return FinancialTier.spender;
    return FinancialTier.danger;
  }
}
