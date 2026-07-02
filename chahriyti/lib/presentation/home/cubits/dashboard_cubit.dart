import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

import '../../../application/use_cases/dashboard/get_dashboard_data_use_case.dart';
import '../../../domain/repositories/expense_repository.dart';
import '../../../domain/repositories/debt_repository.dart';
import '../../../domain/repositories/goal_repository.dart';
import '../../../domain/repositories/lending_repository.dart';
import '../../../domain/repositories/savings_repository.dart';
import '../../../domain/repositories/cycle_repository.dart';
import '../../../domain/entities/expense_entity.dart';
import '../../../domain/entities/debt_entity.dart';
import '../../../domain/entities/lending_entity.dart';
import '../../../domain/entities/savings_goal_entity.dart';

// ─── States ────────────────────────────────────────────────────────────────

abstract class DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final DashboardData data;
  final List<ExpenseEntity> recentExpenses;
  final List<DebtEntity> activeDebts;
  final List<LendingEntity> activeLendings;
  final List<SavingsGoalEntity> activeGoals;
  final int savingsBalance;

  DashboardLoaded({
    required this.data,
    required this.recentExpenses,
    required this.activeDebts,
    this.activeLendings = const [],
    required this.activeGoals,
    this.savingsBalance = 0,
  });
}

class DashboardError extends DashboardState {
  final String message;

  DashboardError(this.message);
}

// ─── Cubit ─────────────────────────────────────────────────────────────────

class DashboardCubit extends Cubit<DashboardState> {
  final GetDashboardDataUseCase _getDashboardData;
  final CycleRepository _cycleRepository;
  final ExpenseRepository _expenseRepository;
  final DebtRepository _debtRepository;
  final GoalRepository _goalRepository;
  final LendingRepository? _lendingRepository;
  final SavingsRepository? _savingsRepository;

  DashboardCubit({
    required GetDashboardDataUseCase getDashboardData,
    required CycleRepository cycleRepository,
    required ExpenseRepository expenseRepository,
    required DebtRepository debtRepository,
    required GoalRepository goalRepository,
    LendingRepository? lendingRepository,
    SavingsRepository? savingsRepository,
  })  : _getDashboardData = getDashboardData,
        _cycleRepository = cycleRepository,
        _expenseRepository = expenseRepository,
        _debtRepository = debtRepository,
        _goalRepository = goalRepository,
        _lendingRepository = lendingRepository,
        _savingsRepository = savingsRepository,
        super(DashboardLoading());

  Future<void> loadDashboard() async {
    emit(DashboardLoading());
    await _fetchData();
  }

  Future<void> refresh() async {
    await _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      debugPrint('📊 DASHBOARD: Starting data fetch...');
      final cycle = await _cycleRepository.getActiveCycle();
      debugPrint('📊 DASHBOARD: Active cycle = ${cycle?.id}');

      final results = await Future.wait([
        _getDashboardData.call(),
        _debtRepository.getActiveDebts(),
        _goalRepository.getActiveGoals(),
      ]);

      final dashboardData = results[0] as DashboardData;
      final activeDebts = results[1] as List<DebtEntity>;
      final activeGoals = results[2] as List<SavingsGoalEntity>;

      List<LendingEntity> activeLendings = [];
      if (_lendingRepository != null) {
        activeLendings = await _lendingRepository.getActiveLendings();
      }

      int savingsBalance = 0;
      if (_savingsRepository != null) {
        savingsBalance = await _savingsRepository.getSavingsBalance();
      }

      debugPrint('📊 DASHBOARD: Total Expenses = ${dashboardData.totalExpenses}');
      debugPrint('📊 DASHBOARD: Current Balance = ${dashboardData.currentBalance}');
      debugPrint('📊 DASHBOARD: Total Income = ${dashboardData.totalIncome}');

      List<ExpenseEntity> recentExpenses = [];
      if (cycle != null) {
        recentExpenses = await _expenseRepository.getRecentExpenses(
          cycle.id,
          limit: 5,
        );
        debugPrint('📊 DASHBOARD: Recent expenses count = ${recentExpenses.length}');
        for (final expense in recentExpenses) {
          debugPrint('   - ${expense.itemName} (${expense.category}): ${expense.amount}');
        }
      }

      emit(DashboardLoaded(
        data: dashboardData,
        recentExpenses: recentExpenses,
        activeDebts: activeDebts,
        activeLendings: activeLendings,
        activeGoals: activeGoals,
        savingsBalance: savingsBalance,
      ));
      debugPrint('📊 DASHBOARD: Data fetch completed successfully');
    } catch (e) {
      debugPrint('❌ DASHBOARD ERROR: ${e.toString()}');
      emit(DashboardError('حدث خطأ في تحميل البيانات: ${e.toString()}'));
    }
  }
}
