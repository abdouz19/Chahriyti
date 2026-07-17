import '../../../domain/entities/debt_entity.dart';
import '../../../domain/entities/lending_entity.dart';

sealed class FinancialSetupState {
  const FinancialSetupState();
}

final class FinancialSetupWelcome extends FinancialSetupState {
  const FinancialSetupWelcome();
}

final class FinancialSetupBalance extends FinancialSetupState {
  final int? currentBalance;
  const FinancialSetupBalance({this.currentBalance});
}

final class FinancialSetupSavings extends FinancialSetupState {
  final int? currentSavings;
  const FinancialSetupSavings({this.currentSavings});
}

final class FinancialSetupDebts extends FinancialSetupState {
  final List<DebtEntity> debts;
  const FinancialSetupDebts({required this.debts});
}

final class FinancialSetupLendings extends FinancialSetupState {
  final List<LendingEntity> lendings;
  const FinancialSetupLendings({required this.lendings});
}

final class FinancialSetupSummary extends FinancialSetupState {
  final int balance;
  final int savings;
  final List<DebtEntity> debts;
  final List<LendingEntity> lendings;

  const FinancialSetupSummary({
    required this.balance,
    required this.savings,
    required this.debts,
    required this.lendings,
  });
}

final class FinancialSetupCompleted extends FinancialSetupState {
  const FinancialSetupCompleted();
}

final class FinancialSetupError extends FinancialSetupState {
  final String message;
  const FinancialSetupError(this.message);
}

final class FinancialSetupLoading extends FinancialSetupState {
  const FinancialSetupLoading();
}
