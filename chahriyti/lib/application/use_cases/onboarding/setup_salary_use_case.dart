import '../../../domain/repositories/user_repository.dart';
import '../../../domain/repositories/cycle_repository.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/value_objects/cycle_dates.dart';

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
    // 0 is valid: not everyone has a fixed salary
    if (monthlySalary < 0) throw ArgumentError('Salary cannot be negative');
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

    final cycleStart = CycleDates.currentCycleStart(salaryDay, DateTime.now());
    final cycleEnd = CycleDates.cycleEnd(salaryDay, cycleStart);

    await _cycleRepo.createCycle(
      startDate: cycleStart,
      endDate: cycleEnd,
      salaryAmount: monthlySalary,
    );

    return user;
  }
}
