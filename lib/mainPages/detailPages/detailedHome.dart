import 'package:flutter/material.dart';
import 'package:yafe/mainPages/drawerPages/profilePage.dart';
import 'package:yafe/mainPages/supplementary/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DetailedHomePage extends StatefulWidget {
  DetailedHomePage({this.auth});
  final BaseAuth auth;

  @override
  _DetailedHomePageState createState() => _DetailedHomePageState();
}

class _DetailedHomePageState extends State<DetailedHomePage> {
  FirebaseUser currentUser;

  @override
  void initState() {
    super.initState();
    setState(() {
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
      return currentUser.displayName;
    } else {
      return username;
    }
  }

  String _email() {
    if (currentUser != null) {
      return currentUser.email;
    } else {
      return "john.doe@doey.com";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Padding(
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
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.account_circle,
              size: 140,
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _email(),
            ),
          ),
          FlatButton(
            onPressed: () {
              Route route = MaterialPageRoute(
                builder: (context) => ProfilePage(
                  auth: widget.auth,
                ),
              );
              Navigator.push(context, route);
            },
            child: Text(
              "Edit Profile",
              style: TextStyle(color: Colors.blue[600]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(2, 30, 2, 0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "1/10",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 28,
                          ),
                        ),
                        Text(
                          "POLLS TAKEN",
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "32",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 28,
                          ),
                        ),
                        Text(
                          "POSTS SHARED",
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "102",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 28,
                          ),
                        ),
                        Text(
                          "POSTS READ",
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
