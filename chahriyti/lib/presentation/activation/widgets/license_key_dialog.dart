import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../cubits/activation_cubit.dart';

class LicenseKeyDialog extends StatefulWidget {
  const LicenseKeyDialog({super.key});

  @override
  State<LicenseKeyDialog> createState() => _LicenseKeyDialogState();
}

class _LicenseKeyDialogState extends State<LicenseKeyDialog> {
  final _keyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _errorText;

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() => _errorText = null);

    if (!_formKey.currentState!.validate()) return;

    final key = _keyController.text.trim();
    context.read<ActivationCubit>().validateLicense(key);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ActivationCubit, ActivationState>(
      listener: (context, state) {
        if (state is ActivationSuccess) {
          Navigator.of(context).pop();
          // The parent page BlocListener handles navigation to /home
        } else if (state is ActivationError) {
          setState(() => _errorText = state.message);
        }
      },
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.vpn_key_rounded,
                        size: 22,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'إدخال مفتاح التفعيل',
                        style: AppTypography.headlineSmall,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Key input field
                TextFormField(
                  controller: _keyController,
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.ltr,
                  style: AppTypography.bodyLarge.copyWith(
                    fontFamily: 'monospace',
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                  textCapitalization: TextCapitalization.characters,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[A-Za-z0-9\-]'),
                    ),
                    _LicenseKeyFormatter(),
                  ],
                  decoration: InputDecoration(
                    hintText: 'CHRY-XXXX-XXXX-XXXX',
                    hintStyle: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary.withValues(alpha: 0.5),
                      fontFamily: 'monospace',
                      letterSpacing: 1.5,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'المفتاح مطلوب';
                    }
                    if (value.trim() == '1111') return null;
                    if (value.trim().length < 10) {
                      return 'المفتاح غير مكتمل';
                    }
                    return null;
                  },
                ),
                // Error text
                if (_errorText != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _errorText!,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.negative,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 24),
                // Action buttons
                BlocBuilder<ActivationCubit, ActivationState>(
                  builder: (context, state) {
                    final isValidating = state is ActivationValidating;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                          onPressed: isValidating ? null : _submit,
                          child: isValidating
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Text('تفعيل'),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: isValidating
                              ? null
                              : () => Navigator.of(context).pop(),
                          child: Text(
                            'إلغاء',
                            style: AppTypography.labelMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// License Key Formatter — auto-inserts dashes
// ---------------------------------------------------------------------------

class _LicenseKeyFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove all dashes to get raw text
    final raw = newValue.text.replaceAll('-', '').toUpperCase();
    if (raw.isEmpty) {
      return const TextEditingValue();
    }

    // Split into groups of 4 and join with dashes
    // Format: CHRY-XXXX-XXXX-XXXX-XXXX (20 raw chars + 4 dashes)
    final buffer = StringBuffer();
    for (var i = 0; i < raw.length && i < 20; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write('-');
      }
      buffer.write(raw[i]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
