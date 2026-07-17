import '../../../domain/repositories/lending_repository.dart';

class EditInitialLendingUseCase {
  final LendingRepository _lendingRepository;

  EditInitialLendingUseCase(this._lendingRepository);

  Future<void> call({
    required int id,
    required String borrowerName,
    required int totalAmount,
  }) async {
    if (borrowerName.trim().isEmpty) {
      throw ArgumentError('يجب إدخال اسم المقترض');
    }
    if (totalAmount <= 0) {
      throw ArgumentError('المبلغ يجب أن يكون أكبر من صفر');
    }
    await _lendingRepository.updateLending(
      id: id,
      borrowerName: borrowerName.trim(),
      totalAmount: totalAmount,
    );
  }
}
