import '../../../domain/entities/debt_entity.dart';
import '../../../domain/entities/lending_entity.dart';
import '../../../domain/repositories/debt_repository.dart';
import '../../../domain/repositories/lending_repository.dart';
import '../../../domain/repositories/savings_repository.dart';
import '../../../domain/repositories/user_repository.dart';

class SetupSummaryData {
  final int balance;
  final int savings;
  final List<DebtEntity> debts;
  final List<LendingEntity> lendings;

  const SetupSummaryData({
    required this.balance,
    required this.savings,
    required this.debts,
    required this.lendings,
  });
}

class GetSetupSummaryUseCase {
  final UserRepository _userRepository;
  final DebtRepository _debtRepository;
  final LendingRepository _lendingRepository;
  final SavingsRepository _savingsRepository;

  GetSetupSummaryUseCase(
    this._userRepository,
    this._debtRepository,
    this._lendingRepository,
    this._savingsRepository,
  );

  Future<SetupSummaryData> call() async {
    final user = await _userRepository.getUser();
    final debts = await _debtRepository.getActiveDebts();
    final lendings = await _lendingRepository.getActiveLendings();
    final savingsBalance = await _savingsRepository.getSavingsBalance();

    return SetupSummaryData(
      balance: user?.initialBalance ?? 0,
      savings: savingsBalance,
      debts: debts,
      lendings: lendings,
    );
  }
}
