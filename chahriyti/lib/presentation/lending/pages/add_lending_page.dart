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
  bool _forgotten = false;
  int _savingsBalance = 0;
  Future<int>? _balanceFuture;

  @override
  void initState() {
    super.initState();
    _borrowerController = TextEditingController();
    _amountController = TextEditingController();
    _notesController = TextEditingController();
    _formKey = GlobalKey<FormState>();
    _loadSavingsBalance();
    _balanceFuture = _getCurrentBalance();
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

    // Forgotten lending: record only, no deduction
    if (_forgotten) {
      cubit.createLending(
        borrowerName: _borrowerController.text,
        amount: amount,
        forgotten: true,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );
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

    // Only name/notes changed — no financial adjustment needed
    if (delta == 0) {
      cubit.updateLending(
        id: lending.id,
        borrowerName: _borrowerController.text,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
        totalAmount: newAmount,
      );
      return;
    }

    // Ask where the delta comes from / goes to
    if (!context.mounted) return;
    final source = await showModalBottomSheet<_DeltaSource>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _DeltaAdjustmentSheet(delta: delta.abs(), isIncrease: delta > 0),
    );
    if (source == null || !context.mounted) return;

    // Validate before executing
    if (delta > 0 && source == _DeltaSource.balance) {
      final balance = await _getCurrentBalance();
      if (delta > balance) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.insufficientFunds), backgroundColor: AppColors.negative),
          );
        }
        return;
      }
    }
    if (delta > 0 && source == _DeltaSource.savings) {
      await _loadSavingsBalance();
      if (delta > _savingsBalance) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.insufficientSavings), backgroundColor: AppColors.negative),
          );
        }
        return;
      }
    }

    // Update lending record
    await Injection.updateLendingUseCase(UpdateLendingRequest(
      id: lending.id,
      borrowerName: _borrowerController.text,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
      totalAmount: newAmount,
    ));

    // Financial side-effects
    if (source == _DeltaSource.savings) {
      if (delta > 0) {
        // Extra lent money came from savings → withdraw delta from savings
        await Injection.withdrawSavingsUseCase(
          amount: delta,
          description: _borrowerController.text,
        );
      } else {
        // Reduced lending amount goes to savings → deposit |delta|
        await Injection.depositFromBalanceUseCase(amount: -delta);
      }
    }
    // balance source: balance formula auto-adjusts; no extra ops
    // forgotten source: no financial tracking; no extra ops

    if (!context.mounted) return;
    cubit.loadLendingById(lending.id);
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
                      if (widget.initialLending == null) ...[
                        const SizedBox(height: 16),
                        // Forgotten toggle
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: _forgotten
                                ? AppColors.warning.withValues(alpha: 0.08)
                                : AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _forgotten ? AppColors.warning : AppColors.border,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  context.l10n.forgottenLending,
                                  style: AppTypography.bodySmall.copyWith(
                                    color: _forgotten
                                        ? AppColors.warning
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                              Switch.adaptive(
                                value: _forgotten,
                                activeTrackColor: AppColors.warning.withValues(alpha: 0.5),
                                activeThumbColor: AppColors.warning,
                                onChanged: (value) {
                                  setState(() {
                                    _forgotten = value;
                                    if (value) _fromSavings = false;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Payment source toggle (hidden when forgotten)
                        if (!_forgotten)
                          FutureBuilder<int>(
                            future: _balanceFuture,
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

// ─── Delta adjustment ────────────────────────────────────────────────────────

enum _DeltaSource { balance, savings, forgotten }

class _DeltaAdjustmentSheet extends StatelessWidget {
  final int delta;
  final bool isIncrease;

  const _DeltaAdjustmentSheet({required this.delta, required this.isIncrease});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isIncrease ? l10n.lendingDeltaIncreaseTitle : l10n.lendingDeltaDecreaseTitle,
              style: AppTypography.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              isIncrease
                  ? l10n.lendingDeltaIncreaseDesc(delta)
                  : l10n.lendingDeltaDecreaseDesc(delta),
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            _SheetOption(
              icon: Icons.account_balance_wallet_outlined,
              label: isIncrease ? l10n.fromCurrentBalance : l10n.toCurrentBalance,
              color: AppColors.primary,
              onTap: () => Navigator.pop(context, _DeltaSource.balance),
            ),
            const SizedBox(height: 12),
            _SheetOption(
              icon: Icons.savings_outlined,
              label: isIncrease ? l10n.fromSavings : l10n.toSavings,
              color: AppColors.positive,
              onTap: () => Navigator.pop(context, _DeltaSource.savings),
            ),
            const SizedBox(height: 12),
            _SheetOption(
              icon: Icons.history_outlined,
              label: l10n.forgottenAdjustment,
              color: AppColors.warning,
              onTap: () => Navigator.pop(context, _DeltaSource.forgotten),
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _SheetOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(label, style: AppTypography.labelLarge.copyWith(color: color)),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: color, size: 14),
          ],
        ),
      ),
    );
  }
}
