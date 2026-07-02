import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/use_cases/income/add_income_use_case.dart';
import '../../../application/use_cases/income/delete_income_use_case.dart';
import '../../../application/use_cases/income/update_income_use_case.dart';
import '../../../domain/entities/additional_income_entity.dart';
import '../../../domain/repositories/cycle_repository.dart';
import '../../../domain/repositories/income_repository.dart';

// ─── States ────────────────────────────────────────────────────────────────

abstract class IncomeState {}

class IncomeInitial extends IncomeState {}

class IncomeSaving extends IncomeState {}

class IncomeSaved extends IncomeState {}

class IncomeLoading extends IncomeState {}

class IncomeLoaded extends IncomeState {
  final List<AdditionalIncomeEntity> incomes;

  IncomeLoaded(this.incomes);
}

class IncomeUpdated extends IncomeState {}

class IncomeDeleted extends IncomeState {}

class IncomeError extends IncomeState {
  final String message;

  IncomeError(this.message);
}

// ─── Cubit ─────────────────────────────────────────────────────────────────

class IncomeCubit extends Cubit<IncomeState> {
  final AddIncomeUseCase _addIncome;
  final UpdateIncomeUseCase _updateIncome;
  final DeleteIncomeUseCase _deleteIncome;
  final CycleRepository _cycleRepository;
  final IncomeRepository _incomeRepository;

  IncomeCubit({
    required AddIncomeUseCase addIncome,
    required UpdateIncomeUseCase updateIncome,
    required DeleteIncomeUseCase deleteIncome,
    required CycleRepository cycleRepository,
    required IncomeRepository incomeRepository,
  })  : _addIncome = addIncome,
        _updateIncome = updateIncome,
        _deleteIncome = deleteIncome,
        _cycleRepository = cycleRepository,
        _incomeRepository = incomeRepository,
        super(IncomeInitial());

  Future<void> loadIncomes() async {
    emit(IncomeLoading());
    try {
      final cycle = await _cycleRepository.getActiveCycle();
      if (cycle == null) {
        emit(IncomeLoaded(const []));
        return;
      }
      final incomes = await _incomeRepository.getIncomesForCycle(cycle.id);
      emit(IncomeLoaded(incomes));
    } catch (_) {
      emit(IncomeLoaded(const []));
    }
  }

  Future<void> addIncome({
    required String description,
    required int amount,
    bool toSavings = false,
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
        toSavings: toSavings,
      );
      emit(IncomeSaved());
    } on ArgumentError catch (e) {
      emit(IncomeError(e.message.toString()));
    } catch (e) {
      emit(IncomeError('حدث خطأ أثناء حفظ الدخل'));
    }
  }

  Future<void> updateIncome(int id, String description) async {
    try {
      await _updateIncome.call(id: id, description: description);
      emit(IncomeUpdated());
    } on ArgumentError catch (e) {
      emit(IncomeError(e.message.toString()));
    } catch (_) {
      emit(IncomeError('حدث خطأ. لم يتم حفظ التغييرات.'));
    }
  }

  Future<void> deleteIncome(int id) async {
    try {
      await _deleteIncome.call(id);
      emit(IncomeDeleted());
    } on ArgumentError catch (_) {
      emit(IncomeError(
          'لا يمكن حذف دخل محوّل للمدخرات. قم بسحب المبلغ من المدخرات يدوياً.'));
    } catch (_) {
      emit(IncomeError('حدث خطأ. لم يتم حذف الدخل.'));
    }
  }

  void reset() => emit(IncomeInitial());
}
