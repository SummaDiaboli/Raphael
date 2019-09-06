import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

// import 'package:yafe/Components/Drawer/profilePage.dart';
import 'package:yafe/Utils/Auth/authentication.dart';
import 'package:yafe/Components/Home/newsCarousel.dart';
import 'package:yafe/Utils/Language/language.dart';

class DetailedHomePage extends StatefulWidget {
  DetailedHomePage({this.auth, this.userId});
  final BaseAuth auth;
  final String userId;

  @override
  _DetailedHomePageState createState() => _DetailedHomePageState();
}

class _DetailedHomePageState extends State<DetailedHomePage> {
  FirebaseUser firebaseUser;
  DocumentSnapshot document;

  String twitterUser;
  String firebaseUserDisplayName;
  String firebaseUserEmail;
  String firebaseUserPhotoUrl;
  String userLanguage;

  bool firstTime;
  bool languageSelected;

  bool _isLoading;

  int shareCount = 0;
  int readArticlesCount = 0;
  int pollsCompletedCount = 0;

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
    checkIfBeginner();
    _loadCurrentUser();
    _displayName();
    _profilePicture();
    _email();
    getUserData();
    getUserLanguage();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getUserLanguage() async {
    userLanguage = await getCurrentLanguage();
  }

  void _loadCurrentUser() {
    // if (widget.userId == null) {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        // call setState to rebuild the view
        this.firebaseUser = user;
      });
    });

    getUserData();
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

  void getUserData() async {
    String userId = firebaseUser.uid;
    DocumentSnapshot documentSnapshot = await Firestore.instance
        .collection('userData')
        .document('$userId')
        .get();

    setState(() {
      document = documentSnapshot;
    });
  }

  String _shareCount() {
    try {
      if (document.data != null) {
        setState(() {
          shareCount = document['shareCount'];
        });
        if (shareCount == null) {
          setState(() {
            shareCount = 0;
          });
        }
        return "$shareCount";
      } else {
        setState(() {
          shareCount = 0;
        });
        return "$shareCount";
      }
    } catch (e) {
      return "$shareCount";
    }
  }

  String _readArticlesCount() {
    try {
      if (document.data != null) {
        setState(() {
          readArticlesCount = document['readArticlesCount'];
        });
        if (readArticlesCount == null) {
          setState(() {
            readArticlesCount = 0;
          });
        }
        return "$readArticlesCount";
      } else {
        setState(() {
          readArticlesCount = 0;
        });
        return "$readArticlesCount";
      }
    } catch (e) {
      return "$readArticlesCount";
    }
  }

  String _pollsCompletedCount() {
    try {
      if (document.data != null) {
        setState(() {
          pollsCompletedCount = document['pollsCompletedCount'];
        });
        if (pollsCompletedCount == null) {
          setState(() {
            pollsCompletedCount = 0;
          });
        }
        return "$pollsCompletedCount";
      } else {
        setState(() {
          readArticlesCount = 0;
        });
        return "$pollsCompletedCount";
      }
    } catch (e) {
      return "$pollsCompletedCount";
    }
  }

  Future checkIfBeginner() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool _seen = (preferences.getBool('seen') ?? false);

    if (_seen) {
      firstTime = false;
      languageSelected = false;
    } else {
      preferences.setBool('seen', true);
      firstTime = true;
      languageSelected = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    _loadCurrentUser();
    _displayName();
    _email();
    getUserData();
    _shareCount();
    _readArticlesCount();
    _pollsCompletedCount();

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
              languageSelected == true
                  ? Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              child: Center(
                                child: Text(
                                  "What language do you prefer speaking in?",
                                  style: TextStyle(
                                    fontSize: 11.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  child: FlatButton(
                                    onPressed: () {
                                      setNewLanguage('en');
                                    },
                                    child: Text(
                                      "English",
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: FlatButton(
                                    onPressed: () {
                                      setNewLanguage('ha');
                                    },
                                    child: Text(
                                      "Hausa",
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: FlatButton(
                                    onPressed: () {
                                      setNewLanguage('ig');
                                    },
                                    child: Text(
                                      "Igbo",
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: FlatButton(
                                    onPressed: () {
                                      setNewLanguage('yo');
                                    },
                                    child: Text(
                                      "Yoruba",
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
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
                              _pollsCompletedCount(),
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
                              _shareCount(),
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
                              _readArticlesCount(),
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 28,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                "ARTICLES READ",
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
