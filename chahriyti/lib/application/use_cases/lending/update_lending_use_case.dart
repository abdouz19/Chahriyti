import '../../../domain/repositories/lending_repository.dart';

class UpdateLendingRequest {
  final int id;
  final String? borrowerName;
  final String? notes;
  final int? totalAmount;

  UpdateLendingRequest({
    required this.id,
    this.borrowerName,
    this.notes,
    this.totalAmount,
  });
}

class UpdateLendingUseCase {
  final LendingRepository _repository;

  UpdateLendingUseCase(this._repository);

  Future<void> call(UpdateLendingRequest request) async {
    if (request.totalAmount != null && request.totalAmount! <= 0) {
      throw ArgumentError('المبلغ يجب أن يكون أكبر من الصفر');
    }

    await _repository.updateLending(
      id: request.id,
      borrowerName: request.borrowerName,
      notes: request.notes,
      totalAmount: request.totalAmount,
    );
  }
}
