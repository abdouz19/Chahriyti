import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

/// One salary month as 30 day-pills, salary day first. The pills fill in one
/// after another; with [runsOutAt] the money stops there and the remaining
/// days stay empty, otherwise the month makes it to the end with the last
/// days marked as money left over.
class MonthBar extends StatefulWidget {
  /// Day (1–30) the money runs out, or null when it lasts the whole month
  final int? runsOutAt;
  final String startLabel;
  final String endLabel;

  /// Shown above the day the money runs out, or above the left-over days
  final String markerLabel;

  const MonthBar({
    super.key,
    this.runsOutAt,
    required this.startLabel,
    required this.endLabel,
    required this.markerLabel,
  });

  @override
  State<MonthBar> createState() => _MonthBarState();
}

class _MonthBarState extends State<MonthBar> with SingleTickerProviderStateMixin {
  static const _days = 30;
  static const _leftOverDays = 4;
  static const _gold = Color(0xFFD4A017);

  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1600));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Respect "reduce motion": show the finished month straight away
    if (MediaQuery.of(context).disableAnimations) {
      _controller.value = 1;
    } else if (!_controller.isAnimating && _controller.value == 0) {
      Future.delayed(const Duration(milliseconds: 250), () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final runsOut = widget.runsOutAt;
    final lastFilled = runsOut ?? _days;
    final markerColor = runsOut != null ? AppColors.negative : _gold;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = Curves.easeOutCubic.transform(_controller.value);
        final reached = (t * lastFilled).ceil();
        final markerOpacity = ((t - 0.85) / 0.15).clamp(0.0, 1.0);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Label above the marker day, fades in once the bar gets there
            Opacity(
              opacity: markerOpacity,
              child: Align(
                alignment: runsOut != null
                    ? AlignmentDirectional(-1 + 2 * (runsOut - 0.5) / _days, 0)
                    : AlignmentDirectional.centerEnd,
                child: Text(
                  widget.markerLabel,
                  style: AppTypography.bodySmall.copyWith(
                    color: markerColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 46,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (var day = 1; day <= _days; day++) ...[
                    if (day > 1) const SizedBox(width: 3),
                    Expanded(child: _pill(day, reached, runsOut)),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(widget.startLabel,
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                const Spacer(),
                Text(widget.endLabel,
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _pill(int day, int reached, int? runsOut) {
    final isMarker = runsOut == day;
    final filled = day <= reached;
    Color color;
    if (runsOut != null && day > runsOut) {
      // Days after the money ran out: an empty, faint outline
      color = AppColors.negative.withValues(alpha: 0.12);
    } else if (!filled) {
      color = AppColors.divider;
    } else if (isMarker) {
      color = AppColors.negative;
    } else if (runsOut == null && day > _days - _leftOverDays) {
      color = _gold;
    } else {
      color = AppColors.primary;
    }
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      // The marker day stands taller so the eye lands on it
      height: isMarker && filled ? 46 : 34,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
    );
  }
}
