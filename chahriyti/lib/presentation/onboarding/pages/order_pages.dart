import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/delivery.dart';
import '../../../core/constants/offer.dart';
import '../../../core/constants/wilayas.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/extensions/money_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../infrastructure/services/lead_service.dart';
import '../../../infrastructure/services/lead_storage.dart';
import '../widgets/commune_picker_sheet.dart';
import '../widgets/wilaya_picker_sheet.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../../core/theme/app_icons.dart';

// ── Order form: same fields and prices as the website's order form ──

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  Wilaya? _wilaya;
  String? _commune;
  DeliveryType? _delivery;
  bool _sending = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  int? get _fee => _wilaya == null || _delivery == null
      ? null
      : deliveryFee(_wilaya!.code, _delivery!);

  void _pickWilaya() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => WilayaPickerSheet(
        onSelected: (w) => setState(() {
          _wilaya = w;
          _commune = null;
          // Prices change with the wilaya: choose again, like the website
          _delivery = null;
        }),
      ),
    );
  }

  void _pickCommune() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CommunePickerSheet(
        wilayaCode: _wilaya!.code,
        onSelected: (c) => setState(() => _commune = c),
      ),
    );
  }

  void _toast(String message, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? AppColors.negative : null,
      ),
    );
  }

  Future<void> _submit() async {
    final l10n = context.l10n;
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    if (name.isEmpty) return _toast(l10n.profileNameRequired);
    if (!RegExp(r'^0[567]\d{8}$').hasMatch(phone)) {
      return _toast(l10n.profilePhoneInvalid);
    }
    if (_wilaya == null) return _toast(l10n.profileWilayaRequired);
    if (_commune == null) return _toast(l10n.profileCommuneRequired);
    final fee = _fee;
    if (fee == null) return _toast(l10n.orderDeliveryRequired);

    setState(() => _sending = true);
    try {
      String? fcmToken;
      try {
        // Optional, and can hang offline
        fcmToken = await FirebaseMessaging.instance.getToken().timeout(
          const Duration(seconds: 5),
        );
      } catch (_) {}

      await LeadService().submitOrder(
        name: name,
        phone: phone,
        wilayaCode: _wilaya!.code,
        commune: _commune!,
        deliveryType: _delivery!.apiValue,
        deliveryFee: fee,
        bookPrice: offerPrice,
        fcmToken: fcmToken,
      );
      // Saved only once the server has it: reopening shows the thank-you page
      await const LeadStorage().saveOrder(
        name: name,
        phone: phone,
        wilayaCode: _wilaya!.code,
        commune: _commune!,
        deliveryType: _delivery!.apiValue,
        total: offerPrice + fee,
      );
      if (mounted) context.go('/onboarding/thanks');
    } catch (e) {
      debugPrint('🛒 order submission failed: $e');
      if (!mounted) return;
      setState(() => _sending = false);
      _toast(l10n.orderSendFailed, error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final symbol = l10n.currencySymbol;
    final fees = _wilaya == null ? null : deliveryFees[_wilaya!.code];
    final fee = _fee;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: IconButton(
                  icon: const Icon(AppIcons.back),
                  color: AppColors.textSecondary,
                  onPressed: () => context.go('/onboarding/offer'),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                children: [
                  Text(
                    l10n.orderTitle,
                    style: AppTypography.headlineLarge.copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.orderSubtitle,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _Label(l10n.salarySetupFullName),
                  TextField(
                    controller: _nameController,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(hintText: l10n.profileNameHint),
                  ),
                  const SizedBox(height: 18),
                  _Label(l10n.profilePhoneLabel),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    decoration: const InputDecoration(
                      hintText: '07XXXXXXXX',
                      counterText: '',
                    ),
                  ),
                  const SizedBox(height: 18),
                  _Label(l10n.profileWhereQuestion),
                  _PickerField(
                    text: _wilaya == null
                        ? null
                        : '${_wilaya!.code} - ${_wilaya!.arabicName}',
                    placeholder: l10n.profileWilayaPlaceholder,
                    onTap: _pickWilaya,
                  ),
                  if (_wilaya != null) ...[
                    const SizedBox(height: 18),
                    _Label(l10n.profileCommuneLabel),
                    _PickerField(
                      text: _commune,
                      placeholder: l10n.profileCommunePlaceholder,
                      onTap: _pickCommune,
                    ),
                  ],
                  const SizedBox(height: 24),
                  _Label(l10n.orderDeliveryTitle),
                  if (_wilaya == null)
                    Text(
                      l10n.orderDeliveryPickWilaya,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    )
                  else if (fees == null)
                    Text(
                      l10n.orderDeliveryNone,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.negative,
                      ),
                    )
                  else
                    Row(
                      children: [
                        for (final type in [
                          DeliveryType.desk,
                          DeliveryType.home,
                        ]) ...[
                          if (type == DeliveryType.home)
                            const SizedBox(width: 12),
                          Expanded(
                            child: _DeliveryCard(
                              icon: type == DeliveryType.desk
                                  ? IconsaxPlusLinear.shop
                                  : IconsaxPlusLinear.home_2,
                              label: type == DeliveryType.desk
                                  ? l10n.orderDeliveryDesk
                                  : l10n.orderDeliveryHome,
                              price: deliveryFee(
                                _wilaya!.code,
                                type,
                              )?.toDZDString(symbol: symbol),
                              unavailableLabel: l10n.orderDeliveryUnavailable,
                              selected: _delivery == type,
                              onTap: () => setState(() => _delivery = type),
                            ),
                          ),
                        ],
                      ],
                    ),
                  const SizedBox(height: 24),
                  // What the total is made of; the total itself sits above the button
                  _PriceRow(
                    l10n.orderBookLine,
                    offerPrice.toDZDString(symbol: symbol),
                  ),
                  const SizedBox(height: 8),
                  _PriceRow(
                    l10n.orderDeliveryLine,
                    fee?.toDZDString(symbol: symbol) ?? '—',
                  ),
                ],
              ),
            ),
            // Pinned: the total stays in view while filling the form
            Container(
              padding: const EdgeInsets.fromLTRB(24, 14, 24, 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: AppColors.divider)),
              ),
              child: Column(
                children: [
                  _PriceRow(
                    l10n.orderTotalLine,
                    fee == null
                        ? '—'
                        : (offerPrice + fee).toDZDString(symbol: symbol),
                    bold: true,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _sending ? null : _submit,
                      child: _sending
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : Text(l10n.orderSubmit),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w700),
    ),
  );
}

class _PickerField extends StatelessWidget {
  final String? text;
  final String placeholder;
  final VoidCallback onTap;

  const _PickerField({
    required this.text,
    required this.placeholder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text ?? placeholder,
                style: AppTypography.bodyMedium.copyWith(
                  color: text != null
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                ),
              ),
            ),
            const Icon(
              IconsaxPlusLinear.arrow_down_1,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _DeliveryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? price;
  final String unavailableLabel;
  final bool selected;
  final VoidCallback onTap;

  const _DeliveryCard({
    required this.icon,
    required this.label,
    required this.price,
    required this.unavailableLabel,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final available = price != null;
    return Opacity(
      opacity: available ? 1 : 0.45,
      child: InkWell(
        onTap: available ? onTap : null,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary.withValues(alpha: 0.08)
                : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: selected ? AppColors.primary : AppColors.textSecondary,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                price ?? unavailableLabel,
                style: AppTypography.bodySmall.copyWith(
                  color: selected ? AppColors.primary : AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  const _PriceRow(this.label, this.value, {this.bold = false});

  @override
  Widget build(BuildContext context) {
    final style = bold
        ? AppTypography.labelLarge.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          )
        : AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary);
    return Row(
      children: [
        Expanded(child: Text(label, style: style)),
        Text(
          value,
          style: style.copyWith(
            color: bold ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

// ── Thank you: shown until they start activating (also after reopening) ──

class OrderThanksPage extends StatelessWidget {
  const OrderThanksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>?>(
          future: const LeadStorage().loadOrder(),
          builder: (context, snapshot) {
            final order = snapshot.data;
            final firstName = (order?['name'] as String? ?? '')
                .split(' ')
                .first;
            final phone = order?['phone'] as String? ?? '';
            final steps = [
              (IconsaxPlusBold.call_calling, l10n.thanksCall(phone)),
              (IconsaxPlusBold.truck, l10n.thanksStep2),
              (IconsaxPlusBold.flash, l10n.thanksStep3),
            ];
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
                    children: [
                      // The order landed: the mark pops in once
                      Center(
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(
                            begin: MediaQuery.of(context).disableAnimations ? 1 : 0,
                            end: 1,
                          ),
                          duration: const Duration(milliseconds: 900),
                          curve: Curves.elasticOut,
                          builder: (context, t, child) =>
                              Transform.scale(scale: t, child: child),
                          child: Container(
                            width: 88,
                            height: 88,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              IconsaxPlusLinear.check,
                              size: 46,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        l10n.thanksTitle(firstName),
                        textAlign: TextAlign.center,
                        style: AppTypography.headlineLarge.copyWith(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Image.asset(
                          'assets/illustrations/order_book_app.png',
                          height: 150,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        l10n.nextStepsTitle,
                        style: AppTypography.labelLarge.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 14),
                      for (var i = 0; i < steps.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: i == 0
                                      ? AppColors.primary
                                      : AppColors.primary.withValues(
                                          alpha: 0.1,
                                        ),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  steps[i].$1,
                                  size: 18,
                                  color: i == 0
                                      ? Colors.white
                                      : AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  steps[i].$2,
                                  style: AppTypography.bodyMedium.copyWith(
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => context.go('/onboarding/quick-setup'),
                      child: Text(l10n.thanksActivate),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
