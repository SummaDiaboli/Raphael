import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yafe/Pages/Comments/commentsPage.dart';

class CommentNumber extends StatefulWidget {
  CommentNumber({this.doc});
  final DocumentSnapshot doc;

  @override
  _CommentNumberState createState() => _CommentNumberState();
}

class _CommentNumberState extends State<CommentNumber> {
  int length = 0;

  @override
  void initState() {
    super.initState();
    getComments(widget.doc);
  }

  getComments(DocumentSnapshot doc) async {
    await Firestore.instance
        .document(doc.reference.path)
        .collection("comments")
        .getDocuments()
        .then((doc) => length = doc.documents.length);
  }

  @override
  Widget build(BuildContext context) {
    getComments(widget.doc);
    return Container(
      width: 60,
      height: 45,
      child: InkWell(
        onTap: () {
          Route route = MaterialPageRoute(
            builder: (context) => CommentsPage(doc: widget.doc),
          );
          Navigator.push(context, route);
        },
        child: Container(
          width: 50,
//        height: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                child: Icon(
                  Icons.comment,
                  color: Colors.grey,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                child: Text("$length"),
              ),
            ],
          ),
        ),
      ),
    );
    /*return FlatButton.icon(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onPressed: () {
        Route route = MaterialPageRoute(
          builder: (context) => CommentsPage(doc: widget.doc),
        );
        Navigator.push(context, route);
      },
      icon: Icon(Icons.comment),
      label: Text("$length"),
    );*/
  }
}
