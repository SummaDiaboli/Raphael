import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TwitterTile extends StatefulWidget {
  TwitterTile(Map<String, dynamic> tweet) : this.tweet = tweet;

  final Map<String, dynamic> tweet;

  @override
  _TwitterTileState createState() => _TwitterTileState();
}

class _TwitterTileState extends State<TwitterTile> {
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
          title: Row(
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(children: <Widget>[
                      Text("${widget.tweet['retweet_count']}"),
                      //TODO : use this when Flutter will support svg new Image.asset("assets/retweet.svg"),
                      Icon(Icons.autorenew),
                    ]),
                    Row(
                      children: <Widget>[
                        Text("${widget.tweet['favorite_count']}"),
                        Icon(Icons.favorite_border),
                      ],
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
