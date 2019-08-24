import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yafe/Components/Comments/editComment.dart';
import 'package:yafe/Components/Comments/newComment.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommentsBuilder extends StatefulWidget {
  CommentsBuilder({this.doc});

  final DocumentSnapshot doc;

  @override
  _CommentsBuilderState createState() => _CommentsBuilderState();
}

class _CommentsBuilderState extends State<CommentsBuilder> {
  String uid;

  getUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String userId = user.uid;
    setState(() {
      uid = userId;
    });
  }

  getComments(AsyncSnapshot<QuerySnapshot> snapshot) {
    getUser();
    return snapshot.data.documents
        .map(
          (doc) => Card(
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    doc['displayName'],
                  ),
                  doc['userId'] == uid
                      ? Align(
                          alignment: Alignment.topRight,
                          child: FlatButton(
                            padding: EdgeInsets.all(0),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => EditComment(
                                    // doc: widget.doc,
                                    comment: doc,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              "edit",
                              style: TextStyle(
                                color: Colors.red[400],
                                fontSize: 13,
                              ),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
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
          .orderBy("dateCreated" /* , descending: true */)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        return Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
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
                    side: BorderSide(color: Colors.red[800]),
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
                      color: Colors.red[800],
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
