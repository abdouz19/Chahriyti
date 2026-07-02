import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/use_cases/onboarding/setup_salary_use_case.dart';
import '../../../application/use_cases/onboarding/add_initial_income_use_case.dart';
import '../../../application/use_cases/savings/deposit_salary_split_use_case.dart';
import '../../../domain/repositories/cycle_repository.dart';

// ---------------------------------------------------------------------------
// States
// ---------------------------------------------------------------------------

sealed class OnboardingState {
  const OnboardingState();
}

final class OnboardingInitial extends OnboardingState {
  const OnboardingInitial();
}

final class OnboardingSalaryInput extends OnboardingState {
  const OnboardingSalaryInput();
}

final class OnboardingIncomeInput extends OnboardingState {
  const OnboardingIncomeInput();
}

final class OnboardingValueProposition extends OnboardingState {
  const OnboardingValueProposition();
}

final class OnboardingCompleted extends OnboardingState {
  const OnboardingCompleted();
}

final class OnboardingSalarySplit extends OnboardingState {
  final int cycleId;
  final int salaryAmount;

  const OnboardingSalarySplit({
    required this.cycleId,
    required this.salaryAmount,
  });
}

final class OnboardingLoading extends OnboardingState {
  const OnboardingLoading();
}

final class OnboardingError extends OnboardingState {
  final String message;
  const OnboardingError(this.message);
}

// ---------------------------------------------------------------------------
// Cubit
// ---------------------------------------------------------------------------

class OnboardingCubit extends Cubit<OnboardingState> {
  final SetupSalaryUseCase _setupSalaryUseCase;
  final AddInitialIncomeUseCase _addInitialIncomeUseCase;
  final DepositSalarySplitUseCase _depositSalarySplitUseCase;
  final CycleRepository _cycleRepository;

  OnboardingCubit({
    required SetupSalaryUseCase setupSalaryUseCase,
    required AddInitialIncomeUseCase addInitialIncomeUseCase,
    required DepositSalarySplitUseCase depositSalarySplitUseCase,
    required CycleRepository cycleRepository,
  })  : _setupSalaryUseCase = setupSalaryUseCase,
        _addInitialIncomeUseCase = addInitialIncomeUseCase,
        _depositSalarySplitUseCase = depositSalarySplitUseCase,
        _cycleRepository = cycleRepository,
        super(const OnboardingInitial());

  void start() => emit(const OnboardingSalaryInput());

  Future<void> setSalary({
    required int monthlySalary,
    required int salaryDay,
    required String fullName,
    required String phoneNumber,
    required int wilayaCode,
  }) async {
    emit(const OnboardingLoading());
    try {
      await _setupSalaryUseCase(
        monthlySalary: monthlySalary,
        salaryDay: salaryDay,
        fullName: fullName,
        phoneNumber: phoneNumber,
        wilayaCode: wilayaCode,
      );
      final cycle = await _cycleRepository.getActiveCycle();
      if (cycle != null) {
        emit(OnboardingSalarySplit(
          cycleId: cycle.id,
          salaryAmount: cycle.salaryAmount,
        ));
      } else {
        emit(const OnboardingIncomeInput());
      }
    } on ArgumentError catch (e) {
      emit(OnboardingError(e.message.toString()));
    } catch (_) {
      emit(const OnboardingError('حدث خطأ غير متوقع، يرجى المحاولة مجدداً'));
    }
  }

  Future<void> addIncome({
    required String description,
    required int amount,
  }) async {
    emit(const OnboardingLoading());
    try {
      await _addInitialIncomeUseCase(
        description: description,
        amount: amount,
      );
      emit(const OnboardingValueProposition());
    } on ArgumentError catch (e) {
      emit(OnboardingError(e.message.toString()));
    } catch (_) {
      emit(const OnboardingError('فشل في إضافة المداخيل الإضافية'));
    }
  }

  Future<void> applySalarySplit(int amount) async {
    if (state is! OnboardingSalarySplit) return;
    final splitState = state as OnboardingSalarySplit;
    emit(const OnboardingLoading());
    try {
      await _depositSalarySplitUseCase(
        cycleId: splitState.cycleId,
        amount: amount,
      );
      emit(const OnboardingIncomeInput());
    } catch (_) {
      emit(const OnboardingError('حدث خطأ في تقسيم الراتب'));
    }
  }

  void skipSalarySplit() => emit(const OnboardingIncomeInput());

  void skipIncome() => emit(const OnboardingValueProposition());

  void complete() => emit(const OnboardingCompleted());
}
