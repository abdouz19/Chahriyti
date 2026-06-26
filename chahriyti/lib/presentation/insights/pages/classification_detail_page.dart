import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../shared/widgets/classification_badge.dart';
import '../cubits/insights_cubit.dart';

class ClassificationDetailPage extends StatelessWidget {
  final int cycleId;

  const ClassificationDetailPage({
    required this.cycleId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => InsightsCubit(
        calculateFinancialClassificationUseCase:
            Injection.calculateFinancialClassificationUseCase,
      )..loadClassification(cycleId),
      child: const _ClassificationDetailView(),
    );
  }
}

class _ClassificationDetailView extends StatelessWidget {
  const _ClassificationDetailView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'تصنيفك المالي',
          style: AppTypography.headlineSmall,
        ),
      ),
      body: BlocBuilder<InsightsCubit, InsightsState>(
        builder: (context, state) {
          if (state is InsightsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is ClassificationLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClassificationBadge(
                    classification: state.classification,
                    savingsRate: state.savingsRate,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'شرح التصنيف',
                    style: AppTypography.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  _buildExplanation(state.classification),
                  const SizedBox(height: 24),
                  Text(
                    'كيفية التحسين',
                    style: AppTypography.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  _buildImprovement(state.classification),
                  const SizedBox(height: 24),
                  Text(
                    'إحصائياتك',
                    style: AppTypography.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  _buildStats(state),
                  const SizedBox(height: 32),
                ],
              ),
            );
          }

          if (state is InsightsError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      size: 48,
                      color: AppColors.negative,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: AppTypography.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildExplanation(classification) {
    String explanation;
    switch (classification) {
      case 'legendarySaver':
        explanation =
            'أنت في أعلى المستويات! تدير أموالك بكفاءة عالية وتحقق أهدافك المالية.';
        break;
      case 'smartSaver':
        explanation = 'تتخذ قرارات مالية ذكية وتحقق معدل ادخار جيد.';
        break;
      case 'balanced':
        explanation =
            'إدارتك للمصاريف متوازنة. استمر في المراقبة الدقيقة.';
        break;
      case 'spendthrift':
        explanation = 'تصرف أسرع من اللازم. حاول تقليل المصاريف الاختيارية.';
        break;
      case 'danger':
        explanation =
            'تحتاج إلى التحكم بأفضل طريقة. احذر من نفاد الرصيد.';
        break;
      case 'earlyBankruptcy':
        explanation =
            'أنفقت أكثر من دخلك. تحرك الآن لإصلاح الوضع!';
        break;
      default:
        explanation = '';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        explanation,
        style: AppTypography.bodyMedium,
      ),
    );
  }

  Widget _buildImprovement(classification) {
    String? suggestion;
    List<String> tips = [];

    switch (classification) {
      case 'legendarySaver':
        suggestion = 'الحفاظ على المستوى الحالي';
        tips = [
          'استثمر فائض أموالك',
          'ساعد الآخرين مالياً',
          'شارك تجربتك مع من تحب',
        ];
        break;
      case 'smartSaver':
        suggestion = 'زيادة معدل الادخار';
        tips = [
          'قلل المصاريف الاختيارية',
          'ابحث عن مصادر دخل إضافية',
          'راقب الإنفاق أسبوعياً',
        ];
        break;
      case 'balanced':
        suggestion = 'المحافظة على التوازن';
        tips = [
          'راقب المصاريف الزائدة',
          'خطط لفترات الطوارئ',
          'حدد أهداف مالية واضحة',
        ];
        break;
      case 'spendthrift':
        suggestion = 'التحكم في الإنفاق';
        tips = [
          'ضع قائمة للمشتريات قبل التسوق',
          'تجنب الشراء العشوائي',
          'حدد ميزانية يومية',
        ];
        break;
      case 'danger':
        suggestion = 'خفض الإنفاق بشكل حتمي';
        tips = [
          'أوقف المشتريات غير الضرورية',
          'راجع كل مصروف يومي',
          'اطلب مساعدة مالية إن لزم',
        ];
        break;
      case 'earlyBankruptcy':
        suggestion = 'تصرف سريع ضروري';
        tips = [
          'حدد المصاريف الحتمية فقط',
          'ابحث عن مصادر دخل إضافية',
          'أعد هيكلة ميزانيتك كاملة',
        ];
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            suggestion ?? '',
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          ...tips.map(
            (tip) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.positive,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      tip,
                      style: AppTypography.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(ClassificationLoaded state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text(
                'معدل الادخار',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${state.savingsRate.toStringAsFixed(1)}%',
                style: AppTypography.headlineSmall.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
