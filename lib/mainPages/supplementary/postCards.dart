import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'package:yafe/mainPages/detailPages/detailedPosts.dart';

class PostsCards extends StatefulWidget {
  @override
  _PostsCardsState createState() => _PostsCardsState();
}

class _PostsCardsState extends State<PostsCards> {
  final usernameList = List<String>.generate(
    20,
    (i) => "Lorem ipsum",
  );

  final postText = List<String>.generate(
    20,
    (i) =>
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi augue tellus, semper ut auctor ac, egestas ac mauris. Morbi id risus imperdiet, tristique nibh sed, dignissim arcu. Cras volutpat dolor sit amet dapibus dignissim",
  );

  Widget _postsCards(BuildContext context, int index) {
    final usernames = usernameList[index];
    final posts = postText[index];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Card(
          margin: EdgeInsets.symmetric(vertical: 2),
          elevation: 0.5,
          child: Column(
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
                  child: Row(
                    children: <Widget>[
                      Text(
                        usernames,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(13, 0, 0, 0),
                        child: Text(
                          "@ipsum ",
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 13),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                        child: Text("•"),
                      ),
                      Text(
                        "${randomNumberGenerator(60)} mins ago",
                        style: TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Text(
                    posts,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 4,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(73, 0, 3, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    FlatButton(
                      padding: EdgeInsets.all(0),
                      child: Text(
                        "Upvote",
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                      onPressed: () {},
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 17, 0),
                      child: FlatButton(
                        padding: EdgeInsets.all(0),
                        child: Text(
                          "Mark as Hate",
                          style: TextStyle(
                            color: Colors.red[800],
                            fontSize: 13,
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Text(
                        "Retweets: ${randomNumberGenerator(1000)}",
                        style: TextStyle(
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        /* Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 10, 5),
          child: SizedBox(
            height: 1.2,
            child: Center(
              child: Container(
                margin: EdgeInsetsDirectional.only(start: 86.0, end: 0.0),
                height: 5.0,
                color: Colors.grey,
              ),
            ),
          ),
        ) */
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: _postsCards,
      itemCount: usernameList.length,
    );
  }

  void _push() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetailedPosts(),
      ),
    );
  }

  int randomNumberGenerator(int max) {
    var random = Random();
    return random.nextInt(max);
  }
}
