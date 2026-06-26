import '../../../domain/repositories/cycle_repository.dart';
import '../../../domain/repositories/income_repository.dart';
import '../../../domain/entities/additional_income_entity.dart';

class AddInitialIncomeUseCase {
  final CycleRepository _cycleRepo;
  final IncomeRepository _incomeRepo;

  const AddInitialIncomeUseCase(this._cycleRepo, this._incomeRepo);

  Future<AdditionalIncomeEntity> call({
    required String description,
    required int amount,
  }) async {
    if (amount <= 0) throw ArgumentError('Amount must be positive');
    if (description.trim().isEmpty) {
      throw ArgumentError('Description required');
    }

    final cycle = await _cycleRepo.getActiveCycle();
    if (cycle == null) throw StateError('No active cycle found');

    return _incomeRepo.addIncome(
      cycleId: cycle.id,
      description: description.trim(),
      amount: amount,
    );
  }
}
