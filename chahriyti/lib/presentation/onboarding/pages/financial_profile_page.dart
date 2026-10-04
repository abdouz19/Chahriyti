import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions/l10n_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../cubits/onboarding_cubit.dart';
import '../widgets/onboarding_progress_dots.dart';
import '../widgets/selection_card.dart';

class FinancialProfilePage extends StatefulWidget {
  const FinancialProfilePage({super.key});

  @override
  State<FinancialProfilePage> createState() => _FinancialProfilePageState();
}

class _FinancialProfilePageState extends State<FinancialProfilePage> {
  final _salaryController = TextEditingController();
  int _salaryDay = 1;
  bool _useCustomDay = false;
  String? _maritalStatus;
  bool? _tracksExpenses;
  late List<String> _maritalOptions;
  late List<String> _expenseOptions;

  @override
  void initState() {
    super.initState();
    final l = context.l10n;
    _maritalOptions = [
      l.financialProfileSingle,
      l.financialProfileMarried,
      l.financialProfileMarried1Child,
      l.financialProfileMarried2Children,
      l.financialProfileMarried3Children,
      l.financialProfileMarried4PlusChildren,
    ];
    _expenseOptions = [l.financialProfileTracksYes, l.financialProfileTracksNo];
    final cubit = context.read<OnboardingCubit>();
    if (cubit.salary > 0) {
      _salaryController.text = cubit.salary.toString();
      _salaryDay = cubit.salaryDay;
      _useCustomDay = cubit.salaryDay != 1;
      _maritalStatus = cubit.maritalStatus;
      _tracksExpenses = cubit.tracksExpenses;
    }
  }

  @override
  void dispose() {
    _salaryController.dispose();
    super.dispose();
  }

  Future<void> _pickDay() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year, now.month, _salaryDay.clamp(1, 28)),
      firstDate: DateTime(now.year, now.month, 1),
      lastDate: DateTime(now.year, now.month, 28),
      helpText: context.l10n.salarySetupPickDayHelp,
      locale: const Locale('ar'),
    );
    if (picked != null) {
      setState(() => _salaryDay = picked.day);
    }
  }

  void _submit() {
    final salary = int.tryParse(
          _salaryController.text.replaceAll(',', '').trim(),
        ) ??
        0;
    if (salary < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.financialProfileSalaryNegative)),
      );
      return;
    }
    context.read<OnboardingCubit>().submitFinancial(
          salary: salary,
          salaryDay: _salaryDay,
          maritalStatus: _maritalStatus,
          tracksExpenses: _tracksExpenses,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingGoals) {
          context.go('/onboarding/goals');
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 8),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: IconButton(
                  onPressed: () => context.go('/onboarding/age'),
                  icon: const Icon(Icons.arrow_back_ios_rounded),
                  color: AppColors.textSecondary,
                ),
              ),
              const OnboardingProgressDots(currentStep: 3),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      Text(
                        context.l10n.financialProfileTitle,
                        style: AppTypography.headlineMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Salary
                      Text(
                        context.l10n.financialProfileSalaryQuestion,
                        style: AppTypography.labelMedium,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _salaryController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          hintText: '50,000',
                          suffixText: context.l10n.currencySymbol,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Salary day
                      Text(
                        context.l10n.financialProfileSalaryDayQuestion,
                        style: AppTypography.labelMedium,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _DayChip(
                            label: context.l10n.financialProfileStartOfMonth,
                            selected: !_useCustomDay,
                            onTap: () => setState(() {
                              _useCustomDay = false;
                              _salaryDay = 1;
                            }),
                          ),
                          const SizedBox(width: 12),
                          _DayChip(
                            label: context.l10n.financialProfileCustomDay,
                            selected: _useCustomDay,
                            onTap: () async {
                              setState(() => _useCustomDay = true);
                              await _pickDay();
                            },
                          ),
                        ],
                      ),
                      if (_useCustomDay) ...[
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: _pickDay,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.primary),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today_rounded,
                                  size: 18,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  context.l10n.financialProfileDayOfMonth(_salaryDay),
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 28),
                      const Divider(),
                      const SizedBox(height: 20),
                      // Marital status
                      Text(
                        context.l10n.financialProfileMaritalQuestion,
                        style: AppTypography.labelMedium,
                      ),
                      const SizedBox(height: 12),
                      ...List.generate(_maritalOptions.length, (i) {
                        final option = _maritalOptions[i];
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: i < _maritalOptions.length - 1 ? 8 : 0,
                          ),
                          child: SelectionCard(
                            label: option,
                            selected: _maritalStatus == option,
                            isCheckbox: false,
                            onTap: () =>
                                setState(() => _maritalStatus = option),
                          ),
                        );
                      }),
                      const SizedBox(height: 28),
                      const Divider(),
                      const SizedBox(height: 20),
                      // Expense tracking
                      Text(
                        context.l10n.financialProfileExpenseTrackQuestion,
                        style: AppTypography.labelMedium,
                      ),
                      const SizedBox(height: 12),
                      ...List.generate(_expenseOptions.length, (i) {
                        final option = _expenseOptions[i];
                        final value = i == 0; // true = yes, false = no
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: i < _expenseOptions.length - 1 ? 8 : 0,
                          ),
                          child: SelectionCard(
                            label: option,
                            selected: _tracksExpenses == value,
                            isCheckbox: false,
                            onTap: () =>
                                setState(() => _tracksExpenses = value),
                          ),
                        );
                      }),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              // Bottom CTA
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submit,
                    child: Text(context.l10n.next),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DayChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _DayChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : AppColors.primary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppTypography.bodySmall.copyWith(
            color: selected ? Colors.white : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
