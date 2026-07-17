import '../../../domain/repositories/debt_repository.dart';

class AddInitialDebtUseCase {
  final DebtRepository _debtRepository;

  AddInitialDebtUseCase(this._debtRepository);

  Future<int> call({
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
    return _debtRepository.createDebt(
      creditorName: creditorName.trim(),
      totalAmount: totalAmount,
      isSpent: isSpent,
    );
  }
}
