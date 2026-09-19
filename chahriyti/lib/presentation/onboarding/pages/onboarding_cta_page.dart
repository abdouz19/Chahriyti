import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class OnboardingCtaPage extends StatefulWidget {
  const OnboardingCtaPage({super.key});

  @override
  State<OnboardingCtaPage> createState() => _OnboardingCtaPageState();
}

class _OnboardingCtaPageState extends State<OnboardingCtaPage> {
  bool _isLoading = false;

  Future<void> _openStore() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(Uri.parse(
        'https://us-central1-chahriyati.cloudfunctions.net/getAppConfig',
      ));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final url = data['data']?['storeUrl'] as String?;
        if (url != null && url.isNotEmpty && mounted) {
          setState(() => _isLoading = false);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => _StoreWebViewPage(url: url),
            ),
          );
          return;
        }
      }
    } catch (_) {}
    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تعذر فتح الصفحة. حاول مرة أخرى.'),
          backgroundColor: AppColors.negative,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  const SizedBox(height: 24),
                  // Hero illustration
                  Center(
                    child: Image.asset(
                      'assets/illustrations/225 copy.png',
                      height: 220,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 28),
                  // Hook text
                  Text(
                    'معظم الناس يحمّلون التطبيقات... ثم ينسونها.',
                    textAlign: TextAlign.center,
                    style: AppTypography.headlineSmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Identity text
                  Text(
                    'أما أنت، فستبدأ رحلة تغيير حقيقية.',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Offer description
                  Text(
                    'كتاب «المال لا يحب الفوضى» + كود التفعيل سيأخذانك في تجربة متكاملة، ويمنحانك العقلية والعادات التي تحتاجها لتنظيم حياتك المالية.',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Payment note
                  Text(
                    'والدفع عند الاستلام.',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            // Buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _openStore,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('اطلب نسختك الآن'),
                ),
              ),
            ),
            TextButton(
              onPressed: () => context.go('/onboarding/salary'),
              child: Text(
                'لدي بالفعل كود التفعيل ←',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Store WebView Page
// ---------------------------------------------------------------------------

class _StoreWebViewPage extends StatefulWidget {
  final String url;
  const _StoreWebViewPage({required this.url});

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
        title: const Text('احصل على شهريتي'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
