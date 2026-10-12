import 'package:flutter/material.dart';

import '../../../core/extensions/l10n_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/storage/app_secure_storage.dart';

/// One stop of the tour: the widget to highlight and what to say about it.
class TourStep {
  final GlobalKey target;
  final IconData icon;
  final String title;
  final String body;

  /// Target lives in the app bar: scroll to the top to show it.
  final bool atTop;

  const TourStep({
    required this.target,
    required this.icon,
    required this.title,
    required this.body,
    this.atTop = false,
  });
}

/// First-visit guided tour: dims the screen, cuts a spotlight around each
/// target and explains it in a card, with next / back / skip.
class FeatureTour {
  FeatureTour._();

  static const _storage = appSecureStorage;
  static const _seenKey = 'chahriyti_tour_seen';

  static Future<bool> hasSeen() async =>
      (await _storage.read(key: _seenKey)) == 'true';

  static Future<void> markSeen() =>
      _storage.write(key: _seenKey, value: 'true');


  /// Shown once, ever: marked as seen before it appears, so closing the app
  /// mid-tour doesn't bring it back.
  static Future<void> show(
    BuildContext context, {
    required List<TourStep> steps,
    required ScrollController scrollController,
    VoidCallback? onClosed,
  }) async {
    await markSeen();
    if (!context.mounted) return;
    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _TourOverlay(
        steps: steps,
        scrollController: scrollController,
        onFinish: () {
          entry.remove();
          onClosed?.call();
        },
      ),
    );
    Overlay.of(context, rootOverlay: true).insert(entry);
  }
}

class _TourOverlay extends StatefulWidget {
  final List<TourStep> steps;
  final ScrollController scrollController;
  final VoidCallback onFinish;

  const _TourOverlay({
    required this.steps,
    required this.scrollController,
    required this.onFinish,
  });

  @override
  State<_TourOverlay> createState() => _TourOverlayState();
}

class _TourOverlayState extends State<_TourOverlay> {
  int _index = 0;
  Rect? _rect;
  bool _moving = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _goTo(0));
  }

  Future<void> _goTo(int index) async {
    setState(() {
      _index = index;
      _moving = true;
    });
    final step = widget.steps[index];
    final targetContext = step.target.currentContext;
    if (targetContext == null) {
      // Not on screen (e.g. hidden section): skip it
      return _advance(index);
    }

    const duration = Duration(milliseconds: 350);
    if (step.atTop) {
      if (widget.scrollController.hasClients) {
        await widget.scrollController.animateTo(0,
            duration: duration, curve: Curves.easeOutCubic);
      }
    } else {
      await Scrollable.ensureVisible(targetContext,
          duration: duration, curve: Curves.easeOutCubic, alignment: 0.35);
    }
    if (!mounted) return;
    // Let the floating app bar settle before measuring
    await Future<void>.delayed(const Duration(milliseconds: 60));
    if (!mounted) return;
    final box = step.target.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return _advance(index);
    setState(() {
      _rect = box.localToGlobal(Offset.zero) & box.size;
      _moving = false;
    });
  }

  void _advance(int from) {
    if (from + 1 < widget.steps.length) {
      _goTo(from + 1);
    } else {
      widget.onFinish();
    }
  }

  void _next() => _advance(_index);

  void _back() {
    if (_index > 0) _goTo(_index - 1);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final rect = _rect?.inflate(6);
    final step = widget.steps[_index];

    // Card below the target when there's room, otherwise above it
    const cardHeightGuess = 230.0;
    final below = rect == null ||
        rect.bottom + cardHeightGuess < size.height - padding.bottom;
    final cardTop = rect == null
        ? size.height / 2 - cardHeightGuess / 2
        : below
            ? rect.bottom + 14
            : null;
    final cardBottom =
        rect != null && !below ? size.height - rect.top + 14 : null;

    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          // Dimmed background with the spotlight hole; taps go nowhere
          Positioned.fill(
            child: GestureDetector(
              onTap: () {},
              // No target measured yet: plain dim, nothing to animate from
              child: rect == null
                  ? CustomPaint(painter: _SpotlightPainter(hole: null))
                  : TweenAnimationBuilder<Rect?>(
                      tween: RectTween(begin: rect, end: rect),
                      duration: const Duration(milliseconds: 280),
                      curve: Curves.easeOutCubic,
                      builder: (_, animated, __) => CustomPaint(
                        painter: _SpotlightPainter(hole: animated),
                      ),
                    ),
            ),
          ),
          // Tapping the highlighted widget moves on
          if (rect != null && !_moving)
            Positioned.fromRect(
              rect: rect,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _next,
              ),
            ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
            left: 16,
            right: 16,
            top: cardTop,
            bottom: cardBottom,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 180),
              opacity: _moving ? 0 : 1,
              child: _TourCard(
                step: step,
                index: _index,
                total: widget.steps.length,
                onNext: _next,
                onBack: _index > 0 ? _back : null,
                onSkip: widget.onFinish,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SpotlightPainter extends CustomPainter {
  final Rect? hole;

  _SpotlightPainter({required this.hole});

  @override
  void paint(Canvas canvas, Size size) {
    final screen = Path()..addRect(Offset.zero & size);
    final dim = Paint()..color = Colors.black.withValues(alpha: 0.68);
    if (hole == null) {
      canvas.drawPath(screen, dim);
      return;
    }
    final rrect = RRect.fromRectAndRadius(hole!, const Radius.circular(18));
    canvas.drawPath(
      Path.combine(PathOperation.difference, screen, Path()..addRRect(rrect)),
      dim,
    );
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.9)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(_SpotlightPainter old) => old.hole != hole;
}

class _TourCard extends StatelessWidget {
  final TourStep step;
  final int index;
  final int total;
  final VoidCallback onNext;
  final VoidCallback? onBack;
  final VoidCallback onSkip;

  const _TourCard({
    required this.step,
    required this.index,
    required this.total,
    required this.onNext,
    required this.onBack,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isLast = index == total - 1;
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(step.icon, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(step.title,
                    style: AppTypography.labelLarge
                        .copyWith(fontWeight: FontWeight.w800, fontSize: 16)),
              ),
              Text(
                l10n.tourStepOf(index + 1, total),
                style: AppTypography.labelSmall,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            step.body,
            style: AppTypography.bodyMedium
                .copyWith(color: AppColors.textSecondary, height: 1.5),
          ),
          const SizedBox(height: 12),
          // Progress dots
          Row(
            children: [
              for (var i = 0; i < total; i++)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsetsDirectional.only(end: 4),
                  width: i == index ? 16 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: i <= index ? AppColors.primary : AppColors.border,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              if (!isLast)
                TextButton(
                  onPressed: onSkip,
                  child: Text(l10n.tourSkip,
                      style: TextStyle(color: AppColors.textSecondary)),
                ),
              const Spacer(),
              if (onBack != null)
                TextButton(onPressed: onBack, child: Text(l10n.tourBack)),
              const SizedBox(width: 4),
              ElevatedButton(
                onPressed: onNext,
                // The app theme makes buttons full-width; not inside a row
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(96, 44),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                child: Text(isLast ? l10n.tourDone : l10n.tourNext),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
