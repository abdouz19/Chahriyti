import '../../../domain/entities/financial_cycle_entity.dart';

/// The single current-balance formula. Every screen and use case that needs
/// the balance must go through this so they never disagree.
int cycleBalance({
  required FinancialCycleEntity cycle,
  required int income,
  required int debtsCreated,
  required int expenses,
  required int debtPayments,
  required int lendingsFromBalance,
  required int collectionsToBalance,
  required int netTransfersToBalance,
}) =>
    cycle.salaryAmount -
    cycle.salarySplitAmount +
    income +
    debtsCreated +
    netTransfersToBalance -
    expenses -
    debtPayments -
    lendingsFromBalance +
    collectionsToBalance;
