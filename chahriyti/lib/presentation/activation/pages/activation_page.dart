import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/constants/wilayas.dart';
import '../../../core/di/injection.dart';
import '../../../core/extensions/l10n_extension.dart';
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
  @override
  Widget build(BuildContext context) {
    return BlocListener<ActivationCubit, ActivationState>(
      listener: (context, state) async {
        if (state is ActivationSuccess) {
          final cycle =
              await Injection.cycleRepository.getActiveCycle();
          if (cycle != null && context.mounted) {
            context.go('/salary-split', extra: {
              'cycleId': cycle.id,
              'salaryAmount': cycle.salaryAmount,
              'onComplete': () {
                if (context.mounted) context.go('/home');
              },
            });
          } else if (context.mounted) {
            context.go('/home');
          }
        } else if (state is ActivationAlreadyUsed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.licenseAlreadyUsed),
              backgroundColor: AppColors.negative,
            ),
          );
        } else if (state is ActivationNetworkError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.warning,
            ),
          );
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
          title: Text(context.l10n.activationTitle),
          automaticallyImplyLeading: false,
          leading: context.canPop()
              ? IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back_ios_rounded),
                  tooltip: context.l10n.editData,
                )
              : null,
          actions: [
            BlocBuilder<ActivationCubit, ActivationState>(
              builder: (context, state) {
                return IconButton(
                  onPressed: () => _showDeviceId(context, state),
                  icon: const Icon(
                    Icons.fingerprint_rounded,
                    color: AppColors.primary,
                  ),
                  tooltip: context.l10n.chahriytiNumber,
                );
              },
            ),
          ],
        ),
        body: SafeArea(
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
                  _buildUserInfoSection(context),
                  const SizedBox(height: 16),
                  _buildLicenseSection(context, state),
                  const SizedBox(height: 24),
                  _buildBuyLink(context),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoSection(BuildContext context) {
    return FutureBuilder(
      future: Injection.userRepository.getUser(),
      builder: (context, snapshot) {
        final user = snapshot.data;
        if (user == null) {
          return const SizedBox.shrink();
        }
        final wilaya = Wilayas.all.firstWhere(
          (w) => w.code == user.wilayaCode,
          orElse: () => Wilaya(0, context.l10n.unknown),
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
                  context.l10n.yourData,
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _InfoRow(label: context.l10n.name, value: user.fullName),
            const SizedBox(height: 8),
            _InfoRow(label: context.l10n.phone, value: user.phoneNumber),
            const SizedBox(height: 8),
            _InfoRow(
              label: context.l10n.wilaya,
              value: '${wilaya.code} - ${wilaya.arabicName}',
            ),
          ],
        );
      },
    );
  }

  void _showDeviceId(BuildContext context, ActivationState state) {
    final deviceId = state is ActivationReady
        ? state.deviceId.displayFormat
        : context.read<ActivationCubit>().deviceId?.displayFormat ?? '...';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
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
                    Icons.fingerprint_rounded,
                    size: 20,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  context.l10n.chahriytiNumber,
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
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
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(context.l10n.copiedChahriytiNumber),
                          duration: const Duration(seconds: 2),
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
        ),
      ),
    );
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
                context.l10n.haveActivationKey,
                style: AppTypography.labelLarge,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          context.l10n.activationKeyDesc,
          style: AppTypography.bodySmall,
        ),
        const SizedBox(height: 16),
        // QR Scan button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _openQrScanner(context),
            icon: const Icon(Icons.qr_code_scanner_rounded, size: 20),
            label: Text(context.l10n.scanQrCode),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(height: 10),
        // Manual entry button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => BlocProvider.value(
                  value: context.read<ActivationCubit>(),
                  child: const LicenseKeyDialog(),
                ),
              );
            },
            icon: const Icon(Icons.keyboard_rounded, size: 20),
            label: Text(context.l10n.enterKeyManually),
          ),
        ),
      ],
    );
  }

  Future<void> _openStore() async {
    try {
      final response = await http.get(Uri.parse(
        'https://us-central1-chahriyati.cloudfunctions.net/getAppConfig',
      ));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final url = data['data']?['storeUrl'] as String?;
        if (url != null && url.isNotEmpty && mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => _StoreWebViewPage(
                url: url,
                title: context.l10n.getChahriyti,
              ),
            ),
          );
          return;
        }
      }
    } catch (_) {}
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.cannotOpenPage)),
      );
    }
  }

  Widget _buildBuyLink(BuildContext context) {
    return GestureDetector(
      onTap: _openStore,
      child: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            children: [
              TextSpan(text: context.l10n.buyBookLink),
              TextSpan(
                text: context.l10n.buyBookLinkHere,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openQrScanner(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _QrScannerSheet(
        title: context.l10n.scanQrForLicense,
        hint: context.l10n.scanQrHint,
        onScanned: (key) {
          Navigator.of(context).pop();
          context.read<ActivationCubit>().validateLicense(key);
        },
      ),
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

// ---------------------------------------------------------------------------
// QR Scanner Bottom Sheet
// ---------------------------------------------------------------------------

class _QrScannerSheet extends StatefulWidget {
  final String title;
  final String hint;
  final void Function(String licenseKey) onScanned;

  const _QrScannerSheet({
    required this.title,
    required this.hint,
    required this.onScanned,
  });

  @override
  State<_QrScannerSheet> createState() => _QrScannerSheetState();
}

class _QrScannerSheetState extends State<_QrScannerSheet> {
  final MobileScannerController _controller = MobileScannerController();
  bool _scanned = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white38,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              children: [
                const Icon(Icons.qr_code_scanner_rounded,
                    color: Colors.white, size: 24),
                const SizedBox(width: 12),
                Text(
                  widget.title,
                  style: AppTypography.labelLarge.copyWith(color: Colors.white),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
          ),
          // Scanner
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: MobileScanner(
                  controller: _controller,
                  onDetect: (capture) {
                    if (_scanned) return;
                    final barcodes = capture.barcodes;
                    for (final barcode in barcodes) {
                      final value = barcode.rawValue;
                      if (value != null &&
                          value.toUpperCase().startsWith('CHRY-')) {
                        _scanned = true;
                        widget.onScanned(value.toUpperCase());
                        return;
                      }
                    }
                  },
                ),
              ),
            ),
          ),
          // Hint
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              widget.hint,
              style: AppTypography.bodySmall.copyWith(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Store WebView Page
// ---------------------------------------------------------------------------

class _StoreWebViewPage extends StatefulWidget {
  final String url;
  final String title;
  const _StoreWebViewPage({required this.url, required this.title});

  @override
  State<_StoreWebViewPage> createState() => _StoreWebViewPageState();
}

class _StoreWebViewPageState extends State<_StoreWebViewPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
