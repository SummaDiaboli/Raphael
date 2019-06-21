import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:yafe/login/login.dart';
import 'package:yafe/mainPages/supplementary/authentication.dart';
import 'package:yafe/rootPage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUp extends StatefulWidget {
  SignUp({this.auth, this.onSignedIn});

  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";

  final _formKey = new GlobalKey<FormState>();

  TextEditingController _registerPassController;
  TextEditingController _registerPassController2;
  TextEditingController _userController;
  TextEditingController _emailController;

  String _username;
  String _email;
  String _password;
  String _confirmPassword;
  String _finalPassword;
  // String _errorMessage;

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
    // _errorMessage = "";
    _isLoading = false;
    print("$_userId");
  }

  /* Widget _showErrorMessage() {
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
      // _errorMessage = "";
      _isLoading = true;
    });
    if (_validateAndSave()) {
      String userId = "";
      if (_password == _confirmPassword) {
        _finalPassword = _password;
        try {
          userId = await widget.auth.signUp(_email, _finalPassword);
          widget.auth.sendEmailVerification();

          _showVerifyEmailSentDialog();
          print('Signed up: $userId');
          if (userId.length > 0 && userId != null) {
            widget.onSignedIn();
          }
          setState(
            () {
              _isLoading = false;
            },
          );
          /* FirebaseUser user = await FirebaseAuth.instance.currentUser();
        UserUpdateInfo updateInfo = UserUpdateInfo();
        updateInfo.displayName = _username;
        user.updateProfile(updateInfo); */

        } catch (e) {
          print('Error: $e');
          return _buildErrorDialog(context,
              "Sorry. Something went wrong with the Sign-up process. Please try again.");
          /*  setState(() {
          _isLoading = false;
          /* /* if (_isIos) {
            _errorMessage = e.details;
          } else */*/
          _errorMessage = e.message;
        }); */
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        _buildErrorDialog(context, "The two passwords do not match");
      }
    }
  }

  void _onSignedOut() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content:
              new Text("Link to verify account has been sent to your email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () async {
                /* Route route = MaterialPageRoute(
                  builder: (context) => Login(),
                );
                Navigator.push(context, route); */
                _formKey.currentState.reset();
                // Navigator.of(context).pop();
                // Navigator.of(context, rootNavigator: true).pop('dialog');
                /* Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Login(
                          auth: /* Auth() */ widget.auth,
                          onSignedIn: widget.onSignedIn,
                        ),
                  ),
                  ModalRoute.withName("/Home"),
                ); */

                widget.auth.updateDisplayName(_username);
                FirebaseUser user = await widget.auth.getCurrentUser();
                print('With the display name: ${user.displayName}');
                await widget.auth.getCurrentUser();

                await FirebaseAuth.instance.signOut();
                _onSignedOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RootPage(
                          auth: Auth(),
                        ),
                  ),
                  ModalRoute.withName("/Home"),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: <Widget>[
          Container(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 18, 0, 2),
                        child: BackButton(),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 18, 6, 2),
                        child: Align(
                            alignment: Alignment.topRight,
                            child: Image.asset(
                              'assets/images/icon.jpg',
                              scale: 25,
                            )
                            /* Icon(Icons.donut_small), */
                            ),
                      )
                    ],
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 25),
                          child: Center(
                            child: Material(
                                shape: CircleBorder(),
                                color: Colors.white10,
                                child: IconButton(
                                  color: Colors.blueGrey[100],
                                  icon: Icon(Icons.account_circle),
                                  iconSize: 150,
                                  onPressed: () {},
                                ) /* FlatButton(
                                onPressed: () {},
                                child: Icon(
                                  Icons.account_circle,
                                  color: Colors.blueGrey[100],
                                  size: 150,
                                ), */
                                ),
                          ),
                        ),
                        Form(
                          key: _formKey,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    textCapitalization: TextCapitalization.none,
                                    controller: _userController,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(),
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                      labelText: "Username",
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        return 'Username can\'t be empty';
                                      }
                                    },
                                    onSaved: (value) => _username = value,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    textCapitalization: TextCapitalization.none,
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(),
                                      labelStyle:
                                          TextStyle(color: Colors.black),
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
                                    },
                                    onSaved: (value) => _email = value,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: _registerPassController,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(),
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                      labelText: "Password",
                                      border: OutlineInputBorder(),
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
                                        return 'Password must be 6 characters or more';
                                      }
                                    },
                                    onSaved: (value) => _password = value,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: _registerPassController2,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(),
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                      labelText: "Confirm Password",
                                      border: OutlineInputBorder(),
                                    ),
                                    obscureText: true,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        return 'Password Confirmation can\'t be empty';
                                      }
                                      if (value.length < 6) {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        return 'Password must be 6 characters or more';
                                      }
                                      /* if (value != _password) {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        return 'Passwords do not match';
                                      } */
                                    },
                                    onSaved: (value) =>
                                        _confirmPassword = value,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: Container(
                            width: 120,
                            height: 45,
                            child: RaisedButton(
                              elevation: 4,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                "SIGN-UP",
                                style: TextStyle(
                                    color: Colors.red[800],
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800),
                              ),
                              onPressed: _validateAndSubmit /* () {} */,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 30, 10, 0),
                          child: Center(
                            child: Text(
                              "By signing up, you are agreeing to our terms and conditions & privacy policy.",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  // _showErrorMessage(),
                ],
              ),
            ),
          ),
          _showCircularProgress()
        ],
      ),
    );
  }
}
