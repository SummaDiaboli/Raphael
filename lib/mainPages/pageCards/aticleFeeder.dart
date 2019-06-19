import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

class ArticleFeeder {
  static final String columnId = "_id";
  static final String columnHeading = "heading";
  static final String columnDislikes = "dislikes";
  static final String columnDescription = "description";
  static final String columnUrl = "url";
  static final String columnPhotoUrl = "image";
  static final String columnLikes = "likes";
  static final String columnTime = "time";

  ArticleFeeder({
    @required this.heading,
    @required this.description,
    @required this.url,
    this.image,
    this.dislikes,
    this.likes,
    this.time,
  });

  final String heading;
  final String description;
  final String url;
  final String image;
  final int dislikes;
  final int likes;
  final DateTime time;

  Map toMap() {
    Map<String, dynamic> map = {
      columnDescription: description,
      columnDislikes: dislikes,
      columnHeading: heading,
      columnLikes: likes,
      columnPhotoUrl: image,
      columnUrl: url,
    };

    return map;
  }

  static ArticleFeeder fromMap(Map map) {
    return ArticleFeeder(
      heading: map[columnHeading],
      description: map[columnDescription],
      url: map[columnUrl],
      image: map[columnPhotoUrl],
      dislikes: map[columnDislikes],
      likes: map[columnLikes],
      time: map[columnTime],
    );
  }
}
