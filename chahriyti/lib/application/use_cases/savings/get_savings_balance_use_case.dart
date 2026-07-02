import '../../../domain/repositories/savings_repository.dart';

class GetSavingsBalanceUseCase {
  final SavingsRepository _repository;

  const GetSavingsBalanceUseCase(this._repository);

  Future<int> call() => _repository.getSavingsBalance();
}
