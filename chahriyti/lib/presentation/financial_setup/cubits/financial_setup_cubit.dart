import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/use_cases/financial_setup/add_initial_debt_use_case.dart';
import '../../../application/use_cases/financial_setup/add_initial_lending_use_case.dart';
import '../../../application/use_cases/financial_setup/complete_financial_setup_use_case.dart';
import '../../../application/use_cases/financial_setup/delete_initial_debt_use_case.dart';
import '../../../application/use_cases/savings/deposit_salary_split_use_case.dart';
import '../../../application/use_cases/financial_setup/delete_initial_lending_use_case.dart';
import '../../../application/use_cases/financial_setup/edit_initial_debt_use_case.dart';
import '../../../application/use_cases/financial_setup/edit_initial_lending_use_case.dart';
import '../../../application/use_cases/financial_setup/get_financial_setup_step_use_case.dart';
import '../../../application/use_cases/financial_setup/get_setup_summary_use_case.dart';
import '../../../application/use_cases/financial_setup/set_initial_balance_use_case.dart';
import '../../../application/use_cases/financial_setup/set_initial_savings_use_case.dart';
import '../../../domain/repositories/cycle_repository.dart';
import '../../../domain/repositories/debt_repository.dart';
import '../../../domain/repositories/lending_repository.dart';
import '../../../domain/repositories/user_repository.dart';
import 'financial_setup_state.dart';

class FinancialSetupCubit extends Cubit<FinancialSetupState> {
  final GetFinancialSetupStepUseCase _getStepUseCase;
  final SetInitialBalanceUseCase _setBalanceUseCase;
  final SetInitialSavingsUseCase _setSavingsUseCase;
  final AddInitialDebtUseCase _addDebtUseCase;
  final EditInitialDebtUseCase _editDebtUseCase;
  final DeleteInitialDebtUseCase _deleteDebtUseCase;
  final AddInitialLendingUseCase _addLendingUseCase;
  final EditInitialLendingUseCase _editLendingUseCase;
  final DeleteInitialLendingUseCase _deleteLendingUseCase;
  final CompleteFinancialSetupUseCase _completeUseCase;
  final GetSetupSummaryUseCase _getSummaryUseCase;
  final DepositSalarySplitUseCase _depositSalarySplitUseCase;
  final UserRepository _userRepository;
  final CycleRepository _cycleRepository;
  final DebtRepository _debtRepository;
  final LendingRepository _lendingRepository;

  // Cached wizard data for back navigation
  int _cachedBalance = 0;
  int _cachedSavings = 0;
  int _cachedSalarySplit = 0;

  FinancialSetupCubit({
    required GetFinancialSetupStepUseCase getStepUseCase,
    required SetInitialBalanceUseCase setBalanceUseCase,
    required SetInitialSavingsUseCase setSavingsUseCase,
    required AddInitialDebtUseCase addDebtUseCase,
    required EditInitialDebtUseCase editDebtUseCase,
    required DeleteInitialDebtUseCase deleteDebtUseCase,
    required AddInitialLendingUseCase addLendingUseCase,
    required EditInitialLendingUseCase editLendingUseCase,
    required DeleteInitialLendingUseCase deleteLendingUseCase,
    required CompleteFinancialSetupUseCase completeUseCase,
    required GetSetupSummaryUseCase getSummaryUseCase,
    required DepositSalarySplitUseCase depositSalarySplitUseCase,
    required UserRepository userRepository,
    required CycleRepository cycleRepository,
    required DebtRepository debtRepository,
    required LendingRepository lendingRepository,
  })  : _getStepUseCase = getStepUseCase,
        _setBalanceUseCase = setBalanceUseCase,
        _setSavingsUseCase = setSavingsUseCase,
        _addDebtUseCase = addDebtUseCase,
        _editDebtUseCase = editDebtUseCase,
        _deleteDebtUseCase = deleteDebtUseCase,
        _addLendingUseCase = addLendingUseCase,
        _editLendingUseCase = editLendingUseCase,
        _deleteLendingUseCase = deleteLendingUseCase,
        _completeUseCase = completeUseCase,
        _getSummaryUseCase = getSummaryUseCase,
        _depositSalarySplitUseCase = depositSalarySplitUseCase,
        _userRepository = userRepository,
        _cycleRepository = cycleRepository,
        _debtRepository = debtRepository,
        _lendingRepository = lendingRepository,
        super(const FinancialSetupWelcome());

  Future<void> start() async {
    final step = await _getStepUseCase();
    if (step == null || step <= 0) {
      emit(const FinancialSetupWelcome());
      return;
    }
    // Resume from last completed step
    await _resumeFromStep(step);
  }

  Future<void> _resumeFromStep(int step) async {
    final user = await _userRepository.getUser();
    _cachedBalance = user?.initialBalance ?? 0;

    switch (step) {
      case 1:
        emit(FinancialSetupBalance(currentBalance: _cachedBalance));
      case 2:
        emit(const FinancialSetupSavings());
      case 3:
        final debts = await _debtRepository.getActiveDebts();
        emit(FinancialSetupDebts(debts: debts));
      case 4:
        final lendings = await _lendingRepository.getActiveLendings();
        emit(FinancialSetupLendings(lendings: lendings));
      case 5:
        final salaryAmount = await _getSalaryAmount();
        emit(FinancialSetupSalarySplit(
          salaryAmount: salaryAmount,
          currentAllocation: _cachedSalarySplit,
        ));
      case 6:
        await _loadSummary();
      default:
        emit(const FinancialSetupWelcome());
    }
  }

  void beginSetup() {
    emit(const FinancialSetupBalance());
  }

  Future<void> setBalance(int amount) async {
    emit(const FinancialSetupLoading());
    try {
      await _setBalanceUseCase(balance: amount);
      _cachedBalance = amount;
      emit(const FinancialSetupSavings());
    } on ArgumentError catch (e) {
      emit(FinancialSetupError(e.message.toString()));
    } catch (_) {
      emit(const FinancialSetupError('حدث خطأ غير متوقع'));
    }
  }

  Future<void> setSavings(int amount) async {
    emit(const FinancialSetupLoading());
    try {
      await _setSavingsUseCase(amount: amount);
      _cachedSavings = amount;
      final debts = await _debtRepository.getActiveDebts();
      emit(FinancialSetupDebts(debts: debts));
    } on ArgumentError catch (e) {
      emit(FinancialSetupError(e.message.toString()));
    } catch (_) {
      emit(const FinancialSetupError('حدث خطأ غير متوقع'));
    }
  }

  Future<void> skipSavings() async {
    final user = await _userRepository.getUser();
    if (user != null) {
      await _userRepository.updateFinancialSetupStep(user.id, 3);
    }
    _cachedSavings = 0;
    final debts = await _debtRepository.getActiveDebts();
    emit(FinancialSetupDebts(debts: debts));
  }

  Future<void> addDebt({
    required String creditorName,
    required int totalAmount,
    bool isSpent = true,
  }) async {
    try {
      await _addDebtUseCase(
        creditorName: creditorName,
        totalAmount: totalAmount,
        isSpent: isSpent,
      );
      final debts = await _debtRepository.getActiveDebts();
      emit(FinancialSetupDebts(debts: debts));
    } on ArgumentError catch (e) {
      emit(FinancialSetupError(e.message.toString()));
    }
  }

  Future<void> editDebt({
    required int id,
    required String creditorName,
    required int totalAmount,
    bool isSpent = true,
  }) async {
    try {
      await _editDebtUseCase(
        id: id,
        creditorName: creditorName,
        totalAmount: totalAmount,
        isSpent: isSpent,
      );
      final debts = await _debtRepository.getActiveDebts();
      emit(FinancialSetupDebts(debts: debts));
    } on ArgumentError catch (e) {
      emit(FinancialSetupError(e.message.toString()));
    }
  }

  Future<void> deleteDebt(int id) async {
    await _deleteDebtUseCase(id);
    final debts = await _debtRepository.getActiveDebts();
    emit(FinancialSetupDebts(debts: debts));
  }

  Future<void> nextFromDebts() async {
    final user = await _userRepository.getUser();
    if (user != null) {
      await _userRepository.updateFinancialSetupStep(user.id, 4);
    }
    final lendings = await _lendingRepository.getActiveLendings();
    emit(FinancialSetupLendings(lendings: lendings));
  }

  Future<void> addLending({
    required String borrowerName,
    required int totalAmount,
  }) async {
    try {
      await _addLendingUseCase(
        borrowerName: borrowerName,
        totalAmount: totalAmount,
      );
      final lendings = await _lendingRepository.getActiveLendings();
      emit(FinancialSetupLendings(lendings: lendings));
    } on ArgumentError catch (e) {
      emit(FinancialSetupError(e.message.toString()));
    }
  }

  Future<void> editLending({
    required int id,
    required String borrowerName,
    required int totalAmount,
  }) async {
    try {
      await _editLendingUseCase(
        id: id,
        borrowerName: borrowerName,
        totalAmount: totalAmount,
      );
      final lendings = await _lendingRepository.getActiveLendings();
      emit(FinancialSetupLendings(lendings: lendings));
    } on ArgumentError catch (e) {
      emit(FinancialSetupError(e.message.toString()));
    }
  }

  Future<void> deleteLending(int id) async {
    await _deleteLendingUseCase(id);
    final lendings = await _lendingRepository.getActiveLendings();
    emit(FinancialSetupLendings(lendings: lendings));
  }

  Future<void> nextFromLendings() async {
    final user = await _userRepository.getUser();
    if (user != null) {
      await _userRepository.updateFinancialSetupStep(user.id, 5);
    }
    final salaryAmount = await _getSalaryAmount();
    emit(FinancialSetupSalarySplit(
      salaryAmount: salaryAmount,
      currentAllocation: _cachedSalarySplit,
    ));
  }

  Future<int> _getSalaryAmount() async {
    final user = await _userRepository.getUser();
    return user?.monthlySalary ?? 0;
  }

  Future<void> setSalarySplit(int amount) async {
    _cachedSalarySplit = amount;
    final user = await _userRepository.getUser();
    if (user != null) {
      await _userRepository.updateFinancialSetupStep(user.id, 6);
    }
    await _loadSummary();
  }

  Future<void> skipSalarySplit() async {
    _cachedSalarySplit = 0;
    final user = await _userRepository.getUser();
    if (user != null) {
      await _userRepository.updateFinancialSetupStep(user.id, 6);
    }
    await _loadSummary();
  }

  Future<void> _loadSummary() async {
    final summary = await _getSummaryUseCase();
    final salaryAmount = await _getSalaryAmount();
    emit(FinancialSetupSummary(
      balance: summary.balance,
      savings: summary.savings,
      debts: summary.debts,
      lendings: summary.lendings,
      salarySplit: _cachedSalarySplit,
      salaryAmount: salaryAmount,
    ));
  }

  Future<void> editFromSummary(int step) async {
    await _resumeFromStep(step);
  }

  Future<void> confirm() async {
    emit(const FinancialSetupLoading());
    try {
      // Deposit salary split before completing setup so the cycle's
      // salarySplitAmount is set for the balance calculation.
      if (_cachedSalarySplit > 0) {
        final cycle = await _cycleRepository.getActiveCycle();
        if (cycle != null) {
          await _depositSalarySplitUseCase(
            cycleId: cycle.id,
            amount: _cachedSalarySplit,
          );
        }
      }
      await _completeUseCase();
      emit(const FinancialSetupCompleted());
    } catch (_) {
      emit(const FinancialSetupError('حدث خطأ في حفظ البيانات'));
    }
  }

  Future<void> goBack() async {
    final currentState = state;
    if (currentState is FinancialSetupBalance) {
      emit(const FinancialSetupWelcome());
    } else if (currentState is FinancialSetupSavings) {
      emit(FinancialSetupBalance(currentBalance: _cachedBalance));
    } else if (currentState is FinancialSetupDebts) {
      emit(FinancialSetupSavings(currentSavings: _cachedSavings));
    } else if (currentState is FinancialSetupLendings) {
      final debts = await _debtRepository.getActiveDebts();
      emit(FinancialSetupDebts(debts: debts));
    } else if (currentState is FinancialSetupSalarySplit) {
      final lendings = await _lendingRepository.getActiveLendings();
      emit(FinancialSetupLendings(lendings: lendings));
    } else if (currentState is FinancialSetupSummary) {
      final salaryAmount = await _getSalaryAmount();
      emit(FinancialSetupSalarySplit(
        salaryAmount: salaryAmount,
        currentAllocation: _cachedSalarySplit,
      ));
    }
  }
}
