import '../../../domain/repositories/user_repository.dart';

class SetInitialBalanceUseCase {
  final UserRepository _userRepository;

  SetInitialBalanceUseCase(this._userRepository);

  Future<void> call({required int balance}) async {
    if (balance < 0) {
      throw ArgumentError('الرصيد لا يمكن أن يكون سالبًا');
    }
    final user = await _userRepository.getUser();
    if (user == null) throw StateError('No user found');
    await _userRepository.updateInitialBalance(user.id, balance);
    await _userRepository.updateFinancialSetupStep(user.id, 2);
  }
}
