import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Importing other pages
import 'package:yafe/mainPages/homePage.dart';
import 'package:yafe/mainPages/mapPage.dart';
import 'package:yafe/mainPages/postPage.dart';

class MainHomePage extends StatefulWidget {
  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    HomePage(),
    MapPage(),
    PostPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          [
            "Articles",
            "Map",
            "Posts",
          ][_currentIndex],
        ),
        backgroundColor: Colors.grey[700],
      ),
      drawer: Drawer(),
      body: _children[_currentIndex],
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
          BottomNavigationBarItem(
            icon: Icon(
              Icons.map,
              size: 30,
              color: Colors.white,
            ),
            title: Text(
              "Map",
              style: TextStyle(color: Colors.white),
            ),
          ),
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
          )
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(
      () {
        _currentIndex = index;
      },
    );
  }
}
