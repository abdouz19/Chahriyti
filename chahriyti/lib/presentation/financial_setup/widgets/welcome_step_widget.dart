import 'package:flutter/material.dart';

import '../../../core/extensions/l10n_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class WelcomeStepWidget extends StatelessWidget {
  final VoidCallback onStart;

  const WelcomeStepWidget({super.key, required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Icon(
            Icons.account_balance_wallet_rounded,
            size: 80,
            color: AppColors.primary,
          ),
          const SizedBox(height: 32),
          Text(
            context.l10n.financialSetupTitle,
            style: AppTypography.headlineLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.financialSetupSubtitle,
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onStart,
              child: Text(context.l10n.start),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
