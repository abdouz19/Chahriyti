import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/injection.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../cubits/salary_split_cubit.dart';
import '../cubits/salary_split_state.dart';
import '../widgets/balance_preview_card.dart';

class SalarySplitPage extends StatelessWidget {
  final int cycleId;
  final int salaryAmount;
  final VoidCallback onComplete;
  final bool isAutoEntry;

  const SalarySplitPage({
    super.key,
    required this.cycleId,
    required this.salaryAmount,
    required this.onComplete,
    this.isAutoEntry = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SalarySplitCubit(
        depositSalarySplitUseCase: Injection.depositSalarySplitUseCase,
        cycleId: cycleId,
        salaryAmount: salaryAmount,
      ),
      child: _SalarySplitView(onComplete: onComplete, isAutoEntry: isAutoEntry),
    );
  }
}

class _SalarySplitView extends StatefulWidget {
  final VoidCallback onComplete;
  final bool isAutoEntry;

  const _SalarySplitView({required this.onComplete, required this.isAutoEntry});

  @override
  State<_SalarySplitView> createState() => _SalarySplitViewState();
}

class _SalarySplitViewState extends State<_SalarySplitView> {
  final _controller = TextEditingController(text: '0');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SalarySplitCubit, SalarySplitState>(
      listener: (context, state) {
        state.whenOrNull(
          complete: () {
            widget.onComplete();
            if (context.mounted) {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/home');
              }
            }
          },
          error: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: AppColors.negative,
              ),
            );
          },
        );
      },
      child: PopScope(
        canPop: !widget.isAutoEntry,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'تقسيم الراتب',
              style: AppTypography.headlineSmall,
            ),
            automaticallyImplyLeading: !widget.isAutoEntry,
          ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'كم تريد أن تدخر من راتبك؟',
                  style: AppTypography.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'حدد المبلغ الذي تريد تحويله مباشرة إلى المدخرات',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                // Balance preview card
                BlocBuilder<SalarySplitCubit, SalarySplitState>(
                  buildWhen: (prev, curr) =>
                      curr is SalarySplitEditing || curr is SalarySplitInitial,
                  builder: (context, state) {
                    return state.maybeWhen(
                      editing: (salary, allocation, remaining) =>
                          BalancePreviewCard(
                        salaryAmount: salary,
                        allocationAmount: allocation,
                        remainingBalance: remaining,
                      ),
                      orElse: () => const SizedBox.shrink(),
                    );
                  },
                ),
                const SizedBox(height: 24),
                // Input field
                TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  textAlign: TextAlign.center,
                  style: AppTypography.amountLarge.copyWith(
                    color: AppColors.primary,
                  ),
                  decoration: InputDecoration(
                    hintText: '0',
                    suffixText: 'دج',
                    suffixStyle: AppTypography.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: AppColors.primary, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  onChanged: (value) {
                    final amount = int.tryParse(value) ?? 0;
                    context.read<SalarySplitCubit>().updateAllocation(amount);
                  },
                ),
                const Spacer(),
                // Confirm button
                BlocBuilder<SalarySplitCubit, SalarySplitState>(
                  builder: (context, state) {
                    final isConfirming = state is SalarySplitConfirming;
                    return FilledButton(
                      onPressed: isConfirming
                          ? null
                          : () {
                              final amount =
                                  int.tryParse(_controller.text) ?? 0;
                              context
                                  .read<SalarySplitCubit>()
                                  .confirmSplit(amount);
                            },
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isConfirming
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'تأكيد',
                              style: AppTypography.labelLarge
                                  .copyWith(color: Colors.white),
                            ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                // Skip button
                TextButton(
                  onPressed: () {
                    context.read<SalarySplitCubit>().skip();
                  },
                  child: Text(
                    'تخطي',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }
}
