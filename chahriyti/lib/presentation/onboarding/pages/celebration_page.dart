import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/offer.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/extensions/money_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../cubits/onboarding_cubit.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class CelebrationPage extends StatelessWidget {
  const CelebrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingDone) {
          context.go('/activation');
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
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 32),
                      Center(
                        // The book + the app: what the order brings
                        child: Image.asset(
                          'assets/illustrations/order_book_app.png',
                          height: 220,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 28),
                      BlocBuilder<OnboardingCubit, OnboardingState>(
                        builder: (context, state) {
                          final firstName = state is OnboardingCelebration
                              ? state.firstName
                              : null;
                          return Text(
                            firstName != null
                                ? context.l10n.celebrationWelcomeWithName(firstName)
                                : context.l10n.celebrationWelcome,
                            style: AppTypography.headlineMedium.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                            textAlign: TextAlign.center,
                          );
                        },
                      ),
                      const SizedBox(height: 4),
                      Text(
                        context.l10n.celebrationTagline,
                        style: AppTypography.bodyLarge.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      const _OfferCard(),
                      const SizedBox(height: 24),
                      const _NextSteps(),
                      const SizedBox(height: 16),
                      const _Reassurance(),
                      const SizedBox(height: 20),
                      Text(
                        context.l10n.celebrationFooter,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              // Bottom section
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Column(
                  children: [
                    BlocBuilder<OnboardingCubit, OnboardingState>(
                      builder: (context, state) {
                        final isLoading = state is OnboardingLoading;
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () =>
                                    context.read<OnboardingCubit>().complete(),
                            child: isLoading
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : Text(context.l10n.celebrationActivateButton),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OfferCard extends StatelessWidget {
  const _OfferCard();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final symbol = l10n.currencySymbol;
    // Honest framing: the price spread over a single year
    final perDay = offerPricePerDay;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              l10n.offerLabel,
              style: AppTypography.labelSmall.copyWith(
                  color: AppColors.primary, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.offerTitle,
            style: AppTypography.labelLarge
                .copyWith(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                offerPrice.toDZDString(symbol: symbol),
                style: AppTypography.amountLarge
                    .copyWith(color: AppColors.primary, fontSize: 30),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    l10n.offerPriceNote,
                    style: AppTypography.bodySmall
                        .copyWith(color: AppColors.textSecondary),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            l10n.offerPerDay(perDay.toDZDString(symbol: symbol)),
            style: AppTypography.bodySmall.copyWith(
                color: AppColors.positive, fontWeight: FontWeight.w600),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1, color: AppColors.divider),
          ),
          for (final item in [
            (IconsaxPlusBold.book, l10n.offerInclude1),
            (IconsaxPlusBold.verify, l10n.offerInclude2),
            (IconsaxPlusBold.chart_square, l10n.offerInclude3),
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(item.$1, size: 18, color: AppColors.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(item.$2, style: AppTypography.bodyMedium),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// What happens next, so waiting for the call feels planned, not uncertain.
class _NextSteps extends StatelessWidget {
  const _NextSteps();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final steps = [
      (IconsaxPlusBold.call_calling, l10n.nextStep1),
      (IconsaxPlusBold.truck, l10n.nextStep2),
      (IconsaxPlusBold.flash, l10n.nextStep3),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.nextStepsTitle,
            style: AppTypography.labelLarge
                .copyWith(fontSize: 16, fontWeight: FontWeight.w800)),
        const SizedBox(height: 14),
        for (var i = 0; i < steps.length; i++)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: i == 0
                            ? AppColors.primary
                            : AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(steps[i].$1,
                          size: 17,
                          color: i == 0 ? Colors.white : AppColors.primary),
                    ),
                    if (i < steps.length - 1)
                      Expanded(
                        child: Container(
                          width: 2,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          color: AppColors.primary.withValues(alpha: 0.15),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 6, bottom: i < steps.length - 1 ? 18 : 0),
                    child: Text(steps[i].$2,
                        style: AppTypography.bodyMedium.copyWith(height: 1.5)),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _Reassurance extends StatelessWidget {
  const _Reassurance();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          const Icon(IconsaxPlusBold.mobile, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              context.l10n.reassuranceKeepPhone,
              style: AppTypography.bodyMedium
                  .copyWith(color: AppColors.primary, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
