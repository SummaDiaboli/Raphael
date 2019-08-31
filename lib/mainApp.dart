import 'package:flutter/material.dart';
import "package:yafe/Screens/rootPage.dart";
import 'package:yafe/Utils/Auth/authentication.dart';
import 'package:yafe/Utils/Style/style.dart';

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
      theme: ThemeData(
        primaryColor: AppBarBackgroundColor,
        appBarTheme: AppBarTheme(
          textTheme: TextTheme(
            title: AppBarTextStyle,
          ),
        ),
        textTheme: TextTheme(
          title: BodyTextStyle,
        ),
      ),
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
