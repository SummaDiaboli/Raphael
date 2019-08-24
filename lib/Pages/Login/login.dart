// import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';

// Importing the other login pages
import 'package:yafe/Pages/SignUp/signUp.dart';
import 'package:yafe/Pages/ForgotPassword/forgotPassword.dart';

// Importing the navigation to the main pages
import 'package:yafe/Pages/mainHome.dart';

// importing progress indicator
//import 'package:yafe/mainPages/supplementary/circularProgressIndicator.dart';

// importing firebase
import "package:yafe/Utils/Auth/authentication.dart";
import 'package:firebase_auth/firebase_auth.dart';

// import 'package:yafe/mainPages/supplementary/showErrorMessage.dart';

class Login extends StatefulWidget {
  Login({this.auth, this.onSignedIn});

  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  String _username;
  String _password;
  //String _errorMessage;

  //int _timeTaken;

  bool _isLoading;
  //bool _isIos;

  //bool _isIos;

  /* Future _delayOperation() {
    return Future.delayed(Duration(minutes: 10));
  } */
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

  /* Widget _showErrorMessage(PlatformException e) {
    return AlertDialog(
      title: Text("Login Error"),
      content: Text(
        '$e',
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      ),
    );
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
      // _isLoading = true;
    });
    if (_validateAndSave()) {
      String userId = "";
      _isLoading = true;
      try {
        userId = await widget.auth.signIn(_username, _password);
        print('Signed in: $userId');
        if (userId.length > 0 && userId != null) {
          widget.onSignedIn();
        }
        setState(() {
          _isLoading = false;
        });
        Route route = MaterialPageRoute(
          builder: (context) => MainHomePage(auth: Auth(), userId: userId),
        );
        Navigator.push(context, route);
        // Timer(Duration(seconds: 15), await _delayOperation());
      } on PlatformException catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
        });
        return _buildErrorDialog(context,
            "This email does not exist on the database. Please Sign-up to continue.");
      } on Exception catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
        });
        // return _buildErrorDialog(context, e.toString());
        return _buildErrorDialog(context,
            "Sorry. Something went wrong while trying to log you in. Please try again");
        /* setState(() {
          _isLoading = false;
          if (_isIos) {
            _errorMessage = e.details;
          } else
            _errorMessage = e.message;
        }); */
      }
    }
  }

  @override
  void initState() {
    //_errorMessage = "";
    _isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // _isIos = Theme.of(context).platform == TargetPlatform.iOS;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
      body: Stack(
        children: <Widget>[
          Container(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    // Container with the logo
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Container(
                        // Will hold placeholder image
                        child: Image.asset(
                          'assets/images/icon.jpg',
                          scale: 5,
                        ),
                        /* Icon(
                        Icons.donut_small,
                        size: 120,
                        color: Colors.red,
                      ), */
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 22),
                      child: Column(
                        // Containing the user login
                        children: <Widget>[
                          // Contains Username
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                labelStyle: TextStyle(color: Colors.black),
                                labelText: "Email",
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  return 'Email can\'t be empty';
                                }
                                if (!value.contains(
                                  RegExp(
                                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$'),
                                )) {
                                  return 'This is not a valid email format';
                                }

                                return null;
                              },
                              onSaved: (value) => _username = value,
                            ),
                          ),

                          // Contains password
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                labelText: "Password",
                                labelStyle: TextStyle(color: Colors.black),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.red[800],
                                      style: BorderStyle.solid),
                                ),
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value.isEmpty) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  return 'Password can\'t be empty';
                                }
                                if (value.length < 6) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  return 'Password must have 6 characters or more';
                                }

                                return null;
                              },
                              onSaved: (value) => _password = value,
                            ),
                          ),

                          // Forgot Password Button
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: FlatButton(
                                onPressed: () {
                                  Route route = MaterialPageRoute(
                                    builder: (context) => ForgotPassword(
                                      auth: widget.auth,
                                    ),
                                  );
                                  Navigator.push(context, route);
                                },
                                child: Text(
                                  "Forgot password?",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.red[800],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Login button
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 20, 0, 16),
                            child: Container(
                              width: 100,
                              height: 45,
                              child: RaisedButton(
                                elevation: 4,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  "LOGIN",
                                  style: TextStyle(
                                      color: Colors.red[800],
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800),
                                ),
                                onPressed:
                                    _validateAndSubmit, /* () {
                                  Route route = MaterialPageRoute(
                                    builder: (context) => MainHomePage(),
                                  );
                                  Navigator.push(context, route);
                                }, */
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.grey[600],
                            indent: 6,
                          ),

                          // Login Alternative using Twitter
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FlatButton(
                              padding: EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                              child: Text(
                                "LOGIN WITH TWITTER",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                                side: BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              onPressed: () async {
                                setState(() {
                                  _isLoading = true;
                                });
                                final twitterLogin = TwitterLogin(
                                    consumerKey: "sbQC3OYcDgketywpBmSnqXiSs",
                                    consumerSecret:
                                        "tfS4tj6wHVkUveEWdutBeXmlMjnhXAoJ9jibMWQPPpSayIxoKj");

                                final TwitterLoginResult result =
                                    await twitterLogin.authorize();

                                switch (result.status) {
                                  case TwitterLoginStatus.loggedIn:
                                    var userId = result.session.username;
                                    FirebaseAuth.instance
                                        .signInWithCredential(
                                            TwitterAuthProvider.getCredential(
                                                authToken: result.session.token,
                                                authTokenSecret:
                                                    result.session.secret))
                                        .then((a) async {
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      FirebaseUser user = await FirebaseAuth
                                          .instance
                                          .currentUser();

                                      UserUpdateInfo updateInfo =
                                          UserUpdateInfo();
                                      updateInfo.displayName = userId;
                                      user.updateProfile(updateInfo);
                                      user.reload();
                                    }).then((signedInUser) {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      Route route = MaterialPageRoute(
                                        builder: (context) => MainHomePage(
                                          auth: Auth(),
                                          userId: userId,
                                        ),
                                      );
                                      Navigator.push(context, route);
                                    }).catchError((e) {
                                      print(e);
                                      return _buildErrorDialog(
                                          context, e.toString());
                                    });
                                    break;

                                  case TwitterLoginStatus.cancelledByUser:
                                    print('Cancelled by you');
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    return _buildErrorDialog(
                                        context, "You cancelled the login");
                                    break;

                                  case TwitterLoginStatus.error:
                                    print('Error');
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    return _buildErrorDialog(context,
                                        "Your twitter sign in could not be continued. Please check your network and try again");
                                    break;
                                }
                              },
                            ),
                          ),

                          // Sign-up button
                          Padding(
                            padding: EdgeInsets.only(top: 12),
                            child: FlatButton(
                              onPressed: () {
                                _formKey.currentState.reset();
                                Route route = MaterialPageRoute(
                                  builder: (context) => SignUp(
                                    auth: widget.auth,
                                    onSignedIn: widget.onSignedIn,
                                  ),
                                );
                                Navigator.push(context, route);
                              },
                              child: Text(
                                "Don't have an account yet? Sign-up here",
                                style: TextStyle(
                                  color: Colors.red[900],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _showCircularProgress()
        ],
      ),
    );
  }
}
