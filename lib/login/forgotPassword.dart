import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
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
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 28),
                  child: Icon(
                    Icons.donut_small,
                    size: 160,
                    color: Colors.red[800],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 2, 30, 10),
                  child: Center(
                    child: Text(
                        "We can help you reset your password and security information, but first enter your email address and follow the instructions provided."),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(),
                      labelStyle: TextStyle(color: Colors.black),
                      labelText: "Email Address",
                      border: OutlineInputBorder(),
                    ),
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
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
