import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

import '../../../application/use_cases/cycle/reset_cycle_use_case.dart';
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

  const SettingsLoaded({
    required this.userName,
    required this.salary,
    required this.salaryDay,
    required this.isActivated,
    required this.challengesEnabled,
  });
}

class SettingsUpdating extends SettingsState {
  const SettingsUpdating();
}

class SettingsResetting extends SettingsState {
  const SettingsResetting();
}

class SettingsResetComplete extends SettingsState {
  const SettingsResetComplete();
}

class SettingsError extends SettingsState {
  final String message;

  const SettingsError(this.message);
}

// ─── Cubit ─────────────────────────────────────────────────────────────────

class SettingsCubit extends Cubit<SettingsState> {
  final UserRepository _userRepository;
  final CycleRepository _cycleRepository;
  final ResetCycleUseCase _resetCycle;

  SettingsCubit({
    required UserRepository userRepository,
    required CycleRepository cycleRepository,
    required ResetCycleUseCase resetCycle,
  })  : _userRepository = userRepository,
        _cycleRepository = cycleRepository,
        _resetCycle = resetCycle,
        super(const SettingsLoading());

  Future<void> loadSettings() async {
    emit(const SettingsLoading());
    try {
      final user = await _userRepository.getUser();
      if (user == null) {
        emit(const SettingsError('لم يتم العثور على بيانات المستخدم'));
        return;
      }

      emit(SettingsLoaded(
        userName: user.fullName,
        salary: user.monthlySalary,
        salaryDay: user.salaryDay,
        isActivated: user.isActivated,
        challengesEnabled: user.challengesEnabled,
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

      final cycle = await _cycleRepository.getActiveCycle();
      if (cycle != null) {
        await _cycleRepository.updateCycleSalary(cycle.id, newSalary);
      }

      debugPrint('✅ SETTINGS: Salary updated successfully');
      await loadSettings();
    } catch (e) {
      debugPrint('❌ SETTINGS ERROR: $e');
      emit(SettingsError('حدث خطأ في تحديث الراتب: ${e.toString()}'));
    }
  }

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

      final cycle = await _cycleRepository.getActiveCycle();
      if (cycle != null) {
        await _cycleRepository.updateCycleSalaryDay(cycle.id, newDay);
      }

      debugPrint('✅ SETTINGS: Salary day updated successfully');
      await loadSettings();
    } catch (e) {
      debugPrint('❌ SETTINGS ERROR: $e');
      emit(SettingsError('حدث خطأ في تحديث يوم الراتب: ${e.toString()}'));
    }
  }

  Future<void> resetCycle() async {
    emit(const SettingsResetting());
    try {
      await _resetCycle();
      emit(const SettingsResetComplete());
      await loadSettings();
    } on StateError catch (e) {
      emit(SettingsError(e.message));
    } catch (e) {
      emit(const SettingsError('حدث خطأ غير متوقع'));
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
