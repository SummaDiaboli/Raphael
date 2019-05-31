import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // TODO: Change all strict padding to relative MediaQuery padding

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Container(
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 14, 0, 2),
                      child: BackButton(),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 14, 6, 2),
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
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(),
                                    labelStyle: TextStyle(color: Colors.black),
                                    labelText: "Username",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(),
                                    labelStyle: TextStyle(color: Colors.black),
                                    labelText: "Password",
                                    border: OutlineInputBorder(),
                                  ),
                                  obscureText: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(),
                                    labelStyle: TextStyle(color: Colors.black),
                                    labelText: "Confirm Password",
                                    border: OutlineInputBorder(),
                                  ),
                                  obscureText: true,
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
                            onPressed: () {},
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
