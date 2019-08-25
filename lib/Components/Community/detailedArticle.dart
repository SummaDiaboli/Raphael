import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:yafe/Pages/Comments/commentsPage.dart';

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
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Article",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
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
            IconButton(
              icon: Icon(Icons.thumb_up),
              color: Colors.red,
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.comment),
              color: Colors.grey,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CommentsPage(
                      doc: widget.doc,
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.share),
              color: Colors.blueAccent,
              onPressed: () {
                Share.share(widget.url);
              },
            ),
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
