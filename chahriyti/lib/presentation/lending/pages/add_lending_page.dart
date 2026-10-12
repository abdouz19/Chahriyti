import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/extensions/money_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/lending_entity.dart';
import '../../shared/widgets/payment_source_toggle.dart';
import '../../shared/widgets/funding_source_sheet.dart';
import '../../../application/use_cases/lending/update_lending_use_case.dart';
import '../../../domain/value_objects/lending_money_place.dart';
import '../cubits/lending_cubit.dart';
import '../cubits/lending_state.dart';
import '../widgets/delta_adjustment_sheet.dart';

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

    // Pre-fetch both balances so the sheet can display and disable unavailable options
    final currentBalance = await _getCurrentBalance();
    await _loadSavingsBalance();

    if (!context.mounted) return;
    final l10n = context.l10n;
    final source = await showModalBottomSheet<LendingMoneyPlace>(
      context: context,
      isScrollControlled: true,
      builder: (_) => LendingDeltaAdjustmentSheet(
        delta: delta.abs(),
        isIncrease: delta > 0,
        title: delta > 0
            ? l10n.lendingDeltaIncreaseTitle
            : l10n.lendingDeltaDecreaseTitle,
        description: delta > 0
            ? l10n.lendingDeltaIncreaseDesc(delta.abs())
            : l10n.lendingDeltaDecreaseDesc(delta.abs()),
        currentBalance: currentBalance,
        savingsBalance: _savingsBalance,
      ),
    );
    if (source == null || !context.mounted) return;

    try {
      await Injection.updateLendingUseCase(UpdateLendingRequest(
        id: lending.id,
        borrowerName: _borrowerController.text,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
        totalAmount: newAmount,
        deltaPlace: source,
      ));
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.negative,
          ),
        );
      }
      return;
    }

    if (!context.mounted) return;
    cubit.loadLendingById(lending.id);
  }

  // Active cycle balance: the difference always moves money today, even when
  // editing a lending made in an older cycle.
  Future<int> _getCurrentBalance() async =>
      (await Injection.getDashboardDataUseCase()).currentBalance;

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
                          final parsed = int.tryParse(value);
                          if (parsed == null) {
                            return context.l10n.enterNumber;
                          }
                          final collected =
                              widget.initialLending?.collectedAmount ?? 0;
                          if (parsed < collected) {
                            return context.l10n.lendingAmountBelowCollected(
                              collected.toDZDString(
                                  symbol: context.l10n.currencySymbol),
                            );
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

