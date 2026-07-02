import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/use_cases/savings/deposit_salary_split_use_case.dart';
import 'salary_split_state.dart';

class SalarySplitCubit extends Cubit<SalarySplitState> {
  final DepositSalarySplitUseCase _depositSalarySplitUseCase;
  final int cycleId;
  final int salaryAmount;

  SalarySplitCubit({
    required DepositSalarySplitUseCase depositSalarySplitUseCase,
    required this.cycleId,
    required this.salaryAmount,
  })  : _depositSalarySplitUseCase = depositSalarySplitUseCase,
        super(SalarySplitState.editing(
          salaryAmount: salaryAmount,
          allocationAmount: 0,
          remainingBalance: salaryAmount,
        ));

  void updateAllocation(int amount) {
    final clamped = amount.clamp(0, salaryAmount);
    emit(SalarySplitState.editing(
      salaryAmount: salaryAmount,
      allocationAmount: clamped,
      remainingBalance: salaryAmount - clamped,
    ));
  }

  Future<void> confirmSplit(int amount) async {
    if (amount <= 0) {
      emit(const SalarySplitState.complete());
      return;
    }

    emit(const SalarySplitState.confirming());
    try {
      await _depositSalarySplitUseCase(cycleId: cycleId, amount: amount);
      emit(const SalarySplitState.complete());
    } catch (e) {
      emit(SalarySplitState.error(e.toString()));
    }
  }

  void skip() {
    emit(const SalarySplitState.complete());
  }
}
