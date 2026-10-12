import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/extensions/l10n_extension.dart';
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
import '../../shared/widgets/feature_tour.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardCubit(
        getDashboardData: Injection.getDashboardDataUseCase,
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
  final _scroll = ScrollController();
  bool _tourChecked = false;

  // Guided tour targets
  final _balanceKey = GlobalKey();
  final _expensesKey = GlobalKey();
  final _incomeKey = GlobalKey();
  final _addExpenseKey = GlobalKey();
  final _goalsKey = GlobalKey();
  final _debtsKey = GlobalKey();
  final _lendingsKey = GlobalKey();
  final _statsKey = GlobalKey();
  final _settingsKey = GlobalKey();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  /// Once, after setup and the tour: explain the reminders, then let the
  /// system ask. Asking at first launch gets refused far more often.
  Future<void> _maybeAskNotifications() async {
    final notifications = Injection.notificationService;
    if (await notifications.hasAskedPermission() || !mounted) return;
    await notifications.markPermissionAsked();
    // Already allowed (e.g. by an earlier version): nothing to ask
    if (await notifications.isPermissionGranted()) return;
    if (!mounted) return;
    final enable = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const _NotificationsExplainer(),
    );
    if (enable == true) {
      await notifications.requestPermissionsAndShowWelcome();
    }
  }

  /// First dashboard visit: walk the user through the main features.
  Future<void> _maybeStartTour() async {
    if (_tourChecked) return;
    _tourChecked = true;
    if (await FeatureTour.hasSeen()) {
      _maybeAskNotifications();
      return;
    }
    if (!mounted) return;
    // Let the dashboard lay out first
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    final l = context.l10n;
    FeatureTour.show(
      context,
      scrollController: _scroll,
      onClosed: _maybeAskNotifications,
      steps: [
        TourStep(target: _balanceKey, icon: Icons.account_balance_wallet_rounded,
            title: l.tourBalanceTitle, body: l.tourBalanceBody),
        TourStep(target: _expensesKey, icon: Icons.trending_up_rounded,
            title: l.tourSpendingTitle, body: l.tourSpendingBody),
        TourStep(target: _incomeKey, icon: Icons.add_card_rounded,
            title: l.tourIncomeTitle, body: l.tourIncomeBody, atTop: true),
        TourStep(target: _addExpenseKey, icon: Icons.add_rounded,
            title: l.tourAddExpenseTitle, body: l.tourAddExpenseBody),
        TourStep(target: _goalsKey, icon: Icons.flag_rounded,
            title: l.tourGoalsTitle, body: l.tourGoalsBody),
        TourStep(target: _debtsKey, icon: Icons.paid_rounded,
            title: l.tourDebtsTitle, body: l.tourDebtsBody),
        TourStep(target: _lendingsKey, icon: Icons.handshake_rounded,
            title: l.tourLendingsTitle, body: l.tourLendingsBody),
        TourStep(target: _statsKey, icon: Icons.bar_chart_rounded,
            title: l.tourStatsTitle, body: l.tourStatsBody),
        TourStep(target: _settingsKey, icon: Icons.savings_rounded,
            title: l.tourSavingsTitle, body: l.tourSavingsBody, atTop: true),
        TourStep(target: _settingsKey, icon: Icons.calendar_month_rounded,
            title: l.tourCyclesTitle, body: l.tourCyclesBody, atTop: true),
        TourStep(target: _settingsKey, icon: Icons.fingerprint_rounded,
            title: l.tourLockTitle, body: l.tourLockBody, atTop: true),
      ],
    );
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
      title: context.l10n.deleteExpense,
      message: context.l10n.deleteExpenseConfirm,
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
              return _buildLoading(context);
            }
            if (state is DashboardError) {
              return _buildError(context, state.message);
            }
            if (state is DashboardLoaded) {
              WidgetsBinding.instance
                  .addPostFrameCallback((_) => _maybeStartTour());
              return _buildLoaded(context, state);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildLoading(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _buildAppBar(context, showActions: false),
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
        _buildAppBar(context, showActions: false),
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
                    label: Text(context.l10n.retry),
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

  SliverAppBar _buildAppBar(BuildContext context, {bool showActions = true}) {
    return SliverAppBar(
      floating: true,
      snap: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: AppColors.background,
      title: Text(
        context.l10n.appName,
        style: AppTypography.headlineMedium,
      ),
      centerTitle: true,
      actions: showActions
          ? [
              IconButton(
                key: _incomeKey,
                onPressed: () => _navigateAndRefresh(context, '/income/add'),
                icon: Icon(
                  Icons.add_card_rounded,
                  color: AppColors.primary,
                ),
                tooltip: context.l10n.addIncomeTooltip,
              ),
              IconButton(
                key: _settingsKey,
                onPressed: () => _navigateAndRefresh(context, '/settings'),
                icon: Icon(
                  Icons.settings_rounded,
                  color: AppColors.textSecondary,
                ),
                tooltip: context.l10n.settingsTitle,
              ),
            ]
          : null,
    );
  }

  Widget _buildLoaded(BuildContext context, DashboardLoaded state) {
    final data = state.data;

    return CustomScrollView(
      controller: _scroll,
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
                        key: _balanceKey,
                        child: BalanceCard(
                          amount: data.currentBalance,
                          cycleTotal: data.totalIn,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        key: _expensesKey,
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
                              label: context.l10n.debtsLabel,
                              amount: state.activeDebts.fold(0, (sum, d) => sum + d.remainingAmount),
                              icon: Icons.paid_rounded,
                              color: AppColors.warning,
                              subtitleLabel: context.l10n.debtPaymentsThisCycle,
                              subtitleAmount: data.totalDebtPayments > 0 ? data.totalDebtPayments : null,
                              savingsSubtitleLabel: context.l10n.fromSavingsThisCycle,
                              savingsSubtitleAmount: data.totalDebtPaymentsFromSavings,
                            ),
                          ),
                        if ((state.activeDebts.isNotEmpty || data.totalDebtPayments > 0) && (state.activeLendings.isNotEmpty || data.totalLendingsFromBalance > 0))
                          const SizedBox(width: 12),
                        if (state.activeLendings.isNotEmpty || data.totalLendingsFromBalance > 0)
                          Expanded(
                            child: _CycleAmountCard(
                              label: context.l10n.lendingsLabel,
                              amount: state.activeLendings.fold(0, (sum, l) => sum + l.remainingAmount),
                              icon: Icons.handshake_rounded,
                              color: AppColors.primary,
                              subtitleLabel: context.l10n.lendingsThisCycle,
                              subtitleAmount: data.totalLendingsFromBalance > 0 ? data.totalLendingsFromBalance : null,
                              savingsSubtitleLabel: context.l10n.fromSavingsThisCycle,
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
                  key: _addExpenseKey,
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
                      context.l10n.recordExpense,
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
                  key: _goalsKey,
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
                                  context.l10n.financialGoals,
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
                            context.l10n.noGoalsYet,
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
                  key: _debtsKey,
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
                                  context.l10n.debtsLabel,
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
                            context.l10n.noDebtsNow,
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
                  key: _lendingsKey,
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
                                  context.l10n.lendingsLabel,
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
                            context.l10n.noLendingsNow,
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
                  key: _statsKey,
                  onPressed: () => context.push('/statistics'),
                  icon: Icon(
                    Icons.bar_chart_rounded,
                    color: AppColors.primary,
                  ),
                  label: Text(
                    context.l10n.statisticsTitle,
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
              amount.toDZDString(symbol: context.l10n.currencySymbol),
              style: AppTypography.amountLarge.copyWith(color: color),
            ),
            if (subtitleLabel != null && subtitleAmount != null) ...[
              const SizedBox(height: 6),
              Text(
                '$subtitleLabel: ${subtitleAmount!.toDZDString(symbol: context.l10n.currencySymbol)}',
                style: AppTypography.bodySmall.copyWith(
                  color: color.withValues(alpha: 0.65),
                ),
              ),
            ],
            if (savingsSubtitleLabel != null && savingsSubtitleAmount != null && savingsSubtitleAmount! > 0) ...[
              const SizedBox(height: 4),
              Text(
                '$savingsSubtitleLabel: ${savingsSubtitleAmount!.toDZDString(symbol: context.l10n.currencySymbol)}',
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

/// Why reminders are worth turning on, shown before the system prompt.
class _NotificationsExplainer extends StatelessWidget {
  const _NotificationsExplainer();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final points = [
      (Icons.payments_rounded, l.notifAskPoint1),
      (Icons.edit_note_rounded, l.notifAskPoint2),
      (Icons.warning_amber_rounded, l.notifAskPoint3),
    ];
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.notifications_active_rounded,
                  size: 34, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            Text(l.notifAskTitle,
                style: AppTypography.headlineSmall, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            for (final p in points)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Icon(p.$1, color: AppColors.primary, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Text(p.$2, style: AppTypography.bodyMedium)),
                  ],
                ),
              ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(l.notifAskEnable),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l.notifAskLater,
                  style: TextStyle(color: AppColors.textSecondary)),
            ),
          ],
        ),
      ),
    );
  }
}
