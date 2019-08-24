import 'package:flutter/material.dart';
import "package:yafe/Pages/rootPage.dart";
import 'package:yafe/Utils/Auth/authentication.dart';

class MainApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Yafe',
      home: SafeArea(
        bottom: true,
        top: true,
        child: RootPage(
          auth: Auth(),
        ),
      ),
    );
  }
}
