import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailedArticle extends StatefulWidget {
  DetailedArticle({this.url, this.likes, this.dislikes, this.doc});

  final String url;
  final int likes;
  final int dislikes;
  final DocumentSnapshot doc;

  @override
  _DetailedArticleState createState() => _DetailedArticleState();
}

class _DetailedArticleState extends State<DetailedArticle> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Article"),
        backgroundColor: Colors.grey[700],
        /*actions: <Widget>[
          PopupMenuButton<MenuItems>(
            onSelected: (MenuItems result) {
              setState(
                () {
                  _selection = result;
                  // Add code to navigate to user selection
                },
              );
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuItems>>[
                  PopupMenuItem<MenuItems>(
                    value: MenuItems.settings,
                    child: Text("Settings"),
                  )
                ],
          ),
        ],*/
      ),
      persistentFooterButtons: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 80, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              /* FlatButton.icon(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                icon: Icon(Icons.thumb_up),
                onPressed: () {
                  setState(() {
                    int key = widget.likes;
                    int update = key++;
                    // Firestore.instance.collection('article').document('${widget.doc['likes']}').updateData()
                    // return update;
                    // Firestore.instance.collection(widget.likes)
                    DocumentReference ref = widget.doc.reference;
                    ref.updateData(
                      <String, dynamic>{'likes': key++},
                    );
                  });
                },
                label: Text("${widget.likes}"),
              ),
              FlatButton.icon(
                padding: EdgeInsets.all(0),
                icon: Icon(Icons.thumb_down),
                onPressed: () {},
                label: Text("${widget.dislikes}"),
                textColor: Colors.red[800],
              ), */
            ],
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FlatButton.icon(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              icon: Icon(Icons.share),
              onPressed: () {},
              label: Text(""),
              textColor: Colors.grey[800],
            ),
            FlatButton.icon(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              icon: Icon(Icons.comment),
              onPressed: () {},
              label: Text(""),
              textColor: Colors.grey[800],
            )
          ],
        ),
      ],
      body: WebView(
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
