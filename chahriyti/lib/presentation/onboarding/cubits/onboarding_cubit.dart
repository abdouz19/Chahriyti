import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/use_cases/onboarding/setup_salary_use_case.dart';
import '../../../infrastructure/services/lead_service.dart';
import '../../../infrastructure/services/lead_storage.dart';

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
  final LeadService _leadService;
  final LeadStorage _leadStorage;

  // In-memory fields — populated during the forward flow
  String _name = '';
  String _phone = '';
  int _wilayaCode = 16;
  String? _commune;
  String? _ageGroup;
  int _salary = 0;
  int _salaryDay = 1;
  String? _maritalStatus;
  bool? _tracksExpenses;
  List<String> _goals = [];

  // Getters for pre-filling forms on back navigation
  String get name => _name;
  String get phone => _phone;
  int get wilayaCode => _wilayaCode;
  String? get commune => _commune;
  String? get ageGroup => _ageGroup;
  int get salary => _salary;
  int get salaryDay => _salaryDay;
  String? get maritalStatus => _maritalStatus;
  bool? get tracksExpenses => _tracksExpenses;
  List<String> get goals => List.unmodifiable(_goals);

  OnboardingCubit({
    required SetupSalaryUseCase setupSalaryUseCase,
    LeadService? leadService,
    LeadStorage? leadStorage,
  })  : _setupSalaryUseCase = setupSalaryUseCase,
        _leadService = leadService ?? LeadService(),
        _leadStorage = leadStorage ?? const LeadStorage(),
        super(const OnboardingProfile());

  void start() => emit(const OnboardingProfile());

  void submitProfile({
    required String name,
    required String phone,
    required int wilayaCode,
    String? commune,
  }) {
    _name = name;
    _phone = phone;
    _wilayaCode = wilayaCode;
    _commune = commune;
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

  /// Goals "التالي": submit to Firestore + save profile locally.
  Future<void> submitGoals(List<String> goals) async {
    _goals = goals;
    emit(const OnboardingLoading());
    try {
      String? fcmToken;
      try {
        fcmToken = await FirebaseMessaging.instance.getToken();
      } catch (_) {
        // APNs not configured or permission denied — token stays null
      }

      // Save locally first — must succeed
      await _leadStorage.save(
        name: _name,
        phone: _phone,
        wilayaCode: _wilayaCode,
        salary: _salary,
        salaryDay: _salaryDay,
      );

      // Submit to Firestore — non-fatal if it fails
      try {
        await _leadService.submitLead(
          name: _name,
          phone: _phone,
          wilayaCode: _wilayaCode,
          commune: _commune,
          ageGroup: _ageGroup,
          salary: _salary,
          salaryDay: _salaryDay,
          maritalStatus: _maritalStatus,
          tracksExpenses: _tracksExpenses,
          goals: _goals,
          fcmToken: fcmToken,
        );
      } catch (_) {
        // Firestore submission failed — user still proceeds to celebration
      }

      emit(OnboardingCelebration(firstName: _name.split(' ').first));
    } catch (_) {
      emit(const OnboardingError('تعذّر حفظ بياناتك، تحقق من الاتصال وحاول مجدداً'));
    }
  }

  // Legacy stub methods
  // ignore: unused_element
  Future<void> setSalary({
    required int monthlySalary,
    required int salaryDay,
    required String fullName,
    required String phoneNumber,
    required int wilayaCode,
  }) async {}

  // ignore: unused_element
  Future<void> addIncome({required String description, required int amount}) async {}

  // ignore: unused_element
  void skipIncome() {}

  // ignore: unused_element
  void skipSalarySplit() {}

  /// Celebration "لدي كود التفعيل": create local DB user then go to activation.
  /// Uses in-memory data in the forward flow, falls back to storage on reopen.
  Future<void> complete() async {
    emit(const OnboardingLoading());
    try {
      String name = _name;
      String phone = _phone;
      int wilayaCode = _wilayaCode;
      int salary = _salary;
      int salaryDay = _salaryDay;

      // Reopen case: cubit is fresh, load from storage
      if (name.isEmpty) {
        final stored = await _leadStorage.load();
        if (stored != null) {
          name = stored['name'] as String? ?? '';
          phone = stored['phone'] as String? ?? '';
          wilayaCode = stored['wilayaCode'] as int? ?? 16;
          salary = stored['salary'] as int? ?? 0;
          salaryDay = stored['salaryDay'] as int? ?? 1;
        }
      }

      await _setupSalaryUseCase(
        monthlySalary: salary,
        salaryDay: salaryDay,
        fullName: name,
        phoneNumber: phone,
        wilayaCode: wilayaCode,
      );
      await _leadStorage.clear();
      emit(const OnboardingDone());
    } on ArgumentError catch (e) {
      emit(OnboardingError(e.message.toString()));
    } catch (_) {
      emit(const OnboardingError('حدث خطأ غير متوقع، يرجى المحاولة مجدداً'));
    }
  }
}
