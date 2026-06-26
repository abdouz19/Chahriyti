import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../application/use_cases/cycle/reset_cycle_use_case.dart';
import '../../../core/di/injection.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/value_objects/money.dart';
import '../../shared/widgets/confirmation_dialog.dart';
import '../../shared/widgets/money_text.dart';
import '../cubits/settings_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsCubit(
        userRepository: Injection.userRepository,
        cycleRepository: Injection.cycleRepository,
        resetCycle: ResetCycleUseCase(Injection.cycleRepository),
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
          'الإعدادات',
          style: AppTypography.headlineSmall,
        ),
      ),
      body: BlocConsumer<SettingsCubit, SettingsState>(
        listener: (context, state) {
          if (state is SettingsResetComplete) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم بدء دورة مالية جديدة بنجاح!'),
                backgroundColor: AppColors.positive,
              ),
            );
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
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: AppColors.primary),
                  SizedBox(height: 16),
                  Text('جاري إعادة التعيين...'),
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
                      child: const Text('إعادة المحاولة'),
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
                              state.isActivated ? 'مفعّل' : 'غير مفعّل',
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
                    'الراتب الشهري',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Row(
                    children: [
                      MoneyText(
                        amount: Money.fromDZD(state.salary),
                        style: AppTypography.amountSmall,
                        color: AppColors.primary,
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
                    'يوم استلام الراتب',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'اليوم ${state.salaryDay}',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
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
              Text(
                'الأهداف والديون',
                style: AppTypography.labelLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'إدارة أهدافك المالية والديون',
                style: AppTypography.bodySmall,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: () => context.push('/goals'),
                  icon: const Icon(Icons.flag_rounded),
                  label: const Text('عرض الأهداف'),
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
                  label: const Text('عرض الديون'),
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

          // ── Challenges section ──
          _SectionCard(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'التحديات الأسبوعية',
                        style: AppTypography.labelLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'تحديات ادخار أسبوعية اختيارية',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  Switch(
                    value: state.challengesEnabled,
                    onChanged: (value) {
                      context.read<SettingsCubit>().toggleChallenges(value);
                    },
                    activeThumbColor: AppColors.primary,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Cycle management section ──
          _SectionCard(
            children: [
              Text(
                'إدارة الدورة المالية',
                style: AppTypography.labelLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'يمكنك بدء دورة مالية جديدة مع الاحتفاظ بسجلك الحالي',
                style: AppTypography.bodySmall,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: () => context.push('/cycle-history'),
                  icon: const Icon(Icons.history_rounded),
                  label: const Text('سجل الدورات'),
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
                  onPressed: () => _onResetCycle(context),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('إعادة تعيين الدورة'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.warning,
                    side: const BorderSide(color: AppColors.warning),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),

          // ── App version ──
          Center(
            child: Text(
              'شهريتي - الإصدار 1.0.0',
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

  Future<void> _onResetCycle(BuildContext context) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'بداية جديدة!',
      message: 'هل تريد بدء دورة مالية جديدة؟ سيتم حفظ السجل الحالي.',
      confirmLabel: 'ابدأ من جديد',
      cancelLabel: 'إلغاء',
      confirmColor: AppColors.warning,
    );

    if (confirmed && context.mounted) {
      context.read<SettingsCubit>().resetCycle();
    }
  }

  Future<void> _onEditSalary(BuildContext context, SettingsLoaded state) async {
    final cubit = context.read<SettingsCubit>();
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (sheetContext, setState) {
          final controller = TextEditingController(text: state.salary.toString());
          final formKey = GlobalKey<FormState>();

          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20,
              left: 20,
              right: 20,
              top: 20,
            ),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'تعديل الراتب الشهري',
                      style: AppTypography.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: controller,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'أدخل الراتب الجديد',
                        suffixText: 'دج',
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'الراتب مطلوب';
                        final val = int.tryParse(v);
                        if (val == null || val <= 0) {
                          return 'يجب أن يكون الراتب أكبر من صفر';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            final newSalary = int.parse(controller.text);
                            cubit.updateSalary(newSalary);
                            Navigator.pop(sheetContext);
                          }
                        },
                        child: const Text('حفظ'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(sheetContext),
                        child: const Text('إلغاء'),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _onEditSalaryDay(BuildContext context, SettingsLoaded state) async {
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
                    'تعديل يوم استلام الراتب',
                    style: AppTypography.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'اختر يوم من 1 إلى 28',
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
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      children: [
                        Slider(
                          value: selectedDay.toDouble(),
                          min: 1,
                          max: 28,
                          divisions: 27,
                          label: 'اليوم $selectedDay',
                          onChanged: (value) {
                            setState(() {
                              selectedDay = value.toInt();
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'اليوم المختار: $selectedDay من كل شهر',
                          style: AppTypography.labelLarge.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        cubit.updateSalaryDay(selectedDay);
                        Navigator.pop(sheetContext);
                      },
                      child: const Text('حفظ'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(sheetContext),
                      child: const Text('إلغاء'),
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
