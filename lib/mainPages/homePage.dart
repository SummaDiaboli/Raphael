import 'package:flutter/material.dart';
import 'package:yafe/mainPages/pageCards/articleCards.dart';
// import 'package:yafe/mainPages/supplementary/articleCards.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // return HomeArticleCards();
    return ArticleCards();
  }
}
