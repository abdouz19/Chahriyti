import '../../../domain/repositories/user_repository.dart';
import '../../../domain/repositories/cycle_repository.dart';
import '../../../domain/entities/user_entity.dart';

class SetupSalaryUseCase {
  final UserRepository _userRepo;
  final CycleRepository _cycleRepo;

  const SetupSalaryUseCase(this._userRepo, this._cycleRepo);

  Future<UserEntity> call({
    required int monthlySalary,
    required int salaryDay,
    required String fullName,
    required String phoneNumber,
    required int wilayaCode,
  }) async {
    if (monthlySalary <= 0) throw ArgumentError('Salary must be positive');
    if (salaryDay < 1 || salaryDay > 31) {
      throw ArgumentError('Invalid salary day');
    }

    final user = await _userRepo.createUser(
      monthlySalary: monthlySalary,
      salaryDay: salaryDay,
      fullName: fullName,
      phoneNumber: phoneNumber,
      wilayaCode: wilayaCode,
    );

    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month, salaryDay);
    final cycleStart = startDate.isAfter(now)
        ? DateTime(now.year, now.month - 1, salaryDay)
        : startDate;
    final cycleEnd = DateTime(
      cycleStart.year,
      cycleStart.month + 1,
      salaryDay,
    ).subtract(const Duration(days: 1));

    await _cycleRepo.createCycle(
      startDate: cycleStart,
      endDate: cycleEnd,
      salaryAmount: monthlySalary,
    );

    return user;
  }
}
