// import 'package:flutter/material.dart';

// import '../../../core/theme/app_colors.dart';
// import '../../../core/theme/app_typography.dart';
// import '../../../infrastructure/services/oem_battery_service.dart';

// class OemBatteryDialog extends StatelessWidget {
//   const OemBatteryDialog({super.key});

//   static Future<void> showIfNeeded(BuildContext context) async {
//     final should = await OemBatteryService.shouldShowPrompt();
//     if (!should || !context.mounted) return;
//     await OemBatteryService.markPromptShown();
//     if (!context.mounted) return;
//     await showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => const OemBatteryDialog(),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       title: Text(
//         'فعّل التنبيهات بشكل كامل 🔔',
//         style: AppTypography.headlineSmall,
//         textAlign: TextAlign.center,
//       ),
//       content: Text(
//         'جهازك يمنع التنبيهات المجدولة تلقائياً.\n\nفعّل "التشغيل التلقائي" للتطبيق لضمان وصول التنبيهات في الوقت المحدد.',
//         style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
//         textAlign: TextAlign.center,
//       ),
//       actionsAlignment: MainAxisAlignment.center,
//       actions: [
//         OutlinedButton(
//           onPressed: () => Navigator.of(context).pop(),
//           child: const Text('لاحقاً'),
//         ),
//         ElevatedButton(
//           onPressed: () async {
//             Navigator.of(context).pop();
//             await OemBatteryService.openAutoStartSettings();
//           },
//           style: ElevatedButton.styleFrom(
//             backgroundColor: AppColors.primary,
//           ),
//           child: const Text('فتح الإعدادات'),
//         ),
//       ],
//     );
//   }
// }
