import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:yafe/mainPages/pageCards/articleDatabase.dart';
// import 'package:yafe/mainPages/pageCards/aticleFeeder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share/share.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:yafe/Components/Community/detailedArticle.dart';
import 'package:yafe/Components/Community/imageDetailScreen.dart';
import 'package:yafe/Components/Community/videoCards.dart';
// import 'package:rxdart/rxdart.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:yafe/Pages/Comments/commentsPage.dart';

class ArticleCards extends StatefulWidget {
  @override
  _ArticleCardsState createState() => _ArticleCardsState();
}

class _ArticleCardsState extends State<ArticleCards> {
  getArticles(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents
        .map(
          (doc) => Card(
            margin: EdgeInsets.symmetric(vertical: 2),
            elevation: 0.5,
            child: doc['media'] == null
                ? createTextTile(doc)
                : createMediaTile(doc),
          ),
        )
        .toList();
  }

  Widget createTextTile(DocumentSnapshot doc) {
    return doc['textType'] == 'userPost'
        ? createUserPostTile(doc)
        : createArticleTile(doc);
  }

  Widget createUserPostTile(DocumentSnapshot doc) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(
            Icons.account_circle,
            color: Colors.grey,
            size: 44,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 6, 0, 10),
            child: Text(
              doc['userDisplayName'],
              style: TextStyle(fontWeight: FontWeight.w500),
              overflow: TextOverflow.clip,
              maxLines: 2,
            ),
          ),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              doc['postContents'],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton.icon(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  icon: Icon(Icons.comment),
                  onPressed: () {
                    Route route = MaterialPageRoute(
                      builder: (context) => CommentsPage(doc: doc),
                    );
                    Navigator.push(context, route);
                  },
                  label: Text(""),
                  textColor: Colors.grey[800],
                ),
                FlatButton.icon(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  icon: Icon(Icons.share),
                  label: Text(""),
                  onPressed: () {
                    Share.share(
                        "\"${doc['postContents']}\" \n-- ${doc['userDisplayName']} ");
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget createArticleTile(DocumentSnapshot doc) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DetailedArticle(
              url: doc['url'],
              likes: doc['likes'],
              dislikes: doc['dislikes'],
              doc: doc,
            ),
          ),
        );
      },
      leading: Padding(
        padding: const EdgeInsets.fromLTRB(0, 9, 0, 0),
        child: Icon(
          Icons.account_circle,
          size: 70,
          color: Colors.grey,
        ),
      ),
      // contentPadding: EdgeInsets.fromLTRB(16, 0, 20, 0),
      contentPadding: EdgeInsets.fromLTRB(10, 0, 15, 0),
      title: Padding(
        padding: const EdgeInsets.fromLTRB(0, 6, 0, 10),
        child: Text(
          doc['heading'],
          style: TextStyle(fontWeight: FontWeight.w500),
          overflow: TextOverflow.clip,
          maxLines: 2,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          // Fills in the article information

          Text(
            doc['description'],
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            softWrap: true,
            //textAlign: TextAlign.justify,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 16, 4, 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                // 'Posted on ${dayFormatter.toString()} - ${dayAndTime.hour}:${dayAndTime.minute} GMT',
                //'Posted on -- - -- GMT',
                'Posted on ${DateFormat('EE, d MMMM yyyy hh:mm a').format(doc['date'])}',
                style: TextStyle(fontSize: 11.9),
              ),
            ),
          ),
          /* Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                        child: SizedBox(
                          height: 1.2,
                          child: Center(
                            child: Container(
                              margin: EdgeInsetsDirectional.only(
                                  start: 0.0, end: 1.0),
                              height: 5.0,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ), */
        ],
      ),
      isThreeLine: true,
    );
  }

  Widget createMediaTile(DocumentSnapshot doc) {
    return doc['mediaType'] == 'image'
        ? imageTile(doc)
        : VideoPlayerCard(
            doc: doc,
          );
  }

  Widget imageTile(DocumentSnapshot doc) {
    final tag = 'imageHero';
    final imageUrl = doc['url'];

    return GestureDetector(
      child: ListTile(
        /* leading: Padding(
          padding: const EdgeInsets.fromLTRB(0, 9, 0, 0),
          child: Icon(
            Icons.account_circle,
            size: 70,
            color: Colors.grey,
          ),
        ),
        contentPadding: EdgeInsets.fromLTRB(10, 0, 15, 0), */
        title: Row(
          children: <Widget>[
            Icon(
              Icons.account_circle,
              color: Colors.grey,
              size: 44,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 6, 0, 10),
              child: Text(
                doc['heading'],
                style: TextStyle(fontWeight: FontWeight.w500),
                overflow: TextOverflow.clip,
                maxLines: 2,
              ),
            ),
          ],
        ),
        subtitle: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Hero(
                tag: tag,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  placeholder: (context, url) => Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 60),
                      child: Container(
                        width: 32,
                        height: 32,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton.icon(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  icon: Icon(Icons.comment),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CommentsPage(
                          doc: doc,
                        ),
                      ),
                    );
                  },
                  label: Text(""),
                  textColor: Colors.grey[800],
                ),
                FlatButton.icon(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  icon: Icon(Icons.share),
                  label: Text(""),
                  onPressed: () {
                    Share.share(imageUrl);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) {
              return ImageDetailScreen(
                tag: tag,
                url: imageUrl,
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('articles').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        return Container(
          child: !snapshot.hasData
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView(
                  children: getArticles(snapshot),
                ),
        );
      },
    );
  }
}

/* Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                child: SizedBox(
                  height: 1.2,
                  child: Center(
                    child: Container(
                      margin: EdgeInsetsDirectional.only(start: 86.0, end: 1.0),
                      height: 5.0,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ), */

/* class ArticleCards extends StatefulWidget {
  @override
  _ArticleCardsState createState() => _ArticleCardsState();
}

class _ArticleCardsState extends State<ArticleCards> {
  List<ArticleFeeder> articles = [];

  @override
  void initState() {
    super.initState();

    ArticleRepository.getArticles().then(
      (List<ArticleFeeder> articles) {
        setState(() {
          this.articles = articles;
        });
      },
    );
  }

  Widget _articleCard(ArticleFeeder article) {

    /* DateTime dateTime = DateTime.fromMicrosecondsSinceEpoch(article.time);
    String date = DateFormat.MMMMd().format(dateTime);
    String time = DateFormat.jm().format(dateTime); */

    final dayAndTime = DateTime.now();
    final dayFormatter = DateFormat('EE, d MMMM yyyy').format(DateTime.now());

    return GestureDetector(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            onTap: _push,
            leading: Padding(
              padding: const EdgeInsets.fromLTRB(0, 9, 0, 0),
              child: Icon(
                Icons.account_circle,
                size: 70,
                color: Colors.grey,
              ),
            ),
            contentPadding: EdgeInsets.fromLTRB(10, 0, 15, 0),
            title: Padding(
              padding: const EdgeInsets.fromLTRB(0, 6, 0, 10),
              child: Text(
                article.heading,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // Fills in the article information
                Text(
                  article.description,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  softWrap: true,
                  //textAlign: TextAlign.justify,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 8, 4, 4),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Posted on ${dayFormatter.toString()} - ${dayAndTime.hour}:${dayAndTime.minute} GMT',
                      //'Posted on -- - -- GMT',
                      style: TextStyle(fontSize: 11.9),
                    ),
                  ),
                ),
              ],
            ),
            isThreeLine: true,
          ),

          // Made a custom divider that's easier to manipulate
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
            child: SizedBox(
              height: 1.2,
              child: Center(
                child: Container(
                  margin: EdgeInsetsDirectional.only(start: 86.0, end: 1.0),
                  height: 5.0,
                  color: Colors.grey,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _push() {
    /* Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetailedArticle(),
      ),
    ); */
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: articles.length == 0
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: articles.length,
              itemBuilder: (_, index) {
                return _articleCard(
                  articles[index],
                );
              },
            ),
    );
  }
} */
