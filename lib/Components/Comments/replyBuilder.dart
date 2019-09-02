import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yafe/Components/Comments/editComment.dart';

class ReplyBuilder extends StatefulWidget {
  ReplyBuilder({this.doc});
  final DocumentSnapshot doc;

  @override
  _ReplyBuilderState createState() => _ReplyBuilderState();
}

class _ReplyBuilderState extends State<ReplyBuilder> {
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

  getReplies(AsyncSnapshot<QuerySnapshot> snapshot) {
    getUser();
    return snapshot.data.documents
        .map(
          (doc) => Card(
            child: ListTile(
              onLongPress: () {
                print("Doc userID " + doc['userId']);
                print("UID " + uid);
              },
              trailing: doc['userId'] == uid
                  ? PopupMenuButton(
                      icon: Icon(Icons.more_horiz),
                      onSelected: (String choice) {
                        if (choice == ReplyCommentActions.Edit) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => EditComment(
                                comment: doc,
                              ),
                            ),
                          );
                        }

                        if (choice == ReplyCommentActions.Delete) {
                          _buildConfirmation(
                              context,
                              "Are you sure you want to delete this comment?",
                              doc);
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return ReplyCommentActions.actions.map((String action) {
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
                  : ClipOval(
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        height: 45,
                        width: 45,
                        imageUrl: doc['photoUrl'],
                        placeholder: (context, url) => CircleAvatar(
                          backgroundImage: NetworkImage("${doc['photoUrl']}"),
                          backgroundColor: Colors.grey,
                          radius: 20,
                        ),
                      ),
                    ),
              title: Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Text(
                  doc['displayName'],
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
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
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .document(widget.doc.reference.path)
          .collection('replies')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        return Container(
          child: !snapshot.hasData
              ? null
              : Padding(
                  padding: EdgeInsets.fromLTRB(40, 0, 0, 0),
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: getReplies(snapshot),
                  ),
                ),
        );
      },
    );
  }
}

class ReplyCommentActions {
  static const String Edit = 'Edit comment';
  static const String Delete = 'Delete comment';

  static const List<String> actions = <String>[
    Edit,
    Delete,
  ];
}
