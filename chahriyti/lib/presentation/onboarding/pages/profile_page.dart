import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/wilayas.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../cubits/onboarding_cubit.dart';
import '../widgets/commune_picker_sheet.dart';
import '../widgets/onboarding_progress_dots.dart';
import '../widgets/wilaya_picker_sheet.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  int _wilayaCode = 16;
  Wilaya? _selectedWilaya;
  String? _selectedCommune;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<OnboardingCubit>();
    if (cubit.name.isNotEmpty) {
      _nameController.text = cubit.name;
      _phoneController.text = cubit.phone;
      _wilayaCode = cubit.wilayaCode;
      _selectedWilaya = Wilayas.all.where((w) => w.code == cubit.wilayaCode).firstOrNull;
      _selectedCommune = cubit.commune;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _openWilayaPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => WilayaPickerSheet(
        onSelected: (wilaya) {
          setState(() {
            _selectedWilaya = wilaya;
            _wilayaCode = wilaya.code;
            _selectedCommune = null; // reset commune on wilaya change
          });
        },
      ),
    );
  }

  void _submit() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.profileNameRequired)),
      );
      return;
    }
    if (_selectedWilaya == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.profileWilayaRequired)),
      );
      return;
    }
    if (_selectedCommune == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.profileCommuneRequired)),
      );
      return;
    }
    final phone = _phoneController.text.trim();
    final phoneValid = RegExp(r'^0[567]\d{8}$').hasMatch(phone);
    if (!phoneValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.profilePhoneInvalid),
        ),
      );
      return;
    }
    context.read<OnboardingCubit>().submitProfile(
          name: _nameController.text.trim(),
          phone: phone,
          wilayaCode: _wilayaCode,
          commune: _selectedCommune,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingAgeGroup) {
          context.go('/onboarding/age');
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                const OnboardingProgressDots(currentStep: 1),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 24),
                        Text(
                          context.l10n.profileSetupTitle,
                          style: AppTypography.headlineMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          context.l10n.profileSetupSubtitle,
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        // Name field
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            context.l10n.profileNameQuestion,
                            style: AppTypography.labelMedium,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _nameController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            hintText: context.l10n.profileNameHint,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Wilaya picker
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            context.l10n.profileWhereQuestion,
                            style: AppTypography.labelMedium,
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: _openWilayaPicker,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _selectedWilaya != null
                                      ? '${_selectedWilaya!.code} - ${_selectedWilaya!.arabicName}'
                                      : context.l10n.profileWilayaPlaceholder,
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: _selectedWilaya != null
                                        ? AppColors.textPrimary
                                        : AppColors.textSecondary,
                                  ),
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: AppColors.textSecondary,
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Commune picker (visible only after wilaya selected)
                        if (_selectedWilaya != null) ...[
                          const SizedBox(height: 20),
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              context.l10n.profileCommuneLabel,
                              style: AppTypography.labelMedium,
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (_) => CommunePickerSheet(
                                  wilayaCode: _wilayaCode,
                                  onSelected: (commune) {
                                    setState(() => _selectedCommune = commune);
                                  },
                                ),
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _selectedCommune ?? context.l10n.profileCommunePlaceholder,
                                    style: AppTypography.bodyMedium.copyWith(
                                      color: _selectedCommune != null
                                          ? AppColors.textPrimary
                                          : AppColors.textSecondary,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: AppColors.textSecondary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 20),
                        // Phone field
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            context.l10n.profilePhoneLabel,
                            style: AppTypography.labelMedium,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            hintText: '0XXXXXXXXX',
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.lock_outline_rounded,
                              size: 14,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                context.l10n.profilePrivacyNote,
                                style: AppTypography.bodySmall,
                              ),
                            ),
                          ],
                        ),
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
                      child: Text(context.l10n.profileSubmitButton),
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
