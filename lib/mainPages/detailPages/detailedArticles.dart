import 'package:flutter/material.dart';

class DetailedArticle extends StatefulWidget {
  DetailedArticle({this.onPush});

  final ValueChanged onPush;

  @override
  _DetailedArticleState createState() => _DetailedArticleState();
}

class _DetailedArticleState extends State<DetailedArticle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
    );
  }
}
