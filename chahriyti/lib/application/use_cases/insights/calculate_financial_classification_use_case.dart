import '../../../domain/repositories/cycle_repository.dart';
import '../../../domain/repositories/expense_repository.dart';
import '../../../domain/repositories/income_repository.dart';

enum FinancialClassification {
  legendarySaver,
  smartSaver,
  balanced,
  spendthrift,
  danger,
  earlyBankruptcy,
}

extension ClassificationDisplay on FinancialClassification {
  String get name {
    switch (this) {
      case FinancialClassification.legendarySaver:
        return 'المدخر الأسطوري';
      case FinancialClassification.smartSaver:
        return 'المدخر الذكي';
      case FinancialClassification.balanced:
        return 'المتوازن';
      case FinancialClassification.spendthrift:
        return 'المبذر';
      case FinancialClassification.danger:
        return 'الخطر';
      case FinancialClassification.earlyBankruptcy:
        return 'المفلس المبكر';
    }
  }

  String get description {
    switch (this) {
      case FinancialClassification.legendarySaver:
        return 'ادخار أكثر من 30% 🌟';
      case FinancialClassification.smartSaver:
        return 'ادخار من 15% إلى 30% 💡';
      case FinancialClassification.balanced:
        return 'إدارة جيدة للمصاريف ⚖️';
      case FinancialClassification.spendthrift:
        return 'صرف سريع 💸';
      case FinancialClassification.danger:
        return 'احتمال نفاد الرصيد ⚠️';
      case FinancialClassification.earlyBankruptcy:
        return 'نفاد الرصيد قبل الراتب القادم 🚨';
    }
  }

  String get suggestion {
    switch (this) {
      case FinancialClassification.legendarySaver:
        return 'أنت تحقق أحلامك المالية! استمر على هذا المنوال 🎯';
      case FinancialClassification.smartSaver:
        return 'تدير أموالك بذكاء. حاول زيادة الادخار قليلاً 📈';
      case FinancialClassification.balanced:
        return 'إدارتك جيدة. راقب المصاريف الإضافية 👀';
      case FinancialClassification.spendthrift:
        return 'قلل المصاريف غير الضرورية لتحسين وضعك 🎯';
      case FinancialClassification.danger:
        return 'احذر! قد لا تكمل الدورة بأمان. خطط أفضل 🚨';
      case FinancialClassification.earlyBankruptcy:
        return 'أنفقت أكثر من دخلك. تحرك بسرعة! 🆘';
    }
  }
}

class CalculateFinancialClassificationUseCase {
  final CycleRepository _cycleRepository;
  final ExpenseRepository _expenseRepository;
  final IncomeRepository _incomeRepository;

  CalculateFinancialClassificationUseCase(
    this._cycleRepository,
    this._expenseRepository,
    this._incomeRepository,
  );

  Future<FinancialClassification> call(int cycleId) async {
    final cycle = await _cycleRepository.getCycleById(cycleId);
    if (cycle == null) {
      return FinancialClassification.danger;
    }

    final expenses = await _expenseRepository.getExpensesByDateRange(
      cycle.startDate,
      cycle.endDate,
    );

    final incomes = await _incomeRepository.getIncomesByDateRange(
      cycle.startDate,
      cycle.endDate,
    );

    final totalExpenses = expenses.fold<int>(0, (sum, e) => sum + e.amount);
    final totalIncome = incomes.fold<int>(0, (sum, i) => sum + i.amount);

    // Calculate savings rate
    if (totalIncome == 0) {
      return FinancialClassification.earlyBankruptcy;
    }

    final savingsAmount = totalIncome - totalExpenses;
    final savingsRate = (savingsAmount / totalIncome) * 100;

    // Classify based on savings rate
    if (savingsRate > 30) {
      return FinancialClassification.legendarySaver;
    } else if (savingsRate >= 15) {
      return FinancialClassification.smartSaver;
    } else if (savingsRate >= 5) {
      return FinancialClassification.balanced;
    } else if (savingsRate >= 0) {
      return FinancialClassification.spendthrift;
    } else if (savingsRate >= -5) {
      return FinancialClassification.danger;
    } else {
      return FinancialClassification.earlyBankruptcy;
    }
  }

  Future<double> getSavingsRate(int cycleId) async {
    final cycle = await _cycleRepository.getCycleById(cycleId);
    if (cycle == null) return 0;

    final expenses = await _expenseRepository.getExpensesByDateRange(
      cycle.startDate,
      cycle.endDate,
    );

    final incomes = await _incomeRepository.getIncomesByDateRange(
      cycle.startDate,
      cycle.endDate,
    );

    final totalExpenses = expenses.fold<int>(0, (sum, e) => sum + e.amount);
    final totalIncome = incomes.fold<int>(0, (sum, i) => sum + i.amount);

    if (totalIncome == 0) return -100;

    return ((totalIncome - totalExpenses) / totalIncome) * 100;
  }
}
