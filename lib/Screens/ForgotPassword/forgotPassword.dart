import 'package:flutter/material.dart';
import 'package:yafe/Utils/Auth/authentication.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({this.auth});

  final BaseAuth auth;

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = new GlobalKey<FormState>();

  // String _userId = "";
  String _email;

  bool _isLoading;

  // bool _isIos;

  @override
  void initState() {
    super.initState();
    _isLoading = false;
    // print("$_userId");
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
      _isLoading = false;
    });
    if (_validateAndSave()) {
      // String userId = "";
      try {
        // userId = await widget.auth.signUp(_email);
        // widget.auth.sendEmailVerification();
        await widget.auth.resetPassword(_email);

        //_showVerifyEmailSentDialog();
        // print('Signed up: $userId');
        /* if (userId.length > 0 && userId != null) {
          widget.onSignedIn();
        } */
        setState(
          () {
            _isLoading = false;
          },
        );
        _showResetPasswordSentDialog();
      } catch (e) {
        print('Error: $e');
        return _buildErrorDialog(
            context, "Please make sure this user exists and try again");
      }
    }
  }

  void _showResetPasswordSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Password reset email sent"),
          content:
              new Text("Password reset process has been sent to your email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () async {
                /* Route route = MaterialPageRoute(
                  builder: (context) => Login(),
                );
                Navigator.push(context, route); */
                _formKey.currentState.reset();
                Navigator.of(context).pop();
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

                /* widget.auth.updateDisplayName(_username);
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
                ); */
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
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey[700],
        title: Text(
          "Forgot Password",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            // color: Colors.white,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    /* Container(
                      height: 65,
                      color: Colors.grey[700],
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 20, 0, 2),
                            child: BackButton(
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(70, 20, 12, 2),
                            child: Text(
                              "Forgot Password",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          )
                        ],
                      ),
                    ), */
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Image.asset(
                        'assets/images/icon.jpg',
                        scale: 5,
                      ) /* Icon(
                        Icons.donut_small,
                        size: 160,
                        color: Colors.red[800],
                      ) */
                      ,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
                      child: Center(
                        child: Text(
                            "We can help you reset your password and security information, but first enter your email address and follow the instructions provided."),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 25),
                      child: TextFormField(
                        textCapitalization: TextCapitalization.none,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(),
                          labelStyle: TextStyle(color: Colors.black),
                          labelText: "Email Address",
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

                          return "";
                        },
                        onSaved: (value) => _email = value,
                      ),
                    ),
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
                            "SEND",
                            style: TextStyle(
                                color: Colors.red[800],
                                fontSize: 18,
                                fontWeight: FontWeight.w800),
                          ),
                          onPressed: _validateAndSubmit /* () {} */,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _showCircularProgress(),
        ],
      ),
    );
  }
}
