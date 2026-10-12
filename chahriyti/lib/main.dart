import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'app.dart';
import 'core/di/injection.dart';
import 'firebase_options.dart';

void main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Cairo ships inside the app (assets/fonts): never download it, so the
  // right font shows offline from the first launch and typing doesn't stall
  GoogleFonts.config.allowRuntimeFetching = false;
  // Western digits in every date and system picker, in Arabic too
  DateFormat.useNativeDigitsByDefaultFor('ar', false);
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  await Injection.init();

  FlutterNativeSplash.remove();

  // Permission is asked later, after setup and the tour, with an
  // explanation first; here just keep scheduled reminders fresh
  unawaited(Injection.notificationService.rescheduleReminders());

  runApp(const ChahriytiApp());
}
