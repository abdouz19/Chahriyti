import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/injection.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/value_objects/money.dart';
import '../../shared/widgets/money_text.dart';
import '../cubits/lending_cubit.dart';
import '../cubits/lending_state.dart';
import '../widgets/lending_card.dart';

class LendingsListPage extends StatelessWidget {
  const LendingsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LendingCubit(
        Injection.createLendingUseCase,
        Injection.getLendingsUseCase,
        Injection.addLendingCollectionUseCase,
        Injection.deleteLendingUseCase,
        Injection.getSavingsBalanceUseCase,
        Injection.updateLendingUseCase,
      )..loadLendings(),
      child: const _LendingsListView(),
    );
  }
}

class _LendingsListView extends StatefulWidget {
  const _LendingsListView();

  @override
  State<_LendingsListView> createState() => _LendingsListViewState();
}

class _LendingsListViewState extends State<_LendingsListView>
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
    final cubit = context.read<LendingCubit>();
    if (_tabController.index == 0) {
      cubit.loadLendings();
    } else {
      cubit.loadCollectedLendings();
    }
  }

  Future<void> _navigateAndRefresh(String path, {Object? extra}) async {
    await context.push(path, extra: extra);
    if (mounted) {
      final cubit = context.read<LendingCubit>();
      if (_tabController.index == 0) {
        cubit.loadLendings();
      } else {
        cubit.loadCollectedLendings();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'السلف',
          style: AppTypography.headlineSmall,
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'نشطة'),
            Tab(text: 'تم التحصيل'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final cycle = await Injection.cycleRepository.getActiveCycle();
          if (mounted && cycle != null) {
            _navigateAndRefresh('/lending/add', extra: cycle.id);
          }
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'سلفة جديدة',
          style: AppTypography.labelLarge.copyWith(color: Colors.white),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _LendingTabContent(
            onNavigate: _navigateAndRefresh,
          ),
          _LendingTabContent(
            onNavigate: _navigateAndRefresh,
          ),
        ],
      ),
    );
  }
}

class _LendingTabContent extends StatelessWidget {
  final Future<void> Function(String path, {Object? extra}) onNavigate;

  const _LendingTabContent({required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LendingCubit, LendingState>(
      builder: (context, state) {
        return state.when(
          initial: () => const SizedBox.shrink(),
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          lendingsLoaded: (lendings, hasMore, offset, isCollectedTab, totalRemaining) {
            if (lendings.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.handshake_rounded,
                        size: 64,
                        color: AppColors.primary.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        isCollectedTab
                            ? 'لا توجد سلف محصّلة'
                            : 'لا توجد سلف حالياً',
                        style: AppTypography.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isCollectedTab
                            ? 'ستظهر هنا السلف التي تم تحصيلها بالكامل'
                            : 'تابع سلفك بسهولة وتحكم بتحصيلاتك',
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
                  context.read<LendingCubit>().loadMore();
                }
                return false;
              },
              child: RefreshIndicator(
                onRefresh: () async {
                  final cubit = context.read<LendingCubit>();
                  if (isCollectedTab) {
                    cubit.loadCollectedLendings();
                  } else {
                    cubit.loadLendings();
                  }
                  await Future.delayed(const Duration(milliseconds: 500));
                },
                child: CustomScrollView(
                  slivers: [
                    if (!isCollectedTab && totalRemaining > 0)
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
                                'إجمالي السلف المتبقية',
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
                          final lending = lendings[index];
                          return LendingCard(
                            lending: lending,
                            onTap: () =>
                                onNavigate('/lending/${lending.id}'),
                          );
                        },
                        childCount: lendings.length,
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
          lendingLoaded: (_, __) => const SizedBox.shrink(),
          lendingCreated: (_) => const SizedBox.shrink(),
          lendingDeleted: () => const SizedBox.shrink(),
          collectionAdded: () => const SizedBox.shrink(),
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
                      context.read<LendingCubit>().loadLendings();
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
