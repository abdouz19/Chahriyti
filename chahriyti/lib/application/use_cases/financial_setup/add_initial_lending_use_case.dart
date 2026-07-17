import '../../../domain/entities/lending_entity.dart';
import '../../../domain/repositories/cycle_repository.dart';
import '../../../domain/repositories/lending_repository.dart';

class AddInitialLendingUseCase {
  final LendingRepository _lendingRepository;
  final CycleRepository _cycleRepository;

  AddInitialLendingUseCase(this._lendingRepository, this._cycleRepository);

  Future<LendingEntity> call({
    required String borrowerName,
    required int totalAmount,
  }) async {
    if (borrowerName.trim().isEmpty) {
      throw ArgumentError('يجب إدخال اسم المقترض');
    }
    if (totalAmount <= 0) {
      throw ArgumentError('المبلغ يجب أن يكون أكبر من صفر');
    }
    final cycle = await _cycleRepository.getActiveCycle();
    return _lendingRepository.createLending(
      borrowerName: borrowerName.trim(),
      totalAmount: totalAmount,
      fromSavings: false,
      cycleId: cycle?.id,
    );
  }
}
