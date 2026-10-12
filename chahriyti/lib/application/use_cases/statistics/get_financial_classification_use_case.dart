import '../../../domain/repositories/cycle_repository.dart';
import '../dashboard/get_dashboard_data_use_case.dart';

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
  final GetDashboardDataUseCase _getDashboardData;

  const GetFinancialClassificationUseCase({
    required CycleRepository cycleRepository,
    required GetDashboardDataUseCase getDashboardData,
  })  : _cycleRepository = cycleRepository,
        _getDashboardData = getDashboardData;

  /// Tier from the share of this cycle's available money expected to be left
  /// at the end, at the current spending pace (same base as the home screen).
  Future<FinancialTier?> call() async {
    final cycle = await _cycleRepository.getActiveCycle();
    if (cycle == null) return null;

    final data = await _getDashboardData();
    final spent = data.totalExpenses;
    final available = spent + data.currentBalance;

    final now = DateTime.now();
    final start = DateTime(
        cycle.startDate.year, cycle.startDate.month, cycle.startDate.day);
    final end = DateTime(
        cycle.endDate.year, cycle.endDate.month, cycle.endDate.day);
    final today = DateTime(now.year, now.month, now.day);
    final totalDays = end.difference(start).inDays + 1;
    final daysElapsed =
        (today.difference(start).inDays + 1).clamp(1, totalDays);

    // Nothing left before the second half of the cycle
    if (data.currentBalance <= 0) {
      return daysElapsed < totalDays * 0.5
          ? FinancialTier.earlyBankrupt
          : FinancialTier.danger;
    }

    final projectedSpend = spent / daysElapsed * totalDays;
    final leftoverRatio = (available - projectedSpend) / available;

    if (leftoverRatio > 0.30) return FinancialTier.legendary;
    if (leftoverRatio > 0.15) return FinancialTier.smart;
    if (leftoverRatio > 0.05) return FinancialTier.balanced;
    if (leftoverRatio >= 0) return FinancialTier.spender;
    return FinancialTier.danger;
  }
}
