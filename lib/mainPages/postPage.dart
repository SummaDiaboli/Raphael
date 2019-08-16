import 'package:flutter/material.dart';
// import 'package:yafe/mainPages/supplementary/postCards.dart';
import 'package:yafe/mainPages/supplementary/twitterFeed.dart';

class PostPage extends StatefulWidget {
  PostPage();

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    // return PostsCards();
    return Center(
      child: TwitterFeedWidget(),
    );
  }
}
