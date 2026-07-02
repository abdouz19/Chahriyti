import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/wilayas.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../cubits/onboarding_cubit.dart';


class SalarySetupPage extends StatefulWidget {
  const SalarySetupPage({super.key});

  @override
  State<SalarySetupPage> createState() => _SalarySetupPageState();
}

class _SalarySetupPageState extends State<SalarySetupPage> {
  final _formKey = GlobalKey<FormState>();
  final _salaryController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  int _salaryDay = 1;
  bool _useCustomDay = false;
  int _selectedWilayaCode = 16; // default: Algiers

  @override
  void dispose() {
    _salaryController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickDay() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year, now.month, _salaryDay.clamp(1, 28)),
      firstDate: DateTime(now.year, now.month, 1),
      lastDate: DateTime(now.year, now.month, 28),
      helpText: 'اختر يوم استلام الراتب',
      locale: const Locale('ar'),
    );
    if (picked != null) {
      setState(() => _salaryDay = picked.day);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final salary = int.tryParse(
          _salaryController.text.replaceAll(',', '').trim(),
        ) ??
        0;

    await context.read<OnboardingCubit>().setSalary(
          monthlySalary: salary,
          salaryDay: _salaryDay,
          fullName: _nameController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          wilayaCode: _selectedWilayaCode,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingSalarySplit) {
          final cubit = context.read<OnboardingCubit>();
          context.push('/salary-split', extra: {
            'cycleId': state.cycleId,
            'salaryAmount': state.salaryAmount,
            'onComplete': () {
              cubit.skipSalarySplit();
            },
          });
        } else if (state is OnboardingIncomeInput) {
          context.go('/onboarding/income');
        } else if (state is OnboardingError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.negative,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إعداد الحساب'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => context.go('/onboarding/value'),
          ),
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                _SectionCard(
                  children: [
                    _buildLabel('الاسم الكامل'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      textAlign: TextAlign.start,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: 'مثال: محمد أمين',
                      ),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'الاسم مطلوب' : null,
                    ),
                    const SizedBox(height: 16),
                    _buildLabel('رقم الهاتف'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _phoneController,
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: '0550000000',
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'رقم الهاتف مطلوب'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    _buildLabel('الولاية'),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      initialValue: _selectedWilayaCode,
                      isExpanded: true,
                      decoration: const InputDecoration(),
                      items: Wilayas.all.map((w) {
                        return DropdownMenuItem(
                          value: w.code,
                          child: Text(
                            '${w.code} - ${w.arabicName}',
                            textAlign: TextAlign.start,
                          ),
                        );
                      }).toList(),
                      onChanged: (v) {
                        if (v != null) setState(() => _selectedWilayaCode = v);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  children: [
                    _buildLabel('الراتب الشهري'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _salaryController,
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        hintText: 'مثال: 50000',
                        suffixText: 'دج',
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'الراتب مطلوب';
                        final val = int.tryParse(v.replaceAll(',', ''));
                        if (val == null || val <= 0) {
                          return 'يجب أن يكون الراتب أكبر من صفر';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  children: [
                    _buildLabel('تاريخ استلام الراتب'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _DayChip(
                          label: 'أول الشهر (اليوم 1)',
                          selected: !_useCustomDay,
                          onTap: () => setState(() {
                            _useCustomDay = false;
                            _salaryDay = 1;
                          }),
                        ),
                        const SizedBox(width: 12),
                        _DayChip(
                          label: 'تاريخ محدد',
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
                                'يوم $_salaryDay من كل شهر',
                                textAlign: TextAlign.start,
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
                  ],
                ),
                const SizedBox(height: 32),
                BlocBuilder<OnboardingCubit, OnboardingState>(
                  builder: (context, state) {
                    final isLoading = state is OnboardingLoading;
                    return ElevatedButton(
                      onPressed: isLoading ? null : _submit,
                      child: isLoading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text('التالي'),
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Text(
        text,
        textAlign: TextAlign.start,
        style: AppTypography.labelMedium,
      );
}

class _SectionCard extends StatelessWidget {
  final List<Widget> children;
  const _SectionCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
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
