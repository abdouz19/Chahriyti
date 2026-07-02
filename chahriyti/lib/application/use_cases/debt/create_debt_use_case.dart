import '../../../domain/repositories/cycle_repository.dart';
import '../../../domain/repositories/debt_repository.dart';

class CreateDebtRequest {
  final String creditorName;
  final int totalAmount; // in centimes
  final String? notes;

  CreateDebtRequest({
    required this.creditorName,
    required this.totalAmount,
    this.notes,
  });
}

class CreateDebtUseCase {
  final DebtRepository _repository;
  final CycleRepository _cycleRepository;

  CreateDebtUseCase(this._repository, this._cycleRepository);

  Future<int> call(CreateDebtRequest request) async {
    if (request.creditorName.isEmpty) {
      throw ArgumentError('Creditor name cannot be empty');
    }
    if (request.totalAmount <= 0) {
      throw ArgumentError('Total amount must be greater than zero');
    }

    final cycle = await _cycleRepository.getActiveCycle();

    final debtId = await _repository.createDebt(
      creditorName: request.creditorName,
      totalAmount: request.totalAmount,
      notes: request.notes,
      cycleId: cycle?.id,
    );

    return debtId;
  }
}
