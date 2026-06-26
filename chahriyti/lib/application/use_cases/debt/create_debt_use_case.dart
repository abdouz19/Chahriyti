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

  CreateDebtUseCase(this._repository);

  Future<int> call(CreateDebtRequest request) async {
    // Validate
    if (request.creditorName.isEmpty) {
      throw ArgumentError('Creditor name cannot be empty');
    }
    if (request.totalAmount <= 0) {
      throw ArgumentError('Total amount must be greater than zero');
    }

    // Create debt via repository
    final debtId = await _repository.createDebt(
      creditorName: request.creditorName,
      totalAmount: request.totalAmount,
      notes: request.notes,
    );

    return debtId;
  }
}
