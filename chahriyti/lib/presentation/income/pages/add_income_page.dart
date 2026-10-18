import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/injection.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/extensions/money_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/additional_income_entity.dart';
import '../../debt/widgets/balance_impact_view.dart';
import '../cubits/income_cubit.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

// Shared options view for income source autocomplete (same style as expense form)
Widget _buildOptionsView(
  BuildContext context,
  AutocompleteOnSelected<String> onSelected,
  Iterable<String> options,
) {
  return Align(
    alignment: AlignmentDirectional.topStart,
    child: Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(12),
      color: AppColors.surface,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 220),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 4),
          shrinkWrap: true,
          itemCount: options.length,
          separatorBuilder: (_, __) => Divider(height: 1, color: AppColors.border),
          itemBuilder: (_, i) {
            final option = options.elementAt(i);
            return InkWell(
              onTap: () => onSelected(option),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Text(option, style: AppTypography.bodyMedium),
              ),
            );
          },
        ),
      ),
    ),
  );
}

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
  final _amountController = TextEditingController();
  bool _toSavings = false;

  List<String> _suggestions = [];
  String _description = '';
  TextEditingController? _descCtrl;

  @override
  void initState() {
    super.initState();
    _loadSuggestions();
  }

  Future<void> _loadSuggestions() async {
    try {
      final results = await Injection.getIncomeSuggestionsUseCase();
      if (mounted) setState(() => _suggestions = results);
    } catch (_) {}
  }

  Iterable<String> _optionsBuilder(TextEditingValue value) {
    if (_suggestions.isEmpty) return const [];
    final q = value.text.trim().toLowerCase();
    if (q.isEmpty) return _suggestions.take(8);
    return _suggestions.where((s) => s.toLowerCase().contains(q));
  }

  @override
  void dispose() {
    _descCtrl?.removeListener(_onDescChanged);
    _amountController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;

    final description = _description.trim();
    final amount = int.tryParse(_amountController.text.trim()) ?? 0;

    context.read<IncomeCubit>().addIncome(
          description: description,
          amount: amount,
          toSavings: _toSavings,
        );
  }

  void _onDescChanged() => _description = _descCtrl?.text ?? '';

  Future<void> _showEditDialog(AdditionalIncomeEntity income) async {
    final cubit = context.read<IncomeCubit>();
    final result = await showDialog<(String, int)>(
      context: context,
      builder: (ctx) => _EditIncomeDialog(
        income: income,
        available: _availableFor(income),
      ),
    );
    if (result != null) {
      cubit.updateIncome(income, result.$1, result.$2);
    }
  }

  Future<void> _showDeleteConfirmation(AdditionalIncomeEntity income) async {
    final cubit = context.read<IncomeCubit>();
    final available = await _availableFor(income);
    if (!mounted) return;
    final blocked = available - income.amount < 0;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(ctx.l10n.deleteIncome),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(ctx.l10n.deleteIncomeConfirm(_incomeName(ctx, income))),
            const SizedBox(height: 12),
            BalanceImpactView(
              delta: -income.amount,
              currentBalance: available,
              isSavings: income.toSavings,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(ctx.l10n.cancel),
          ),
          ElevatedButton(
            onPressed: blocked ? null : () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.negative,
              foregroundColor: Colors.white,
            ),
            child: Text(ctx.l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      cubit.deleteIncome(income);
    }
  }

  /// Money in the place this income went to: savings or the current balance.
  Future<int> _availableFor(AdditionalIncomeEntity income) async =>
      income.toSavings
          ? await Injection.getSavingsBalanceUseCase()
          : (await Injection.getDashboardDataUseCase()).currentBalance;

  @override
  Widget build(BuildContext context) {
    return BlocListener<IncomeCubit, IncomeState>(
      listener: (context, state) {
        if (state is IncomeSaved) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                context.l10n.incomeSaved,
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
                context.l10n.incomeUpdated,
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
                context.l10n.incomeDeleted,
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
            context.l10n.addIncomeTitle,
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

                // Description field with history suggestions
                Autocomplete<String>(
                  optionsBuilder: _optionsBuilder,
                  displayStringForOption: (s) => s,
                  onSelected: (value) => _description = value,
                  optionsViewBuilder: _buildOptionsView,
                  fieldViewBuilder: (ctx, controller, focusNode, onFieldSubmitted) {
                    if (_descCtrl != controller) {
                      _descCtrl?.removeListener(_onDescChanged);
                      _descCtrl = controller;
                      controller.addListener(_onDescChanged);
                    }
                    return TextFormField(
                      controller: controller,
                      focusNode: focusNode,
                      textDirection: TextDirection.rtl,
                      style: AppTypography.bodyLarge,
                      decoration: InputDecoration(
                        hintText: context.l10n.incomeSource,
                        hintStyle: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        prefixIcon: Icon(
                          IconsaxPlusBold.document_text,
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
                      validator: (_) {
                        if (_description.trim().isEmpty) {
                          return context.l10n.incomeSourceRequired;
                        }
                        return null;
                      },
                    );
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
                    hintText: context.l10n.amount,
                    hintStyle: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    suffixText: context.l10n.currencySymbol,
                    suffixStyle: AppTypography.labelMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    prefixIcon: Icon(
                      IconsaxPlusBold.moneys,
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
                      return context.l10n.amountRequired;
                    }
                    final amount = int.tryParse(value.trim());
                    if (amount == null || amount <= 0) {
                      return context.l10n.amountMustBePositive;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Destination toggle
                Text(
                  context.l10n.destination,
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
                                IconsaxPlusBold.wallet,
                                size: 18,
                                color: !_toSavings
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                context.l10n.balanceSummaryLabel,
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
                                IconsaxPlusBold.strongbox,
                                size: 18,
                                color: _toSavings
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                context.l10n.savings,
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
                                context.l10n.save,
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

// ─── Edit Income Dialog ─────────────────────────────────────────────────────

class _EditIncomeDialog extends StatefulWidget {
  final AdditionalIncomeEntity income;
  final Future<int> available;
  const _EditIncomeDialog({required this.income, required this.available});

  @override
  State<_EditIncomeDialog> createState() => _EditIncomeDialogState();
}

class _EditIncomeDialogState extends State<_EditIncomeDialog> {
  late final TextEditingController _descController;
  late final TextEditingController _amountController;
  int? _available;

  @override
  void initState() {
    super.initState();
    _descController = TextEditingController(text: widget.income.description);
    _amountController = TextEditingController(text: widget.income.amount.toString());
    _amountController.addListener(() => setState(() {}));
    widget.available.then((v) {
      if (mounted) setState(() => _available = v);
    });
  }

  int get _delta {
    final amount =
        int.tryParse(_amountController.text.replaceAll(',', '').trim());
    return amount == null ? 0 : amount - widget.income.amount;
  }

  bool get _blocked =>
      _delta < 0 && (_available == null || _available! + _delta < 0);

  @override
  void dispose() {
    _descController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _save() {
    final desc = _descController.text.trim();
    final amount = int.tryParse(_amountController.text.replaceAll(',', '').trim()) ?? 0;
    if (desc.isEmpty || amount <= 0) return;
    Navigator.of(context).pop((desc, amount));
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColors.border),
    );
    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColors.primary, width: 2),
    );
    return AlertDialog(
      backgroundColor: AppColors.card,
      title: Text(context.l10n.editIncomeTitle, style: AppTypography.headlineSmall),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _descController,
            // The setup opening balance keeps its name
            readOnly: widget.income.isInitialBalance,
            autofocus: !widget.income.isInitialBalance,
            style: AppTypography.bodyLarge,
            decoration: InputDecoration(
              hintText: context.l10n.incomeSource,
              hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
              border: border,
              focusedBorder: focusedBorder,
              filled: true,
              fillColor: AppColors.background,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.right,
            style: AppTypography.bodyLarge,
            decoration: InputDecoration(
              hintText: context.l10n.amount,
              hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
              suffixText: context.l10n.currencySymbol,
              border: border,
              focusedBorder: focusedBorder,
              filled: true,
              fillColor: AppColors.background,
            ),
          ),
          if (_delta != 0) ...[
            const SizedBox(height: 12),
            BalanceImpactView(
              delta: _delta,
              currentBalance: _available,
              isSavings: widget.income.toSavings,
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: Text(
            context.l10n.cancel,
            style: AppTypography.labelMedium.copyWith(color: AppColors.textSecondary),
          ),
        ),
        TextButton(
          onPressed: _blocked ? null : _save,
          child: Text(
            context.l10n.save,
            style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
          ),
        ),
      ],
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
          context.l10n.additionalIncomes,
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
          _incomeName(context, income),
          style: AppTypography.bodyMedium,
        ),
        subtitle: Row(
          children: [
            Text(
              income.amount.toDZDString(symbol: context.l10n.currencySymbol),
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.positive,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    income.toSavings
                        ? IconsaxPlusBold.strongbox
                        : IconsaxPlusBold.wallet,
                    size: 12,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    income.toSavings
                        ? context.l10n.incomeToSavingsTag
                        : context.l10n.incomeToBalanceTag,
                    style: AppTypography.labelSmall
                        .copyWith(color: AppColors.primary, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(IconsaxPlusLinear.edit_2,
                  size: 20, color: AppColors.textSecondary),
              onPressed: () => onEdit(income),
              tooltip: context.l10n.edit,
            ),
            IconButton(
              icon: Icon(IconsaxPlusLinear.trash,
                  size: 20, color: AppColors.negative),
              onPressed: () => onDelete(income),
              tooltip: context.l10n.delete,
            ),
          ],
        ),
      ),
    );
  }
}

/// Display name; the setup opening balance is stored in Arabic.
String _incomeName(BuildContext context, AdditionalIncomeEntity income) =>
    income.isInitialBalance ? context.l10n.openingBalance : income.description;
