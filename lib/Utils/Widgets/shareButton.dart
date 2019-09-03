import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ShareButton extends StatelessWidget {
  ShareButton({this.doc});
  final DocumentSnapshot doc;

  void updateFirestoreShareCount() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String userId = user.uid;
    int shareCount = 0;

    DocumentSnapshot document = await Firestore.instance
        .collection("userData")
        .document('$userId')
        .get();

    if (document.exists) {
      shareCount = document['shareCount'];
    }

    await Firestore.instance.collection('userData').document('$userId').setData(
      {"shareCount": shareCount + 1},
      merge: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.share),
      color: Colors.blueAccent,
      onPressed: () async {
        Share.share(
                "\"${doc['postContents']}\" \n-- ${doc['userDisplayName']} ")
            .whenComplete(() async {
          updateFirestoreShareCount();
        });
      },
    );
  }
}
