import 'package:flutter/material.dart';

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
            'إعداد وضعك المالي',
            style: AppTypography.headlineLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'سيستغرق دقيقتين فقط.\nيمكنك التعديل لاحقًا في أي وقت.',
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
              child: const Text('ابدأ'),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
