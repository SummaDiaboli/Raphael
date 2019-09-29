import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'mainApp.dart';

import 'package:sentry/sentry.dart';
import 'dsn.dart';

final SentryClient _sentry = new SentryClient(dsn: dsn);

bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

Future<Null> _reportError(dynamic error, dynamic stackTrace) async {
  print('Caught error: $error');
  if (isInDebugMode) {
    print(stackTrace);
    print('In dev mode. Not sending report to Sentry.io.');
    return;
  }

  print('Reporting to Sentry.io...');

  final SentryResponse response = await _sentry.captureException(
    exception: error,
    stackTrace: stackTrace,
  );

  if (response.isSuccessful) {
    print('Success! Event ID: ${response.eventId}');
  } else {
    print('Failed to report to Sentry.io: ${response.error}');
  }
}

Future<Null> main() async {
  FlutterError.onError = (FlutterErrorDetails details) async {
    if (isInDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    } else {
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };

  runZoned<Future<Null>>(() async {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
        (_) {
      runApp(
        MainApp(),
      );
    }, onError: (error, stackTrace) async {
      await _reportError(error, stackTrace);
    });
  });
}

/* void main() =>
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
        .then((_) {
      runApp(
        MainApp(),
      );
    }); */
