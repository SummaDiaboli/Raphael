import 'package:flutter/material.dart';
import 'package:yafe/mainPages/pageCards/twitterCards.dart';

class TwitterRenderer {
  TwitterRenderer();

  Widget render(List data) {
    return ListView(
      children: data.map((tweet) => TwitterTile(tweet)).toList(),
    );
  }
}
