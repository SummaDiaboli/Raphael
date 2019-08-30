import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class NewsCarousel extends StatefulWidget {
  @override
  _NewsCarouselState createState() => _NewsCarouselState();
}

class _NewsCarouselState extends State<NewsCarousel> {
  List<CachedNetworkImage> newsImages = [];
  GlobalKey swiperKey = GlobalKey(debugLabel: 'SwiperKey');

  @override
  void initState() {
    super.initState();
    getImages();
  }

  @override
  void dispose() {
    super.dispose();
    newsImages = [];
  }

  getImages() async {
    await Firestore.instance
        .collection('newsCarousel')
        .snapshots()
        .forEach((document) {
      document.documents.map((doc) {
        newsImages.add(
          CachedNetworkImage(
            imageUrl: doc['contentUrl'],
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
          ),
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Swiper(
        key: swiperKey,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            child: newsImages[index],
          );
        },
        itemCount: newsImages.length,
        viewportFraction: 0.6,
        scale: 0.9,
        onTap: (int index) {
          // Make sure the images open up a webview with the url
        },
        // control: SwiperControl(),
      ),
    );
  }
}
