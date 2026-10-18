import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../application/use_cases/statistics/get_past_cycles_use_case.dart';
import '../../../core/di/injection.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/extensions/money_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../statistics/widgets/stat_widgets.dart';
import '../cubits/cycle_history_cubit.dart';
import 'past_cycle_detail_page.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../../core/theme/app_icons.dart';

/// Finished monthly cycles, newest first; each opens its own statistics.
class CycleHistoryPage extends StatelessWidget {
  const CycleHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CycleHistoryCubit(
        getPastCycles: GetPastCyclesUseCase(
          cycleRepository: Injection.cycleRepository,
          expenseRepository: Injection.expenseRepository,
          incomeRepository: Injection.incomeRepository,
          savingsRepository: Injection.savingsRepository,
        ),
      )..loadHistory(),
      child: const _CycleHistoryView(),
    );
  }
}

class _CycleHistoryView extends StatelessWidget {
  const _CycleHistoryView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.cycleHistory, style: AppTypography.headlineSmall),
      ),
      body: BlocBuilder<CycleHistoryCubit, CycleHistoryState>(
        builder: (context, state) {
          if (state is CycleHistoryLoading) {
            return const Center(
                child: CircularProgressIndicator(color: AppColors.primary));
          }
          if (state is CycleHistoryError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.message,
                        style: AppTypography.bodyMedium,
                        textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () =>
                          context.read<CycleHistoryCubit>().loadHistory(),
                      child: Text(l10n.retry),
                    ),
                  ],
                ),
              ),
            );
          }
          if (state is! CycleHistoryLoaded) return const SizedBox.shrink();
          if (state.cycles.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(IconsaxPlusBold.clock,
                        size: 56, color: AppColors.textSecondary),
                    const SizedBox(height: 12),
                    Text(l10n.noPreviousCycles,
                        style: AppTypography.labelLarge),
                    const SizedBox(height: 4),
                    Text(
                      l10n.pastCyclesEmptyHint,
                      style: AppTypography.bodySmall
                          .copyWith(color: AppColors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
          return NotificationListener<ScrollNotification>(
            onNotification: (n) {
              if (n.metrics.pixels >= n.metrics.maxScrollExtent - 200) {
                context.read<CycleHistoryCubit>().loadMore();
              }
              return false;
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.cycles.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) =>
                  PastCycleCard(summary: state.cycles[i]),
            ),
          );
        },
      ),
    );
  }
}

/// "October 2026" style title for a cycle (by the month it started in).
String pastCycleTitle(BuildContext context, DateTime start) {
  final locale = Localizations.localeOf(context).languageCode;
  return DateFormat('MMMM y', locale).format(start);
}

String pastCycleRange(BuildContext context, DateTime start, DateTime end) {
  final locale = Localizations.localeOf(context).languageCode;
  final f = DateFormat('d MMM', locale);
  return '${f.format(start)} – ${f.format(end)}';
}

class PastCycleCard extends StatelessWidget {
  final PastCycleSummary summary;

  const PastCycleCard({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final symbol = l10n.currencySymbol;
    final cycle = summary.cycle;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => PastCycleDetailPage(summary: summary),
        )),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: statCardDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(pastCycleTitle(context, cycle.startDate),
                            style: AppTypography.labelLarge.copyWith(
                                fontSize: 16, fontWeight: FontWeight.w800)),
                        Text(
                          pastCycleRange(
                              context, cycle.startDate, cycle.endDate),
                          style: AppTypography.labelSmall,
                        ),
                      ],
                    ),
                  ),
                  const Icon(AppIcons.forwardChevron,
                      color: AppColors.textSecondary),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(height: 1, color: AppColors.divider),
              ),
              IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      child: _Figure(
                          label: l10n.pastCycleIncome,
                          value: summary.income.toDZDString(symbol: symbol)),
                    ),
                    const VerticalDivider(width: 16, color: AppColors.divider),
                    Expanded(
                      child: _Figure(
                        label: l10n.pastCycleSpent,
                        value: summary.spending.toDZDString(symbol: symbol),
                        color: AppColors.negative,
                      ),
                    ),
                    const VerticalDivider(width: 16, color: AppColors.divider),
                    Expanded(
                      child: _Figure(
                        label: l10n.pastCycleSaved,
                        value: summary.saved.toDZDString(symbol: symbol),
                        color: AppColors.positive,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Figure extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _Figure({required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.labelSmall),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            value,
            style: AppTypography.amountSmall.copyWith(
                color: color ?? AppColors.textPrimary, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
