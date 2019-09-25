import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yafe/Utils/Auth/authentication.dart';
import 'package:path/path.dart' as prefix0;

class ProfilePage extends StatefulWidget {
  ProfilePage({this.auth});

  final BaseAuth auth;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String _userId = "";

  FirebaseUser currentUser;
  BaseAuth auth;

  String _username;
  String _userEmail;
  String _profilePicUrl;
  //String _errorMessage;
  // String _downloadUrl;
  File imageFile;

  bool _isLoading;
  bool _changeProfilePicture;
  //bool _isIos;

  @override
  void initState() {
    super.initState();
    _isLoading = false;

    //auth.reloadProfile();
    setState(() {
      _loadCurrentUser();
    });
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      user.reload();
    });
    print("$_userId");
  }

  @override
  void dispose() {
    super.dispose();
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

  void _loadCurrentUser() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        // call setState to rebuild the view
        this.currentUser = user;
      });
    });
  }

  String _displayName() {
    String username = "No Display name";
    if (currentUser != null) {
      setState(() {
        currentUser.displayName;
        _username = currentUser.displayName;
      });
      return currentUser.displayName;
    } else {
      return username;
    }
  }

  String _email() {
    if (currentUser.email != null) {
      setState(() {
        currentUser.email;
        _userEmail = currentUser.email;
      });
      return currentUser.email;
    } else {
      setState(() {
        _userEmail = "";
      });
      return "";
    }
  }

  String _profilePicture() {
    if (currentUser.photoUrl != null) {
      setState(() {
        currentUser.photoUrl;
        _profilePicUrl = currentUser.photoUrl;
      });
      return currentUser.photoUrl;
    } else {
      return "";
    }
  }

  /*  Widget _showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  } */

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  _validateAndSubmit() async {
    setState(() {
      //_errorMessage = "";
      _isLoading = true;
    });
    if (_validateAndSave()) {
      try {
        if (_username.isNotEmpty) {
          await widget.auth.updateDisplayName(_username);
        }

        if (_userEmail.isNotEmpty) {
          await widget.auth.updateUserEmail(_userEmail);
        }

        if (_changeProfilePicture == true) {
          await uploadTask(imageFile);
          // await widget.auth.updateProfilePicture(_downloadUrl);
        }

        setState(
          () {
            _isLoading = false;
            _loadCurrentUser();
            _displayName();
            _email();
            _profilePicture();
          },
        );

        // auth.reloadProfile();
        /* FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
          user.reload();
        }); */
        widget.auth.reloadProfile();
        _loadCurrentUser();
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          /* if (_isIos) {
            _errorMessage = e.details;
          } else
            _errorMessage = e.message; */
        });
      }
    }
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    print(image);
    setState(() {
      imageFile = image;
      _changeProfilePicture = true;
    });
  }

  Future<void> uploadTask(File image) async {
    setState(() {
      _isLoading = true;
    });
    String filename = prefix0.basename(image.path);
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    StorageReference storage = FirebaseStorage.instance
        .ref()
        .child("${user.displayName} ${user.uid}")
        .child(filename);

    StorageUploadTask uploadTask = storage.putFile(image);
    sendToDatabase(uploadTask);
  }

  Future<void> sendToDatabase(StorageUploadTask uploadTask) async {
    var downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    String url = downloadUrl.toString();
    await widget.auth.updateProfilePicture(url);

    setState(() {
      // _downloadUrl = url;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _displayName();
    _email();
    _profilePicture();
    _loadCurrentUser();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: /* Colors.grey[700] */ Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text(
          "Profile",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          IconButton(
                            iconSize: 110,
                            icon: _profilePicUrl == null
                                ? Icon(
                                    Icons.account_circle,
                                    color: Colors.grey,
                                  )
                                : CircleAvatar(
                                    backgroundImage:
                                        NetworkImage("$_profilePicUrl"),
                                    radius: 60.0,
                                    backgroundColor: Colors.transparent,
                                  ),
                            onPressed: getImage,
                          ),
                          /* Positioned(
                            top: 76,
                            left: 80,
                            child: ClipOval(
                              child: Container(
                                width: 34,
                                height: 34,
                                color: Colors.red[800],
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ) */
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 26, 0, 10),
                            child: Text(
                              // "Not given",
                              _username,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          /* Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: Text(
                              "Content Regulator",
                              style: TextStyle(),
                            ),
                          ), */
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: Text(
                              // "salim.hussaini@backlinq.ng",
                              _userEmail,
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                    child: Divider(
                      indent: 15,
                      color: Colors.grey[800],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 15, 0, 0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(14, 0, 18, 15),
                          child: Text(
                            "Fill the fields below to update your account information",
                            style: TextStyle(wordSpacing: 2),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 44, 10),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.account_box,
                                size: 22,
                                color: Colors.grey[700],
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              labelStyle: TextStyle(color: Colors.black),
                              labelText: "Username",
                              border: OutlineInputBorder(),
                            ),
                            /* validator: (value) {
                              if (value.isEmpty) {
                                setState(() {
                                  _isLoading = false;
                                });
                                return 'Username can\'t be empty';
                              }
                            }, */
                            onSaved: (value) => _username = value,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 10, 44, 10),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.email,
                                size: 20,
                                color: Colors.grey[700],
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              labelStyle: TextStyle(color: Colors.black),
                              labelText: "Email",
                              border: OutlineInputBorder(),
                            ),
                            /* validator: (value) {
                              if (value.isEmpty) {
                                setState(() {
                                  _isLoading = false;
                                });
                                return 'Email can\'t be empty';
                              }
                            }, */
                            onSaved: (value) => _userEmail = value,
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 26, 20, 16),
                            child: Container(
                              height: 50,
                              child: RaisedButton(
                                elevation: 4,
                                color: Colors.red[900],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: Text(
                                  "Save Changes",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                onPressed: _validateAndSubmit /* () {} */,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // _showErrorMessage(),
                ],
              ),
            ),
          ),
          _showCircularProgress(),
        ],
      ),
    );
  }
}
