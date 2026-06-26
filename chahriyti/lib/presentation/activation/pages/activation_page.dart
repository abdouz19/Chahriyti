import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/wilayas.dart';
import '../../../core/di/injection.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../cubits/activation_cubit.dart';
import '../widgets/license_key_dialog.dart';

class ActivationPage extends StatefulWidget {
  const ActivationPage({super.key});

  @override
  State<ActivationPage> createState() => _ActivationPageState();
}

class _ActivationPageState extends State<ActivationPage> {
  int _currentStep = 0;

  static const _stepLabels = ['بياناتك', 'إرسال', 'تفعيل'];

  @override
  Widget build(BuildContext context) {
    return BlocListener<ActivationCubit, ActivationState>(
      listener: (context, state) {
        if (state is ActivationSuccess) {
          context.go('/home');
        } else if (state is ActivationError) {
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
          title: const Text('تفعيل التطبيق'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => context.go('/onboarding/value'),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Step indicator
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                child: _StepIndicator(
                  currentStep: _currentStep,
                  labels: _stepLabels,
                ),
              ),
              // Content
              Expanded(
                child: BlocBuilder<ActivationCubit, ActivationState>(
                  builder: (context, state) {
                    if (state is ActivationLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      );
                    }
                    return ListView(
                      padding: const EdgeInsets.all(24),
                      children: [
                        // Step 1: User info
                        _buildUserInfoSection(),
                        const SizedBox(height: 16),
                        // Device ID
                        _buildDeviceIdSection(context, state),
                        const SizedBox(height: 16),
                        // Step 2: Send via WhatsApp
                        _buildWhatsAppSection(context, state),
                        const SizedBox(height: 16),
                        // Step 3: Enter license key
                        _buildLicenseSection(context, state),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoSection() {
    return FutureBuilder(
      future: Injection.userRepository.getUser(),
      builder: (context, snapshot) {
        final user = snapshot.data;
        if (user == null) {
          return const SizedBox.shrink();
        }
        final wilaya = Wilayas.all.firstWhere(
          (w) => w.code == user.wilayaCode,
          orElse: () => const Wilaya(0, 'غير معروف'),
        );
        return _SectionCard(
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_outline_rounded,
                    size: 20,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'بياناتك',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _InfoRow(label: 'الاسم', value: user.fullName),
            const SizedBox(height: 8),
            _InfoRow(label: 'الهاتف', value: user.phoneNumber),
            const SizedBox(height: 8),
            _InfoRow(
              label: 'الولاية',
              value: '${wilaya.code} - ${wilaya.arabicName}',
            ),
          ],
        );
      },
    );
  }

  Widget _buildDeviceIdSection(BuildContext context, ActivationState state) {
    final deviceId = state is ActivationReady
        ? state.deviceId.displayFormat
        : context.read<ActivationCubit>().deviceId?.displayFormat ?? '...';

    return _SectionCard(
      children: [
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.devices_rounded,
                size: 20,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'رقم الجهاز',
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  deviceId,
                  style: AppTypography.bodySmall.copyWith(
                    fontFamily: 'monospace',
                    fontSize: 13,
                    letterSpacing: 0.5,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: deviceId));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم نسخ رقم الجهاز'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.copy_rounded,
                    size: 18,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWhatsAppSection(BuildContext context, ActivationState state) {
    return _SectionCard(
      children: [
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.positive.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.send_rounded,
                size: 20,
                color: AppColors.positive,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'أرسل طلب التفعيل عبر واتساب',
                style: AppTypography.labelLarge,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'سيتم إرسال بياناتك ورقم الجهاز للمسؤول لتفعيل حسابك.',
          style: AppTypography.bodySmall,
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: state is ActivationSending
                ? null
                : () => _sendWhatsApp(context),
            icon: state is ActivationSending
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.chat_rounded, size: 20),
            label: const Text('أرسل عبر واتساب'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF25D366),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _sendWhatsApp(BuildContext context) async {
    setState(() => _currentStep = 1);
    final user = await Injection.userRepository.getUser();
    if (user == null || !context.mounted) return;

    final cubit = context.read<ActivationCubit>();
    final url = cubit.composeWhatsAppUrl(
      name: user.fullName,
      phone: user.phoneNumber,
      wilayaCode: user.wilayaCode,
    );

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('لا يمكن فتح واتساب'),
            backgroundColor: AppColors.negative,
          ),
        );
      }
    }
  }

  Widget _buildLicenseSection(BuildContext context, ActivationState state) {
    return _SectionCard(
      children: [
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.vpn_key_rounded,
                size: 20,
                color: AppColors.warning,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'هل لديك مفتاح التفعيل؟',
                style: AppTypography.labelLarge,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'إذا حصلت على مفتاح التفعيل، أدخله هنا لتفعيل التطبيق مباشرة.',
          style: AppTypography.bodySmall,
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              setState(() => _currentStep = 2);
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => BlocProvider.value(
                  value: context.read<ActivationCubit>(),
                  child: const LicenseKeyDialog(),
                ),
              );
            },
            icon: const Icon(Icons.key_rounded, size: 20),
            label: const Text('لدي مفتاح التفعيل'),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Step Indicator
// ---------------------------------------------------------------------------

class _StepIndicator extends StatelessWidget {
  final int currentStep;
  final List<String> labels;

  const _StepIndicator({
    required this.currentStep,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(labels.length * 2 - 1, (index) {
        if (index.isOdd) {
          // Connector line between dots
          final stepBefore = index ~/ 2;
          return Expanded(
            child: Container(
              height: 2,
              color: stepBefore < currentStep
                  ? AppColors.primary
                  : AppColors.border,
            ),
          );
        }
        final stepIndex = index ~/ 2;
        final isActive = stepIndex <= currentStep;
        final isCurrent = stepIndex == currentStep;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: isCurrent ? 32 : 26,
              height: isCurrent ? 32 : 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? AppColors.primary : AppColors.surface,
                border: Border.all(
                  color: isActive ? AppColors.primary : AppColors.border,
                  width: isCurrent ? 2.5 : 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  '${stepIndex + 1}',
                  style: AppTypography.labelSmall.copyWith(
                    color: isActive ? Colors.white : AppColors.textSecondary,
                    fontSize: isCurrent ? 13 : 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              labels[stepIndex],
              style: AppTypography.labelSmall.copyWith(
                color: isActive ? AppColors.primary : AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        );
      }),
    );
  }
}

// ---------------------------------------------------------------------------
// Section Card
// ---------------------------------------------------------------------------

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

// ---------------------------------------------------------------------------
// Info Row
// ---------------------------------------------------------------------------

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: AppTypography.bodySmall,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
