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
        notificationService: Injection.notificationService,
      )..loadDebts(),
      child: const _DebtsListView(),
    );
  }
}

class _DebtsListView extends StatelessWidget {
  const _DebtsListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'الديون',
          style: AppTypography.headlineSmall,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/debt/add'),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'دين جديد',
          style: AppTypography.labelLarge.copyWith(color: Colors.white),
        ),
      ),
      body: BlocBuilder<DebtCubit, DebtState>(
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
            debtsLoaded: (debts, hasMore, offset) {
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
                          'لا توجد ديون',
                          style: AppTypography.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'تابع ديونك بسهولة وتحكم بسداداتك',
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

              // Calculate total remaining debt
              int totalRemaining = 0;
              for (final debt in debts) {
                final paid = debt.payments.fold<int>(0, (sum, p) => sum + p.amount);
                totalRemaining += debt.totalAmount - paid;
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<DebtCubit>().refresh();
                  await Future.delayed(const Duration(milliseconds: 500));
                },
                child: CustomScrollView(
                  slivers: [
                    // Total remaining debt header
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
                    // Debts list
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final debt = debts[index];
                          return DebtCard(
                            debt: debt,
                            onTap: () => context.push('/debt/${debt.id}'),
                          );
                        },
                        childCount: debts.length,
                      ),
                    ),
                    // Bottom spacing
                    SliverToBoxAdapter(
                      child: const SizedBox(height: 16),
                    ),
                  ],
                ),
              );
            },
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
      ),
    );
  }
}

