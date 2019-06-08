import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Importing other pages for the main route
import 'package:yafe/mainPages/homePage.dart';
//import 'package:yafe/mainPages/pollsPage.dart';
import 'package:yafe/mainPages/postPage.dart';

// Importing the drawer
import 'package:yafe/mainPages/drawer.dart';

class MainHomePage extends StatefulWidget {
  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  int _currentIndex = 0; // Index of the bottom navigation bar items
  int index = 0;

  // All the pages contained in the bottom navigation bar
  /* final List<Widget> _children = [
    HomePage(),
    MapPage(),
    PostPage(),
  ]; */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,

        // This changes the title of the appbar in accordance
        // with changes in the child of the bottom nav bar
        title: Text(
          [
            "Articles",
            //"Polls",
            "Posts",
          ][_currentIndex],
        ),
        backgroundColor: Colors.grey[700],
      ),
      drawer: MainDrawer(),
      body: Stack(
        children: <Widget>[
          Offstage(
            offstage: _currentIndex != 0,
            child: HomePage(),
          ),
          /* Offstage(
            offstage: _currentIndex != 1,
            child: PollsPage(),
          ), */
          Offstage(
            // offstage: _currentIndex != 2,
            offstage: _currentIndex != 1,
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
              "Articles",
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
