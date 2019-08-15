import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class NewsCarousel extends StatefulWidget {
  @override
  _NewsCarouselState createState() => _NewsCarouselState();
}

// TODO: have the container for the urls open links to the articles.

class _NewsCarouselState extends State<NewsCarousel> {
  List<Image> newsImages = [
    Image.asset("assets/images/hatespeech/hatespeechImage1.jpeg"),
    Image.asset("assets/images/hatespeech/hatespeechImage2.jpg"),
    Image.asset("assets/images/hatespeech/hatespeechImage3.jpg"),
    Image.asset("assets/images/hatespeech/hatespeechImage4.jpg"),
  ];

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
        ),
      ),
    );
  }
}
