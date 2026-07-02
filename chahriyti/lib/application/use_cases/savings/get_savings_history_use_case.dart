import '../../../domain/entities/savings_history_entity.dart';
import '../../../domain/repositories/savings_repository.dart';

class GetSavingsHistoryUseCase {
  final SavingsRepository _repository;

  const GetSavingsHistoryUseCase(this._repository);

  Future<List<SavingsHistoryEntity>> call({int? limit, int? offset}) =>
      _repository.getSavingsHistory(limit: limit, offset: offset);
}
