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
import '../widgets/goal_progress_card.dart';
import '../widgets/recent_expenses_list.dart';
import '../widgets/safe_balance_card.dart';

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
        ),
        cycleRepository: Injection.cycleRepository,
        expenseRepository: Injection.expenseRepository,
        debtRepository: Injection.debtRepository,
        goalRepository: Injection.goalRepository,
      )..loadDashboard(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final cycle = await Injection.cycleRepository.getActiveCycle();
          if (context.mounted && cycle != null) {
            _navigateAndRefresh(context, '/expense/add', extra: cycle.id);
          }
        },
        backgroundColor: AppColors.positive,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'صرف',
          style: AppTypography.labelLarge.copyWith(color: Colors.white),
        ),
      ),
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
                Row(
                  children: [
                    Expanded(
                      child: BalanceCard(amount: data.currentBalance),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ExpensesCard(amount: data.totalExpenses),
                    ),
                  ],
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

                // Goals (if any)
                if (state.activeGoals.isNotEmpty) ...[
                  GoalProgressCard(goals: state.activeGoals),
                  const SizedBox(height: 12),
                ],

                // Debts (if any)
                if (state.activeDebts.isNotEmpty) ...[
                  DebtSummaryCard(debts: state.activeDebts),
                  const SizedBox(height: 12),
                ],

                // Goals summary section
                GestureDetector(
                  onTap: () => context.push('/goals'),
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
                        Text(
                          'لم تضع أهدافاً بعد',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Debts summary section
                GestureDetector(
                  onTap: () => context.push('/debts'),
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
                        Text(
                          'لا توجد ديون حالياً',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.positive,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Recent expenses
                RecentExpensesList(expenses: state.recentExpenses),
                const SizedBox(height: 16),

                // Quick actions row
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
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
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => context.push('/insights'),
                        icon: const Icon(Icons.lightbulb_rounded),
                        label: Text(
                          'الذكاء المالي',
                          style: AppTypography.labelSmall.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Bottom spacing for FAB
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
