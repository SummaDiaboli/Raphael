import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TwitterTile extends StatefulWidget {
  TwitterTile(Map<String, dynamic> tweet) : this.tweet = tweet;

  final Map<String, dynamic> tweet;

  @override
  _TwitterTileState createState() => _TwitterTileState();
}

class _TwitterTileState extends State<TwitterTile> {
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
    List<Widget> tweetContent = [
      Text(widget.tweet['text']),
    ];

    //If tweet contains images, add them
    if (widget.tweet["entities"].containsKey("media")) {
      var tweetImages = widget.tweet["entities"]["media"];
      var numberOfImagePerRow =
          tweetImages.length <= 3 ? tweetImages.length : 2;
      List<Widget> images = List<Widget>();
      tweetImages.forEach(
        (image) => images.add(
          CachedNetworkImage(
            imageUrl: image['media_url_https'],
            placeholder: (context, url) => Center(
              child: Container(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(),
              ),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          /* Image.network(
            image['media_url_https'],
          ), */
        ),
      );
      tweetContent.add(
        Container(
          height: 200.0,
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: GridView.count(
              physics: NeverScrollableScrollPhysics(),
              primary: true,
              shrinkWrap: true,
              crossAxisCount: numberOfImagePerRow,
              children: images,
            ),
          ),
        ),
      );
    }
    return InkWell(
      child: Card(
        margin: const EdgeInsets.all(5.0),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
              widget.tweet["user"]["profile_image_url_https"],
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
            child: Row(
              //Tweet heading
              children: <Widget>[
                Text(
                  "${widget.tweet['user']['name']}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    "@${widget.tweet['user']['screen_name']}",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.start,
            ),
          ),
          subtitle: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  children: tweetContent,
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 2, 0),
                            child: Text("${widget.tweet['retweet_count']}"),
                          ),
                          Icon(
                            Icons.autorenew,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 2, 0),
                            child: Text("${widget.tweet['favorite_count']}"),
                          ),
                          Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.all(0),
                      color: Colors.blueAccent,
                      icon: Icon(Icons.share),
                      onPressed: () {
                        //* Gets the shortened tweet URl for sharing */
                        Share.share(
                          widget.tweet['entities']['urls'][0]['url'],
                        ).whenComplete(() async {
                          updateFirestoreShareCount();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () => _launchTwitterURL(widget.tweet["id_str"]),
    );
  }
}

_launchTwitterURL(String tweetId) async {
  var fullURL = 'https://twitter.com/statuses/$tweetId';

  if (await canLaunch(fullURL)) {
    await launch(fullURL);
  } else {
    throw 'Could not launch $fullURL';
  }
}
