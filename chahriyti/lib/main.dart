import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'app.dart';
import 'core/di/injection.dart';
import 'firebase_options.dart';

void main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Injection.init();

  FlutterNativeSplash.remove();

  // Request notification permissions after splash is removed
  unawaited(
    Injection.notificationService.requestPermissionsAndShowWelcome(),
  );

  runApp(const ChahriytiApp());
}
