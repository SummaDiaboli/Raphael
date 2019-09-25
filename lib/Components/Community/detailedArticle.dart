// import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:yafe/Utils/Language/language.dart';
import 'package:firebase_auth/firebase_auth.dart';

// import 'package:share/share.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// //import 'package:yafe/Pages/Comments/commentsPage.dart';
// import 'package:yafe/Components/Community/commentNumber.dart';
// import 'package:yafe/Components/Community/likesNumber.dart';

class DetailedArticle extends StatefulWidget {
  DetailedArticle({
    this.url,
    /* this.likes, this.dislikes, this.doc */
  });

  final String url;
  // final int likes;
  // final int dislikes;
  // final DocumentSnapshot doc;

  @override
  _DetailedArticleState createState() => _DetailedArticleState();
}

class _DetailedArticleState extends State<DetailedArticle> {
  String userLanguage;

  @override
  void initState() {
    super.initState();
    getUserLanguage();
    updateFirestoreReadArticlesCount();
    // print(userLanguage);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void updateFirestoreReadArticlesCount() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String userId = user.uid;
    int readArticlesCount = 0;

    DocumentSnapshot document = await Firestore.instance
        .collection("userData")
        .document('$userId')
        .get();

    if (document.exists) {
      readArticlesCount = document['readArticlesCount'];
      print(readArticlesCount);
    }

    if (readArticlesCount == null) {
      readArticlesCount = 0;
    }

    await Firestore.instance.collection('userData').document('$userId').setData(
      {"readArticlesCount": readArticlesCount + 1},
      merge: true,
    );
  }

  Future<void> getUserLanguage() async {
    String language = await getCurrentLanguage();
    setState(() {
      userLanguage = language;
    });
    print(userLanguage);
  }

  @override
  Widget build(BuildContext context) {
    return userLanguage == null
        ? Center(
            child: CircularProgressIndicator(),
          )

        // WebviewScaffold is used in the place of WebView because google translate's redirect
        // didn't automatically redirect in WebView, it required a manual tap
        : WebviewScaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                "Article",
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.black),
            ),
            appCacheEnabled: false,
            clearCache: true,
            clearCookies: true,
            withLocalStorage: false,
            withJavascript: true,
            url: userLanguage == "en"
                ? widget.url
                : "https://translate.google.com/translate?hl=en&sl=auto&tl=$userLanguage&u=${widget.url}",
          );
  }
}

/* Scaffold(
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
            LikesNumber(
              doc: widget.doc,
            ),
            CommentNumber(doc: widget.doc),
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
      body: userLanguage == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : WebView(
              onWebViewCreated: (WebViewController viewController) {
              },
              initialUrl: userLanguage == "en"
                  ? widget.url
                  : "https://translate.google.com/translate?hl=en&sl=auto&tl=$userLanguage&u=${widget.url}",
              javascriptMode: JavascriptMode.unrestricted,
            ),
    ); */
