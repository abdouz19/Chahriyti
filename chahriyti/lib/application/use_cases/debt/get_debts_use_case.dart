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

  Future<List<DebtEntity>> getActiveDebts({
    int? limit,
    int? offset,
  }) async {
    return _repository.getActiveDebts(limit: limit, offset: offset);
  }

  Future<List<DebtEntity>> getCompletedDebts({
    int? limit,
    int? offset,
  }) async {
    return _repository.getCompletedDebts(limit: limit, offset: offset);
  }

  Future<int> getTotalActiveRemainingAmount() {
    return _repository.getTotalActiveRemainingAmount();
  }
}
