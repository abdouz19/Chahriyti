import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/use_cases/income/add_income_use_case.dart';
import '../../../domain/repositories/cycle_repository.dart';

// ─── States ────────────────────────────────────────────────────────────────

abstract class IncomeState {}

class IncomeInitial extends IncomeState {}

class IncomeSaving extends IncomeState {}

class IncomeSaved extends IncomeState {}

class IncomeError extends IncomeState {
  final String message;

  IncomeError(this.message);
}

// ─── Cubit ─────────────────────────────────────────────────────────────────

class IncomeCubit extends Cubit<IncomeState> {
  final AddIncomeUseCase _addIncome;
  final CycleRepository _cycleRepository;

  IncomeCubit({
    required AddIncomeUseCase addIncome,
    required CycleRepository cycleRepository,
  })  : _addIncome = addIncome,
        _cycleRepository = cycleRepository,
        super(IncomeInitial());

  Future<void> addIncome({
    required String description,
    required int amount,
  }) async {
    emit(IncomeSaving());
    try {
      final cycle = await _cycleRepository.getActiveCycle();
      if (cycle == null) {
        emit(IncomeError('لا يوجد دورة مالية نشطة'));
        return;
      }
      await _addIncome.call(
        cycleId: cycle.id,
        description: description,
        amount: amount,
      );
      emit(IncomeSaved());
    } on ArgumentError catch (e) {
      emit(IncomeError(e.message.toString()));
    } catch (e) {
      emit(IncomeError('حدث خطأ أثناء حفظ الدخل'));
    }
  }

  void reset() => emit(IncomeInitial());
}
