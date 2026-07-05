import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

import '../../../application/use_cases/cycle/reset_app_data_use_case.dart';
import '../../../domain/repositories/cycle_repository.dart';
import '../../../domain/repositories/user_repository.dart';

// ─── States ────────────────────────────────────────────────────────────────

abstract class SettingsState {
  const SettingsState();
}

class SettingsLoading extends SettingsState {
  const SettingsLoading();
}

class SettingsLoaded extends SettingsState {
  final String userName;
  final int salary;
  final int salaryDay;
  final bool isActivated;
  final bool challengesEnabled;
  // Current active cycle values (may differ from pending user values)
  final int? currentCycleSalary;
  final int? currentCycleSalaryDay;

  const SettingsLoaded({
    required this.userName,
    required this.salary,
    required this.salaryDay,
    required this.isActivated,
    required this.challengesEnabled,
    this.currentCycleSalary,
    this.currentCycleSalaryDay,
  });

  bool get salaryPending =>
      currentCycleSalary != null && salary != currentCycleSalary;

  bool get salaryDayPending =>
      currentCycleSalaryDay != null && salaryDay != currentCycleSalaryDay;
}

class SettingsUpdating extends SettingsState {
  const SettingsUpdating();
}

class SettingsResetting extends SettingsState {
  const SettingsResetting();
}

class SettingsDataResetComplete extends SettingsState {
  const SettingsDataResetComplete();
}

class SettingsError extends SettingsState {
  final String message;

  const SettingsError(this.message);
}

// ─── Cubit ─────────────────────────────────────────────────────────────────

class SettingsCubit extends Cubit<SettingsState> {
  final UserRepository _userRepository;
  final CycleRepository _cycleRepository;
  final ResetAppDataUseCase _resetAppData;

  SettingsCubit({
    required UserRepository userRepository,
    required CycleRepository cycleRepository,
    required ResetAppDataUseCase resetAppData,
  })  : _userRepository = userRepository,
        _cycleRepository = cycleRepository,
        _resetAppData = resetAppData,
        super(const SettingsLoading());

  Future<void> loadSettings() async {
    emit(const SettingsLoading());
    try {
      final user = await _userRepository.getUser();
      if (user == null) {
        emit(const SettingsError('لم يتم العثور على بيانات المستخدم'));
        return;
      }

      final cycle = await _cycleRepository.getActiveCycle();

      emit(SettingsLoaded(
        userName: user.fullName,
        salary: user.monthlySalary,
        salaryDay: user.salaryDay,
        isActivated: user.isActivated,
        challengesEnabled: user.challengesEnabled,
        currentCycleSalary: cycle?.salaryAmount,
        currentCycleSalaryDay: cycle?.startDate.day,
      ));
    } catch (e) {
      debugPrint('❌ SETTINGS ERROR: $e');
      emit(SettingsError('حدث خطأ في تحميل الإعدادات: ${e.toString()}'));
    }
  }

  Future<void> updateSalary(int newSalary) async {
    emit(const SettingsUpdating());
    try {
      debugPrint('💾 SETTINGS: Updating salary to $newSalary');
      final user = await _userRepository.getUser();
      if (user == null) {
        emit(const SettingsError('لم يتم العثور على المستخدم'));
        return;
      }

      final updatedUser = user.copyWith(monthlySalary: newSalary);
      await _userRepository.updateUser(updatedUser);
      // Do NOT update the current cycle — change takes effect next cycle only.
      debugPrint('✅ SETTINGS: Salary updated successfully (applies next cycle)');
      await loadSettings();
    } catch (e) {
      debugPrint('❌ SETTINGS ERROR: $e');
      emit(SettingsError('حدث خطأ في تحديث الراتب: ${e.toString()}'));
    }
  }

  /// Updates the user's salary day. Never modifies the active cycle's dates —
  /// the change takes effect when the next cycle is auto-created on salary day.
  Future<void> updateSalaryDay(int newDay) async {
    emit(const SettingsUpdating());
    try {
      debugPrint('💾 SETTINGS: Updating salary day to $newDay');
      final user = await _userRepository.getUser();
      if (user == null) {
        emit(const SettingsError('لم يتم العثور على المستخدم'));
        return;
      }

      final updatedUser = user.copyWith(salaryDay: newDay);
      await _userRepository.updateUser(updatedUser);

      debugPrint('✅ SETTINGS: Salary day updated successfully');
      await loadSettings();
    } catch (e) {
      debugPrint('❌ SETTINGS ERROR: $e');
      emit(SettingsError('حدث خطأ في تحديث يوم الراتب: ${e.toString()}'));
    }
  }

  Future<void> resetAllData() async {
    emit(const SettingsResetting());
    try {
      await _resetAppData();
      emit(const SettingsDataResetComplete());
    } catch (e) {
      emit(SettingsError('فشل إعادة تعيين البيانات: ${e.toString()}'));
    }
  }

  Future<void> toggleChallenges(bool enabled) async {
    emit(const SettingsUpdating());
    try {
      debugPrint('💾 SETTINGS: Toggling challenges to $enabled');
      final user = await _userRepository.getUser();
      if (user == null) {
        emit(const SettingsError('لم يتم العثور على المستخدم'));
        return;
      }

      final updatedUser = user.copyWith(challengesEnabled: enabled);
      await _userRepository.updateUser(updatedUser);

      debugPrint('✅ SETTINGS: Challenges toggled successfully');
      await loadSettings();
    } catch (e) {
      debugPrint('❌ SETTINGS ERROR: $e');
      emit(SettingsError('حدث خطأ في تحديث إعدادات التحديات: ${e.toString()}'));
    }
  }
}
