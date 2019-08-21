// import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'dart:collection';
import 'package:yafe/_deprecated/pageCards/aticleFeeder.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class ArticleRepository {
  static const ARTICLE_TABLE_NAME = "articles";
  static const String KEY_LAST_FETCH = "last_fetch";
  static const int MILLISECONDS_IN_HOUR = 3600000;
  static const int REFRESH_THRESHOLD = 3 * MILLISECONDS_IN_HOUR;

  static Future<List<ArticleFeeder>> getArticles() async {
    List<ArticleFeeder> articles = [];

    // if (await _shouldRefreshLocalEvents()) {
    articles = await getEventsFromFirestore();
    //   _setLastRefreshToNow();
    // }

    return articles;
  }

  static Future<List<ArticleFeeder>> getEventsFromFirestore() async {
    CollectionReference ref = Firestore.instance.collection('/articles/');
    QuerySnapshot articlesQuery = await ref.getDocuments();

    HashMap<String, ArticleFeeder> articlesHashMap =
        HashMap<String, ArticleFeeder>();

    articlesQuery.documents.forEach(
      (document) {
        articlesHashMap.putIfAbsent(
          document['id'],
          () => ArticleFeeder(
            description: document['description'],
            heading: document['heading'],
            url: document['url'],
            // image: _getArticlePhotoUrl(document['image']),
            image: document['image'],
            dislikes: document['dislikes'],
            likes: document['likes'],
            time: document['date'],
          ),
        );
      },
    );

    return articlesHashMap.values.toList();
  }

  // static Future<bool> _shouldRefreshLocalEvents() async {
  //   Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  //   SharedPreferences prefs = await _prefs;
  //   int lastFetchTimeStamp = prefs.getInt(KEY_LAST_FETCH);

  //   if (lastFetchTimeStamp == null) {
  //     print("last timestamp is null");
  //     return true;
  //   }

  //   return (new DateTime.now().millisecondsSinceEpoch - lastFetchTimeStamp) >
  //       (REFRESH_THRESHOLD);
  // }

  // static void _setLastRefreshToNow() async {
  //   Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  //   SharedPreferences prefs = await _prefs;
  //   prefs.setInt(KEY_LAST_FETCH, new DateTime.now().millisecondsSinceEpoch);
  // }

  /* static String _getArticlePhotoUrl(Map<dynamic, dynamic> data) {
    String defaultImage = "";
    if (data == null) {
      return defaultImage;
    }

    Map<dynamic, dynamic> groupPhotoObject = data['groupPhoto'];
    if (groupPhotoObject == null) {
      return defaultImage;
    }

    String photoUrl = groupPhotoObject['photoUrl'];
    return photoUrl;
  } */
}
