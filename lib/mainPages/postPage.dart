import 'package:flutter/material.dart';
import 'package:yafe/mainPages/supplementary/postCards.dart';

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    return PostsCards();
  }
}
