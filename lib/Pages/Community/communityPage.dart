import 'package:flutter/material.dart';
// import 'dart:math';
import 'package:yafe/Components/Community/articleCards.dart';
// import 'package:firebase_storage/firebase_storage.dart';

// import 'package:yafe/mainPages/supplementary/articleCards.dart';

class CommunityPage extends StatefulWidget {
  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  @override
  Widget build(BuildContext context) {
    // return HomeArticleCards();
    return ArticleCards();
  }
}
