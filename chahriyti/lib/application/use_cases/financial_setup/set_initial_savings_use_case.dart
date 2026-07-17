import '../../../domain/repositories/savings_repository.dart';
import '../../../domain/repositories/user_repository.dart';

class SetInitialSavingsUseCase {
  final UserRepository _userRepository;
  final SavingsRepository _savingsRepository;

  SetInitialSavingsUseCase(this._userRepository, this._savingsRepository);

  Future<void> call({required int amount}) async {
    if (amount < 0) {
      throw ArgumentError('المبلغ لا يمكن أن يكون سالبًا');
    }
    final user = await _userRepository.getUser();
    if (user == null) throw StateError('No user found');

    if (amount > 0) {
      await _savingsRepository.createInitialDeposit(amount: amount);
    }
    await _userRepository.updateFinancialSetupStep(user.id, 3);
  }
}
