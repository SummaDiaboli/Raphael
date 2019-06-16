import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Importing the other login pages
import 'package:yafe/login/signUp.dart';
import 'package:yafe/login/forgotPassword.dart';

// Importing the navigation to the main pages
import 'package:yafe/mainPages/mainHome.dart';

// importing progress indicator
//import 'package:yafe/mainPages/supplementary/circularProgressIndicator.dart';

// importing firebase
import "package:yafe/mainPages/supplementary/authentication.dart";

// import 'package:yafe/mainPages/supplementary/showErrorMessage.dart';

class Login extends StatefulWidget {
  Login({this.auth, this.onSignedIn});

  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = new GlobalKey<FormState>();

  String _username;
  String _password;
  String _errorMessage;

  bool _isLoading;

  bool _isIos;

  // TODO: Change all strict padding to relative MediaQuery padding

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget _showErrorMessage() {
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
  }

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
      _errorMessage = "";
      _isLoading = true;
    });
    if (_validateAndSave()) {
      String userId = "";
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
          builder: (context) => MainHomePage(),
        );
        Navigator.push(context, route);
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

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _isIos = Theme.of(context).platform == TargetPlatform.iOS;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
      body: Stack(
        children: <Widget>[
          Container(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
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
                                labelText: "Username",
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  return 'Email can\'t be empty';
                                }
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
                                    builder: (context) => ForgotPassword(),
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
                              onPressed: () {},
                            ),
                          ),

                          // Sign-up button
                          Padding(
                            padding: EdgeInsets.only(top: 12),
                            child: FlatButton(
                              onPressed: () {
                                Route route = MaterialPageRoute(
                                  builder: (context) => SignUp(),
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
                    _showErrorMessage(),
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
