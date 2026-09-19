import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';
import 'presentation/settings/cubits/locale_cubit.dart';
import 'presentation/shared/routing/app_router.dart';

class ChahriytiApp extends StatelessWidget {
  const ChahriytiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LocaleCubit(const FlutterSecureStorage())..load(),
      child: BlocBuilder<LocaleCubit, LocaleState>(
        builder: (context, localeState) {
          return MaterialApp.router(
            title: 'شهريتي',
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
          );
        },
      ),
    );
  }
}
