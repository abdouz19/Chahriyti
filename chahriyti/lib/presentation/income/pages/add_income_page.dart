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
import '../../shared/widgets/confirmation_dialog.dart';
import '../cubits/income_cubit.dart';

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
    final controller = TextEditingController(text: income.description);
    final cubit = context.read<IncomeCubit>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text(context.l10n.editIncomeTitle, style: AppTypography.headlineSmall),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: AppTypography.bodyLarge,
          decoration: InputDecoration(
            hintText: context.l10n.incomeSource,
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
            child: Text(ctx.l10n.cancel,
                style:
                    AppTypography.labelMedium.copyWith(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(ctx.l10n.save,
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
      title: context.l10n.deleteIncome,
      message: context.l10n.deleteIncomeConfirm(income.description),
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
                                Icons.account_balance_wallet_rounded,
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
                                Icons.savings_rounded,
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
          income.description,
          style: AppTypography.bodyMedium,
          textDirection: TextDirection.rtl,
        ),
        subtitle: Text(
          income.amount.toDZDString(symbol: context.l10n.currencySymbol),
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
              tooltip: context.l10n.edit,
            ),
            IconButton(
              icon: Icon(Icons.delete_outline,
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
