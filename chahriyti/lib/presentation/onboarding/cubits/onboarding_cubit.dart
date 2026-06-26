import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/use_cases/onboarding/setup_salary_use_case.dart';
import '../../../application/use_cases/onboarding/add_initial_income_use_case.dart';

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

  OnboardingCubit({
    required SetupSalaryUseCase setupSalaryUseCase,
    required AddInitialIncomeUseCase addInitialIncomeUseCase,
  })  : _setupSalaryUseCase = setupSalaryUseCase,
        _addInitialIncomeUseCase = addInitialIncomeUseCase,
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
      emit(const OnboardingIncomeInput());
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

  void skipIncome() => emit(const OnboardingValueProposition());

  void complete() => emit(const OnboardingCompleted());
}
