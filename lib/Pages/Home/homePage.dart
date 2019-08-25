import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:path/path.dart';
import 'package:yafe/Components/Home/detailedHome.dart';

import 'package:yafe/Utils/Auth/authentication.dart';

// import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  HomePage({this.auth, this.userId});
  final BaseAuth auth;
  final String userId;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // bool _isIos;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // void _selectAndUpload() async {}
  /* Image _image;
  VideoPlayerController _video; */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            DetailedHomePage(auth: widget.auth, userId: widget.userId),
          ],
        ),
      ),
    );
  }
}
