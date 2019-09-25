import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'mainApp.dart';

void main() =>
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
        .then((_) {
      runApp(
        MainApp(),
      );
    });
