import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/injection.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/value_objects/money.dart';
import '../../shared/widgets/money_text.dart';
import '../cubits/debt_cubit.dart';
import '../cubits/debt_state.dart';
import '../widgets/debt_card.dart';

class DebtsListPage extends StatelessWidget {
  const DebtsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DebtCubit(
        Injection.createDebtUseCase,
        Injection.getDebtsUseCase,
        Injection.updateDebtUseCase,
        Injection.deleteDebtUseCase,
        Injection.addPaymentUseCase,
        Injection.getSavingsBalanceUseCase,
        notificationService: Injection.notificationService,
      )..loadDebts(),
      child: const _DebtsListView(),
    );
  }
}

class _DebtsListView extends StatefulWidget {
  const _DebtsListView();

  @override
  State<_DebtsListView> createState() => _DebtsListViewState();
}

class _DebtsListViewState extends State<_DebtsListView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    final cubit = context.read<DebtCubit>();
    if (_tabController.index == 0) {
      cubit.loadDebts();
    } else {
      cubit.loadCompletedDebts();
    }
  }

  Future<void> _navigateAndRefresh(String path, {Object? extra}) async {
    await context.push(path, extra: extra);
    if (mounted) {
      final cubit = context.read<DebtCubit>();
      if (_tabController.index == 0) {
        cubit.loadDebts();
      } else {
        cubit.loadCompletedDebts();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'الديون',
          style: AppTypography.headlineSmall,
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'نشطة'),
            Tab(text: 'مسددة'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateAndRefresh('/debt/add'),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'دين جديد',
          style: AppTypography.labelLarge.copyWith(color: Colors.white),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _DebtTabContent(onNavigate: _navigateAndRefresh),
          _DebtTabContent(onNavigate: _navigateAndRefresh),
        ],
      ),
    );
  }
}

class _DebtTabContent extends StatelessWidget {
  final Future<void> Function(String path, {Object? extra}) onNavigate;

  const _DebtTabContent({required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DebtCubit, DebtState>(
      builder: (context, state) {
        return state.when(
          initial: () => const SizedBox.shrink(),
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          debtsLoaded: (debts, hasMore, offset, isCompletedTab, totalRemaining) {
            if (debts.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.paid_rounded,
                        size: 64,
                        color: AppColors.primary.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        isCompletedTab
                            ? 'لا توجد ديون مسددة'
                            : 'لا توجد ديون حالياً',
                        style: AppTypography.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isCompletedTab
                            ? 'ستظهر هنا الديون التي تم سدادها بالكامل'
                            : 'تابع ديونك بسهولة وتحكم بسداداتك',
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
                  context.read<DebtCubit>().loadMore();
                }
                return false;
              },
              child: RefreshIndicator(
                onRefresh: () async {
                  final cubit = context.read<DebtCubit>();
                  if (isCompletedTab) {
                    cubit.loadCompletedDebts();
                  } else {
                    cubit.loadDebts();
                  }
                  await Future.delayed(const Duration(milliseconds: 500));
                },
                child: CustomScrollView(
                  slivers: [
                    if (!isCompletedTab && totalRemaining > 0)
                      SliverToBoxAdapter(
                        child: Container(
                          margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'إجمالي الديون المتبقية',
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              MoneyText(
                                amount: Money(totalRemaining),
                                style: AppTypography.headlineSmall,
                                color: AppColors.primary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final debt = debts[index];
                          return DebtCard(
                            debt: debt,
                            onTap: () => onNavigate('/debt/${debt.id}'),
                          );
                        },
                        childCount: debts.length,
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
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 80),
                    ),
                  ],
                ),
              ),
            );
          },
          debtLoaded: (_) => const SizedBox.shrink(),
          debtCreated: (_) => const SizedBox.shrink(),
          debtUpdated: () => const SizedBox.shrink(),
          debtDeleted: () => const SizedBox.shrink(),
          paymentAdded: () => const SizedBox.shrink(),
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
                      context.read<DebtCubit>().loadDebts();
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
