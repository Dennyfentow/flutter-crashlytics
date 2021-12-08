import 'dart:async';

import 'package:alura_crashlytics/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

void main() async {
  // Initialize Firebase.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  } else {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    FirebaseCrashlytics.instance.setUserIdentifier('id_alura123');
    FlutterError.onError =
        FirebaseCrashlytics.instance.recordFlutterError; // Erros do Aplicativo
  }

  // cria uma zona izolada onde o aplicativo é executado, protegendo de erros do dart
  runZonedGuarded<Future<void>>(() async {
    runApp(BytebankApp());
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
}

class BytebankApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.green[900],
        buttonTheme: ButtonThemeData(
          buttonColor: Color.fromRGBO(71, 161, 56, 1),
          textTheme: ButtonTextTheme.primary,
        ),
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(secondary: Color.fromRGBO(71, 161, 56, 1)),
      ),
      home: Dashboard(),
    );
  }
}
