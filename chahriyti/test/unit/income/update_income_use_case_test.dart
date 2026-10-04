import 'package:flutter_test/flutter_test.dart';

import 'package:chahriyti/application/use_cases/income/update_income_use_case.dart';
import 'package:chahriyti/domain/entities/additional_income_entity.dart';
import 'package:chahriyti/domain/repositories/income_repository.dart';

class FakeIncomeRepository implements IncomeRepository {
  int? lastUpdatedId;
  String? lastUpdatedDescription;
  int? lastUpdatedAmount;

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
      {required int id, required String description, required int amount}) async {
    lastUpdatedId = id;
    lastUpdatedDescription = description;
    lastUpdatedAmount = amount;
  }

  @override
  Future<void> deleteIncome(int id) async {}
}

void main() {
  late FakeIncomeRepository repository;
  late UpdateIncomeUseCase useCase;

  setUp(() {
    repository = FakeIncomeRepository();
    useCase = UpdateIncomeUseCase(repository);
  });

  test('empty description throws ArgumentError', () async {
    expect(
      () => useCase.call(id: 1, description: '', amount: 1000),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('whitespace-only description throws ArgumentError', () async {
    expect(
      () => useCase.call(id: 1, description: '   ', amount: 1000),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('valid description passes and trims whitespace', () async {
    await useCase.call(id: 5, description: '  راتب شهري  ', amount: 5000);

    expect(repository.lastUpdatedId, 5);
    expect(repository.lastUpdatedDescription, 'راتب شهري');
    expect(repository.lastUpdatedAmount, 5000);
  });
}
