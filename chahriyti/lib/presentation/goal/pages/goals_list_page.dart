import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/injection.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../cubits/goal_cubit.dart';
import '../cubits/goal_state.dart';
import '../widgets/goal_card.dart';

class GoalsListPage extends StatelessWidget {
  const GoalsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GoalCubit(
        Injection.createGoalUseCase,
        Injection.getGoalsUseCase,
        Injection.updateGoalUseCase,
        Injection.deleteGoalUseCase,
        withdrawSavingsUseCase: Injection.withdrawSavingsUseCase,
        goalRepository: Injection.goalRepository,
        notificationService: Injection.notificationService,
      )..loadGoals(),
      child: const _GoalsListView(),
    );
  }
}

class _GoalsListView extends StatefulWidget {
  const _GoalsListView();

  @override
  State<_GoalsListView> createState() => _GoalsListViewState();
}

class _GoalsListViewState extends State<_GoalsListView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int _savingsBalance = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
    _loadSavingsBalance();
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    final cubit = context.read<GoalCubit>();
    if (_tabController.index == 0) {
      cubit.loadGoals();
    } else {
      cubit.loadCompletedGoals();
    }
  }

  Future<void> _loadSavingsBalance() async {
    final balance = await Injection.getSavingsBalanceUseCase();
    if (mounted) {
      setState(() => _savingsBalance = balance);
    }
  }

  Future<void> _navigateAndRefresh(String path, {Object? extra}) async {
    await context.push(path, extra: extra);
    if (mounted) {
      _loadSavingsBalance();
      final cubit = context.read<GoalCubit>();
      if (_tabController.index == 0) {
        cubit.loadGoals();
      } else {
        cubit.loadCompletedGoals();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'الأهداف المالية',
          style: AppTypography.headlineSmall,
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'نشطة'),
            Tab(text: 'مكتملة'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateAndRefresh('/goal/add'),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'هدف جديد',
          style: AppTypography.labelLarge.copyWith(color: Colors.white),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _GoalTabContent(
            savingsBalance: _savingsBalance,
            onNavigate: _navigateAndRefresh,
          ),
          _GoalTabContent(
            savingsBalance: _savingsBalance,
            onNavigate: _navigateAndRefresh,
          ),
        ],
      ),
    );
  }
}

class _GoalTabContent extends StatelessWidget {
  final int savingsBalance;
  final Future<void> Function(String path, {Object? extra}) onNavigate;

  const _GoalTabContent({
    required this.savingsBalance,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoalCubit, GoalState>(
      builder: (context, state) {
        return state.when(
          initial: () => const SizedBox.shrink(),
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          goalsLoaded: (goals, hasMore, offset, isCompletedTab) {
            if (goals.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.flag_rounded,
                        size: 64,
                        color: AppColors.primary.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        isCompletedTab
                            ? 'لا توجد أهداف مكتملة'
                            : 'لا توجد أهداف بعد',
                        style: AppTypography.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isCompletedTab
                            ? 'ستظهر هنا الأهداف التي تم شراؤها'
                            : 'ابدأ برحلتك المالية بإنشاء هدف جديد',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            return NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is ScrollEndNotification &&
                    notification.metrics.extentAfter < 200 &&
                    hasMore) {
                  context.read<GoalCubit>().loadMore();
                }
                return false;
              },
              child: RefreshIndicator(
                onRefresh: () async {
                  final cubit = context.read<GoalCubit>();
                  if (isCompletedTab) {
                    cubit.loadCompletedGoals();
                  } else {
                    cubit.loadGoals();
                  }
                  await Future.delayed(const Duration(milliseconds: 500));
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: goals.length + (hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == goals.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    }
                    final goal = goals[index];
                    return GoalCard(
                      goal: goal,
                      savingsBalance: savingsBalance,
                      onTap: () => onNavigate('/goal/${goal.id}'),
                    );
                  },
                ),
              ),
            );
          },
          goalLoaded: (_) => const SizedBox.shrink(),
          goalCreated: (_) => const SizedBox.shrink(),
          goalUpdated: () => const SizedBox.shrink(),
          goalDeleted: () => const SizedBox.shrink(),
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
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<GoalCubit>().loadGoals();
                    },
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
