import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:yafe/Components/Comments/editComment.dart';
import 'package:yafe/Components/Comments/newComment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yafe/Components/Comments/newReply.dart';
import 'package:yafe/Components/Comments/replyBuilder.dart';

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

  Future _buildErrorDialog(BuildContext context, _message) {
    return showDialog(
      builder: (context) {
        return AlertDialog(
          title: Text('Error Message'),
          content: Text(_message),
          actions: <Widget>[
            FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        );
      },
      context: context,
    );
  }

  Future<void> _buildConfirmation(
      BuildContext context, _message, DocumentSnapshot doc) {
    return showDialog<void>(
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text(_message),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "Delete comment",
                style: TextStyle(color: Colors.red[800]),
              ),
              onPressed: () {
                _deleteComment(doc);
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                "Close",
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
      context: context,
    );
  }

  _deleteComment(DocumentSnapshot doc) {
    try {
      Firestore.instance.document(doc.reference.path).delete();
    } catch (e) {
      print(e);
      _buildErrorDialog(context, e.toString());
    }
  }

  getComments(AsyncSnapshot<QuerySnapshot> snapshot) {
    getUser();
    return snapshot.data.documents
        .map(
          (doc) => Column(
            children: <Widget>[
              Card(
                child: ListTile(
                  trailing: doc['userId'] == uid
                      ? PopupMenuButton(
                          icon: Icon(Icons.more_horiz),
                          onSelected: (String choice) {
                            if (choice == CommentActions.Edit) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => EditComment(
                                    comment: doc,
                                  ),
                                ),
                              );
                            }

                            if (choice == CommentActions.Delete) {
                              _buildConfirmation(
                                  context,
                                  "Are you sure you want to delete this comment?",
                                  doc);
                            }

                            if (choice == CommentActions.Reply) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => NewReply(
                                    doc: doc,
                                  ),
                                ),
                              );
                            }
                          },
                          itemBuilder: (BuildContext context) {
                            return CommentActions.actions.map((String action) {
                              return PopupMenuItem<String>(
                                value: action,
                                child: Text(action),
                              );
                            }).toList();
                          },
                        )
                      : null,
                  leading: doc['photoUrl'] == null
                      ? Icon(
                          Icons.account_circle,
                          color: Colors.grey,
                          size: 44,
                        )
                      : CircleAvatar(
                          backgroundImage: NetworkImage(doc['photoUrl']),
                          backgroundColor: Colors.transparent,
                          radius: 15,
                        ),
                  title: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                    child: Text(
                      doc['displayName'],
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  // doc['userId'] == uid
                  //     ? Align(
                  //         alignment: Alignment.topRight,
                  //         child: FlatButton(
                  //           padding: EdgeInsets.all(0),
                  //           materialTapTargetSize:
                  //               MaterialTapTargetSize.shrinkWrap,
                  //           onPressed: () {
                  //             Navigator.of(context).push(
                  //               MaterialPageRoute(
                  //                 builder: (context) => EditComment(
                  //                   // doc: widget.doc,
                  //                   comment: doc,
                  //                 ),
                  //               ),
                  //             );
                  //           },
                  //           child: Text(
                  //             "edit",
                  //             style: TextStyle(
                  //               color: Colors.red[400],
                  //               fontSize: 13,
                  //             ),
                  //           ),
                  //         ),
                  //       )
                  //     : Container(),

                  subtitle: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 6),
                          child: Text(
                            doc['comment'],
                            maxLines: null,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 4, 0, 6),
                          child: Text(
                            "${DateFormat("MMM dd 'at' hh:mm:ss a").format(doc['dateCreated'])}",
                            style: TextStyle(fontSize: 12),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              ReplyBuilder(
                doc: doc,
              ),
            ],
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
                  color: Colors.red[800],
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
                      color: Colors.white,
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

class CommentActions {
  static const String Reply = 'Reply';
  static const String Edit = 'Edit comment';
  static const String Delete = 'Delete comment';

  static const List<String> actions = <String>[
    Reply,
    Edit,
    Delete,
  ];
}
