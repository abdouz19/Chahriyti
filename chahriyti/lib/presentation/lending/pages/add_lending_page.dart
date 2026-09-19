import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/lending_entity.dart';
import '../../shared/widgets/payment_source_toggle.dart';
import '../../shared/widgets/funding_source_sheet.dart';
import '../../../application/use_cases/lending/update_lending_use_case.dart';
import '../cubits/lending_cubit.dart';
import '../cubits/lending_state.dart';

class AddLendingPage extends StatefulWidget {
  final int cycleId;
  final LendingEntity? initialLending;

  const AddLendingPage({super.key, required this.cycleId, this.initialLending});

  @override
  State<AddLendingPage> createState() => _AddLendingPageState();
}

class _AddLendingPageState extends State<AddLendingPage> {
  late final TextEditingController _borrowerController;
  late final TextEditingController _amountController;
  late final TextEditingController _notesController;
  late final GlobalKey<FormState> _formKey;
  bool _fromSavings = false;
  int _savingsBalance = 0;

  @override
  void initState() {
    super.initState();
    _borrowerController = TextEditingController();
    _amountController = TextEditingController();
    _notesController = TextEditingController();
    _formKey = GlobalKey<FormState>();
    _loadSavingsBalance();
    if (widget.initialLending != null) {
      _borrowerController.text = widget.initialLending!.borrowerName;
      _amountController.text = widget.initialLending!.totalAmount.toString();
      _notesController.text = widget.initialLending!.notes ?? '';
    }
  }

  Future<void> _loadSavingsBalance() async {
    final balance = await Injection.getSavingsBalanceUseCase();
    if (mounted) {
      setState(() => _savingsBalance = balance);
    }
  }

  @override
  void dispose() {
    _borrowerController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit(BuildContext context, LendingCubit cubit) async {
    if (!_formKey.currentState!.validate()) return;

    final amount = int.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.enterValidAmount)),
      );
      return;
    }

    if (widget.initialLending != null) {
      await _submitEdit(context, cubit, amount);
      return;
    }

    // New lending: check balance
    if (!_fromSavings) {
      final balance = await _getCurrentBalance();
      if (amount > balance + _savingsBalance) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.insufficientFunds)),
          );
        }
        return;
      }
      if (amount > balance && context.mounted) {
        final result = await showFundingSourceSheet(
          context,
          amount: amount,
          availableBalance: balance,
          availableSavings: _savingsBalance,
        );
        if (result == null || !context.mounted) return;
        cubit.createLending(
          borrowerName: _borrowerController.text,
          amount: amount,
          fromSavings: false,
          savingsAmount: result.savingsAmount,
          notes: _notesController.text.isEmpty ? null : _notesController.text,
        );
        return;
      }
    } else {
      // All from savings
      if (amount > _savingsBalance) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.insufficientSavings)),
          );
        }
        return;
      }
    }

    cubit.createLending(
      borrowerName: _borrowerController.text,
      amount: amount,
      fromSavings: _fromSavings,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
    );
  }

  Future<void> _submitEdit(
    BuildContext context,
    LendingCubit cubit,
    int newAmount,
  ) async {
    final lending = widget.initialLending!;
    final delta = newAmount - lending.totalAmount;

    if (delta > 0) {
      final balance = await _getCurrentBalance();
      // Effective balance = current balance + original amount freed up (if from balance)
      final effectiveBalance = balance + (lending.fromSavings ? 0 : lending.totalAmount);

      if (delta > effectiveBalance) {
        await _loadSavingsBalance();
        if (!context.mounted) return;

        if (newAmount > effectiveBalance + _savingsBalance) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.insufficientFunds),
              backgroundColor: AppColors.negative,
            ),
          );
          return;
        }

        final result = await showFundingSourceSheet(
          context,
          amount: newAmount,
          availableBalance: effectiveBalance,
          availableSavings: _savingsBalance,
        );
        if (result == null || !context.mounted) return;

        // Update lending
        await Injection.updateLendingUseCase(UpdateLendingRequest(
          id: lending.id,
          borrowerName: _borrowerController.text,
          notes: _notesController.text.isEmpty ? null : _notesController.text,
          totalAmount: newAmount,
        ));

        // Handle savings withdrawal delta
        final newSavingsAmount = result.savingsAmount;
        final oldSavingsAmount = lending.savingsAmount;
        if (newSavingsAmount > 0) {
          if (oldSavingsAmount > 0) {
            // Replace old record
            await Injection.savingsRepository.deleteWithdrawalByLendingId(lending.id);
          }
          await Injection.withdrawSavingsUseCase(
            amount: newSavingsAmount,
            description: _borrowerController.text,
            lendingId: lending.id,
          );
        }

        if (!context.mounted) return;
        cubit.loadLendingById(lending.id);
        return;
      }
    }

    // Delta fits in balance (or is reduction) — update directly
    cubit.updateLending(
      id: lending.id,
      borrowerName: _borrowerController.text,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
      totalAmount: newAmount,
    );
  }

  Future<int> _getCurrentBalance() async {
    final totalExpenses =
        await Injection.expenseRepository.getTotalExpenses(widget.cycleId);
    final totalIncome =
        await Injection.incomeRepository.getTotalIncomeForCycle(widget.cycleId);
    final totalDebtPayments =
        await Injection.debtRepository.getTotalDebtPaymentsForCycle(
            widget.cycleId);
    final totalDebtsCreated =
        await Injection.debtRepository.getTotalDebtsCreatedForCycle(
            widget.cycleId);
    final totalLendings =
        await Injection.lendingRepository.getTotalLendingsFromBalanceForCycle(
            widget.cycleId);
    final totalCollections =
        await Injection.lendingRepository.getTotalCollectionsToBalanceForCycle(
            widget.cycleId);
    final cycle =
        await Injection.cycleRepository.getCycleById(widget.cycleId);
    if (cycle == null) return 0;
    return cycle.salaryAmount -
        cycle.salarySplitAmount +
        totalIncome +
        totalDebtsCreated -
        totalExpenses -
        totalDebtPayments -
        totalLendings +
        totalCollections;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LendingCubit>(
      create: (_) => LendingCubit(
        Injection.createLendingUseCase,
        Injection.getLendingsUseCase,
        Injection.addLendingCollectionUseCase,
        Injection.deleteLendingUseCase,
        Injection.getSavingsBalanceUseCase,
        Injection.updateLendingUseCase,
      ),
      child: BlocListener<LendingCubit, LendingState>(
        listener: (context, state) {
          state.whenOrNull(
            lendingCreated: (_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.l10n.lendingCreated),
                  backgroundColor: AppColors.positive,
                ),
              );
              Navigator.pop(context);
            },
            lendingLoaded: (_, __) {
              if (widget.initialLending != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(context.l10n.lendingUpdated),
                    backgroundColor: AppColors.positive,
                  ),
                );
                Navigator.pop(context);
              }
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
              widget.initialLending != null ? context.l10n.editLending : context.l10n.newLending,
              style: AppTypography.headlineSmall,
            ),
          ),
          body: BlocBuilder<LendingCubit, LendingState>(
            builder: (context, state) {
              if (state is LendingLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              final cubit = context.read<LendingCubit>();

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.borrowerName,
                        style: AppTypography.labelLarge,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _borrowerController,
                        decoration: InputDecoration(
                          hintText: context.l10n.borrowerNameHint,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return context.l10n.borrowerNameRequired;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Text(
                        context.l10n.lendingAmount,
                        style: AppTypography.labelLarge,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
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
                      // Payment source toggle (hidden in edit mode)
                      if (widget.initialLending == null) ...[
                        FutureBuilder<int>(
                          future: _getCurrentBalance(),
                          initialData: 0,
                          builder: (context, snapshot) {
                            return PaymentSourceToggle(
                              currentBalance: snapshot.data ?? 0,
                              savingsBalance: _savingsBalance,
                              fromSavings: _fromSavings,
                              onChanged: (value) {
                                setState(() => _fromSavings = value);
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                      Text(
                        context.l10n.notesOptional,
                        style: AppTypography.labelLarge,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _notesController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: context.l10n.addLendingNoteHint,
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async => _submit(context, cubit),
                          child: Text(
                            widget.initialLending != null
                                ? context.l10n.saveEdit
                                : context.l10n.saveLending,
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
