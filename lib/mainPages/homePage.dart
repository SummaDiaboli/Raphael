import 'dart:math';

import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:path/path.dart';

import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as prefix0;

// import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File _image;
  File _video;

  bool _isLoading;

  // bool _isIos;

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
    // String filename = Random().nextInt(1000000).toString();
    StorageReference storage =
        FirebaseStorage.instance.ref().child("${user.email}").child(filename);

    StorageUploadTask uploadTask = storage.putFile(userSelection);

    if (uploadTask.isInProgress) {
      /* setState(() {
        // _errorMessage = "";
        _isLoading = true;
      }); */
      final snackBar = SnackBar(
        content: Text(
          "Uploading. You will be contacted if any issues arise.",
          style: TextStyle(fontSize: 12),
        ),
        // backgroundColor: Color,
      );
      Scaffold.of(context).showSnackBar(snackBar);
      /* if (uploadTask.isComplete) {
        if (uploadTask.isSuccessful) {
          /* setState(() {
          _isLoading = false;
        }); */
          final snackBar = SnackBar(
            content: Text("Uploaded"),
            // backgroundColor: Color,
          );
          Scaffold.of(context).showSnackBar(snackBar);
        } else {
          _buildErrorDialog(context, "${uploadTask.lastSnapshot.error}");
        }
      } */
    }

    print("File uploaded");
  }

  // void _selectAndUpload() async {}
  /* Image _image;
  VideoPlayerController _video; */

  @override
  void initState() {
    super.initState();
    _isLoading = false;
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
              } /* () async {
                await uploadTask(_file, _filename);
                Navigator.of(context).pop();
              } */
              ,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[Container(), _showCircularProgress()],
      ),
      floatingActionButton: _fabSpeedDial(),
    );
  }

  Widget _fabSpeedDial() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      tooltip: "Upload",
      shape: StadiumBorder(),
      backgroundColor: Colors.red[800],
      children: [
        SpeedDialChild(
          child: Icon(Icons.photo),
          label: "Upload picture",
          backgroundColor: Colors.red[800],
          onTap: getImage,
        ),
        SpeedDialChild(
          child: Icon(Icons.videocam),
          label: "Upload video",
          backgroundColor: Colors.red[800],
          onTap: getVideo,
        ),
      ],
    );
  }
}
