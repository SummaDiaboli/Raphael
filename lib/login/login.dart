import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Importing the other login pages
import 'package:yafe/login/signUp.dart';
import 'package:yafe/login/forgotPassword.dart';

// Importing the navigation to the main pages
import 'package:yafe/mainPages/mainHome.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // TODO: Change all strict padding to relative MediaQuery padding

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
      body: Container(
        child: Form(
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
                            onPressed: () {
                              Route route = MaterialPageRoute(
                                builder: (context) => MainHomePage(),
                              );
                              Navigator.push(context, route);
                            },
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
