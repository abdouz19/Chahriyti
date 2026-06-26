import '../../../domain/repositories/expense_repository.dart';
import '../../../domain/entities/expense_entity.dart';

class GetExpensesUseCase {
  final ExpenseRepository _repo;

  const GetExpensesUseCase(this._repo);

  Future<List<ExpenseEntity>> call(
    int cycleId, {
    int? limit,
    int? offset,
  }) {
    return _repo.getExpenses(cycleId, limit: limit, offset: offset);
  }
}
