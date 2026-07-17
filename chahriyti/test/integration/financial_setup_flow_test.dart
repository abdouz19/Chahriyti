import 'package:flutter_test/flutter_test.dart';

import 'package:chahriyti/domain/entities/additional_income_entity.dart';
import 'package:chahriyti/domain/entities/debt_entity.dart';
import 'package:chahriyti/domain/entities/expense_entity.dart';
import 'package:chahriyti/domain/entities/financial_cycle_entity.dart';
import 'package:chahriyti/domain/entities/lending_entity.dart';
import 'package:chahriyti/domain/entities/lending_collection_entity.dart';
import 'package:chahriyti/domain/entities/savings_history_entity.dart';
import 'package:chahriyti/domain/entities/user_entity.dart';
import 'package:chahriyti/domain/repositories/cycle_repository.dart';
import 'package:chahriyti/domain/repositories/debt_repository.dart';
import 'package:chahriyti/domain/repositories/expense_repository.dart';
import 'package:chahriyti/domain/repositories/income_repository.dart';
import 'package:chahriyti/domain/repositories/lending_repository.dart';
import 'package:chahriyti/domain/repositories/savings_repository.dart';
import 'package:chahriyti/domain/repositories/user_repository.dart';

import 'package:chahriyti/application/use_cases/financial_setup/add_initial_debt_use_case.dart';
import 'package:chahriyti/application/use_cases/financial_setup/add_initial_lending_use_case.dart';
import 'package:chahriyti/application/use_cases/financial_setup/complete_financial_setup_use_case.dart';
import 'package:chahriyti/application/use_cases/financial_setup/delete_initial_debt_use_case.dart';
import 'package:chahriyti/application/use_cases/financial_setup/delete_initial_lending_use_case.dart';
import 'package:chahriyti/application/use_cases/financial_setup/edit_initial_debt_use_case.dart';
import 'package:chahriyti/application/use_cases/financial_setup/edit_initial_lending_use_case.dart';
import 'package:chahriyti/application/use_cases/financial_setup/get_financial_setup_step_use_case.dart';
import 'package:chahriyti/application/use_cases/financial_setup/get_setup_summary_use_case.dart';
import 'package:chahriyti/application/use_cases/financial_setup/set_initial_balance_use_case.dart';
import 'package:chahriyti/application/use_cases/financial_setup/set_initial_savings_use_case.dart';
import 'package:chahriyti/presentation/financial_setup/cubits/financial_setup_cubit.dart';
import 'package:chahriyti/presentation/financial_setup/cubits/financial_setup_state.dart';

// ─── Fakes ──────────────────────────────────────────────────────────────────

class FakeUserRepository implements UserRepository {
  UserEntity? _user;

  FakeUserRepository({UserEntity? user}) : _user = user;

  @override
  Future<UserEntity?> getUser() async => _user;

  @override
  Future<UserEntity> createUser({
    required int monthlySalary,
    required int salaryDay,
    required String fullName,
    required String phoneNumber,
    required int wilayaCode,
  }) async =>
      throw UnimplementedError();

  @override
  Future<void> updateUser(UserEntity user) async {
    _user = user;
  }

  @override
  Future<bool> isActivated() async => _user?.isActivated ?? false;

  @override
  Future<void> setActivated(bool activated) async {
    if (_user != null) {
      _user = _user!.copyWith(isActivated: activated);
    }
  }

  @override
  Future<void> updateInitialBalance(int userId, int balance) async {
    if (_user != null) {
      _user = _user!.copyWith(initialBalance: balance);
    }
  }

  @override
  Future<void> updateFinancialSetupStep(int userId, int? step) async {
    if (_user != null) {
      _user = _user!.copyWith(financialSetupStep: step);
    }
  }

  @override
  Future<void> completeFinancialSetup(int userId) async {
    if (_user != null) {
      _user = _user!.copyWith(
        hasCompletedFinancialSetup: true,
        financialSetupStep: null,
      );
    }
  }
}

class FakeDebtRepository implements DebtRepository {
  final List<DebtEntity> _debts = [];
  int _nextId = 1;

  @override
  Future<int> createDebt({
    required String creditorName,
    required int totalAmount,
    String? notes,
    int? cycleId,
    bool isSpent = true,
  }) async {
    final id = _nextId++;
    _debts.add(DebtEntity(
      id: id,
      creditorName: creditorName,
      totalAmount: totalAmount,
      paidAmount: 0,
      isFullyPaid: false,
      notes: notes,
      createdAt: DateTime.now(),
    ));
    return id;
  }

  @override
  Future<List<DebtEntity>> getActiveDebts({int? limit, int? offset}) async =>
      List.of(_debts);

  @override
  Future<void> updateDebt({
    required int id,
    String? creditorName,
    int? totalAmount,
    String? notes,
    bool? isSpent,
  }) async {
    final idx = _debts.indexWhere((d) => d.id == id);
    if (idx >= 0) {
      _debts[idx] = _debts[idx].copyWith(
        creditorName: creditorName ?? _debts[idx].creditorName,
        totalAmount: totalAmount ?? _debts[idx].totalAmount,
      );
    }
  }

  @override
  Future<void> deleteDebt(int id) async {
    _debts.removeWhere((d) => d.id == id);
  }

  @override
  Future<DebtEntity> addDebt({
    required String creditorName,
    required int totalAmount,
    required int paidAmount,
  }) async =>
      throw UnimplementedError();
  @override
  Future<DebtEntity?> getDebtById(int id) async => null;
  @override
  Future<List<DebtEntity>> getUserDebts({int limit = 20, int offset = 0}) async => [];
  @override
  Future<List<DebtEntity>> getCompletedDebts({int? limit, int? offset}) async => [];
  @override
  Future<void> addPayment({
    required int debtId,
    required int amount,
    bool fromSavings = false,
    int savingsAmount = 0,
  }) async {}
  @override
  Future<void> markDebtCompleted(int id) async {}
  @override
  Future<void> makePayment({
    required int debtId,
    required int amount,
    required int cycleId,
    bool fromSavings = false,
  }) async {}
  @override
  Future<int> getTotalDebtPaymentsForCycle(int cycleId) async => 0;
  @override
  Future<int> getTotalDebtPaymentsFromSavingsForCycle(int cycleId) async => 0;
  @override
  Future<int> getTotalDebtsCreatedForCycle(int cycleId) async => 0;
  @override
  Future<List<int>> getSavingsPaymentIds(int debtId) async => [];
  @override
  Future<int> getTotalActiveRemainingAmount() async => 0;
}

class FakeLendingRepository implements LendingRepository {
  final List<LendingEntity> _lendings = [];
  int _nextId = 1;

  @override
  Future<LendingEntity> createLending({
    required String borrowerName,
    required int totalAmount,
    required bool fromSavings,
    int savingsAmount = 0,
    int? cycleId,
    String? notes,
  }) async {
    final lending = LendingEntity(
      id: _nextId++,
      borrowerName: borrowerName,
      totalAmount: totalAmount,
      collectedAmount: 0,
      cycleId: cycleId,
      fromSavings: fromSavings,
      notes: notes,
      savingsAmount: savingsAmount,
      createdAt: DateTime.now(),
    );
    _lendings.add(lending);
    return lending;
  }

  @override
  Future<List<LendingEntity>> getActiveLendings(
          {int? limit, int? offset}) async =>
      List.of(_lendings);

  @override
  Future<void> updateLending({
    required int id,
    String? borrowerName,
    String? notes,
    int? totalAmount,
  }) async {
    final idx = _lendings.indexWhere((l) => l.id == id);
    if (idx >= 0) {
      _lendings[idx] = _lendings[idx].copyWith(
        borrowerName: borrowerName ?? _lendings[idx].borrowerName,
        totalAmount: totalAmount ?? _lendings[idx].totalAmount,
      );
    }
  }

  @override
  Future<void> deleteLending(int id) async {
    _lendings.removeWhere((l) => l.id == id);
  }

  @override
  Future<LendingEntity?> getLendingById(int id) async => null;
  @override
  Future<List<LendingEntity>> getCollectedLendings(
          {int? limit, int? offset}) async =>
      [];
  @override
  Future<void> addCollection({
    required int lendingId,
    required int amount,
    bool toSavings = false,
  }) async {}
  @override
  Future<List<LendingCollectionEntity>> getCollectionsForLending(
          int lendingId) async =>
      [];
  @override
  Future<int> getTotalLendingsFromBalanceForCycle(int cycleId) async => 0;
  @override
  Future<int> getTotalLendingsFromSavingsForCycle(int cycleId) async => 0;
  @override
  Future<int> getTotalCollectionsToBalanceForCycle(int cycleId) async => 0;
  @override
  Future<int> getTotalOutstandingLendingAmount() async => 0;
}

class FakeSavingsRepository implements SavingsRepository {
  int _balance = 0;

  @override
  Future<int> getSavingsBalance() async => _balance;

  @override
  Future<void> createInitialDeposit({required int amount}) async {
    _balance += amount;
  }

  @override
  Future<SavingsHistoryEntity> createDeposit({
    required int amount,
    required String description,
    required int cycleId,
  }) async =>
      throw UnimplementedError();
  @override
  Future<List<SavingsHistoryEntity>> getSavingsHistory(
          {int? limit, int? offset}) async =>
      [];
  @override
  Future<SavingsHistoryEntity> createWithdrawal({
    required int amount,
    required String description,
    int? expenseId,
    int? debtPaymentId,
    int? lendingId,
  }) async =>
      throw UnimplementedError();
  @override
  Future<void> deleteWithdrawalByExpenseId(int expenseId) async {}
  @override
  Future<void> deleteWithdrawalByDebtPaymentId(int debtPaymentId) async {}
  @override
  Future<void> deleteWithdrawalByLendingId(int lendingId) async {}
  @override
  Future<void> updateWithdrawalAmountByExpenseId(
      int expenseId, int newAmount) async {}
  @override
  Future<void> updateWithdrawalAmountByDebtPaymentId(
      int debtPaymentId, int newAmount) async {}
}

class FakeCycleRepository implements CycleRepository {
  @override
  Future<FinancialCycleEntity?> getActiveCycle() async => FinancialCycleEntity(
        id: 1,
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 1, 31),
        salaryAmount: 50000,
        salarySplitAmount: 0,
        isActive: true,
      );

  @override
  Future<FinancialCycleEntity> createCycle({
    required DateTime startDate,
    required DateTime endDate,
    required int salaryAmount,
    int salarySplitAmount = 0,
  }) async =>
      throw UnimplementedError();

  @override
  Future<FinancialCycleEntity?> getCycleById(int id) async => null;
  @override
  Future<FinancialCycleEntity?> getPreviousCycle(int cycleId) async => null;
  @override
  Future<void> closeCycle(int id) async {}
  @override
  Future<void> updateCycleSalary(int cycleId, int salaryAmount) async {}
  @override
  Future<void> updateCycleSalarySplit(int cycleId, int salarySplitAmount) async {}
  @override
  Future<void> updateCycleSalaryDay(int cycleId, int salaryDay) async {}
  @override
  Future<List<FinancialCycleEntity>> getCycleHistory(
          {int limit = 6, int offset = 0}) async =>
      [];
  @override
  Future<FinancialCycleEntity?> getCycleForMonth(int year, int month) async => null;
}

class FakeIncomeRepository implements IncomeRepository {
  @override
  Future<AdditionalIncomeEntity> addIncome({
    required int cycleId,
    required String description,
    required int amount,
    bool toSavings = false,
  }) async =>
      AdditionalIncomeEntity(
        id: 1,
        cycleId: cycleId,
        description: description,
        amount: amount,
        createdAt: DateTime.now(),
      );

  @override
  Future<List<AdditionalIncomeEntity>> getIncomesForCycle(int cycleId) async => [];
  @override
  Future<List<AdditionalIncomeEntity>> getIncomesByDateRange(
          DateTime s, DateTime e) async =>
      [];
  @override
  Future<int> getTotalIncomeForCycle(int cycleId) async => 0;
  @override
  Future<void> updateIncome({required int id, required String description}) async {}
  @override
  Future<void> deleteIncome(int id) async {}
}

class FakeExpenseRepository implements ExpenseRepository {
  @override
  Future<ExpenseEntity> addExpense({
    required int cycleId,
    required String category,
    required String subcategory,
    required String itemName,
    required int amount,
    String? notes,
    bool fromSavings = false,
    int savingsAmount = 0,
  }) async =>
      ExpenseEntity(
        id: 1,
        cycleId: cycleId,
        category: category,
        subcategory: subcategory,
        itemName: itemName,
        amount: amount,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

  @override
  Future<void> editExpense(ExpenseEntity expense) async {}
  @override
  Future<void> deleteExpense(int id) async {}
  @override
  Future<List<ExpenseEntity>> getExpenses(int cycleId,
          {int? limit, int? offset}) async =>
      [];
  @override
  Future<List<ExpenseEntity>> getRecentExpenses(int cycleId,
          {int limit = 5}) async =>
      [];
  @override
  Future<List<ExpenseEntity>> getAllExpenses({int? limit, int? offset}) async => [];
  @override
  Future<List<ExpenseEntity>> getExpensesByDateRange(
          DateTime s, DateTime e) async =>
      [];
  @override
  Future<int> getTotalExpenses(int cycleId) async => 0;
  @override
  Future<int> getTotalExpensesFromSavingsForCycle(int cycleId) async => 0;
  @override
  Future<Map<String, int>> getExpensesByCategory(int cycleId) async => {};
}

// ─── Helpers ────────────────────────────────────────────────────────────────

UserEntity _testUser({int? step, int? balance}) => UserEntity(
      id: 1,
      fullName: 'Test',
      phoneNumber: '0500000000',
      wilayaCode: 16,
      monthlySalary: 50000,
      salaryDay: 25,
      isActivated: true,
      challengesEnabled: false,
      initialBalance: balance,
      hasCompletedFinancialSetup: false,
      financialSetupStep: step,
      createdAt: DateTime.now(),
    );

FinancialSetupCubit _createCubit({
  required FakeUserRepository userRepo,
  required FakeDebtRepository debtRepo,
  required FakeLendingRepository lendingRepo,
  required FakeSavingsRepository savingsRepo,
}) {
  return FinancialSetupCubit(
    getStepUseCase: GetFinancialSetupStepUseCase(userRepo),
    setBalanceUseCase: SetInitialBalanceUseCase(userRepo),
    setSavingsUseCase: SetInitialSavingsUseCase(userRepo, savingsRepo),
    addDebtUseCase: AddInitialDebtUseCase(debtRepo),
    editDebtUseCase: EditInitialDebtUseCase(debtRepo),
    deleteDebtUseCase: DeleteInitialDebtUseCase(debtRepo),
    addLendingUseCase: AddInitialLendingUseCase(lendingRepo, FakeCycleRepository()),
    editLendingUseCase: EditInitialLendingUseCase(lendingRepo),
    deleteLendingUseCase: DeleteInitialLendingUseCase(lendingRepo),
    completeUseCase: CompleteFinancialSetupUseCase(
        userRepo, FakeCycleRepository(), FakeIncomeRepository(), FakeExpenseRepository(), lendingRepo),
    getSummaryUseCase: GetSetupSummaryUseCase(
        userRepo, debtRepo, lendingRepo, savingsRepo),
    userRepository: userRepo,
    debtRepository: debtRepo,
    lendingRepository: lendingRepo,
  );
}

// ─── Tests ──────────────────────────────────────────────────────────────────

void main() {
  group('Financial Setup Flow — end-to-end', () {
    late FakeUserRepository userRepo;
    late FakeDebtRepository debtRepo;
    late FakeLendingRepository lendingRepo;
    late FakeSavingsRepository savingsRepo;
    late FinancialSetupCubit cubit;

    setUp(() {
      userRepo = FakeUserRepository(user: _testUser());
      debtRepo = FakeDebtRepository();
      lendingRepo = FakeLendingRepository();
      savingsRepo = FakeSavingsRepository();
      cubit = _createCubit(
        userRepo: userRepo,
        debtRepo: debtRepo,
        lendingRepo: lendingRepo,
        savingsRepo: savingsRepo,
      );
    });

    tearDown(() => cubit.close());

    test('full wizard: welcome → balance → savings → debts → lendings → summary → confirm',
        () async {
      // Start → Welcome
      await cubit.start();
      expect(cubit.state, isA<FinancialSetupWelcome>());

      // Begin → Balance
      cubit.beginSetup();
      expect(cubit.state, isA<FinancialSetupBalance>());

      // Set balance → Savings
      await cubit.setBalance(75000);
      expect(cubit.state, isA<FinancialSetupSavings>());
      final user1 = await userRepo.getUser();
      expect(user1?.initialBalance, 75000);

      // Set savings → Debts
      await cubit.setSavings(20000);
      expect(cubit.state, isA<FinancialSetupDebts>());

      // Add 2 debts
      await cubit.addDebt(creditorName: 'البنك', totalAmount: 50000);
      expect(cubit.state, isA<FinancialSetupDebts>());
      expect((cubit.state as FinancialSetupDebts).debts.length, 1);

      await cubit.addDebt(creditorName: 'صديق', totalAmount: 10000);
      expect((cubit.state as FinancialSetupDebts).debts.length, 2);

      // Next → Lendings
      await cubit.nextFromDebts();
      expect(cubit.state, isA<FinancialSetupLendings>());

      // Add 1 lending
      await cubit.addLending(borrowerName: 'أحمد', totalAmount: 30000);
      expect((cubit.state as FinancialSetupLendings).lendings.length, 1);

      // Next → Summary
      await cubit.nextFromLendings();
      expect(cubit.state, isA<FinancialSetupSummary>());

      final summary = cubit.state as FinancialSetupSummary;
      expect(summary.balance, 75000);
      expect(summary.savings, 20000);
      expect(summary.debts.length, 2);
      expect(summary.lendings.length, 1);

      // Confirm → Completed
      await cubit.confirm();
      expect(cubit.state, isA<FinancialSetupCompleted>());

      final finalUser = await userRepo.getUser();
      expect(finalUser?.hasCompletedFinancialSetup, isTrue);
    });

    test('edit balance from summary', () async {
      await cubit.start();
      cubit.beginSetup();
      await cubit.setBalance(50000);
      await cubit.skipSavings();
      await cubit.nextFromDebts();
      await cubit.nextFromLendings();

      expect(cubit.state, isA<FinancialSetupSummary>());

      // Edit balance
      await cubit.editFromSummary(1);
      expect(cubit.state, isA<FinancialSetupBalance>());
      expect((cubit.state as FinancialSetupBalance).currentBalance, 50000);

      // Change balance
      await cubit.setBalance(80000);
      expect(cubit.state, isA<FinancialSetupSavings>());

      // Go through remaining steps back to summary
      await cubit.skipSavings();
      await cubit.nextFromDebts();
      await cubit.nextFromLendings();

      final summary = cubit.state as FinancialSetupSummary;
      expect(summary.balance, 80000);
    });
  });

  group('Financial Setup — back navigation', () {
    late FinancialSetupCubit cubit;
    late FakeUserRepository userRepo;

    setUp(() {
      userRepo = FakeUserRepository(user: _testUser());
      cubit = _createCubit(
        userRepo: userRepo,
        debtRepo: FakeDebtRepository(),
        lendingRepo: FakeLendingRepository(),
        savingsRepo: FakeSavingsRepository(),
      );
    });

    tearDown(() => cubit.close());

    test('back from balance → welcome', () async {
      await cubit.start();
      cubit.beginSetup();
      expect(cubit.state, isA<FinancialSetupBalance>());

      await cubit.goBack();
      expect(cubit.state, isA<FinancialSetupWelcome>());
    });

    test('back from savings → balance with cached value', () async {
      await cubit.start();
      cubit.beginSetup();
      await cubit.setBalance(30000);
      expect(cubit.state, isA<FinancialSetupSavings>());

      await cubit.goBack();
      expect(cubit.state, isA<FinancialSetupBalance>());
      expect((cubit.state as FinancialSetupBalance).currentBalance, 30000);
    });

    test('back from debts → savings with cached value', () async {
      await cubit.start();
      cubit.beginSetup();
      await cubit.setBalance(10000);
      await cubit.setSavings(5000);
      expect(cubit.state, isA<FinancialSetupDebts>());

      await cubit.goBack();
      expect(cubit.state, isA<FinancialSetupSavings>());
      expect((cubit.state as FinancialSetupSavings).currentSavings, 5000);
    });

    test('back from lendings → debts preserves debts', () async {
      await cubit.start();
      cubit.beginSetup();
      await cubit.setBalance(10000);
      await cubit.skipSavings();
      await cubit.addDebt(creditorName: 'Test', totalAmount: 5000);
      await cubit.nextFromDebts();
      expect(cubit.state, isA<FinancialSetupLendings>());

      await cubit.goBack();
      expect(cubit.state, isA<FinancialSetupDebts>());
      expect((cubit.state as FinancialSetupDebts).debts.length, 1);
    });
  });

  group('Financial Setup — resume after restart', () {
    test('resumes at balance step when step = 1', () async {
      final userRepo =
          FakeUserRepository(user: _testUser(step: 1, balance: 40000));
      final cubit = _createCubit(
        userRepo: userRepo,
        debtRepo: FakeDebtRepository(),
        lendingRepo: FakeLendingRepository(),
        savingsRepo: FakeSavingsRepository(),
      );

      await cubit.start();
      expect(cubit.state, isA<FinancialSetupBalance>());
      expect((cubit.state as FinancialSetupBalance).currentBalance, 40000);
      cubit.close();
    });

    test('resumes at debts step when step = 3', () async {
      final userRepo = FakeUserRepository(user: _testUser(step: 3));
      final debtRepo = FakeDebtRepository();
      // Pre-populate a debt
      await debtRepo.createDebt(creditorName: 'Bank', totalAmount: 25000);

      final cubit = _createCubit(
        userRepo: userRepo,
        debtRepo: debtRepo,
        lendingRepo: FakeLendingRepository(),
        savingsRepo: FakeSavingsRepository(),
      );

      await cubit.start();
      expect(cubit.state, isA<FinancialSetupDebts>());
      expect((cubit.state as FinancialSetupDebts).debts.length, 1);
      cubit.close();
    });

    test('resumes at lendings step when step = 4', () async {
      final userRepo = FakeUserRepository(user: _testUser(step: 4));
      final cubit = _createCubit(
        userRepo: userRepo,
        debtRepo: FakeDebtRepository(),
        lendingRepo: FakeLendingRepository(),
        savingsRepo: FakeSavingsRepository(),
      );

      await cubit.start();
      expect(cubit.state, isA<FinancialSetupLendings>());
      cubit.close();
    });

    test('resumes at summary when step = 5', () async {
      final userRepo =
          FakeUserRepository(user: _testUser(step: 5, balance: 60000));
      final savingsRepo = FakeSavingsRepository();
      await savingsRepo.createInitialDeposit(amount: 15000);

      final cubit = _createCubit(
        userRepo: userRepo,
        debtRepo: FakeDebtRepository(),
        lendingRepo: FakeLendingRepository(),
        savingsRepo: savingsRepo,
      );

      await cubit.start();
      expect(cubit.state, isA<FinancialSetupSummary>());
      final summary = cubit.state as FinancialSetupSummary;
      expect(summary.balance, 60000);
      expect(summary.savings, 15000);
      cubit.close();
    });
  });
}
