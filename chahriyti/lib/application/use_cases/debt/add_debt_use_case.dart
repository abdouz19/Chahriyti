import '../../../domain/entities/debt_entity.dart';
import '../../../domain/repositories/debt_repository.dart';

class AddDebtUseCase {
  final DebtRepository _repo;

  const AddDebtUseCase(this._repo);

  Future<DebtEntity> call({
    required String creditorName,
    required int totalAmount,
    int paidAmount = 0,
  }) async {
    if (creditorName.trim().isEmpty) {
      throw ArgumentError('اسم الدائن مطلوب');
    }
    if (totalAmount <= 0) {
      throw ArgumentError('المبلغ الإجمالي يجب أن يكون أكبر من الصفر');
    }
    if (paidAmount < 0) {
      throw ArgumentError('المبلغ المدفوع لا يمكن أن يكون سالباً');
    }
    if (paidAmount > totalAmount) {
      throw ArgumentError('المبلغ المدفوع لا يمكن أن يتجاوز المبلغ الإجمالي');
    }
    return _repo.addDebt(
      creditorName: creditorName.trim(),
      totalAmount: totalAmount,
      paidAmount: paidAmount,
    );
  }
}
