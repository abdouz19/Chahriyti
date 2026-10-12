import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/use_cases/dashboard/get_dashboard_data_use_case.dart';
import '../../../core/di/injection.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/extensions/money_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/debt_entity.dart';
import '../../../domain/entities/financial_cycle_entity.dart';
import '../cubits/debt_cubit.dart';
import '../cubits/debt_state.dart';
import '../widgets/balance_impact_view.dart';

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
  int? _currentBalance;
  int? _activeCycleId;

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
    _amountController.addListener(() => setState(() {}));
    _loadBalance();
  }

  Future<void> _loadBalance() async {
    final results = await Future.wait([
      Injection.getDashboardDataUseCase(),
      Injection.cycleRepository.getActiveCycle(),
    ]);
    if (!mounted) return;
    setState(() {
      _currentBalance = (results[0] as DashboardData).currentBalance;
      _activeCycleId = (results[1] as FinancialCycleEntity?)?.id;
    });
  }

  bool get _isEdit => widget.initialDebt != null;

  int get _enteredAmount => int.tryParse(_amountController.text) ?? 0;

  /// Mirrors the balance formula: only non-spent debts of the active cycle
  /// count as income in the current balance.
  bool get _affectsBalance =>
      _activeCycleId != null &&
      (!_isEdit || widget.initialDebt!.cycleId == _activeCycleId);

  bool get _hasBalanceChange =>
      !_isEdit ||
      _enteredAmount != widget.initialDebt!.totalAmount ||
      _isSpent != widget.initialDebt!.isSpent;

  /// A deduction can't exceed the current balance. While the balance is
  /// still loading, any deduction is treated as unaffordable.
  bool get _isUnaffordable {
    final delta = _balanceDelta;
    if (delta >= 0) return false;
    final balance = _currentBalance;
    return balance == null || balance + delta < 0;
  }

  int get _balanceDelta {
    if (!_affectsBalance) return 0;
    final newEffect = _isSpent ? 0 : _enteredAmount;
    if (!_isEdit) return newEffect;
    final old = widget.initialDebt!;
    final oldEffect = old.isSpent ? 0 : old.totalAmount;
    return newEffect - oldEffect;
  }

  @override
  void dispose() {
    _creditorController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit(BuildContext context, DebtCubit cubit) async {
    if (!_formKey.currentState!.validate()) return;

    final amount = int.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.enterValidAmount)),
      );
      return;
    }

    if (_isEdit) {
      if (_isUnaffordable) return;
      if (_balanceDelta != 0) {
        final confirmed = await _confirmBalanceChange(context);
        if (confirmed != true || !context.mounted) return;
      }
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

  Future<bool?> _confirmBalanceChange(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          context.l10n.debtConfirmEditTitle,
          style: AppTypography.headlineSmall,
        ),
        content: _buildImpactContent(context),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(context.l10n.cancel,
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(context.l10n.confirm,
                style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  Widget _buildImpactPreview(BuildContext context) {
    if (!_hasBalanceChange || _enteredAmount <= 0) {
      return const SizedBox.shrink();
    }
    final delta = _balanceDelta;
    final color = delta > 0
        ? AppColors.positive
        : delta < 0
            ? AppColors.negative
            : AppColors.textSecondary;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: _buildImpactContent(context),
    );
  }

  Widget _buildImpactContent(BuildContext context) {
    final old = widget.initialDebt;
    // Debts from setup have no cycle: they never touched the balance
    final isPastCycle = old != null &&
        _activeCycleId != null &&
        old.cycleId != null &&
        old.cycleId != _activeCycleId;
    return BalanceImpactView(
      delta: _balanceDelta,
      currentBalance: _currentBalance,
      notice: isPastCycle ? context.l10n.debtImpactPastCycle : null,
      hint: old != null && !old.isSpent && _isSpent
          ? context.l10n.debtSpentDoubleCountHint
          : null,
    );
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
                          final parsed = int.tryParse(value);
                          if (parsed == null) {
                            return context.l10n.enterNumber;
                          }
                          final paid = widget.initialDebt?.paidAmount ?? 0;
                          if (parsed < paid) {
                            return context.l10n.debtAmountBelowPaid(
                              paid.toDZDString(
                                  symbol: context.l10n.currencySymbol),
                            );
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
                      _buildImpactPreview(context),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isEdit && _isUnaffordable
                              ? null
                              : () => _submit(context, cubit),
                          child: Text(
                            _isEdit
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
