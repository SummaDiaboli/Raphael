import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: Container(
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Container with the logo
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 60),
                  child: Container(
                    // Will hold placeholder image
                    child: Icon(
                      Icons.donut_small,
                      size: 120,
                      color: Colors.red,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 22),
                  child: Column(
                    // Containing the user login
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(6.0),
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
                      Padding(
                        padding: const EdgeInsets.all(6.0),
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
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 45, 0, 20),
                        child: Container(
                          width: 100,
                          height: 45,
                          child: RaisedButton(
                            elevation: 4,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  color: Colors.red[800], fontSize: 18),
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.grey[600],
                        indent: 6,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FlatButton(
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                          child: Text(
                            "LOGIN WITH TWITTER",
                            style: TextStyle(color: Colors.grey[600]),
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
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: FlatButton(
                          onPressed: () {},
                          child: Text(
                            "Don't have an account yet? Sign-up here",
                            style: TextStyle(color: Colors.red[900]),
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

/* MyHomePage({Key key, this.title}) : super(key: key);

    // This widget is the home page of your application. It is stateful, meaning
    // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title; */

/* int _counter = 0;

  void _incrementCounter() {
	setState(() {
	  // This call to setState tells the Flutter framework that something has
	  // changed in this State, which causes it to rerun the build method below
	  // so that the display can reflect the updated values. If we changed
	  // _counter without calling setState(), then the build method would not be
	  // called again, and so nothing would appear to happen.
	  _counter++;
	});
  } */

// This method is rerun every time setState is called, for instance as done
// by the _incrementCounter method above.
//
// The Flutter framework has been optimized to make rerunning build methods
// fast, so that you can just rebuild anything that needs updating rather
// than having to individually change instances of widgets.

/* appBar: AppBar(
		// Here we take the value from the MyHomePage object that was created by
		// the App.build method, and use it to set our appbar title.
		title: Text(widget.title),
	  ), */

// Center is a layout widget. It takes a single child and positions it
// in the middle of the parent.

// Column is also layout widget. It takes a list of children and
// arranges them vertically. By default, it sizes itself to fit its
// children horizontally, and tries to be as tall as its parent.
//
// Invoke "debug painting" (press "p" in the console, choose the
// "Toggle Debug Paint" action from the Flutter Inspector in Android
// Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
// to see the wireframe for each widget.
//
// Column has various properties to control how it sizes itself and
// how it positions its children. Here we use mainAxisAlignment to
// center the children vertically; the main axis here is the vertical
// axis because Columns are vertical (the cross axis would be
// horizontal).

/* children: <Widget>[
			Text(
			  'You have pushed the button this many times:',
			),
			Text(
			  '$_counter',
			  style: Theme.of(context).textTheme.display1,
			),
		  ]*/

/* floatingActionButton: FloatingActionButton(
		onPressed: _incrementCounter,
		tooltip: 'Increment',
		child: Icon(Icons.add),
	  ), // This trailing comma makes auto-formatting nicer for build methods. */
