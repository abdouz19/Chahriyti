import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/offer.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/extensions/money_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

/// The sales screens shown between the welcome screen and the profile
/// questions, in order. Everyone sees the offer before sharing their details.
const salesRoutes = [
  '/onboarding/mirror',
  '/onboarding/change',
  '/onboarding/how',
  '/onboarding/offer',
];

/// Shared frame: progress dots, back arrow, fading content, bottom button.
class _SalesScaffold extends StatelessWidget {
  final int step;
  final String buttonLabel;
  final VoidCallback onNext;
  final List<Widget> children;

  const _SalesScaffold({
    required this.step,
    required this.buttonLabel,
    required this.onNext,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 24, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    color: AppColors.textSecondary,
                    onPressed: () => context.go(step == 0 ? '/' : salesRoutes[step - 1]),
                  ),
                  const Spacer(),
                  for (var i = 0; i < salesRoutes.length; i++)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsetsDirectional.only(start: 6),
                      width: i == step ? 22 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: i <= step
                            ? AppColors.primary
                            : AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 450),
                curve: Curves.easeOut,
                builder: (context, t, child) => Opacity(
                  opacity: t,
                  child: Transform.translate(offset: Offset(0, 16 * (1 - t)), child: child),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: children,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: onNext, child: Text(buttonLabel)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

TextStyle _title(BuildContext context) => AppTypography.headlineMedium.copyWith(
      fontSize: 26,
      fontWeight: FontWeight.w800,
      color: AppColors.textPrimary,
      height: 1.35,
    );

TextStyle get _body => AppTypography.bodyLarge.copyWith(
      color: AppColors.textPrimary.withValues(alpha: 0.75),
      height: 1.7,
    );

/// A big round icon that opens each screen.
class _Badge extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _Badge(this.icon, {this.color = AppColors.primary});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 32, color: color),
    );
  }
}

// ── 1. The mirror: the monthly pain, and the people who are fine today ──

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
        const _Badge(Icons.account_balance_wallet_outlined, color: AppColors.negative),
        const SizedBox(height: 24),
        Text(l10n.salesMirrorTitle, style: _title(context)),
        const SizedBox(height: 14),
        Text(l10n.salesMirrorBody, style: _body),
        const SizedBox(height: 8),
        Text(l10n.salesMirrorBody2, style: _body),
        const SizedBox(height: 28),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.salesMirrorFineTitle,
                style: AppTypography.labelLarge.copyWith(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(l10n.salesMirrorFineBody, style: _body.copyWith(fontSize: 15)),
              const SizedBox(height: 12),
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

// ── 2. The change: what the end of the month looks like after ──

class SalesChangePage extends StatelessWidget {
  const SalesChangePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final items = [
      (Icons.visibility_outlined, l10n.salesChange1),
      (Icons.trending_down_rounded, l10n.salesChange2),
      (Icons.flag_outlined, l10n.salesChange3),
      (Icons.nightlight_outlined, l10n.salesChange4),
    ];
    return _SalesScaffold(
      step: 1,
      buttonLabel: l10n.salesNext,
      onNext: () => context.go(salesRoutes[2]),
      children: [
        const _Badge(Icons.wb_sunny_outlined, color: AppColors.positive),
        const SizedBox(height: 24),
        Text(l10n.salesChangeTitle, style: _title(context)),
        const SizedBox(height: 24),
        for (final item in items)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.positive.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(item.$1, size: 20, color: AppColors.positive),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    item.$2,
                    style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// ── 3. How: the book and the app work together ──

class SalesHowPage extends StatelessWidget {
  const SalesHowPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final rows = [
      (Icons.menu_book_rounded, l10n.salesHowBook),
      (Icons.phone_android_rounded, l10n.salesHowApp),
      (Icons.vpn_key_rounded, l10n.salesHowCode),
    ];
    return _SalesScaffold(
      step: 2,
      buttonLabel: l10n.salesNext,
      onNext: () => context.go(salesRoutes[3]),
      children: [
        Center(
          child: Image.asset(
            'assets/illustrations/order_book_app.png',
            height: 220,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 20),
        Text(l10n.salesHowTitle, style: _title(context)),
        const SizedBox(height: 20),
        for (final row in rows)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(row.$1, color: AppColors.primary),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    row.$2,
                    style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// ── 4. The offer: price last, framed as small next to the result ──

class SalesOfferPage extends StatelessWidget {
  const SalesOfferPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final symbol = l10n.currencySymbol;
    return _SalesScaffold(
      step: 3,
      buttonLabel: l10n.salesOfferCta,
      onNext: () => context.go('/onboarding/profile'),
      children: [
        Center(
          child: Image.asset(
            'assets/illustrations/order_book_app.png',
            height: 170,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: Text(
            l10n.salesOfferTitle,
            style: _title(context),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 18),
        Container(
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
            children: [
              Text(
                l10n.salesOfferPrice(offerPrice.toDZDString(symbol: symbol)),
                style: AppTypography.amountLarge.copyWith(color: AppColors.primary, fontSize: 26),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.salesOfferPerDay(offerPricePerDay.toDZDString(symbol: symbol)),
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.positive,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(height: 1, color: AppColors.divider),
              ),
              Row(
                children: [
                  for (final item in [
                    (Icons.payments_outlined, l10n.salesOfferCod),
                    (Icons.local_shipping_outlined, l10n.salesOfferDelivery),
                  ])
                    Expanded(
                      child: Column(
                        children: [
                          Icon(item.$1, color: AppColors.primary),
                          const SizedBox(height: 6),
                          Text(
                            item.$2,
                            style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
