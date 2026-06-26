import '../../../domain/repositories/debt_repository.dart';

class UpdateDebtRequest {
  final int id;
  final String? creditorName;
  final int? totalAmount; // in centimes
  final String? notes;

  UpdateDebtRequest({
    required this.id,
    this.creditorName,
    this.totalAmount,
    this.notes,
  });
}

class UpdateDebtUseCase {
  final DebtRepository _repository;

  UpdateDebtUseCase(this._repository);

  Future<void> call(UpdateDebtRequest request) async {
    // Validate
    if (request.totalAmount != null && request.totalAmount! <= 0) {
      throw ArgumentError('Total amount must be greater than zero');
    }

    // Update via repository
    await _repository.updateDebt(
      id: request.id,
      creditorName: request.creditorName,
      totalAmount: request.totalAmount,
      notes: request.notes,
    );
  }
}
