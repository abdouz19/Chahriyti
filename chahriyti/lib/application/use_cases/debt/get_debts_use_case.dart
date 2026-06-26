import '../../../domain/entities/debt_entity.dart';
import '../../../domain/repositories/debt_repository.dart';

class GetDebtsUseCase {
  final DebtRepository _repository;

  GetDebtsUseCase(this._repository);

  Future<List<DebtEntity>> call({
    int limit = 20,
    int offset = 0,
  }) async {
    return _repository.getUserDebts(limit: limit, offset: offset);
  }

  /// Get active (non-completed) debts only
  Future<List<DebtEntity>> getActiveDebts({
    int limit = 20,
    int offset = 0,
  }) async {
    final allDebts = await _repository.getUserDebts(limit: limit, offset: offset);
    return allDebts.where((debt) => !debt.isCompleted).toList();
  }
}
