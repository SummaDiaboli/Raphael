import 'package:flutter/material.dart';
import 'package:yafe/Components/Drawer/profilePage.dart';
import 'package:yafe/Components/Drawer/settingsPage.dart';
import 'package:yafe/Components/Drawer/surveyPage.dart';
import 'package:yafe/Utils/Auth/authentication.dart';

import 'package:firebase_auth/firebase_auth.dart';
import "package:yafe/Pages/rootPage.dart";

class MainDrawer extends StatefulWidget {
  MainDrawer({this.userId, this.auth, this.onSignedOut});

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;
  /* final String userId; */

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class _MainDrawerState extends State<MainDrawer> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";
  /* AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
        }
        authStatus =
            user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  } */

  // void _onLoggedIn() {
  //   widget.auth.getCurrentUser().then((user) {
  //     setState(() {
  //       _userId = user.uid.toString();
  //     });
  //   });
  //   setState(() {
  //     authStatus = AuthStatus.LOGGED_IN;
  //   });
  // }

  /* void _onSignedOut() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  } */

  String username = "John Doe";
  // String userRole = "Content Manager";
  String userEmail = "john.doe@doey.com";
  String photoUrl;

  /* _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  } */

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      user.reload();
    });
    print("$_userId");
  }

  @override
  void dispose() {
    super.dispose();
  }

  FirebaseUser currentUser;

  void _loadCurrentUser() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        // call setState to rebuild the view
        this.currentUser = user;
      });
    });
  }

  String _displayName() {
    if (currentUser != null) {
      _photoUrl();
      return currentUser.displayName;
    } else {
      return username;
    }
  }

  String _email() {
    if (currentUser.email != null) {
      return currentUser.email;
    } else {
      return "";
    }
  }

  String _photoUrl() {
    if (currentUser.photoUrl != null) {
      setState(() {
        photoUrl = currentUser.photoUrl;
      });
      return currentUser.photoUrl;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    _photoUrl();
    return Drawer(
      child: Container(
        child: Column(
          children: <Widget>[
            DrawerHeader(
              padding: EdgeInsets.fromLTRB(2, 20, 0, 0),
              child: Column(
                children: <Widget>[
                  ListTile(
                    contentPadding: EdgeInsets.all(0),
                    leading: photoUrl == null
                        ? Icon(
                            Icons.account_circle,
                            size: 110,
                            color: Colors.grey,
                          )
                        : Padding(
                            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage("$photoUrl"),
                              backgroundColor: Colors.transparent,
                              radius: 30,
                            ),
                          ),
                    title: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 34, 0, 0),
                      child: Text(
                        /* username */ _displayName(),
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Text(
                          //   userRole,
                          //   style: TextStyle(fontSize: 12),
                          // ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                            child: Text(
                              _email(),
                              style: TextStyle(
                                  fontStyle: FontStyle.italic, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.all(0),
              /* leading: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: SizedBox(
                    width: 5,
                    height: 45,
                    child: Container(
                      margin: EdgeInsetsDirectional.only(
                        start: 0,
                      ),
                      color: Colors.red[800],
                    ),
                  ),
                ), */
              title: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Text(
                  "Profile",
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Colors.red[800], fontSize: 16),
                ),
              ),
              onTap: () {
                Route route = MaterialPageRoute(
                  builder: (context) => ProfilePage(
                    auth: widget.auth,
                  ),
                );
                Navigator.pop(context);
                Navigator.push(context, route);
              },
            ),
            /*ListTile(
              contentPadding: EdgeInsets.all(0),
              /* leading: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: SizedBox(
                    width: 5,
                    height: 45,
                    child: Container(
                      margin: EdgeInsetsDirectional.only(
                        start: 0,
                      ),
                      color: Colors.red[800],
                    ),
                  ),
                ), */
              title: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Text(
                  "Account",
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Colors.red[800], fontSize: 16),
                ),
              ),
              onTap: () {},
            ),*/
            ListTile(
              contentPadding: EdgeInsets.all(0),
              /* leading: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: SizedBox(
                    width: 5,
                    height: 45,
                    child: Container(
                      margin: EdgeInsetsDirectional.only(
                        start: 0,
                      ),
                      color: Colors.red[800],
                    ),
                  ),
                ), */
              title: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Text(
                  "Settings",
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Colors.red[800], fontSize: 16),
                ),
              ),
              onTap: () {
                Route route = MaterialPageRoute(
                  builder: (context) => SettingsPage(),
                );
                Navigator.pop(context);
                Navigator.push(context, route);
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.all(0),
              /* leading: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: SizedBox(
                    width: 5,
                    height: 45,
                    child: Container(
                      margin: EdgeInsetsDirectional.only(
                        start: 0,
                      ),
                      color: Colors.red[800],
                    ),
                  ),
                ), */
              title: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Text(
                  "Survey",
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Colors.red[800], fontSize: 16),
                ),
              ),
              onTap: () {
                Route route = MaterialPageRoute(
                  builder: (context) => SurveyPage(),
                );
                Navigator.pop(context);
                Navigator.push(context, route);
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.all(0),
              /* leading: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: SizedBox(
                    width: 5,
                    height: 45,
                    child: Container(
                      margin: EdgeInsetsDirectional.only(
                        start: 0,
                      ),
                      color: Colors.red[800],
                    ),
                  ),
                ), */
              title: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Text(
                  "Logout",
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Colors.red[800], fontSize: 16),
                ),
              ),
              onTap: () async {
                try {
                  widget.onSignedOut();
                  Navigator.of(context).pop();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RootPage(
                        auth: Auth(),
                      ),
                    ),
                    ModalRoute.withName("/Home"),
                  );
                  await FirebaseAuth.instance.signOut();
                } catch (e) {
                  print(e);
                }

                // Navigator.of(context).pushReplacementNamed('/');
              },
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Color(0xFFD0202D),
                  height: 60,
                  /* child: Align(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      "assets/images/logo.jpg",
                    ),
                  ), */
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
