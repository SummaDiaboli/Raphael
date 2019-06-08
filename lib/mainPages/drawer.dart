import 'package:flutter/material.dart';
import 'package:yafe/mainPages/drawerPages/profilePage.dart';

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  String username = "Salim Hussaini";
  String userRole = "Software Maintainer";
  String userEmail = "salim.hussaini@backlinq.ng";

  @override
  Widget build(BuildContext context) {
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
                    leading: Icon(
                      Icons.account_circle,
                      size: 110,
                      color: Colors.grey,
                    ),
                    title: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 34, 0, 0),
                      child: Text(
                        username,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            userRole,
                            style: TextStyle(fontSize: 12),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 14, 0, 0),
                            child: Text(
                              userEmail,
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
                  builder: (context) => ProfilePage(),
                );
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
                  "Account",
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Colors.red[800], fontSize: 16),
                ),
              ),
              onTap: () {},
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
                  "Settings",
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Colors.red[800], fontSize: 16),
                ),
              ),
              onTap: () {},
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
                  "Help",
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Colors.red[800], fontSize: 16),
                ),
              ),
              onTap: () {},
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Color(0xFFD0202D),
                  height: 60,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      "assets/images/logo.jpg",
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
