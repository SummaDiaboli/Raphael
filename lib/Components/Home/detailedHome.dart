import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

// import 'package:yafe/Components/Drawer/profilePage.dart';
import 'package:yafe/Utils/Auth/authentication.dart';
import 'package:yafe/Components/Home/newsCarousel.dart';

class DetailedHomePage extends StatefulWidget {
  DetailedHomePage({this.auth, this.userId});
  final BaseAuth auth;
  final String userId;

  @override
  _DetailedHomePageState createState() => _DetailedHomePageState();
}

class _DetailedHomePageState extends State<DetailedHomePage> {
  FirebaseUser firebaseUser;
  String twitterUser;
  String firebaseUserDisplayName;
  String firebaseUserEmail;
  String firebaseUserPhotoUrl;

  bool firstTime;

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

  @override
  void initState() {
    super.initState();
    setState(() {
      checkIfBeginner();
      _loadCurrentUser();
      _displayName();
      _profilePicture();
      _email();
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _loadCurrentUser() {
    // if (widget.userId == null) {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        // call setState to rebuild the view
        this.firebaseUser = user;
      });
    });
    /*  } else {
      this.twitterUser = widget.userId;
    } */
  }

  String _displayName() {
    // String username = "No Display name";
    if (firebaseUser != null) {
      setState(() {
        firebaseUserDisplayName = firebaseUser.displayName;
        firebaseUserPhotoUrl = firebaseUser.photoUrl;
      });
      // print(firebaseUserPhotoUrl);
      return firebaseUserDisplayName;
    } else if (twitterUser != null) {
      return twitterUser;
    } else {
      return "John Doe";
    }
  }

  String _profilePicture() {
    if (firebaseUser != null) {
      setState(() {
        firebaseUserPhotoUrl = firebaseUser.displayName;
      });
      // print(firebaseUser.photoUrl);
      return firebaseUserPhotoUrl;
    } else {
      return null;
    }
    // print(firebaseUser.photoUrl);
    // return firebaseUserPhotoUrl;
  }

  String _email() {
    if (firebaseUser != null) {
      firebaseUserEmail = firebaseUser.email;
      // print(firebaseUser.email);
      return firebaseUser.email;
    } else {
      return "";
    }
  }

  Future checkIfBeginner() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool _seen = (preferences.getBool('seen') ?? false);

    if (_seen) {
      firstTime = false;
    } else {
      preferences.setBool('seen', true);
      firstTime = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    _loadCurrentUser();
    _displayName();
    _email();
    return Stack(
      children: <Widget>[
        Center(
          child: Column(
            children: <Widget>[
              firstTime == true
                  ? Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: FlatButton(
                          padding: EdgeInsets.all(0),
                          color: Colors.red[800],
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          onPressed: () {
                            setState(() {
                              firstTime = false;
                            });
                          },
                          child: Text(
                            "What is YAFE? How to get started",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: NewsCarousel(),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(2, 30, 2, 30),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 15, 0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              "-/-",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 28,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                "POLLS TAKEN",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              "-",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 28,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                "POSTS SHARED",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              "-/-",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 28,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                "POSTS READ",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              firebaseUserPhotoUrl == null
                  ? Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.account_circle,
                        size: 100,
                        color: Colors.grey,
                      ),
                    )
                  : ClipOval(
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        height: 90,
                        width: 90,
                        imageUrl: firebaseUserPhotoUrl,
                        placeholder: (context, url) => CircleAvatar(
                          backgroundColor: Colors.grey,
                          child: Icon(
                            Icons.account_circle,
                            size: 80,
                            color: Colors.grey,
                          ),
                          radius: 45,
                        ),
                      ),
                    ) /* Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 4),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage("$firebaseUserPhotoUrl"),
                        backgroundColor: Colors.transparent,
                        radius: 45.0,
                      ),
                    ) */
              ,
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _displayName(),
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                ),
              ),
              firebaseUserEmail != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _email(),
                      ),
                    )
                  : Container(),
              /* firebaseUserDisplayName != null
                  ? FlatButton(
                      padding: EdgeInsets.all(0),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onPressed: () {
                        Route route = MaterialPageRoute(
                          builder: (context) => ProfilePage(auth: widget.auth),
                        );
                        Navigator.push(context, route);
                      },
                      child: Text(
                        "Edit Profile",
                        style: TextStyle(color: Colors.red[800]),
                      ),
                    )
                  : Container(), */
            ],
          ),
        ),
        _showCircularProgress(),
      ],
    );
  }
}
