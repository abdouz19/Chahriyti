import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/value_objects/money.dart';
import '../../shared/widgets/money_text.dart';
import '../cubits/cycle_history_cubit.dart';

class CycleHistoryPage extends StatelessWidget {
  const CycleHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CycleHistoryCubit(
        cycleRepository: Injection.cycleRepository,
        expenseRepository: Injection.expenseRepository,
      )..loadHistory(),
      child: const _CycleHistoryView(),
    );
  }
}

class _CycleHistoryView extends StatelessWidget {
  const _CycleHistoryView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'سجل الدورات',
          style: AppTypography.headlineSmall,
        ),
      ),
      body: BlocBuilder<CycleHistoryCubit, CycleHistoryState>(
        builder: (context, state) {
          if (state is CycleHistoryLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is CycleHistoryError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      size: 48,
                      color: AppColors.negative,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: AppTypography.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<CycleHistoryCubit>().loadHistory(),
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is CycleHistoryLoaded) {
            if (state.cycles.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.history_rounded,
                        size: 64,
                        color: AppColors.textSecondary.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'لا توجد دورات سابقة',
                        style: AppTypography.bodyLarge.copyWith(
                          color: AppColors.textSecondary,
                        ),
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
                    state.hasMore) {
                  context.read<CycleHistoryCubit>().loadMore();
                }
                return false;
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.cycles.length + (state.hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == state.cycles.length) {
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
                  return _CycleCard(cycle: state.cycles[index]);
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _CycleCard extends StatelessWidget {
  final CycleWithStats cycle;

  const _CycleCard({required this.cycle});

  String _formatDateRange(DateTime start, DateTime end) {
    final arabicMonths = [
      'جانفي',
      'فيفري',
      'مارس',
      'أفريل',
      'ماي',
      'جوان',
      'جويلية',
      'أوت',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر'
    ];

    final startMonth = arabicMonths[start.month - 1];
    final endMonth = arabicMonths[end.month - 1];

    if (start.month == end.month) {
      return '${start.day} - ${end.day} $startMonth ${start.year}';
    }

    return '${start.day} $startMonth - ${end.day} $endMonth ${end.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isPositive = cycle.balance >= 0;

    return Card(
      color: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: isPositive
              ? AppColors.positive.withValues(alpha: 0.3)
              : AppColors.negative.withValues(alpha: 0.3),
        ),
      ),
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date range
            Text(
              _formatDateRange(cycle.cycle.startDate, cycle.cycle.endDate),
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),

            // Salary
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'الراتب',
                  style: AppTypography.bodyMedium,
                ),
                MoneyText(
                  amount: Money(cycle.cycle.salaryAmount),
                  style: AppTypography.labelMedium,
                  color: AppColors.primary,
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Total expenses
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'إجمالي المصاريف',
                  style: AppTypography.bodyMedium,
                ),
                MoneyText(
                  amount: Money(cycle.totalExpenses),
                  style: AppTypography.labelMedium,
                  color: AppColors.negative,
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Balance
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isPositive
                    ? AppColors.positive.withValues(alpha: 0.08)
                    : AppColors.negative.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'الرصيد النهائي',
                    style: AppTypography.labelMedium,
                  ),
                  MoneyText(
                    amount: Money(cycle.balance),
                    style: AppTypography.amountSmall.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    color: isPositive ? AppColors.positive : AppColors.negative,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
