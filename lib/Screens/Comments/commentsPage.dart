import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yafe/Components/Comments/commentBuider.dart';

class CommentsPage extends StatefulWidget {
  CommentsPage({this.doc});

  final DocumentSnapshot doc;

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Comments",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: CommentsBuilder(
          doc: widget.doc,
        ),
      ),
    );
  }
}
