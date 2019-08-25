import 'package:flutter/material.dart';
// import 'dart:math';
import 'package:yafe/Components/Community/articleCards.dart';
import 'package:yafe/Components/Community/uPost.dart';
// import 'package:firebase_storage/firebase_storage.dart';

// import 'package:yafe/mainPages/supplementary/articleCards.dart';
import 'package:yafe/Components/Community/uReport.dart';
import 'package:path/path.dart' as prefix0;
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityPage extends StatefulWidget {
  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  File _image;
  File _video;

  bool _isLoading;

  @override
  void initState() {
    super.initState();
    _isLoading = false;
    // FlutterPollfish.instance.show();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return HomeArticleCards();
    return Scaffold(
      body: Stack(
        children: <Widget>[
          ArticleCards(),
          _showCircularProgress(),
        ],
      ),
      floatingActionButton: _fabSpeedDial(),
    );
  }

  Widget _fabSpeedDial() {
    return SpeedDial(
      // animatedIcon: AnimatedIcons.menu_close,
      child: Image.asset(
        "assets/images/icon-fab-upload.png",
      ),
      tooltip: "Upload",
      shape: StadiumBorder(),
      backgroundColor: Colors.white10,
      children: [
        SpeedDialChild(
          child: Icon(Icons.videocam),
          label: "Upload Video",
          backgroundColor: Colors.red[800],
          onTap: getVideo,
        ),
        SpeedDialChild(
          child: Icon(Icons.photo),
          label: "Upload Picture",
          backgroundColor: Colors.red[800],
          onTap: getImage,
        ),
        SpeedDialChild(
          child: Icon(Icons.description),
          label: "Upload Article",
          backgroundColor: Colors.red[800],
          onTap: () {
            Route route = MaterialPageRoute(
              builder: (context) => UReportPage(),
            );
            Navigator.push(context, route);
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.short_text),
          label: "What's on your mind?",
          backgroundColor: Colors.red[800],
          onTap: () {
            Route route = MaterialPageRoute(
              builder: (context) => UPost(),
            );
            Navigator.push(context, route);
          },
        )
      ],
    );
  }

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

  Future _buildErrorDialog(BuildContext context, _message) {
    return showDialog(
      builder: (context) {
        return AlertDialog(
          title: Text('Error Message'),
          content: Text(_message),
          actions: <Widget>[
            FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        );
      },
      context: context,
    );
  }

  Future<void> uploadTask(File userSelection, String filename) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    StorageReference storage = FirebaseStorage.instance
        .ref()
        .child("${user.displayName} ${user.uid}")
        .child(filename);

    StorageUploadTask uploadTask = storage.putFile(userSelection);

    if (uploadTask.isInProgress) {
      final snackBar = SnackBar(
        content: Text(
          "Uploading. You will be contacted if any issues arise.",
          style: TextStyle(fontSize: 12),
        ),
        // backgroundColor: Color,
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }

    sendToDatabase(uploadTask);

    print("File uploaded");
  }

  Future<void> sendToDatabase(StorageUploadTask uploadTask) async {
    var downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    String url = downloadUrl.toString();

    final FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    String userId = firebaseUser.uid;
    String userDisplayName = firebaseUser.displayName;
    String photoUrl = firebaseUser.photoUrl;
    DateTime dateAndTime = DateTime.now();

    CollectionReference dbPending = Firestore.instance.collection('pending');
    dbPending.add({
      "userId": userId,
      "userDisplayName": userDisplayName,
      "contentUrl": url,
      "uploadDateAndTime": dateAndTime,
      "photoUrl": photoUrl,
    }).catchError((err) => print(err));
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    // return image;
    print(image);
    _image = image;
    _video = null;

    whatToDisplay(_image, _video);
  }

  Future getVideo() async {
    var video = await ImagePicker.pickVideo(source: ImageSource.gallery);
    print(video);

    _video = video;
    _image = null;
    whatToDisplay(_image, _video);
  }

  _uploadInProgress(file, filename) async {
    try {
      await uploadTask(file, filename);
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      return _buildErrorDialog(context,
          "Sorry. Something went wrong uploading the file. Please try again.");
    }
  }

  Future<void> _buildConfirmation(
      BuildContext context, _message, _file, _filename) {
    return showDialog<void>(
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text(_message),
          actions: <Widget>[
            FlatButton(
              child: Text("Confirm"),
              onPressed: () {
                _uploadInProgress(_file, _filename);
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
      context: context,
    );
  }

  whatToDisplay(File image, File video) {
    String fileprefix = Random().nextInt(1000000).toString();

    if (image == null && video != null) {
      String filename = prefix0.basename(video.path);
      _buildConfirmation(context, "Are you sure you want to upload this video?",
          _video, "${fileprefix}_$filename");
    } else if (image != null && video == null) {
      String filename = prefix0.basename(image.path);
      _buildConfirmation(context, "Are you sure you want to upload this image?",
          _image, "${fileprefix}_$filename");
    }
  }
}
