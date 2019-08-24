import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class NewsCarousel extends StatefulWidget {
  @override
  _NewsCarouselState createState() => _NewsCarouselState();
}

// TODO: have the container for the urls open links to the articles.

class _NewsCarouselState extends State<NewsCarousel> {
  List<CachedNetworkImage> newsImages = [];

  @override
  void initState() {
    super.initState();
    getImages();
  }

  getImages() async {
    await Firestore.instance
        .collection('newsCarousel')
        .snapshots()
        .forEach((document) {
      document.documents.map((doc) {
        setState(() {
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
        });
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Container(
        child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: newsImages[index],
            );
          },
          itemCount: newsImages.length,
          viewportFraction: 0.6,
          scale: 0.9,
          // control: SwiperControl(),
        ),
      ),
    );
  }
}
