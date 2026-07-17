import '../../../domain/repositories/user_repository.dart';

class GetFinancialSetupStepUseCase {
  final UserRepository _userRepository;

  GetFinancialSetupStepUseCase(this._userRepository);

  /// Returns the current wizard step (null = not started, 1-5 = in progress).
  Future<int?> call() async {
    final user = await _userRepository.getUser();
    return user?.financialSetupStep;
  }
}
