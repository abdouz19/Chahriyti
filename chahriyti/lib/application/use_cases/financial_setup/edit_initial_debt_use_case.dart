import '../../../domain/repositories/debt_repository.dart';

class EditInitialDebtUseCase {
  final DebtRepository _debtRepository;

  EditInitialDebtUseCase(this._debtRepository);

  Future<void> call({
    required int id,
    required String creditorName,
    required int totalAmount,
    bool isSpent = true,
  }) async {
    if (creditorName.trim().isEmpty) {
      throw ArgumentError('يجب إدخال اسم الدائن');
    }
    if (totalAmount <= 0) {
      throw ArgumentError('المبلغ يجب أن يكون أكبر من صفر');
    }
    await _debtRepository.updateDebt(
      id: id,
      creditorName: creditorName.trim(),
      totalAmount: totalAmount,
      isSpent: isSpent,
    );
  }
}
