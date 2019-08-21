import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Importing other pages for the main route
import 'package:yafe/Pages/Home/homePage.dart';
import 'package:yafe/Pages/Community/communityPage.dart';
import 'package:yafe/Pages/Posts/postPage.dart';

// Importing the drawer
import 'package:yafe/Pages/Drawer/drawer.dart';

import "package:yafe/Utils/Auth/authentication.dart";

class MainHomePage extends StatefulWidget {
  MainHomePage({Key key, this.auth, this.userId, this.onSignedOut})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  int _currentIndex = 0; // Index of the bottom navigation bar items
  int index = 0;

  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";

  bool _isEmailVerified;

  // All the pages contained in the bottom navigation bar
  /* final List<Widget> _children = [
    HomePage(),
    MapPage(),
    PostPage(),
  ]; */
  @override
  void initState() {
    super.initState();

    _checkEmailVerification();
    print("$_userId");
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _checkEmailVerification() async {
    _isEmailVerified = await widget.auth.isEmailVerified();
    if (!_isEmailVerified) {
      _showVerifyEmailDialog();
    }
  }

  void _showVerifyEmailDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Verify your account"),
          content: Text("Please verify account in the link sent to email"),
          actions: <Widget>[
            FlatButton(
              child: Text("Resend verification link"),
              onPressed: () {
                Navigator.of(context).pop();
                _resendVerifyEmail();
              },
            ),
            FlatButton(
              child: Text(
                "Dismiss",
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _resendVerifyEmail() {
    widget.auth.sendEmailVerification();
    _showVerifyEmailSentDialog();
  }

  Widget _showVerifyEmailSentDialog() {
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    // return object of type Dialog
    return AlertDialog(
      title: Text("Verify your account"),
      content: Text("Link to verify account has been sent to your email"),
      actions: <Widget>[
        FlatButton(
          child: Text(
            "Dismiss",
            style: TextStyle(color: Colors.grey),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
    // },
    // );
  }
  /* @override
  void dispose() {
    super.dispose();
    print("$_userId");
  } */

  void _onSignedOut() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,

        // This changes the title of the appbar in accordance
        // with changes in the child of the bottom nav bar
        title: Text(
          [
            "Home",
            "Community",
            "Posts",
          ][_currentIndex],
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white /* Colors.grey[700] */,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.monetization_on),
            onPressed: () {},
            tooltip: "Donate",
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {},
            tooltip: "Share Yafe",
          )
        ],
      ),
      drawer: MainDrawer(
        userId: widget.userId,
        auth: widget.auth,
        onSignedOut: _onSignedOut,
      ),
      body: Stack(
        children: <Widget>[
          Offstage(
            offstage: _currentIndex != 0,
            child: HomePage(
              auth: widget.auth,
              userId: widget.userId,
            ),
          ),
          Offstage(
            offstage: _currentIndex != 1,
            child: CommunityPage(),
          ),
          Offstage(
            // offstage: _currentIndex != 2,
            offstage: _currentIndex != 2,
            child: PostPage(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        backgroundColor: Colors.red[900],
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 30,
              color: Colors.white,
            ),
            title: Text(
              "Home",
              style: TextStyle(color: Colors.white),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.group,
              size: 30,
              color: Colors.white,
            ),
            title: Text(
              "Community",
              style: TextStyle(color: Colors.white),
            ),
          ),
          /* BottomNavigationBarItem(
            icon: Icon(
              Icons.map,
              size: 30,
              color: Colors.white,
            ),
            title: Text(
              "Map",
              style: TextStyle(color: Colors.white),
            ),
          ), */
          BottomNavigationBarItem(
            icon: Icon(
              Icons.mode_comment,
              size: 30,
              color: Colors.white,
            ),
            title: Text(
              "Posts",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // Changes the index of the child when another item
  // in the bottom navigation bar is tapped
  void onTabTapped(int index) {
    setState(
      () {
        _currentIndex = index;
      },
    );
  }
}
