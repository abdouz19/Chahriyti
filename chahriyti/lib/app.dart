import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';
import 'presentation/settings/cubits/locale_cubit.dart';
import 'presentation/shared/routing/app_router.dart';
import 'presentation/shared/widgets/app_lock_gate.dart';
import 'core/storage/app_secure_storage.dart';

class ChahriytiApp extends StatefulWidget {
  const ChahriytiApp({super.key});

  @override
  State<ChahriytiApp> createState() => _ChahriytiAppState();
}

class _ChahriytiAppState extends State<ChahriytiApp> {
  @override
  void initState() {
    super.initState();
    // Tapping a notification opens its screen (the router's redirect still
    // applies: lock, onboarding, setup)
    final notifications = Injection.notificationService;
    notifications.onOpenRoute = _open;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final route = notifications.takeLaunchRoute();
      if (route != null) _open(route);
    });
  }

  void _open(String route) {
    if (route == '/home') {
      AppRouter.router.go('/home');
    } else {
      AppRouter.router.go('/home');
      AppRouter.router.push(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LocaleCubit(appSecureStorage)..load(),
      child: BlocBuilder<LocaleCubit, LocaleState>(
        builder: (context, localeState) {
          return MaterialApp.router(
            title: 'Chahriyti',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            locale: localeState.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            routerConfig: AppRouter.router,
            builder: (context, child) =>
                AppLockGate(child: child ?? const SizedBox.shrink()),
          );
        },
      ),
    );
  }
}
