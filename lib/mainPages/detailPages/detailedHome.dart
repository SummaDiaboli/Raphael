import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yafe/mainPages/drawerPages/profilePage.dart';
import 'package:yafe/mainPages/supplementary/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yafe/mainPages/supplementary/newsCarousel.dart';

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

  bool firstTime;

  @override
  void initState() {
    super.initState();
    setState(() {
      checkIfBeginner();
      _loadCurrentUser();
      _displayName();
      _email();
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
      firebaseUserDisplayName = firebaseUser.displayName;
      return firebaseUserDisplayName;
    } else if (twitterUser != null) {
      return twitterUser;
    } else {
      return "Something is missing";
    }
  }

  String _email() {
    if (firebaseUser != null) {
      firebaseUserEmail = firebaseUser.email;
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
    return Center(
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
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onPressed: () {},
                      child: Text(
                        "What is YAFE? How to get started",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: NewsCarousel(),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Icon(
              Icons.account_circle,
              size: 100,
              color: Colors.grey,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _displayName(),
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            ),
          ),
          /* firebaseUserEmail == null
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _email(),
                  ),
                )
              : Container(), */
          firebaseUserDisplayName != null
              ? FlatButton(
                  onPressed: () {
                    Route route = MaterialPageRoute(
                      builder: (context) => ProfilePage(auth: widget.auth),
                    );
                    Navigator.push(context, route);
                  },
                  child: Text(
                    "Edit Profile",
                    style: TextStyle(color: Colors.blue[600]),
                  ),
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.fromLTRB(2, 10, 2, 0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 15, 0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "1/10",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 28,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            "POLLS\nTAKEN",
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
                          "32",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 28,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            "POSTS\nSHARED",
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
                          "102",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 28,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            "POSTS\nREAD",
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
