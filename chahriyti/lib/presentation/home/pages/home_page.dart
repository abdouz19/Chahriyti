import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../application/use_cases/dashboard/get_dashboard_data_use_case.dart';
import '../../../core/di/injection.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../shared/widgets/loading_shimmer.dart';
import '../cubits/dashboard_cubit.dart';
import '../widgets/balance_card.dart';
import '../widgets/consumption_bar.dart';
import '../widgets/daily_average_widget.dart';
import '../widgets/days_remaining_widget.dart';
import '../widgets/debt_summary_card.dart';
import '../widgets/expenses_card.dart';
import '../widgets/lending_summary_card.dart';
import '../widgets/goal_progress_card.dart';
import '../widgets/recent_expenses_list.dart';
import '../widgets/safe_balance_card.dart';
import '../../../core/extensions/money_extensions.dart';
import '../../../domain/entities/expense_entity.dart';
import '../../expense/cubits/expense_cubit.dart';
import '../../shared/widgets/confirmation_dialog.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardCubit(
        getDashboardData: GetDashboardDataUseCase(
          cycleRepository: Injection.cycleRepository,
          expenseRepository: Injection.expenseRepository,
          incomeRepository: Injection.incomeRepository,
          debtRepository: Injection.debtRepository,
          lendingRepository: Injection.lendingRepository,
        ),
        cycleRepository: Injection.cycleRepository,
        expenseRepository: Injection.expenseRepository,
        debtRepository: Injection.debtRepository,
        goalRepository: Injection.goalRepository,
        lendingRepository: Injection.lendingRepository,
        savingsRepository: Injection.savingsRepository,
        notificationService: Injection.notificationService,
      )..loadDashboard(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _navigateAndRefresh(
    BuildContext context,
    String path, {
    Object? extra,
  }) async {
    await context.push(path, extra: extra);
    if (context.mounted) {
      context.read<DashboardCubit>().refresh();
    }
  }

  Future<void> _editExpense(
      BuildContext context, ExpenseEntity expense) async {
    await context.push('/expense/edit', extra: expense);
    if (context.mounted) {
      context.read<DashboardCubit>().refresh();
    }
  }

  Future<void> _deleteExpense(
      BuildContext context, ExpenseEntity expense) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'حذف المصروف',
      message: 'هل تريد حذف هذا المصروف؟',
      confirmColor: AppColors.negative,
    );
    if (!confirmed || !context.mounted) return;

    final error = await HomeExpenseActions.deleteExpense(
      expenseId: expense.id,
      cycleId: expense.cycleId,
    );

    if (!context.mounted) return;

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(error), backgroundColor: AppColors.negative),
      );
    } else {
      context.read<DashboardCubit>().refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<DashboardCubit>().loadDashboard();
          // Wait for the state to change
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoading) {
              return _buildLoading();
            }
            if (state is DashboardError) {
              return _buildError(context, state.message);
            }
            if (state is DashboardLoaded) {
              return _buildLoaded(context, state);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return CustomScrollView(
      slivers: [
        _buildAppBar(null),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: const [
                ShimmerCard(),
                SizedBox(height: 12),
                ShimmerCard(),
                SizedBox(height: 12),
                ShimmerCard(),
                SizedBox(height: 12),
                ShimmerCard(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return CustomScrollView(
      slivers: [
        _buildAppBar(null),
        SliverFillRemaining(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 64,
                    color: AppColors.negative,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    message,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<DashboardCubit>().loadDashboard();
                    },
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('إعادة المحاولة'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  SliverAppBar _buildAppBar(BuildContext? context) {
    return SliverAppBar(
      floating: true,
      snap: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: AppColors.background,
      title: Text(
        'شهريتي',
        style: AppTypography.headlineMedium,
      ),
      centerTitle: true,
      actions: context != null
          ? [
              IconButton(
                onPressed: () => _navigateAndRefresh(context, '/income/add'),
                icon: Icon(
                  Icons.add_card_rounded,
                  color: AppColors.primary,
                ),
                tooltip: 'إضافة مدخول',
              ),
              IconButton(
                onPressed: () => _navigateAndRefresh(context, '/settings'),
                icon: Icon(
                  Icons.settings_rounded,
                  color: AppColors.textSecondary,
                ),
                tooltip: 'الإعدادات',
              ),
            ]
          : null,
    );
  }

  Widget _buildLoaded(BuildContext context, DashboardLoaded state) {
    final data = state.data;

    return CustomScrollView(
      slivers: [
        _buildAppBar(context),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Balance + Expenses row
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: BalanceCard(
                          amount: data.currentBalance,
                          cycleTotal: data.totalIn,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ExpensesCard(
                          expenses: data.totalExpenses,
                          savingsAmount: data.totalExpensesFromSavings,
                        ),
                      ),
                    ],
                  ),
                ),

                // Debt + Lending cards row (only when amounts exist)
                if (state.activeDebts.isNotEmpty || data.totalDebtPayments > 0 || state.activeLendings.isNotEmpty || data.totalLendingsFromBalance > 0) ...[
                  const SizedBox(height: 12),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (state.activeDebts.isNotEmpty || data.totalDebtPayments > 0)
                          Expanded(
                            child: _CycleAmountCard(
                              label: 'الديون',
                              amount: state.activeDebts.fold(0, (sum, d) => sum + d.remainingAmount),
                              icon: Icons.paid_rounded,
                              color: AppColors.warning,
                              subtitleLabel: 'مدفوعات هذه الدورة',
                              subtitleAmount: data.totalDebtPayments > 0 ? data.totalDebtPayments : null,
                              savingsSubtitleLabel: 'من المدخرات هذه الدورة',
                              savingsSubtitleAmount: data.totalDebtPaymentsFromSavings,
                            ),
                          ),
                        if ((state.activeDebts.isNotEmpty || data.totalDebtPayments > 0) && (state.activeLendings.isNotEmpty || data.totalLendingsFromBalance > 0))
                          const SizedBox(width: 12),
                        if (state.activeLendings.isNotEmpty || data.totalLendingsFromBalance > 0)
                          Expanded(
                            child: _CycleAmountCard(
                              label: 'السلف',
                              amount: state.activeLendings.fold(0, (sum, l) => sum + l.remainingAmount),
                              icon: Icons.handshake_rounded,
                              color: AppColors.primary,
                              subtitleLabel: 'سلف هذه الدورة',
                              subtitleAmount: data.totalLendingsFromBalance > 0 ? data.totalLendingsFromBalance : null,
                              savingsSubtitleLabel: 'من المدخرات هذه الدورة',
                              savingsSubtitleAmount: data.totalLendingsFromSavings,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 12),

                // Add expense button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final cycle =
                          await Injection.cycleRepository.getActiveCycle();
                      if (context.mounted && cycle != null) {
                        _navigateAndRefresh(
                          context,
                          '/expense/add',
                          extra: cycle.id,
                        );
                      }
                    },
                    icon: const Icon(Icons.add, size: 24),
                    label: Text(
                      'تسجيل مصروف',
                      style: AppTypography.labelLarge
                          .copyWith(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.positive,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Consumption bar
                ConsumptionBar(
                  consumptionPercent: data.consumptionPercent,
                ),
                const SizedBox(height: 12),

                // Days remaining + Daily average row
                Row(
                  children: [
                    Expanded(
                      child: DaysRemainingWidget(
                        daysRemaining: data.daysRemaining,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DailyAverageWidget(
                        dailyAverage: data.dailyAverage,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Safe balance card
                SafeBalanceCard(safeDaily: data.safeDaily),
                const SizedBox(height: 12),

                // Goals section
                GestureDetector(
                  onTap: () => _navigateAndRefresh(context, '/goals'),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.flag_rounded,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'الأهداف المالية',
                                  style: AppTypography.labelLarge,
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: AppColors.textSecondary,
                              size: 18,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (state.activeGoals.isEmpty)
                          Text(
                            'لم تضع أهدافاً بعد',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          )
                        else
                          GoalProgressCard(
                            goals: state.activeGoals,
                            savingsBalance: state.savingsBalance,
                            onViewAll: () => _navigateAndRefresh(context, '/goals'),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Debts section
                GestureDetector(
                  onTap: () => _navigateAndRefresh(context, '/debts'),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.paid_rounded,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'الديون',
                                  style: AppTypography.labelLarge,
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: AppColors.textSecondary,
                              size: 18,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (state.activeDebts.isEmpty)
                          Text(
                            'لا توجد ديون حالياً',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.positive,
                            ),
                          )
                        else
                          DebtSummaryCard(
                            debts: state.activeDebts,
                            onViewAll: () => _navigateAndRefresh(context, '/debts'),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Lendings section
                GestureDetector(
                  onTap: () => _navigateAndRefresh(context, '/lendings'),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.handshake_rounded,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'السلف',
                                  style: AppTypography.labelLarge,
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: AppColors.textSecondary,
                              size: 18,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (state.activeLendings.isEmpty)
                          Text(
                            'لا توجد سلف حالياً',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.positive,
                            ),
                          )
                        else
                          LendingSummaryCard(
                            lendings: state.activeLendings,
                            onViewAll: () => _navigateAndRefresh(context, '/lendings'),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Recent expenses
                RecentExpensesList(
                  expenses: state.recentExpenses,
                  onEditExpense: (expense) => _editExpense(context, expense),
                  onDeleteExpense: (expense) =>
                      _deleteExpense(context, expense),
                ),
                const SizedBox(height: 16),

                // Quick actions row
                OutlinedButton.icon(
                  onPressed: () => context.push('/statistics'),
                  icon: Icon(
                    Icons.bar_chart_rounded,
                    color: AppColors.primary,
                  ),
                  label: Text(
                    'الإحصائيات',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CycleAmountCard extends StatelessWidget {
  final String label;
  final int amount;
  final IconData icon;
  final Color color;
  final String? subtitleLabel;
  final int? subtitleAmount;
  final String? savingsSubtitleLabel;
  final int? savingsSubtitleAmount;

  const _CycleAmountCard({
    required this.label,
    required this.amount,
    required this.icon,
    required this.color,
    this.subtitleLabel,
    this.subtitleAmount,
    this.savingsSubtitleLabel,
    this.savingsSubtitleAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: color.withValues(alpha: 0.3)),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 18),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: AppTypography.labelSmall.copyWith(color: color),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              amount.toDZDString(),
              style: AppTypography.amountLarge.copyWith(color: color),
            ),
            if (subtitleLabel != null && subtitleAmount != null) ...[
              const SizedBox(height: 6),
              Text(
                '$subtitleLabel: ${subtitleAmount!.toDZDString()}',
                style: AppTypography.bodySmall.copyWith(
                  color: color.withValues(alpha: 0.65),
                ),
              ),
            ],
            if (savingsSubtitleLabel != null && savingsSubtitleAmount != null && savingsSubtitleAmount! > 0) ...[
              const SizedBox(height: 4),
              Text(
                '$savingsSubtitleLabel: ${savingsSubtitleAmount!.toDZDString()}',
                style: AppTypography.bodySmall.copyWith(
                  color: color.withValues(alpha: 0.65),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
