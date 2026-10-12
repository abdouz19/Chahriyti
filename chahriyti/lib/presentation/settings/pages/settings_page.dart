import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/injection.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/value_objects/money.dart';
import '../../debt/widgets/balance_impact_view.dart';
import '../../../domain/value_objects/cycle_dates.dart';
import '../../../core/extensions/money_extensions.dart';
import '../../../infrastructure/services/app_lock_service.dart';
import '../../shared/widgets/money_text.dart';
import '../cubits/locale_cubit.dart';
import '../cubits/settings_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsCubit(
        userRepository: Injection.userRepository,
        cycleRepository: Injection.cycleRepository,
        resetAppData: Injection.resetAppDataUseCase,
        getDashboardData: Injection.getDashboardDataUseCase,
        onSalaryDayChanged: Injection.notificationService.rescheduleReminders,
      )..loadSettings(),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.settingsTitle,
          style: AppTypography.headlineSmall,
        ),
      ),
      body: BlocConsumer<SettingsCubit, SettingsState>(
        listener: (context, state) {
          if (state is SettingsDataResetComplete) {
            Injection.notificationService.resetSession();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.l10n.dataClearedSuccess),
                backgroundColor: AppColors.positive,
              ),
            );
            context.go('/financial-setup');
          } else if (state is SettingsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.negative,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is SettingsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is SettingsResetting) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(color: AppColors.primary),
                  const SizedBox(height: 16),
                  Text(context.l10n.resetting),
                ],
              ),
            );
          }

          if (state is SettingsLoaded) {
            return _buildContent(context, state);
          }

          if (state is SettingsError) {
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
                          context.read<SettingsCubit>().loadSettings(),
                      child: Text(context.l10n.retry),
                    ),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, SettingsLoaded state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── User info section ──
          _SectionCard(
            children: [
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      color: AppColors.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.userName,
                          style: AppTypography.headlineSmall,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              state.isActivated
                                  ? Icons.verified_rounded
                                  : Icons.warning_amber_rounded,
                              size: 16,
                              color: state.isActivated
                                  ? AppColors.positive
                                  : AppColors.warning,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              state.isActivated
                                  ? context.l10n.activated
                                  : context.l10n.notActivated,
                              style: AppTypography.bodySmall.copyWith(
                                color: state.isActivated
                                    ? AppColors.positive
                                    : AppColors.warning,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(color: AppColors.divider),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.l10n.monthlySalary,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          MoneyText(
                            amount: Money(state.salary),
                            style: AppTypography.amountSmall,
                            color: AppColors.primary,
                          ),
                          if (state.salaryPending)
                            Text(
                              context.l10n.fromNextCycle,
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 10,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => _onEditSalary(context, state),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.edit_rounded,
                            size: 18,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.l10n.salaryDay,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            context.l10n.dayN(state.salaryDay),
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (state.salaryDayPending)
                            Text(
                              _formatNextCycleDate(context, state.salaryDay),
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 10,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => _onEditSalaryDay(context, state),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.edit_rounded,
                            size: 18,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Goals & Debts section ──
          _SectionCard(
            children: [
              Text(context.l10n.goalsAndDebts, style: AppTypography.labelLarge),
              const SizedBox(height: 8),
              Text(
                context.l10n.goalsAndDebtsDesc,
                style: AppTypography.bodySmall,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: () => context.push('/goals'),
                  icon: const Icon(Icons.flag_rounded),
                  label: Text(context.l10n.viewGoals),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: () => context.push('/debts'),
                  icon: const Icon(Icons.paid_rounded),
                  label: Text(context.l10n.viewDebts),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: () => context.push('/savings'),
                  icon: const Icon(Icons.savings_rounded),
                  label: Text(context.l10n.savings),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Cycle management section ──
          _SectionCard(
            children: [
              Text(context.l10n.manageCycle, style: AppTypography.labelLarge),
              const SizedBox(height: 8),
              Text(
                context.l10n.manageCycleDesc,
                style: AppTypography.bodySmall,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: () => context.push('/cycle-history'),
                  icon: const Icon(Icons.history_rounded),
                  label: Text(context.l10n.cycleHistory),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Language section ──
          _SectionCard(
            children: [
              Text(context.l10n.language, style: AppTypography.labelLarge),
              const SizedBox(height: 12),
              ...['ar', 'fr', 'en'].map((code) {
                final label = code == 'ar'
                    ? context.l10n.languageAr
                    : code == 'fr'
                    ? context.l10n.languageFr
                    : context.l10n.languageEn;
                final isSelected =
                    Localizations.localeOf(context).languageCode == code;
                return ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(label, style: AppTypography.bodyMedium),
                  trailing: isSelected
                      ? const Icon(
                          Icons.check_rounded,
                          color: AppColors.primary,
                          size: 20,
                        )
                      : null,
                  onTap: () async {
                    await context.read<LocaleCubit>().setLocale(Locale(code));
                    // Scheduled reminders carry the language they were made in
                    Injection.notificationService.rescheduleReminders();
                  },
                );
              }),
            ],
          ),
          const SizedBox(height: 20),

          // ── Security ──
          const _SectionCard(children: [_AppLockSettings()]),
          const SizedBox(height: 20),

          // ── Notifications ──
          const _SectionCard(children: [_NotificationsSwitch()]),
          const SizedBox(height: 20),

          // ── Danger zone ──
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.negative.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.negative.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.warning_rounded,
                      color: AppColors.negative,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      context.l10n.dangerZone,
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.negative,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  context.l10n.dangerZoneDesc,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.negative.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () => _onResetAllData(context),
                    icon: const Icon(Icons.delete_forever_rounded),
                    label: Text(context.l10n.clearAllData),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.negative,
                      side: const BorderSide(color: AppColors.negative),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          // ── App version ──
          Center(
            child: Text(
              context.l10n.appVersion,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Future<void> _onResetAllData(BuildContext context) async {
    // First confirmation
    final firstConfirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.warning_rounded, color: AppColors.negative, size: 24),
            const SizedBox(width: 8),
            Text(
              context.l10n.importantWarning,
              style: AppTypography.headlineSmall,
            ),
          ],
        ),
        content: Text(
          context.l10n.resetWarningBody,
          style: AppTypography.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              context.l10n.cancel,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              context.l10n.continueLabel,
              style: TextStyle(color: AppColors.negative),
            ),
          ),
        ],
      ),
    );

    if (firstConfirmed != true || !context.mounted) return;

    // Second confirmation — final gate
    final finalConfirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          context.l10n.areYouSure,
          style: AppTypography.headlineSmall,
        ),
        content: Text(
          context.l10n.cannotBeUndone,
          style: AppTypography.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              context.l10n.noCancel,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.negative,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(context.l10n.yesDeleteEverything),
          ),
        ],
      ),
    );

    if (finalConfirmed == true && context.mounted) {
      context.read<SettingsCubit>().resetAllData();
    }
  }

  Future<void> _onEditSalary(BuildContext context, SettingsLoaded state) async {
    final cubit = context.read<SettingsCubit>();
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _EditSalarySheet(
        initialSalary: state.salary,
        salaryDay: state.salaryDay,
        currentCycleSalary: state.currentCycleSalary,
        loadBalance: cubit.currentBalance,
        onSave: (newSalary, applyNow) {
          cubit.updateSalary(newSalary, applyToCurrentCycle: applyNow);
        },
      ),
    );
  }

  Future<void> _onEditSalaryDay(
    BuildContext context,
    SettingsLoaded state,
  ) async {
    final cubit = context.read<SettingsCubit>();
    int selectedDay = state.salaryDay;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (sheetContext, setState) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sheetContext.l10n.editSalaryDay,
                    style: AppTypography.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    sheetContext.l10n.chooseDayHint,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        Slider(
                          value: selectedDay.toDouble(),
                          min: 1,
                          max: 28,
                          divisions: 27,
                          label: sheetContext.l10n.sliderDayLabel(selectedDay),
                          onChanged: (value) {
                            setState(() {
                              selectedDay = value.toInt();
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                        Text(
                          sheetContext.l10n.selectedDayLabel(selectedDay),
                          style: AppTypography.labelLarge.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _formatNextCycleDate(sheetContext, selectedDay),
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final confirmed = await showDialog<bool>(
                          context: sheetContext,
                          builder: (_) => AlertDialog(
                            title: Text(sheetContext.l10n.confirmEditSalaryDay),
                            content: Text(() {
                              final next = CycleDates.nextSalaryDateAfter(
                                selectedDay,
                                DateTime.now(),
                              );
                              return sheetContext.l10n
                                  .salaryDayChangeConfirmBody(
                                    _formatDate(
                                      sheetContext,
                                      CycleDates.dayBefore(next),
                                    ),
                                    _formatDate(sheetContext, next),
                                  );
                            }()),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(sheetContext, false),
                                child: Text(sheetContext.l10n.cancel),
                              ),
                              ElevatedButton(
                                onPressed: () =>
                                    Navigator.pop(sheetContext, true),
                                child: Text(sheetContext.l10n.confirm),
                              ),
                            ],
                          ),
                        );
                        if (confirmed == true && sheetContext.mounted) {
                          cubit.updateSalaryDay(selectedDay);
                          Navigator.pop(sheetContext);
                        }
                      },
                      child: Text(sheetContext.l10n.save),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(sheetContext),
                      child: Text(sheetContext.l10n.cancel),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final List<Widget> children;

  const _SectionCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

String _formatNextCycleDate(BuildContext context, int salaryDay) {
  final next = CycleDates.nextSalaryDateAfter(salaryDay, DateTime.now());
  return context.l10n.appliesFromDate(
    next.day,
    _monthName(context, next.month),
    next.year,
  );
}

String _monthName(BuildContext context, int month) {
  final l = context.l10n;
  return [
    l.monthJan,
    l.monthFeb,
    l.monthMar,
    l.monthApr,
    l.monthMay,
    l.monthJun,
    l.monthJul,
    l.monthAug,
    l.monthSep,
    l.monthOct,
    l.monthNov,
    l.monthDec,
  ][month - 1];
}

/// "20 أكتوبر 2026"
String _formatDate(BuildContext context, DateTime date) =>
    '${date.day} ${_monthName(context, date.month)} ${date.year}';

class _EditSalarySheet extends StatefulWidget {
  final int initialSalary;
  final int salaryDay;
  final int? currentCycleSalary;
  final Future<int> Function() loadBalance;
  final void Function(int salary, bool applyToCurrentCycle) onSave;

  const _EditSalarySheet({
    required this.initialSalary,
    required this.salaryDay,
    required this.currentCycleSalary,
    required this.loadBalance,
    required this.onSave,
  });

  @override
  State<_EditSalarySheet> createState() => _EditSalarySheetState();
}

class _EditSalarySheetState extends State<_EditSalarySheet> {
  late final TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();
  bool _applyNow = false;
  int? _balance;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialSalary.toString());
    _controller.addListener(() => setState(() {}));
    widget.loadBalance().then((b) {
      if (mounted) setState(() => _balance = b);
    });
  }

  /// Balance change if the new salary also applies to the current cycle.
  int get _delta {
    final cycleSalary = widget.currentCycleSalary;
    final entered = int.tryParse(_controller.text);
    if (!_applyNow || cycleSalary == null || entered == null) return 0;
    return entered - cycleSalary;
  }

  bool get _blocked =>
      _delta < 0 && (_balance == null || _balance! + _delta < 0);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.editMonthlySalary,
                style: AppTypography.headlineSmall,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _controller,
                keyboardType: TextInputType.number,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: context.l10n.enterNewSalary,
                  suffixText: context.l10n.currencySymbol,
                ),
                validator: (v) {
                  if (v == null || v.isEmpty)
                    return context.l10n.salaryRequired;
                  final val = int.tryParse(v);
                  // 0 is valid: not everyone has a fixed salary
                  if (val == null || val < 0) {
                    return context.l10n.salaryMustBePositive;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              if (widget.currentCycleSalary != null)
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _applyNow,
                  onChanged: (v) => setState(() => _applyNow = v),
                  activeThumbColor: AppColors.primary,
                  title: Text(
                    context.l10n.applySalaryToCurrentCycle,
                    style: AppTypography.labelLarge,
                  ),
                  subtitle: Text(
                    context.l10n.applySalaryToCurrentCycleDesc,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              if (_applyNow)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: BalanceImpactView(
                    delta: _delta,
                    currentBalance: _balance,
                  ),
                )
              else
                Row(
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _formatNextCycleDate(context, widget.salaryDay),
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _blocked
                      ? null
                      : () async {
                          if (!_formKey.currentState!.validate()) return;
                          final newSalary = int.parse(_controller.text);
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text(context.l10n.confirmEditSalary),
                              content: Text(
                                _applyNow
                                    ? context.l10n.newSalaryConfirmBodyNow(
                                        newSalary.toDZDString(
                                          symbol: context.l10n.currencySymbol,
                                        ),
                                      )
                                    : context.l10n.newSalaryConfirmBody(
                                        newSalary,
                                      ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: Text(context.l10n.cancel),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: Text(context.l10n.confirm),
                                ),
                              ],
                            ),
                          );
                          if (confirmed == true && context.mounted) {
                            widget.onSave(newSalary, _applyNow);
                            Navigator.pop(context);
                          }
                        },
                  child: Text(context.l10n.save),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(context.l10n.cancel),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationsSwitch extends StatefulWidget {
  const _NotificationsSwitch();

  @override
  State<_NotificationsSwitch> createState() => _NotificationsSwitchState();
}

class _NotificationsSwitchState extends State<_NotificationsSwitch> {
  bool? _enabled;
  bool _onTime = true;

  @override
  void initState() {
    super.initState();
    Injection.notificationService.isEnabled().then((v) {
      if (mounted) setState(() => _enabled = v);
    });
    _checkOnTime();
  }

  Future<void> _checkOnTime() async {
    final onTime = await Injection.notificationService.canRemindOnTime();
    if (mounted) setState(() => _onTime = onTime);
  }

  Future<void> _allowOnTime() async {
    await Injection.notificationService.allowRemindOnTime();
    await _checkOnTime();
  }

  @override
  Widget build(BuildContext context) {
    final toggle = SwitchListTile(
      contentPadding: EdgeInsets.zero,
      value: _enabled ?? true,
      onChanged: _enabled == null
          ? null
          : (v) async {
              setState(() => _enabled = v);
              await Injection.notificationService.setEnabled(v);
            },
      activeThumbColor: AppColors.primary,
      secondary: const Icon(
        Icons.notifications_active_outlined,
        color: AppColors.primary,
      ),
      title: Text(
        context.l10n.notificationsSetting,
        style: AppTypography.labelLarge,
      ),
      subtitle: Text(
        context.l10n.notificationsSettingDesc,
        style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
      ),
    );
    final onTime = _enabled == true && !_onTime
        ? ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.alarm_outlined, color: AppColors.warning),
            title: Text(
              context.l10n.notifOnTimeTitle,
              style: AppTypography.labelLarge,
            ),
            subtitle: Text(
              context.l10n.notifOnTimeDesc,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            trailing: TextButton(
              onPressed: _allowOnTime,
              child: Text(context.l10n.notifOnTimeAction),
            ),
          )
        : null;
    if (!kDebugMode && onTime == null) return toggle;
    return Column(
      children: [
        toggle,
        ?onTime,
        // Developer check only (never in release builds): proves delivery
        if (kDebugMode)
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              onPressed: () async {
                await Injection.notificationService.scheduleTestReminder();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Test reminder in 1 minute — leave the app',
                      ),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.bug_report_outlined, size: 18),
              label: const Text('Test reminder (debug)'),
            ),
          ),
      ],
    );
  }
}

class _AppLockSettings extends StatefulWidget {
  const _AppLockSettings();

  @override
  State<_AppLockSettings> createState() => _AppLockSettingsState();
}

class _AppLockSettingsState extends State<_AppLockSettings> {
  final _lock = Injection.appLockService;
  bool _loading = true;
  bool _enabled = false;
  int _delay = AppLockService.defaultDelay;
  bool _hideAmounts = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final enabled = await _lock.isEnabled();
    final delay = await _lock.delaySeconds();
    final hide = await _lock.hideAmounts();
    if (!mounted) return;
    setState(() {
      _enabled = enabled;
      _delay = delay;
      _hideAmounts = hide;
      _loading = false;
    });
  }

  /// Both ways need an unlock: on proves it works (no lock-out), off stops
  /// someone else from simply switching it off.
  Future<void> _toggle(bool value) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    if (value && !await _lock.isDeviceSupported()) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.appLockNoDeviceLock)));
      return;
    }
    if (!await _lock.authenticate(l10n.appLockReason)) return;
    await _lock.setEnabled(value);
    if (mounted) setState(() => _enabled = value);
    // Notification texts depend on "hide amounts"
    Injection.notificationService.rescheduleReminders();
  }

  String _delayLabel(BuildContext context, int seconds) => switch (seconds) {
    0 => context.l10n.appLockImmediately,
    60 => context.l10n.appLockAfterMinutes(1),
    _ => context.l10n.appLockAfterMinutes(seconds ~/ 60),
  };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.securitySection, style: AppTypography.labelLarge),
        const SizedBox(height: 4),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: _enabled,
          onChanged: _loading ? null : _toggle,
          activeThumbColor: AppColors.primary,
          secondary: const Icon(
            Icons.lock_outline_rounded,
            color: AppColors.primary,
          ),
          title: Text(l10n.appLockTitle, style: AppTypography.labelLarge),
          subtitle: Text(
            l10n.appLockSubtitle,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        if (_enabled) ...[
          const SizedBox(height: 4),
          Text(
            l10n.appLockAfterLabel,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final seconds in AppLockService.delays)
                ChoiceChip(
                  label: Text(_delayLabel(context, seconds)),
                  selected: _delay == seconds,
                  selectedColor: AppColors.primary.withValues(alpha: 0.12),
                  labelStyle: AppTypography.labelSmall.copyWith(
                    color: _delay == seconds
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                  onSelected: (_) async {
                    await _lock.setDelaySeconds(seconds);
                    if (mounted) setState(() => _delay = seconds);
                  },
                ),
            ],
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _hideAmounts,
            onChanged: (v) async {
              await _lock.setHideAmounts(v);
              if (mounted) setState(() => _hideAmounts = v);
              Injection.notificationService.rescheduleReminders();
            },
            activeThumbColor: AppColors.primary,
            secondary: const Icon(
              Icons.visibility_off_outlined,
              color: AppColors.primary,
            ),
            title: Text(
              l10n.hideAmountsInNotifications,
              style: AppTypography.labelLarge,
            ),
          ),
        ],
      ],
    );
  }
}
