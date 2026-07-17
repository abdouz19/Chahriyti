import 'package:flutter_test/flutter_test.dart';

import 'package:chahriyti/application/use_cases/financial_setup/complete_financial_setup_use_case.dart';
import 'package:chahriyti/domain/entities/additional_income_entity.dart';
import 'package:chahriyti/domain/entities/expense_entity.dart';
import 'package:chahriyti/domain/entities/financial_cycle_entity.dart';
import 'package:chahriyti/domain/entities/lending_entity.dart';
import 'package:chahriyti/domain/entities/lending_collection_entity.dart';
import 'package:chahriyti/domain/entities/user_entity.dart';
import 'package:chahriyti/domain/repositories/cycle_repository.dart';
import 'package:chahriyti/domain/repositories/expense_repository.dart';
import 'package:chahriyti/domain/repositories/income_repository.dart';
import 'package:chahriyti/domain/repositories/lending_repository.dart';
import 'package:chahriyti/domain/repositories/user_repository.dart';

// ── Fakes ────────────────────────────────────────────────────────────────────

class FakeUserRepository implements UserRepository {
  UserEntity? _user;
  int? completedForUserId;

  void setUser(UserEntity? user) => _user = user;

  @override
  Future<UserEntity?> getUser() async => _user;

  @override
  Future<void> completeFinancialSetup(int userId) async {
    completedForUserId = userId;
  }

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
  Future<void> updateUser(UserEntity user) async {}

  @override
  Future<bool> isActivated() async => true;

  @override
  Future<void> setActivated(bool activated) async {}

  @override
  Future<void> updateInitialBalance(int userId, int balance) async {}

  @override
  Future<void> updateFinancialSetupStep(int userId, int? step) async {}
}

class FakeCycleRepository implements CycleRepository {
  FinancialCycleEntity? _activeCycle;

  void setActiveCycle(FinancialCycleEntity? cycle) => _activeCycle = cycle;

  @override
  Future<FinancialCycleEntity?> getActiveCycle() async => _activeCycle;

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
  Future<List<FinancialCycleEntity>> getCycleHistory({
    int limit = 6,
    int offset = 0,
  }) async =>
      [];

  @override
  Future<FinancialCycleEntity?> getCycleForMonth(int year, int month) async => null;
}

class FakeIncomeRepository implements IncomeRepository {
  int? lastCycleId;
  String? lastDescription;
  int? lastAmount;

  @override
  Future<AdditionalIncomeEntity> addIncome({
    required int cycleId,
    required String description,
    required int amount,
    bool toSavings = false,
  }) async {
    lastCycleId = cycleId;
    lastDescription = description;
    lastAmount = amount;
    return AdditionalIncomeEntity(
      id: 1,
      cycleId: cycleId,
      description: description,
      amount: amount,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<List<AdditionalIncomeEntity>> getIncomesForCycle(int cycleId) async => [];

  @override
  Future<List<AdditionalIncomeEntity>> getIncomesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async =>
      [];

  @override
  Future<int> getTotalIncomeForCycle(int cycleId) async => 0;

  @override
  Future<void> updateIncome({required int id, required String description}) async {}

  @override
  Future<void> deleteIncome(int id) async {}
}

class FakeExpenseRepository implements ExpenseRepository {
  int? lastCycleId;
  String? lastCategory;
  String? lastItemName;
  int? lastAmount;

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
  }) async {
    lastCycleId = cycleId;
    lastCategory = category;
    lastItemName = itemName;
    lastAmount = amount;
    return ExpenseEntity(
      id: 1,
      cycleId: cycleId,
      category: category,
      subcategory: subcategory,
      itemName: itemName,
      amount: amount,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<void> editExpense(ExpenseEntity expense) async {}

  @override
  Future<void> deleteExpense(int id) async {}

  @override
  Future<List<ExpenseEntity>> getExpenses(int cycleId, {int? limit, int? offset}) async => [];

  @override
  Future<List<ExpenseEntity>> getRecentExpenses(int cycleId, {int limit = 5}) async => [];

  @override
  Future<List<ExpenseEntity>> getAllExpenses({int? limit, int? offset}) async => [];

  @override
  Future<List<ExpenseEntity>> getExpensesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async =>
      [];

  @override
  Future<int> getTotalExpenses(int cycleId) async => 0;

  @override
  Future<int> getTotalExpensesFromSavingsForCycle(int cycleId) async => 0;

  @override
  Future<Map<String, int>> getExpensesByCategory(int cycleId) async => {};
}

class FakeLendingRepository implements LendingRepository {
  final int totalLendingsFromBalance;

  FakeLendingRepository({this.totalLendingsFromBalance = 0});

  @override
  Future<int> getTotalLendingsFromBalanceForCycle(int cycleId) async =>
      totalLendingsFromBalance;

  @override
  Future<LendingEntity> createLending({
    required String borrowerName,
    required int totalAmount,
    required bool fromSavings,
    int savingsAmount = 0,
    int? cycleId,
    String? notes,
  }) async =>
      throw UnimplementedError();

  @override
  Future<LendingEntity?> getLendingById(int id) async => throw UnimplementedError();

  @override
  Future<List<LendingEntity>> getActiveLendings({int? limit, int? offset}) async =>
      throw UnimplementedError();

  @override
  Future<List<LendingEntity>> getCollectedLendings({int? limit, int? offset}) async =>
      throw UnimplementedError();

  @override
  Future<void> deleteLending(int id) async => throw UnimplementedError();

  @override
  Future<void> updateLending({
    required int id,
    String? borrowerName,
    String? notes,
    int? totalAmount,
  }) async =>
      throw UnimplementedError();

  @override
  Future<void> addCollection({
    required int lendingId,
    required int amount,
    bool toSavings = false,
  }) async =>
      throw UnimplementedError();

  @override
  Future<List<LendingCollectionEntity>> getCollectionsForLending(int lendingId) async =>
      throw UnimplementedError();

  @override
  Future<int> getTotalLendingsFromSavingsForCycle(int cycleId) async =>
      throw UnimplementedError();

  @override
  Future<int> getTotalCollectionsToBalanceForCycle(int cycleId) async =>
      throw UnimplementedError();

  @override
  Future<int> getTotalOutstandingLendingAmount() async => throw UnimplementedError();
}

// ── Helpers ───────────────────────────────────────────────────────────────────

UserEntity _user({int? initialBalance}) => UserEntity(
      id: 7,
      monthlySalary: 80000,
      salaryDay: 25,
      fullName: 'أحمد',
      phoneNumber: '0555555555',
      wilayaCode: 16,
      isActivated: true,
      challengesEnabled: false,
      initialBalance: initialBalance,
      createdAt: DateTime(2024, 1, 1),
    );

FinancialCycleEntity _cycle({int salary = 80000, int split = 0}) =>
    FinancialCycleEntity(
      id: 1,
      startDate: DateTime(2024, 1, 1),
      endDate: DateTime(2024, 1, 31),
      salaryAmount: salary,
      salarySplitAmount: split,
      isActive: true,
    );

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  late FakeUserRepository userRepo;
  late FakeCycleRepository cycleRepo;
  late FakeIncomeRepository incomeRepo;
  late FakeExpenseRepository expenseRepo;
  late FakeLendingRepository lendingRepo;
  late CompleteFinancialSetupUseCase useCase;

  setUp(() {
    userRepo = FakeUserRepository();
    cycleRepo = FakeCycleRepository();
    incomeRepo = FakeIncomeRepository();
    expenseRepo = FakeExpenseRepository();
    lendingRepo = FakeLendingRepository();
    useCase = CompleteFinancialSetupUseCase(
      userRepo,
      cycleRepo,
      incomeRepo,
      expenseRepo,
      lendingRepo,
    );
  });

  test('marks setup complete', () async {
    userRepo.setUser(_user(initialBalance: 80000));
    cycleRepo.setActiveCycle(_cycle(salary: 80000, split: 0));

    await useCase.call();

    expect(userRepo.completedForUserId, 7);
  });

  test('throws StateError when no user', () async {
    expect(() => useCase.call(), throwsA(isA<StateError>()));
  });

  test('adds income when initialBalance > salary net', () async {
    // user has 100k but salary is 80k → +20k income adjustment
    userRepo.setUser(_user(initialBalance: 100000));
    cycleRepo.setActiveCycle(_cycle(salary: 80000, split: 0));

    await useCase.call();

    expect(incomeRepo.lastAmount, 20000);
    expect(incomeRepo.lastCycleId, 1);
    expect(expenseRepo.lastAmount, isNull);
  });

  test('adds expense when initialBalance < salary net', () async {
    // user only has 50k but salary is 80k → already spent 30k
    userRepo.setUser(_user(initialBalance: 50000));
    cycleRepo.setActiveCycle(_cycle(salary: 80000, split: 0));

    await useCase.call();

    expect(expenseRepo.lastAmount, 30000);
    expect(expenseRepo.lastCycleId, 1);
    expect(incomeRepo.lastAmount, isNull);
  });

  test('no adjustment when initialBalance equals salary net', () async {
    userRepo.setUser(_user(initialBalance: 70000));
    cycleRepo.setActiveCycle(_cycle(salary: 80000, split: 10000));

    await useCase.call();

    expect(incomeRepo.lastAmount, isNull);
    expect(expenseRepo.lastAmount, isNull);
  });

  test('accounts for salary split in delta calculation', () async {
    // salary=80k, split=20k → net=60k; user has 75k → delta=+15k
    userRepo.setUser(_user(initialBalance: 75000));
    cycleRepo.setActiveCycle(_cycle(salary: 80000, split: 20000));

    await useCase.call();

    expect(incomeRepo.lastAmount, 15000);
  });

  test('no adjustment when initialBalance is null', () async {
    userRepo.setUser(_user(initialBalance: null));
    cycleRepo.setActiveCycle(_cycle(salary: 80000));

    await useCase.call();

    expect(incomeRepo.lastAmount, isNull);
    expect(expenseRepo.lastAmount, isNull);
  });

  test('no adjustment when no active cycle', () async {
    userRepo.setUser(_user(initialBalance: 50000));
    cycleRepo.setActiveCycle(null);

    await useCase.call();

    expect(incomeRepo.lastAmount, isNull);
    expect(expenseRepo.lastAmount, isNull);
  });

  test('offsets initial lendings so post-setup balance equals initialBalance', () async {
    // salary=80k, split=0 → net=80k
    // user has 60k cash (already spent some AND lent 10k to someone)
    // initialBalance=60k (user's actual cash, does NOT include the 10k lending)
    // initial lendings=10k → they are deducted from balance formula
    // delta must compensate: 60000 - 80000 + 10000 = -10000 → expense of 10k
    // post-setup balance = 80000 - 10000 - 10000(lending) = 60000 ✓
    final repo = FakeLendingRepository(totalLendingsFromBalance: 10000);
    final uc = CompleteFinancialSetupUseCase(
      userRepo, cycleRepo, incomeRepo, expenseRepo, repo,
    );
    userRepo.setUser(_user(initialBalance: 60000));
    cycleRepo.setActiveCycle(_cycle(salary: 80000, split: 0));

    await uc.call();

    expect(expenseRepo.lastAmount, 10000);
    expect(incomeRepo.lastAmount, isNull);
  });

  test('initial lendings reduce income adjustment when user has extra cash', () async {
    // salary=80k, split=0 → net=80k
    // user has 95k cash, lent 10k before app → delta = 95000 - 80000 + 10000 = 25000
    final repo = FakeLendingRepository(totalLendingsFromBalance: 10000);
    final uc = CompleteFinancialSetupUseCase(
      userRepo, cycleRepo, incomeRepo, expenseRepo, repo,
    );
    userRepo.setUser(_user(initialBalance: 95000));
    cycleRepo.setActiveCycle(_cycle(salary: 80000, split: 0));

    await uc.call();

    expect(incomeRepo.lastAmount, 25000);
    expect(expenseRepo.lastAmount, isNull);
  });
}
