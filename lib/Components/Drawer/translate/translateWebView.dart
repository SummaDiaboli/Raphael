import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TranslateWebView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Manhajar Fassara ta Google",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: WebView(
        initialUrl:
            "https://translate.google.com/#view=home&op=translate&sl=en&tl=ha",
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
