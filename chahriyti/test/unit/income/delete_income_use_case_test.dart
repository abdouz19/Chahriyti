import 'package:flutter_test/flutter_test.dart';

import 'package:chahriyti/application/use_cases/income/delete_income_use_case.dart';
import 'package:chahriyti/domain/entities/additional_income_entity.dart';
import 'package:chahriyti/domain/repositories/income_repository.dart';

class FakeIncomeRepository implements IncomeRepository {
  int? deletedId;
  bool shouldThrow = false;

  @override
  Future<AdditionalIncomeEntity> addIncome({
    required int cycleId,
    required String description,
    required int amount,
    bool toSavings = false,
  }) async =>
      throw UnimplementedError();

  @override
  Future<List<AdditionalIncomeEntity>> getIncomesForCycle(
          int cycleId) async =>
      [];

  @override
  Future<List<AdditionalIncomeEntity>> getIncomesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async =>
      [];

  @override
  Future<int> getTotalIncomeForCycle(int cycleId) async => 0;

  @override
  Future<void> updateIncome(
      {required int id, required String description}) async {}

  @override
  Future<void> deleteIncome(int id) async {
    if (shouldThrow) {
      throw ArgumentError('لا يمكن حذف دخل مرتبط بالمدخرات');
    }
    deletedId = id;
  }
}

void main() {
  late FakeIncomeRepository repository;
  late DeleteIncomeUseCase useCase;

  setUp(() {
    repository = FakeIncomeRepository();
    useCase = DeleteIncomeUseCase(repository);
  });

  test('calls repository.deleteIncome with correct id', () async {
    await useCase.call(7);

    expect(repository.deletedId, 7);
  });

  test('propagates ArgumentError from repository', () async {
    repository.shouldThrow = true;

    expect(
      () => useCase.call(7),
      throwsA(isA<ArgumentError>()),
    );
  });
}
