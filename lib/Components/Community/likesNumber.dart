import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LikesNumber extends StatefulWidget {
  LikesNumber({this.doc});
  final DocumentSnapshot doc;

  @override
  _LikesNumberState createState() => _LikesNumberState();
}

class _LikesNumberState extends State<LikesNumber> {
  int likes = 0;
  bool hasLiked = false;

  @override
  void initState() {
    super.initState();
    getLikes(widget.doc);
    hasUserLiked(widget.doc);
  }

  getLikes(DocumentSnapshot doc) async {
    if (doc['likes'] == null) {
      setState(() {
        likes = 0;
      });
      return 0;
    } else {
      setState(() {
        likes = doc['likes'];
      });
      return likes;
    }
  }

  updateLikes(DocumentSnapshot doc) async {
    DocumentReference reference =
        Firestore.instance.document(doc.reference.path);
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String userId = user.uid;
    DateTime date = DateTime.now();

    /*QuerySnapshot query = await reference
        .collection("hasLiked")
        .where("userId", isEqualTo: userId)
        .getDocuments();
    print(query.documents.length);*/

    if (hasLiked == false) {
      await reference.updateData({
        "likes": likes + 1,
      });

      await reference.collection('hasLiked').document().setData({
        "userId": userId,
        "dateLiked": date,
      });
      await getLikes(doc);
      await hasUserLiked(doc);
    }
  }

  hasUserLiked(DocumentSnapshot doc) async {
    setState(() {
      hasLiked = false;
    });

    DocumentReference reference =
        Firestore.instance.document(doc.reference.path);
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String userId = user.uid;
    QuerySnapshot query = await reference
        .collection("hasLiked")
        .where("userId", isEqualTo: userId)
        .getDocuments();

    if (query.documents.length == 0) {
      setState(() {
        hasLiked = false;
      });
    } else {
      setState(() {
        hasLiked = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    getLikes(widget.doc);
//    hasUserLiked(widget.doc);
    return Container(
      width: 60,
      height: 45,
      child: InkWell(
        onTap: () {
          updateLikes(widget.doc);
        },
        child: Container(
          width: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              hasLiked == false
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                      child: Icon(
                        Icons.thumb_up,
                        color: Colors.grey,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                      child: Icon(
                        Icons.thumb_up,
                        color: Colors.red,
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                child: Text("$likes"),
              ),
            ],
          ),
        ),
      ),
    );
    /*return FlatButton.icon(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onPressed: () {
        updateLikes(widget.doc);
      },
      icon: hasLiked == false
          ? Icon(
              Icons.thumb_up,
              color: Colors.grey,
            )
          : Icon(
              Icons.thumb_up,
              color: Colors.red[800],
            ),
      label: Text("$likes"),
    );*/
  }
}
