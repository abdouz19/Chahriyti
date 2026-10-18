import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../application/use_cases/onboarding/setup_salary_use_case.dart';
import '../../../core/di/injection.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/extensions/money_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../infrastructure/services/lead_storage.dart';
import '../../shared/widgets/salary_day_picker.dart';
import '../../../core/theme/app_icons.dart';

/// For people who already bought the book: the three answers the app needs
/// (name, salary, salary day), kept on the phone only — no lead is sent.
/// Then straight to entering the activation code.
class QuickSetupPage extends StatefulWidget {
  const QuickSetupPage({super.key});

  @override
  State<QuickSetupPage> createState() => _QuickSetupPageState();
}

class _QuickSetupPageState extends State<QuickSetupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _salaryController = TextEditingController();
  int _salaryDay = 1;
  bool _useCustomDay = false;
  bool _saving = false;

  /// The in-app order, if they came from the thank-you page
  Map<String, dynamic>? _order;

  @override
  void initState() {
    super.initState();
    const LeadStorage().loadOrder().then((order) {
      if (!mounted || order == null) return;
      setState(() {
        _order = order;
        if (_nameController.text.isEmpty) _nameController.text = order['name'] as String? ?? '';
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  Future<void> _pickDay() async {
    final picked = await showSalaryDayPicker(context, selected: _salaryDay);
    if (picked != null) {
      setState(() {
        _useCustomDay = true;
        _salaryDay = picked;
      });
    }
  }

  /// A salary of 1–9,999 DZD is almost always missing zeros (58 for 58,000):
  /// scale it up to 5 digits. 0 and real salaries are left alone.
  static int? _likelySalary(int value) {
    if (value <= 0 || value >= 10000) return null;
    var fixed = value;
    while (fixed < 10000) {
      fixed *= 10;
    }
    return fixed;
  }

  /// Asks "did you mean …?" for a suspiciously small salary; fixes the field
  /// when they agree. Returns false if they dismissed the question.
  Future<bool> _confirmSalary() async {
    final typed = int.parse(_salaryController.text);
    final suggestion = _likelySalary(typed);
    if (suggestion == null) return true;

    final l10n = context.l10n;
    final symbol = l10n.currencySymbol;
    final typedText = typed.toDZDString(symbol: symbol);
    final suggestionText = suggestion.toDZDString(symbol: symbol);
    final useSuggestion = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.salaryCheckTitle(suggestionText),
                style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.salaryCheckBody(typedText),
                style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary, height: 1.6),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(sheetContext, true),
                  child: Text(l10n.salaryCheckYes(suggestionText)),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(sheetContext, false),
                  child: Text(l10n.salaryCheckNo(typedText)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (useSuggestion == null || !mounted) return false;
    if (useSuggestion) {
      setState(() => _salaryController.text = '$suggestion');
    }
    return true;
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (!await _confirmSalary()) return;
    setState(() => _saving = true);
    try {
      await SetupSalaryUseCase(Injection.userRepository, Injection.cycleRepository)(
        monthlySalary: int.parse(_salaryController.text),
        salaryDay: _salaryDay,
        fullName: _nameController.text.trim(),
        // From the in-app order if there was one; the "already bought" path
        // doesn't ask, and the activation page hides empty values
        phoneNumber: _order?['phone'] as String? ?? '',
        wilayaCode: _order?['wilayaCode'] as int? ?? 0,
      );
      await const LeadStorage().clearOrder();
      if (mounted) context.go('/activation');
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.quickSetupFailed),
          backgroundColor: AppColors.negative,
        ),
      );
    }
  }

  Widget _label(String text) => Text(
        text,
        style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w700),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: IconButton(
                    icon: const Icon(AppIcons.back),
                    color: AppColors.textSecondary,
                    onPressed: () => context.go(_order != null ? '/onboarding/thanks' : '/onboarding/offer'),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  children: [
                    Text(
                      l10n.quickSetupTitle,
                      style: AppTypography.headlineLarge.copyWith(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.quickSetupSubtitle,
                      style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 28),
                    _label(l10n.salarySetupFullName),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(hintText: l10n.salarySetupNameHint),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? l10n.salarySetupNameRequired : null,
                    ),
                    const SizedBox(height: 20),
                    _label(l10n.salarySetupSalary),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _salaryController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        hintText: l10n.salarySetupSalaryHint,
                        suffixText: l10n.currencySymbol,
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return l10n.salarySetupSalaryRequired;
                        final value = int.tryParse(v);
                        // 0 is fine: not everyone has a fixed salary
                        if (value == null || value < 0) return l10n.salarySetupSalaryPositive;
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    _label(l10n.salarySetupSalaryDay),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _DayOption(
                            label: l10n.salarySetupFirstOfMonth,
                            selected: !_useCustomDay,
                            onTap: () => setState(() {
                              _useCustomDay = false;
                              _salaryDay = 1;
                            }),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _DayOption(
                            label: _useCustomDay
                                ? l10n.salarySetupDayOfMonth(_salaryDay)
                                : l10n.salarySetupSpecificDate,
                            selected: _useCustomDay,
                            onTap: _pickDay,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saving ? null : _submit,
                    child: _saving
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                          )
                        : Text(l10n.quickSetupContinue),
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

class _DayOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _DayOption({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withValues(alpha: 0.08) : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: selected ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
