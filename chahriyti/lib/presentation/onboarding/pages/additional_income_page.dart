import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../cubits/onboarding_cubit.dart';

class _IncomeEntry {
  final TextEditingController descriptionController;
  final TextEditingController amountController;

  _IncomeEntry()
      : descriptionController = TextEditingController(),
        amountController = TextEditingController();

  void dispose() {
    descriptionController.dispose();
    amountController.dispose();
  }
}

class AdditionalIncomePage extends StatefulWidget {
  const AdditionalIncomePage({super.key});

  @override
  State<AdditionalIncomePage> createState() => _AdditionalIncomePageState();
}

class _AdditionalIncomePageState extends State<AdditionalIncomePage> {
  final _formKey = GlobalKey<FormState>();
  final List<_IncomeEntry> _entries = [_IncomeEntry()];

  @override
  void dispose() {
    for (final entry in _entries) {
      entry.dispose();
    }
    super.dispose();
  }

  void _addEntry() {
    setState(() => _entries.add(_IncomeEntry()));
  }

  void _removeEntry(int index) {
    if (_entries.length <= 1) return;
    final entry = _entries.removeAt(index);
    entry.dispose();
    setState(() {});
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final cubit = context.read<OnboardingCubit>();
    for (final entry in _entries) {
      final description = entry.descriptionController.text.trim();
      final amount =
          int.tryParse(entry.amountController.text.replaceAll(',', '')) ?? 0;
      if (description.isNotEmpty && amount > 0) {
        await cubit.addIncome(description: description, amount: amount);
      }
    }
  }

  void _skip() {
    context.read<OnboardingCubit>().skipIncome();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingValueProposition) {
          context.go('/onboarding/value');
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
          title: const Text('مداخيل إضافية'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => context.go('/onboarding/salary'),
          ),
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text(
                  'أضف مداخيلك الإضافية',
                  style: AppTypography.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'مثال: عمل إضافي، إيجار، منحة...',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                ..._entries.asMap().entries.map((mapEntry) {
                  final i = mapEntry.key;
                  final entry = mapEntry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'مدخول ${i + 1}',
                                  style: AppTypography.labelMedium,
                                ),
                                const Spacer(),
                                if (_entries.length > 1)
                                  IconButton(
                                    onPressed: () => _removeEntry(i),
                                    icon: const Icon(
                                      Icons.remove_circle_outline_rounded,
                                      color: AppColors.negative,
                                      size: 20,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: entry.descriptionController,
                              textAlign: TextAlign.start,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                hintText: 'المصدر (مثال: عمل إضافي)',
                              ),
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'المصدر مطلوب'
                                  : null,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: entry.amountController,
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: const InputDecoration(
                                hintText: 'المبلغ',
                                suffixText: 'دج',
                              ),
                              validator: (v) {
                                if (v == null || v.isEmpty) return 'المبلغ مطلوب';
                                final val = int.tryParse(v);
                                if (val == null || val <= 0) {
                                  return 'يجب أن يكون المبلغ أكبر من صفر';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                TextButton.icon(
                  onPressed: _addEntry,
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('إضافة مدخول آخر'),
                ),
                const SizedBox(height: 24),
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
                          : const Text('حفظ والمتابعة'),
                    );
                  },
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _skip,
                  child: Text(
                    'تخطي',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
