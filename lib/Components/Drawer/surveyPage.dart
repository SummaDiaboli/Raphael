import 'package:flutter/material.dart';
import 'package:flutter_pollfish/flutter_pollfish.dart';
// import 'package:flutter_pollfish/flutter_pollfish.dart' as prefix0;
// import 'package:flutter_pollfish/flutter_pollfish.dart' as prefix0;

class SurveyPage extends StatefulWidget {
  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  bool _isLoading;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    FlutterPollfish.instance.setPollfishSurveyOpenedListener(onPollfishOpened);
    FlutterPollfish.instance.setPollfishSurveyClosedListener(onPollfishClosed);
    FlutterPollfish.instance
        .setPollfishSurveyNotAvailableSurveyListener(onSurveyNotAvailable);
    FlutterPollfish.instance.hide();
    _takeSurvey();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onPollfishOpened() => setState(() {
        _isLoading = false;
      });

  void onPollfishClosed() => Navigator.of(context).pop();

  void onSurveyNotAvailable() => Navigator.of(context).pop();

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Container(
        color: Colors.white70,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  _takeSurvey() async {
    setState(() {
      _isLoading = true;
    });
    FlutterPollfish.instance.hide();
    await FlutterPollfish.instance
        .init(
      apiKey: 'bc35c872-d025-44e2-9bcc-7999d3789ea3',
      releaseMode: false,
      pollfishPosition: 5,
      rewardMode: false,
      offerwallMode: false,
    )
        // .timeout(Duration(seconds: 15))
        .whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            color: Colors.white,
          ),
          _showCircularProgress(),
        ],
      ),
    );
  }
}
