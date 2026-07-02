import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/injection.dart';
import '../../../core/extensions/money_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/additional_income_entity.dart';
import '../../shared/widgets/confirmation_dialog.dart';
import '../cubits/income_cubit.dart';

class AddIncomePage extends StatelessWidget {
  const AddIncomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => IncomeCubit(
        addIncome: Injection.addIncomeUseCase,
        updateIncome: Injection.updateIncomeUseCase,
        deleteIncome: Injection.deleteIncomeUseCase,
        cycleRepository: Injection.cycleRepository,
        incomeRepository: Injection.incomeRepository,
      )..loadIncomes(),
      child: const _AddIncomeView(),
    );
  }
}

class _AddIncomeView extends StatefulWidget {
  const _AddIncomeView();

  @override
  State<_AddIncomeView> createState() => _AddIncomeViewState();
}

class _AddIncomeViewState extends State<_AddIncomeView> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  bool _toSavings = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;

    final description = _descriptionController.text.trim();
    final amount = int.tryParse(_amountController.text.trim()) ?? 0;

    context.read<IncomeCubit>().addIncome(
          description: description,
          amount: amount,
          toSavings: _toSavings,
        );
  }

  Future<void> _showEditDialog(AdditionalIncomeEntity income) async {
    final controller = TextEditingController(text: income.description);
    final cubit = context.read<IncomeCubit>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text('تعديل المدخول', style: AppTypography.headlineSmall),
        content: TextField(
          controller: controller,
          textDirection: TextDirection.rtl,
          autofocus: true,
          style: AppTypography.bodyLarge,
          decoration: InputDecoration(
            hintText: 'مصدر المدخول',
            hintStyle:
                AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            filled: true,
            fillColor: AppColors.background,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('إلغاء',
                style:
                    AppTypography.labelMedium.copyWith(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text('حفظ',
                style: AppTypography.labelMedium.copyWith(color: AppColors.primary)),
          ),
        ],
      ),
    );
    if (confirmed == true && controller.text.trim().isNotEmpty) {
      cubit.updateIncome(income.id, controller.text.trim());
    }
    controller.dispose();
  }

  Future<void> _showDeleteConfirmation(AdditionalIncomeEntity income) async {
    final cubit = context.read<IncomeCubit>();
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'حذف المدخول',
      message: 'هل تريد حذف "${income.description}"؟',
      confirmColor: AppColors.negative,
    );
    if (confirmed) {
      cubit.deleteIncome(income.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<IncomeCubit, IncomeState>(
      listener: (context, state) {
        if (state is IncomeSaved) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'تم حفظ المدخول بنجاح',
                style: AppTypography.bodyMedium.copyWith(color: Colors.white),
              ),
              backgroundColor: AppColors.positive,
            ),
          );
          context.pop();
        } else if (state is IncomeUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'تم تعديل المدخول بنجاح',
                style: AppTypography.bodyMedium.copyWith(color: Colors.white),
              ),
              backgroundColor: AppColors.positive,
            ),
          );
          context.read<IncomeCubit>().loadIncomes();
        } else if (state is IncomeDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'تم حذف المدخول',
                style: AppTypography.bodyMedium.copyWith(color: Colors.white),
              ),
              backgroundColor: AppColors.positive,
            ),
          );
          context.read<IncomeCubit>().loadIncomes();
        } else if (state is IncomeError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
                style: AppTypography.bodyMedium.copyWith(color: Colors.white),
              ),
              backgroundColor: AppColors.negative,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(
            'إضافة مدخول',
            style: AppTypography.headlineSmall,
          ),
          centerTitle: true,
          backgroundColor: AppColors.background,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),

                // Description field
                TextFormField(
                  controller: _descriptionController,
                  textDirection: TextDirection.rtl,
                  decoration: InputDecoration(
                    hintText: 'مصدر المدخول',
                    hintStyle: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    prefixIcon: Icon(
                      Icons.description_rounded,
                      color: AppColors.textSecondary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: AppColors.card,
                  ),
                  style: AppTypography.bodyLarge,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'مصدر الدخل مطلوب';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Amount field
                TextFormField(
                  controller: _amountController,
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.right,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    hintText: 'المبلغ',
                    hintStyle: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    suffixText: 'دج',
                    suffixStyle: AppTypography.labelMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    prefixIcon: Icon(
                      Icons.payments_rounded,
                      color: AppColors.textSecondary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: AppColors.card,
                  ),
                  style: AppTypography.amountMedium,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'المبلغ مطلوب';
                    }
                    final amount = int.tryParse(value.trim());
                    if (amount == null || amount <= 0) {
                      return 'المبلغ يجب أن يكون أكبر من الصفر';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Destination toggle
                Text(
                  'الوجهة',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _toSavings = false),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: !_toSavings
                                ? AppColors.primary.withValues(alpha: 0.1)
                                : AppColors.card,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: !_toSavings
                                  ? AppColors.primary
                                  : AppColors.border,
                              width: !_toSavings ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.account_balance_wallet_rounded,
                                size: 18,
                                color: !_toSavings
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'الرصيد',
                                style: AppTypography.labelMedium.copyWith(
                                  color: !_toSavings
                                      ? AppColors.primary
                                      : AppColors.textSecondary,
                                  fontWeight: !_toSavings
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _toSavings = true),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: _toSavings
                                ? AppColors.primary.withValues(alpha: 0.1)
                                : AppColors.card,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _toSavings
                                  ? AppColors.primary
                                  : AppColors.border,
                              width: _toSavings ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.savings_rounded,
                                size: 18,
                                color: _toSavings
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'المدخرات',
                                style: AppTypography.labelMedium.copyWith(
                                  color: _toSavings
                                      ? AppColors.primary
                                      : AppColors.textSecondary,
                                  fontWeight: _toSavings
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Save button
                BlocBuilder<IncomeCubit, IncomeState>(
                  builder: (context, state) {
                    final isSaving = state is IncomeSaving;

                    return SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: isSaving ? null : _onSave,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor:
                              AppColors.primary.withValues(alpha: 0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isSaving
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'حفظ',
                                style: AppTypography.labelLarge.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 32),

                // Existing incomes list
                BlocBuilder<IncomeCubit, IncomeState>(
                  builder: (context, state) {
                    if (state is IncomeLoading) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    if (state is IncomeLoaded && state.incomes.isNotEmpty) {
                      return _IncomeList(
                        incomes: state.incomes,
                        onEdit: _showEditDialog,
                        onDelete: _showDeleteConfirmation,
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Income List Widget ─────────────────────────────────────────────────────

class _IncomeList extends StatelessWidget {
  final List<AdditionalIncomeEntity> incomes;
  final void Function(AdditionalIncomeEntity) onEdit;
  final void Function(AdditionalIncomeEntity) onDelete;

  const _IncomeList({
    required this.incomes,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'المدخولات الإضافية',
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        ...incomes.map((income) => _IncomeItem(
              income: income,
              onEdit: onEdit,
              onDelete: onDelete,
            )),
      ],
    );
  }
}

class _IncomeItem extends StatelessWidget {
  final AdditionalIncomeEntity income;
  final void Function(AdditionalIncomeEntity) onEdit;
  final void Function(AdditionalIncomeEntity) onDelete;

  const _IncomeItem({
    required this.income,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: Text(
          income.description,
          style: AppTypography.bodyMedium,
          textDirection: TextDirection.rtl,
        ),
        subtitle: Text(
          income.amount.toDZDString(),
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.positive,
            fontWeight: FontWeight.w600,
          ),
          textDirection: TextDirection.rtl,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit_outlined,
                  size: 20, color: AppColors.textSecondary),
              onPressed: () => onEdit(income),
              tooltip: 'تعديل',
            ),
            IconButton(
              icon: Icon(Icons.delete_outline,
                  size: 20, color: AppColors.negative),
              onPressed: () => onDelete(income),
              tooltip: 'حذف',
            ),
          ],
        ),
      ),
    );
  }
}
