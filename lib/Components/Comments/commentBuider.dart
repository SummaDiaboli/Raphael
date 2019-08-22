import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yafe/Components/Comments/newComment.dart';

class CommentsBuilder extends StatefulWidget {
  CommentsBuilder({this.doc});

  final DocumentSnapshot doc;

  @override
  _CommentsBuilderState createState() => _CommentsBuilderState();
}

class _CommentsBuilderState extends State<CommentsBuilder> {
  getComments(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents
        .map(
          (doc) => Card(
            child: ListTile(
              title: Text(doc['displayName']),
              subtitle: Text(
                doc['comment'],
              ),
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('articles')
          .document('${widget.doc.documentID}')
          .collection('comments')
          .orderBy("dateCreated", descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        return Stack(
          children: <Widget>[
            Container(
              child: !snapshot.hasData
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView(
                      children: getComments(snapshot),
                    ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: FlatButton(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  color: Colors.white,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: BeveledRectangleBorder(
                    side: BorderSide(color: Colors.grey),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) {
                          return NewComment(
                            doc: widget.doc,
                          );
                        },
                      ),
                    );
                  },
                  child: Text(
                    "COMMENT",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
