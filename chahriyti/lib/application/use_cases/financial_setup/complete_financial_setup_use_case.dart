import '../../../domain/repositories/cycle_repository.dart';
import '../../../domain/repositories/expense_repository.dart';
import '../../../domain/repositories/income_repository.dart';
import '../../../domain/repositories/lending_repository.dart';
import '../../../domain/repositories/user_repository.dart';

class CompleteFinancialSetupUseCase {
  final UserRepository _userRepository;
  final CycleRepository _cycleRepository;
  final IncomeRepository _incomeRepository;
  final ExpenseRepository _expenseRepository;
  final LendingRepository _lendingRepository;

  CompleteFinancialSetupUseCase(
    this._userRepository,
    this._cycleRepository,
    this._incomeRepository,
    this._expenseRepository,
    this._lendingRepository,
  );

  Future<void> call() async {
    final user = await _userRepository.getUser();
    if (user == null) throw StateError('No user found');

    // Safety net: ensure an active cycle exists (handles cross-month activation
    // and post-reset flows where no cycle was created yet).
    var existingCycle = await _cycleRepository.getActiveCycle();
    if (existingCycle == null) {
      final now = DateTime.now();
      final salaryDay = user.salaryDay;
      final thisMonthLastDay = DateTime(now.year, now.month + 1, 0).day;
      final effectiveDay =
          salaryDay > thisMonthLastDay ? thisMonthLastDay : salaryDay;
      final startDate = DateTime(now.year, now.month, effectiveDay);
      final cycleStart = startDate.isAfter(now)
          ? DateTime(now.year, now.month - 1, effectiveDay)
          : startDate;
      final nm = cycleStart.month == 12 ? 1 : cycleStart.month + 1;
      final ny = cycleStart.month == 12 ? cycleStart.year + 1 : cycleStart.year;
      final nextLastDay = DateTime(ny, nm + 1, 0).day;
      final nextEffDay = salaryDay > nextLastDay ? nextLastDay : salaryDay;
      final cycleEnd =
          DateTime(ny, nm, nextEffDay).subtract(const Duration(days: 1));
      await _cycleRepository.createCycle(
        startDate: cycleStart,
        endDate: cycleEnd,
        salaryAmount: user.monthlySalary,
      );
    }

    final initialBalance = user.initialBalance;
    if (initialBalance != null) {
      final cycle = await _cycleRepository.getActiveCycle();
      if (cycle != null) {
        final salaryNet = cycle.salaryAmount - cycle.salarySplitAmount;

        // Initial lendings are tied to this cycle and will be deducted from
        // the balance formula. We must compensate so that post-setup balance
        // equals the initialBalance the user entered.
        final initialLendings =
            await _lendingRepository.getTotalLendingsFromBalanceForCycle(cycle.id);

        final delta = initialBalance - salaryNet + initialLendings;

        if (delta > 0) {
          // User has more cash than salary (net of initial lendings) → add income
          await _incomeRepository.addIncome(
            cycleId: cycle.id,
            description: 'رصيد أولي',
            amount: delta,
          );
        } else if (delta < 0) {
          // User already spent some salary before installing → add expense
          await _expenseRepository.addExpense(
            cycleId: cycle.id,
            category: 'أخرى',
            subcategory: 'أخرى',
            itemName: 'رصيد قبل التطبيق',
            amount: -delta,
          );
        }
      }
    }

    await _userRepository.completeFinancialSetup(user.id);
  }
}
