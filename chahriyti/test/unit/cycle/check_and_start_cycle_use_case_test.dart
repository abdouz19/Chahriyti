import 'package:flutter_test/flutter_test.dart';

import 'package:chahriyti/application/use_cases/cycle/check_and_start_cycle_use_case.dart';
import 'package:chahriyti/application/use_cases/savings/deposit_cycle_savings_use_case.dart';
import 'package:chahriyti/domain/entities/financial_cycle_entity.dart';
import 'package:chahriyti/domain/entities/savings_history_entity.dart';
import 'package:chahriyti/domain/entities/user_entity.dart';
import 'package:chahriyti/domain/repositories/cycle_repository.dart';
import 'package:chahriyti/domain/repositories/user_repository.dart';
import 'package:chahriyti/domain/value_objects/cycle_dates.dart';

class FakeUserRepository extends Fake implements UserRepository {
  final UserEntity user;
  FakeUserRepository(this.user);

  @override
  Future<UserEntity?> getUser() async => user;
}

class FakeCycleRepository extends Fake implements CycleRepository {
  final cycles = <FinancialCycleEntity>[];

  @override
  Future<FinancialCycleEntity?> getActiveCycle() async =>
      cycles.where((c) => c.isActive).firstOrNull;

  @override
  Future<FinancialCycleEntity> createCycle({
    required DateTime startDate,
    required DateTime endDate,
    required int salaryAmount,
    int salarySplitAmount = 0,
  }) async {
    final cycle = FinancialCycleEntity(
      id: cycles.length + 1,
      startDate: startDate,
      endDate: endDate,
      salaryAmount: salaryAmount,
      isActive: true,
    );
    cycles.add(cycle);
    return cycle;
  }

  @override
  Future<void> closeCycle(int id) async {
    final i = cycles.indexWhere((c) => c.id == id);
    cycles[i] = cycles[i].copyWith(isActive: false);
  }
}

class FakeDepositSavings extends Fake implements DepositCycleSavingsUseCase {
  final closedIds = <int>[];

  @override
  Future<SavingsHistoryEntity?> call(int cycleId) async {
    closedIds.add(cycleId);
    return null;
  }
}

void main() {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  UserEntity user(int salaryDay) => UserEntity(
        id: 1,
        monthlySalary: 100000,
        salaryDay: salaryDay,
        fullName: 'Test',
        phoneNumber: '0',
        wilayaCode: 16,
        isActivated: true,
        challengesEnabled: false,
        createdAt: DateTime(2026),
      );

  test('running cycle: nothing happens', () async {
    final cycles = FakeCycleRepository();
    await cycles.createCycle(
      startDate: today.subtract(const Duration(days: 3)),
      endDate: today.add(const Duration(days: 20)),
      salaryAmount: 100000,
    );
    final deposits = FakeDepositSavings();
    final result = await CheckAndStartCycleUseCase(
            FakeUserRepository(user(5)), cycles, deposits)
        .call();
    expect(result, isNull);
    expect(cycles.cycles, hasLength(1));
  });

  test('months without opening the app each get a cycle and salary',
      () async {
    final salaryDay = today.day > 28 ? 28 : today.day;
    final cycles = FakeCycleRepository();
    // Active cycle that ended about three months ago
    final oldStart = DateTime(today.year, today.month - 4, salaryDay);
    final oldEnd = DateTime(today.year, today.month - 3, salaryDay)
        .subtract(const Duration(days: 1));
    await cycles.createCycle(
        startDate: oldStart, endDate: oldEnd, salaryAmount: 100000);
    final deposits = FakeDepositSavings();

    final result = await CheckAndStartCycleUseCase(
            FakeUserRepository(user(salaryDay)), cycles, deposits)
        .call();

    // Old cycle + 3 missed months closed, one current cycle open
    expect(deposits.closedIds, hasLength(4));
    expect(cycles.cycles.where((c) => c.isActive), hasLength(1));
    expect(result, isNotNull);
    expect(result!.cycle.startDate.isAfter(today), isFalse);
    expect(result.cycle.endDate.isBefore(today), isFalse);
    // No gaps between cycles
    for (var i = 1; i < cycles.cycles.length; i++) {
      expect(cycles.cycles[i].startDate,
          CycleDates.dayAfter(cycles.cycles[i - 1].endDate));
    }
  });
}
