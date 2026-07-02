import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/use_cases/dashboard/get_dashboard_data_use_case.dart';
import '../../../core/di/injection.dart';
import '../../../core/extensions/money_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/value_objects/money.dart';
import '../../shared/widgets/money_text.dart';
import '../cubits/savings_cubit.dart';
import '../cubits/savings_state.dart';
import '../widgets/savings_history_item.dart';

class SavingsPage extends StatelessWidget {
  const SavingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SavingsCubit(
        Injection.getSavingsBalanceUseCase,
        Injection.getSavingsHistoryUseCase,
        Injection.depositFromBalanceUseCase,
        Injection.withdrawToBalanceUseCase,
        GetDashboardDataUseCase(
          cycleRepository: Injection.cycleRepository,
          expenseRepository: Injection.expenseRepository,
          incomeRepository: Injection.incomeRepository,
          debtRepository: Injection.debtRepository,
          lendingRepository: Injection.lendingRepository,
        ),
      )..loadSavings(),
      child: const _SavingsView(),
    );
  }
}

class _SavingsView extends StatelessWidget {
  const _SavingsView();

  Future<void> _showDepositSheet(BuildContext context) async {
    final cubit = context.read<SavingsCubit>();
    final availableBalance = await cubit.fetchAvailableBalance();

    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => _TransferSheet(
        title: 'إيداع في المدخرات',
        subtitle: 'الرصيد المتاح',
        availableAmount: availableBalance,
        confirmLabel: 'تأكيد الإيداع',
        accentColor: AppColors.primary,
        onConfirm: (amount) async {
          Navigator.of(sheetContext).pop();
          final error = await cubit.deposit(amount);
          if (error != null && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(error),
                backgroundColor: AppColors.negative,
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> _showWithdrawSheet(BuildContext context) async {
    final cubit = context.read<SavingsCubit>();
    final currentState = cubit.state;
    final savingsBalance = currentState is SavingsLoaded ? currentState.balance : 0;

    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => _TransferSheet(
        title: 'سحب للرصيد',
        subtitle: 'المدخرات المتاحة',
        availableAmount: savingsBalance,
        confirmLabel: 'تأكيد السحب',
        accentColor: AppColors.positive,
        onConfirm: (amount) async {
          Navigator.of(sheetContext).pop();
          final error = await cubit.withdraw(amount);
          if (error != null && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(error),
                backgroundColor: AppColors.negative,
              ),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'المدخرات',
          style: AppTypography.headlineSmall,
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'savings_withdraw',
            onPressed: () => _showWithdrawSheet(context),
            backgroundColor: AppColors.positive,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.arrow_upward_rounded),
            label: Text(
              'سحب للرصيد',
              style: AppTypography.labelSmall.copyWith(color: Colors.white),
            ),
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: 'savings_deposit',
            onPressed: () => _showDepositSheet(context),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.arrow_downward_rounded),
            label: Text(
              'إيداع من الرصيد',
              style: AppTypography.labelSmall.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
      body: BlocBuilder<SavingsCubit, SavingsState>(
        builder: (context, state) {
          return state.when(
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
            loaded: (balance, history, hasMore, offset) {
              return NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollEndNotification &&
                      notification.metrics.extentAfter < 200 &&
                      hasMore) {
                    context.read<SavingsCubit>().loadMore();
                  }
                  return false;
                },
                child: CustomScrollView(
                  slivers: [
                    // Balance card
                    SliverToBoxAdapter(
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'إجمالي المدخرات',
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            MoneyText(
                              amount: Money(balance),
                              style: AppTypography.headlineLarge,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // History header
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Text(
                          'سجل العمليات',
                          style: AppTypography.labelLarge,
                        ),
                      ),
                    ),
                    // History list or empty state
                    if (history.isEmpty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.savings_rounded,
                                  size: 64,
                                  color: AppColors.primary.withValues(alpha: 0.5),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'لا توجد عمليات ادخار بعد',
                                  style: AppTypography.bodyLarge.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'سيتم إضافة المدخرات تلقائياً عند انتهاء الدورة المالية',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    else
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return SavingsHistoryItem(record: history[index]);
                          },
                          childCount: history.length,
                        ),
                      ),
                    if (hasMore)
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      ),
                    // Bottom spacing
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 16),
                    ),
                  ],
                ),
              );
            },
            error: (message) => Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 64,
                      color: AppColors.negative,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      message,
                      style: AppTypography.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<SavingsCubit>().loadSavings();
                      },
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TransferSheet extends StatefulWidget {
  final String title;
  final String subtitle;
  final int availableAmount;
  final String confirmLabel;
  final Color accentColor;
  final Future<void> Function(int amount) onConfirm;

  const _TransferSheet({
    required this.title,
    required this.subtitle,
    required this.availableAmount,
    required this.confirmLabel,
    required this.accentColor,
    required this.onConfirm,
  });

  @override
  State<_TransferSheet> createState() => _TransferSheetState();
}

class _TransferSheetState extends State<_TransferSheet> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final amount = int.tryParse(_controller.text.replaceAll(',', '')) ?? 0;
    setState(() => _loading = true);
    await widget.onConfirm(amount);
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title, style: AppTypography.headlineSmall),
            const SizedBox(height: 4),
            Text(
              '${widget.subtitle}: ${widget.availableAmount.toDZDString()}',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _controller,
              keyboardType: TextInputType.number,
              autofocus: true,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                labelText: 'المبلغ',
                suffixText: 'دج',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: widget.accentColor, width: 2),
                ),
              ),
              validator: (v) {
                final n = int.tryParse((v ?? '').replaceAll(',', ''));
                if (n == null || n <= 0) return 'أدخل مبلغاً صحيحاً';
                if (n > widget.availableAmount) return 'المبلغ يتجاوز المتاح';
                return null;
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _loading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.accentColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(widget.confirmLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
