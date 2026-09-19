import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection.dart';
import '../../../core/extensions/l10n_extension.dart';
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
  bool _isSpent = false;

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
      _isSpent = widget.initialDebt!.isSpent;
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
        SnackBar(content: Text(context.l10n.enterValidAmount)),
      );
      return;
    }

    if (widget.initialDebt != null) {
      cubit.updateDebt(
        id: widget.initialDebt!.id,
        creditorName: _creditorController.text,
        totalAmount: amount,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
        isSpent: _isSpent,
      );
    } else {
      cubit.createDebt(
        creditorName: _creditorController.text,
        totalAmount: amount,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
        isSpent: _isSpent,
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
                SnackBar(
                  content: Text(context.l10n.debtCreated),
                  backgroundColor: AppColors.positive,
                ),
              );
              Navigator.pop(context);
            },
            debtUpdated: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.l10n.debtUpdated),
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
              widget.initialDebt != null ? context.l10n.editDebt : context.l10n.newDebt,
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
                        context.l10n.creditorName,
                        style: AppTypography.labelLarge,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _creditorController,
                        decoration: InputDecoration(
                          hintText: context.l10n.creditorNameHint,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.l10n.creditorNameRequired;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Text(
                        context.l10n.totalDebtAmount,
                        style: AppTypography.labelLarge,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: context.l10n.enterAmount,
                          suffixText: context.l10n.currencySymbol,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.l10n.amountRequired;
                          }
                          if (int.tryParse(value) == null) {
                            return context.l10n.enterNumber;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Text(
                        context.l10n.notesOptional,
                        style: AppTypography.labelLarge,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _notesController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: context.l10n.addDebtNoteHint,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    context.l10n.debtIsSpentQuestion,
                                    style: AppTypography.labelLarge,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _isSpent
                                        ? context.l10n.debtIsSpentDesc
                                        : context.l10n.debtNotSpentDesc,
                                    style: AppTypography.bodySmall.copyWith(
                                      color: _isSpent
                                          ? AppColors.negative
                                          : AppColors.positive,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: _isSpent,
                              onChanged: (v) => setState(() => _isSpent = v),
                              activeThumbColor: AppColors.primary,
                              activeTrackColor: AppColors.primary.withValues(alpha: 0.4),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _submit(context, cubit),
                          child: Text(
                            widget.initialDebt != null
                                ? context.l10n.saveEdit
                                : context.l10n.saveDebt,
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
