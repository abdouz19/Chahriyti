import 'package:flutter_test/flutter_test.dart';

import 'package:chahriyti/application/use_cases/savings/get_savings_history_use_case.dart';
import 'package:chahriyti/domain/entities/savings_history_entity.dart';
import 'package:chahriyti/domain/repositories/savings_repository.dart';

class FakeSavingsRepository implements SavingsRepository {
  List<SavingsHistoryEntity> _history = [];

  void setHistory(List<SavingsHistoryEntity> history) => _history = history;

  @override
  Future<int> getSavingsBalance() async => 0;
  @override
  Future<List<SavingsHistoryEntity>> getSavingsHistory({int? limit, int? offset}) async => _history;
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

void main() {
  late FakeSavingsRepository repository;
  late GetSavingsHistoryUseCase useCase;

  setUp(() {
    repository = FakeSavingsRepository();
    useCase = GetSavingsHistoryUseCase(repository);
  });

  test('returns records ordered by date desc', () async {
    final records = [
      SavingsHistoryEntity(
        id: 1,
        type: SavingsTransactionType.deposit,
        amount: 5000,
        description: 'ادخار دورة جوان',
        relatedCycleId: 1,
        createdAt: DateTime(2026, 7, 1),
      ),
      SavingsHistoryEntity(
        id: 2,
        type: SavingsTransactionType.withdrawal,
        amount: 2000,
        description: 'سداد مصروف',
        relatedExpenseId: 1,
        createdAt: DateTime(2026, 7, 5),
      ),
    ];
    repository.setHistory(records);

    final result = await useCase();

    expect(result, hasLength(2));
    expect(result.first.id, 1);
    expect(result.last.id, 2);
  });

  test('returns empty list when no history', () async {
    repository.setHistory([]);

    final result = await useCase();

    expect(result, isEmpty);
  });
}
