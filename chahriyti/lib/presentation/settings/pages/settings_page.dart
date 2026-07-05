import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/injection.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/value_objects/money.dart';
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
        resetAppData: Injection.resetAppDataUseCase,
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
          if (state is SettingsDataResetComplete) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم مسح جميع البيانات بنجاح'),
                backgroundColor: AppColors.positive,
              ),
            );
            context.go('/home');
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
                              'من الدورة القادمة',
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
                    'يوم استلام الراتب',
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
                            'اليوم ${state.salaryDay}',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (state.salaryDayPending)
                            Text(
                              'من الدورة القادمة',
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
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: () => context.push('/savings'),
                  icon: const Icon(Icons.savings_rounded),
                  label: const Text('المدخرات'),
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
              Text(
                'إدارة الدورة المالية',
                style: AppTypography.labelLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'تبدأ الدورة تلقائياً في يوم استلام راتبك كل شهر',
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
            ],
          ),
          const SizedBox(height: 20),

          // ── Danger zone ──
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.negative.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.negative.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.warning_rounded, color: AppColors.negative, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'منطقة الخطر',
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.negative,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'هذه الإجراءات لا يمكن التراجع عنها. تأكد تماماً قبل المتابعة.',
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
                    label: const Text('مسح كل البيانات'),
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
            Text('تحذير مهم', style: AppTypography.headlineSmall),
          ],
        ),
        content: Text(
          'ستقوم بمسح جميع بياناتك المالية بما فيها:\n\n'
          '• جميع المصاريف\n'
          '• جميع الديون والمدفوعات\n'
          '• جميع الإقراضات\n'
          '• جميع الأهداف والمدخرات\n'
          '• سجل الدورات المالية\n\n'
          'سيتم الاحتفاظ فقط براتبك ويوم استلامه.\n\n'
          'هذا الإجراء لا يمكن التراجع عنه نهائياً.',
          style: AppTypography.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('إلغاء', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('متابعة', style: TextStyle(color: AppColors.negative)),
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
        title: Text('هل أنت متأكد تماماً؟', style: AppTypography.headlineSmall),
        content: Text(
          'لن تتمكن من استرجاع أي بيانات بعد هذه الخطوة.\n\nهل تريد المتابعة؟',
          style: AppTypography.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('لا، إلغاء', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.negative,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('نعم، امسح كل شيء'),
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
        onSave: (newSalary) {
          cubit.updateSalary(newSalary);
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
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.info_outline_rounded, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 6),
                      Text(
                        'سيُطبَّق من الدورة القادمة',
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
                            title: const Text('تأكيد تعديل يوم الراتب'),
                            content: Text(
                              'سيُطبَّق يوم الراتب الجديد (اليوم $selectedDay) ابتداءً من دورتك القادمة.\nالدورة الحالية لن تتأثر.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(sheetContext, false),
                                child: const Text('إلغاء'),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(sheetContext, true),
                                child: const Text('تأكيد'),
                              ),
                            ],
                          ),
                        );
                        if (confirmed == true && sheetContext.mounted) {
                          cubit.updateSalaryDay(selectedDay);
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

class _EditSalarySheet extends StatefulWidget {
  final int initialSalary;
  final void Function(int) onSave;

  const _EditSalarySheet({
    required this.initialSalary,
    required this.onSave,
  });

  @override
  State<_EditSalarySheet> createState() => _EditSalarySheetState();
}

class _EditSalarySheetState extends State<_EditSalarySheet> {
  late final TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialSalary.toString());
  }

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
              Text('تعديل الراتب الشهري', style: AppTypography.headlineSmall),
              const SizedBox(height: 16),
              TextFormField(
                controller: _controller,
                keyboardType: TextInputType.number,
                autofocus: true,
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
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.info_outline_rounded, size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 6),
                  Text(
                    'سيُطبَّق من الدورة القادمة',
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
                    if (!_formKey.currentState!.validate()) return;
                    final newSalary = int.parse(_controller.text);
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('تأكيد تعديل الراتب'),
                        content: Text(
                          'سيُطبَّق الراتب الجديد ($newSalary دج) ابتداءً من دورتك القادمة.\nالدورة الحالية لن تتأثر.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('إلغاء'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('تأكيد'),
                          ),
                        ],
                      ),
                    );
                    if (confirmed == true && context.mounted) {
                      widget.onSave(newSalary);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('حفظ'),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('إلغاء'),
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
