import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/use_cases/onboarding/setup_salary_use_case.dart';

// ---------------------------------------------------------------------------
// States
// ---------------------------------------------------------------------------

sealed class OnboardingState {
  const OnboardingState();
}

final class OnboardingProfile extends OnboardingState {
  const OnboardingProfile();
}

final class OnboardingAgeGroup extends OnboardingState {
  const OnboardingAgeGroup();
}

final class OnboardingFinancial extends OnboardingState {
  const OnboardingFinancial();
}

final class OnboardingGoals extends OnboardingState {
  const OnboardingGoals();
}

final class OnboardingCelebration extends OnboardingState {
  final String firstName;
  const OnboardingCelebration({required this.firstName});
}

final class OnboardingLoading extends OnboardingState {
  const OnboardingLoading();
}

final class OnboardingError extends OnboardingState {
  final String message;
  const OnboardingError(this.message);
}

final class OnboardingDone extends OnboardingState {
  const OnboardingDone();
}

// ---------------------------------------------------------------------------
// Legacy state aliases (kept for backward compatibility with dead-code pages)
// ---------------------------------------------------------------------------

// ignore: unused_element
final class OnboardingSalarySplit extends OnboardingState {
  final int cycleId;
  final int salaryAmount;
  const OnboardingSalarySplit({required this.cycleId, required this.salaryAmount});
}

// ignore: unused_element
final class OnboardingIncomeInput extends OnboardingState {
  const OnboardingIncomeInput();
}

// ignore: unused_element
final class OnboardingValueProposition extends OnboardingState {
  const OnboardingValueProposition();
}

// ---------------------------------------------------------------------------
// Cubit
// ---------------------------------------------------------------------------

class OnboardingCubit extends Cubit<OnboardingState> {
  final SetupSalaryUseCase _setupSalaryUseCase;

  // Internal fields (in-memory only)
  String _name = '';
  String _phone = '';
  int _wilayaCode = 16;
  // ignore: unused_field
  String? _ageGroup;
  int _salary = 0;
  int _salaryDay = 1;
  // ignore: unused_field
  String? _maritalStatus;
  // ignore: unused_field
  bool? _tracksExpenses;
  // ignore: unused_field
  List<String> _goals = [];

  OnboardingCubit({required SetupSalaryUseCase setupSalaryUseCase})
      : _setupSalaryUseCase = setupSalaryUseCase,
        super(const OnboardingProfile());

  void start() => emit(const OnboardingProfile());

  void submitProfile({
    required String name,
    required String phone,
    required int wilayaCode,
  }) {
    _name = name;
    _phone = phone;
    _wilayaCode = wilayaCode;
    emit(const OnboardingAgeGroup());
  }

  void submitAgeGroup(String? ageGroup) {
    _ageGroup = ageGroup;
    emit(const OnboardingFinancial());
  }

  void submitFinancial({
    required int salary,
    required int salaryDay,
    String? maritalStatus,
    bool? tracksExpenses,
  }) {
    _salary = salary;
    _salaryDay = salaryDay;
    _maritalStatus = maritalStatus;
    _tracksExpenses = tracksExpenses;
    emit(const OnboardingGoals());
  }

  void submitGoals(List<String> goals) {
    _goals = goals;
    emit(OnboardingCelebration(firstName: _name.split(' ').first));
  }

  // Legacy stub methods (kept for backward compatibility with dead-code pages)
  // ignore: unused_element
  Future<void> setSalary({
    required int monthlySalary,
    required int salaryDay,
    required String fullName,
    required String phoneNumber,
    required int wilayaCode,
  }) async {}

  // ignore: unused_element
  Future<void> addIncome({
    required String description,
    required int amount,
  }) async {}

  // ignore: unused_element
  void skipIncome() {}

  // ignore: unused_element
  void skipSalarySplit() {}

  Future<void> complete() async {
    emit(const OnboardingLoading());
    try {
      await _setupSalaryUseCase(
        monthlySalary: _salary,
        salaryDay: _salaryDay,
        fullName: _name,
        phoneNumber: _phone,
        wilayaCode: _wilayaCode,
      );
      emit(const OnboardingDone());
    } on ArgumentError catch (e) {
      emit(OnboardingError(e.message.toString()));
    } catch (_) {
      emit(const OnboardingError('حدث خطأ غير متوقع، يرجى المحاولة مجدداً'));
    }
  }
}
