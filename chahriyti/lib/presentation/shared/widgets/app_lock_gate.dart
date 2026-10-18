import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/di/injection.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

/// Covers the whole app with a lock screen when the app lock is on: at launch,
/// and when coming back after the chosen delay. Also blurs the screen while
/// the app is in the background, so balances don't show in the app switcher.
class AppLockGate extends StatefulWidget {
  final Widget child;

  const AppLockGate({super.key, required this.child});

  @override
  State<AppLockGate> createState() => _AppLockGateState();
}

class _AppLockGateState extends State<AppLockGate> with WidgetsBindingObserver {
  final _lock = Injection.appLockService;
  bool _checking = true;
  bool _locked = false;
  bool _obscured = false;
  DateTime? _leftAt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _lockIfEnabled();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _lockIfEnabled() async {
    final enabled = await _lock.isEnabled();
    if (!mounted) return;
    setState(() {
      _checking = false;
      _locked = enabled;
    });
    if (enabled) _unlock();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // The system prompt itself sends the app to the background
    if (_lock.isAuthenticating) return;

    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        setState(() => _obscured = true);
      case AppLifecycleState.paused:
        _leftAt ??= DateTime.now();
        setState(() => _obscured = true);
      case AppLifecycleState.resumed:
        _onResume();
      case AppLifecycleState.detached:
        break;
    }
  }

  Future<void> _onResume() async {
    final leftAt = _leftAt;
    _leftAt = null;
    if (!_locked && leftAt != null && await _lock.isEnabled()) {
      final away = DateTime.now().difference(leftAt).inSeconds;
      if (away >= await _lock.delaySeconds()) {
        setState(() {
          _locked = true;
          _obscured = false;
        });
        _unlock();
        return;
      }
    }
    if (mounted) setState(() => _obscured = false);
  }

  Future<void> _unlock() async {
    final ok = await _lock.authenticate(context.l10n.appLockReason);
    if (ok && mounted) setState(() => _locked = false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_checking || _locked)
          Positioned.fill(
            child: _checking
                ? const ColoredBox(color: AppColors.background)
                : _LockScreen(onUnlock: _unlock),
          )
        else if (_obscured)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: ColoredBox(
                  color: AppColors.background.withValues(alpha: 0.4)),
            ),
          ),
      ],
    );
  }
}

class _LockScreen extends StatelessWidget {
  final VoidCallback onUnlock;

  const _LockScreen({required this.onUnlock});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Material(
      color: AppColors.background,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(IconsaxPlusBold.lock,
                    size: 40, color: AppColors.primary),
              ),
              const SizedBox(height: 24),
              Text(l10n.appLockedTitle,
                  style: AppTypography.headlineSmall,
                  textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(
                l10n.appLockedSubtitle,
                style: AppTypography.bodyMedium
                    .copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: onUnlock,
                  icon: const Icon(IconsaxPlusBold.finger_scan),
                  label: Text(l10n.appUnlock),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
