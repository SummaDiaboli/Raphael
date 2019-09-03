import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:yafe/Components/Community/detailedArticle.dart';

class NewsCarousel extends StatefulWidget {
  @override
  _NewsCarouselState createState() => _NewsCarouselState();
}

class _NewsCarouselState extends State<NewsCarousel> {
  List<CachedNetworkImage> newsImages = [];
  List<String> urls = [];
  GlobalKey swiperKey = GlobalKey(debugLabel: 'SwiperKey');

  @override
  void initState() {
    super.initState();
    getCarousel();
  }

  @override
  void dispose() {
    super.dispose();
    newsImages = [];
    urls = [];
  }

  getCarousel() async {
    await Firestore.instance
        .collection('newsCarousel')
        .snapshots()
        .forEach((document) {
      document.documents.map((doc) {
        urls.add(doc['url']);

        newsImages.add(
          CachedNetworkImage(
            imageUrl: doc['contentUrl'],
            fit: BoxFit.cover,
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
    return newsImages == null
        ? Center(child: CircularProgressIndicator())
        : SizedBox(
            height: 180,
            child: Swiper(
              key: swiperKey,
              itemBuilder: (BuildContext context, int index) {
                return Stack(
                  children: <Widget>[
                    Container(
                      width: 200,
                      height: 160,
                      child: newsImages[index],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Stack(
                          children: <Widget>[
                            Positioned.fill(
                              child: Opacity(
                                opacity: 0.5,
                                child: Container(
                                  height: 80,
                                  width: 200,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 8),
                              child: Text(
                                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec accumsan nec neque et fringilla",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              },
              itemCount: newsImages.length,
              viewportFraction: 0.5,
              scale: 0.9,
              onTap: (int index) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DetailedArticle(
                      url: urls[index],
                    ),
                  ),
                );
              },
            ),
          );
  }
}
