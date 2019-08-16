import 'package:flutter/material.dart';
import 'package:yafe/mainPages/supplementary/collector/twitterCollector.dart';
import 'package:yafe/mainPages/supplementary/renderer/twitterRenderer.dart';
import 'dart:async';

class TwitterFeedWidget extends StatefulWidget {
  TwitterFeedWidget({this.query: 'statuses/home_timeline.json?count=200'});
  final String query;

  @override
  _TwitterFeedWidgetState createState() => _TwitterFeedWidgetState();
}

class _TwitterFeedWidgetState extends State<TwitterFeedWidget> {
  List tweets;

  Future<Null> _gatherTweets() async {
    var collector = TwitterCollector.fromFile("config.yaml", widget.query);
    await collector.getConfigCredentials().then((success) {
      collector.gather().then((response) {
        setState(() {
          tweets = response;
        });
      });
    });

    return null;
  }

  @override
  initState() {
    super.initState();
    _gatherTweets();
  }

  @override
  Widget build(BuildContext context) {
    if (tweets == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Center(
        child: RefreshIndicator(
          child: TwitterRenderer().render(tweets),
          onRefresh: () => _gatherTweets(),
        ),
      );
    }
  }
}
