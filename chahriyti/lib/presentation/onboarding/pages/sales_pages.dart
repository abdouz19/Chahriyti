import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../../core/constants/offer.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/extensions/money_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_typography.dart';
import '../widgets/month_bar.dart';

/// The sales screens shown between the welcome screen and the profile
/// questions, in order. Everyone sees the offer before sharing their details.
const salesRoutes = [
  '/onboarding/mirror',
  '/onboarding/change',
  '/onboarding/how',
  '/onboarding/offer',
];

// Light gold: readable on the teal price block
const _gold = Color(0xFFF5D06F);

TextStyle get _headline => AppTypography.headlineLarge.copyWith(
      fontSize: 32,
      fontWeight: FontWeight.w800,
      color: AppColors.textPrimary,
      height: 1.3,
    );

TextStyle get _body => AppTypography.bodyLarge.copyWith(
      color: AppColors.textPrimary.withValues(alpha: 0.72),
      height: 1.75,
    );

/// Shared frame: back arrow and a segmented progress line on top, content
/// aligned to the reading edge, the action(s) pinned at the bottom.
class _SalesScaffold extends StatelessWidget {
  final int step;
  final String buttonLabel;
  final VoidCallback onNext;
  final List<Widget> children;
  final Widget? secondary;

  const _SalesScaffold({
    required this.step,
    required this.buttonLabel,
    required this.onNext,
    required this.children,
    this.secondary,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 24, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(AppIcons.back),
                    color: AppColors.textPrimary,
                    onPressed: () => context.go(step == 0 ? '/' : salesRoutes[step - 1]),
                  ),
                  const SizedBox(width: 8),
                  // Where they are in the story: one segment per screen
                  for (var i = 0; i < salesRoutes.length; i++) ...[
                    if (i > 0) const SizedBox(width: 6),
                    Expanded(
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: i <= step ? AppColors.primary : AppColors.divider,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: children,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(onPressed: onNext, child: Text(buttonLabel)),
                  ),
                  if (secondary != null) ...[
                    const SizedBox(height: 10),
                    SizedBox(width: double.infinity, child: secondary),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The book and phone settle into place once, when the screen opens.
class _ProductShot extends StatelessWidget {
  final double height;
  const _ProductShot({required this.height});

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: reduceMotion ? 1 : 0, end: 1),
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOutBack,
        builder: (context, t, child) => Opacity(
          opacity: t.clamp(0.0, 1.0),
          child: Transform.scale(scale: 0.92 + 0.08 * t, child: child),
        ),
        child: Image.asset('assets/illustrations/order_book_app.png', height: height, fit: BoxFit.contain),
      ),
    );
  }
}

// ── 1. The mirror: the month that runs dry on the 20th ──

class SalesMirrorPage extends StatelessWidget {
  const SalesMirrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return _SalesScaffold(
      step: 0,
      buttonLabel: l10n.salesNext,
      onNext: () => context.go(salesRoutes[1]),
      children: [
        Text(l10n.salesMirrorTitle, style: _headline),
        const SizedBox(height: 14),
        Text('${l10n.salesMirrorBody} ${l10n.salesMirrorBody2}', style: _body),
        const SizedBox(height: 32),
        MonthBar(
          runsOutAt: 20,
          startLabel: l10n.monthBarSalaryDay,
          endLabel: l10n.monthBarNextSalary,
          markerLabel: l10n.monthBarRunsOut,
        ),
        const SizedBox(height: 36),
        // For people who are fine today: a side note, set apart by a rule
        Container(
          padding: const EdgeInsetsDirectional.only(start: 16),
          decoration: const BoxDecoration(
            border: BorderDirectional(start: BorderSide(color: AppColors.primary, width: 3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.salesMirrorFineTitle,
                style: AppTypography.labelLarge.copyWith(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              Text(l10n.salesMirrorFineBody, style: _body.copyWith(fontSize: 15)),
              const SizedBox(height: 10),
              Text(
                l10n.salesMirrorFineBold,
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── 2. The change: the same month, lasting to the end ──

class SalesChangePage extends StatelessWidget {
  const SalesChangePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final outcomes = [l10n.salesChange1, l10n.salesChange2, l10n.salesChange3, l10n.salesChange4];
    return _SalesScaffold(
      step: 1,
      buttonLabel: l10n.salesNext,
      onNext: () => context.go(salesRoutes[2]),
      children: [
        Text(l10n.salesChangeTitle, style: _headline),
        const SizedBox(height: 32),
        MonthBar(
          startLabel: l10n.monthBarSalaryDay,
          endLabel: l10n.monthBarNextSalary,
          markerLabel: l10n.monthBarLeftOver,
        ),
        const SizedBox(height: 32),
        for (final outcome in outcomes)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 3),
                  child: Icon(IconsaxPlusBold.tick_circle, size: 22, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    outcome,
                    style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600, height: 1.6),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// ── 3. How: a system, not only an app — and why today ──

class SalesHowPage extends StatelessWidget {
  const SalesHowPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final parts = [
      (IconsaxPlusLinear.book, l10n.salesHowBook),
      (IconsaxPlusLinear.mobile, l10n.salesHowApp),
      (IconsaxPlusLinear.key, l10n.salesHowCode),
    ];
    return _SalesScaffold(
      step: 2,
      buttonLabel: l10n.salesNext,
      onNext: () => context.go(salesRoutes[3]),
      children: [
        const _ProductShot(height: 210),
        const SizedBox(height: 24),
        Text(l10n.salesHowTitle, style: _headline.copyWith(fontSize: 28)),
        const SizedBox(height: 20),
        for (final (icon, text) in parts)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              children: [
                Icon(icon, color: AppColors.primary, size: 24),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(text, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        const SizedBox(height: 14),
        Text(
          l10n.salesHowUrgency,
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.primaryDark,
            fontWeight: FontWeight.w800,
            height: 1.65,
          ),
        ),
      ],
    );
  }
}

// ── 4. The offer: price last, small next to what it changes ──

class SalesOfferPage extends StatelessWidget {
  const SalesOfferPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final symbol = l10n.currencySymbol;
    return _SalesScaffold(
      step: 3,
      // Bought the book: three setup answers on the phone, then the code
      buttonLabel: l10n.salesOfferHaveCode,
      onNext: () => context.go('/onboarding/quick-setup'),
      secondary: OutlinedButton.icon(
        onPressed: () => context.go('/onboarding/order'),
        icon: const Icon(IconsaxPlusLinear.shopping_bag),
        label: Text(l10n.salesOfferOrderOnline),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      children: [
        const _ProductShot(height: 180),
        const SizedBox(height: 24),
        Text(l10n.salesOfferHeadline, style: _headline.copyWith(fontSize: 28)),
        const SizedBox(height: 22),
        // The price, on a teal block: the one place colour is used heavily
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    offerPrice.toDZDString(symbol: symbol),
                    style: AppTypography.amountLarge.copyWith(color: Colors.white, fontSize: 34),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      l10n.salesOfferOnce,
                      style: AppTypography.bodyMedium.copyWith(color: Colors.white.withValues(alpha: 0.8)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                l10n.salesOfferPerDay(offerPricePerDay.toDZDString(symbol: symbol)),
                style: AppTypography.bodyMedium.copyWith(color: _gold, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            for (final (icon, text) in [
              (IconsaxPlusLinear.moneys, l10n.salesOfferCod),
              (IconsaxPlusLinear.truck, l10n.salesOfferDelivery),
            ]) ...[
              Icon(icon, size: 20, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(text, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
              const SizedBox(width: 18),
            ],
          ],
        ),
      ],
    );
  }
}
