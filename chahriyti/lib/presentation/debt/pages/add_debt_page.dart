import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/debt_entity.dart';
import '../cubits/debt_cubit.dart';
import '../cubits/debt_state.dart';

class AddDebtPage extends StatefulWidget {
  final DebtEntity? initialDebt;

  const AddDebtPage({this.initialDebt, super.key});

  @override
  State<AddDebtPage> createState() => _AddDebtPageState();
}

class _AddDebtPageState extends State<AddDebtPage> {
  late final TextEditingController _creditorController;
  late final TextEditingController _amountController;
  late final TextEditingController _notesController;
  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _creditorController = TextEditingController();
    _amountController = TextEditingController();
    _notesController = TextEditingController();
    _formKey = GlobalKey<FormState>();

    if (widget.initialDebt != null) {
      _creditorController.text = widget.initialDebt!.creditorName;
      _amountController.text = widget.initialDebt!.totalAmount.toString();
      _notesController.text = widget.initialDebt!.notes ?? '';
    }
  }

  @override
  void dispose() {
    _creditorController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context, DebtCubit cubit) {
    if (!_formKey.currentState!.validate()) return;

    final amount = int.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('أدخل مبلغاً صحيحاً')),
      );
      return;
    }

    if (widget.initialDebt != null) {
      cubit.updateDebt(
        id: widget.initialDebt!.id,
        creditorName: _creditorController.text,
        totalAmount: amount,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );
    } else {
      cubit.createDebt(
        creditorName: _creditorController.text,
        totalAmount: amount,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DebtCubit>(
      create: (_) => DebtCubit(
        Injection.createDebtUseCase,
        Injection.getDebtsUseCase,
        Injection.updateDebtUseCase,
        Injection.deleteDebtUseCase,
        Injection.addPaymentUseCase,
        Injection.getSavingsBalanceUseCase,
        notificationService: Injection.notificationService,
      ),
      child: BlocListener<DebtCubit, DebtState>(
        listener: (context, state) {
          state.whenOrNull(
            debtCreated: (_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم إنشاء الدين بنجاح'),
                  backgroundColor: AppColors.positive,
                ),
              );
              Navigator.pop(context);
            },
            debtUpdated: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم تعديل الدين بنجاح'),
                  backgroundColor: AppColors.positive,
                ),
              );
              Navigator.pop(context);
            },
            error: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message),
                  backgroundColor: AppColors.negative,
                ),
              );
            },
          );
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              widget.initialDebt != null ? 'تعديل الدين' : 'دين جديد',
              style: AppTypography.headlineSmall,
            ),
          ),
          body: BlocBuilder<DebtCubit, DebtState>(
            builder: (context, state) {
              if (state is DebtLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              final cubit = context.read<DebtCubit>();

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'اسم الدائن',
                        style: AppTypography.labelLarge,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _creditorController,
                        decoration: const InputDecoration(
                          hintText: 'مثال: محمد أحمد',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'اسم الدائن مطلوب';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'المبلغ الكلي للدين',
                        style: AppTypography.labelLarge,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'أدخل المبلغ',
                          suffixText: 'دج',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'المبلغ مطلوب';
                          }
                          if (int.tryParse(value) == null) {
                            return 'أدخل رقماً صحيحاً';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'ملاحظات (اختياري)',
                        style: AppTypography.labelLarge,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _notesController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          hintText: 'أضف ملاحظات عن الدين...',
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _submit(context, cubit),
                          child: Text(
                            widget.initialDebt != null
                                ? 'حفظ التعديل'
                                : 'حفظ الدين',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
