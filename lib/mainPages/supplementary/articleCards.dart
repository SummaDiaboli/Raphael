import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';

class ArticleCards extends StatefulWidget {
  @override
  _ArticleCardsState createState() => _ArticleCardsState();
}

class _ArticleCardsState extends State<ArticleCards> {
  final articleText = List<String>.generate(
    20,
    (i) =>
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi augue tellus, semper ut auctor ac, egestas ac mauris. Morbi id risus imperdiet, tristique nibh sed, dignissim arcu. Cras volutpat dolor sit amet dapibus dignissim",
  );

  final articleHeading = List<String>.generate(
    20,
    (i) => "Pellentesque vel sapien neque",
  );

  final dayAndTime = DateTime.now();
  final dayFormatter = DateFormat('EEEE, d MMMM yyyy').format(DateTime.now());

  Widget _articleCards(BuildContext context, int index) {
    final article = articleText[index];
    final header = articleHeading[index];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListTile(
          leading: Padding(
            padding: const EdgeInsets.fromLTRB(0, 9, 0, 0),
            child: Icon(
              Icons.account_circle,
              size: 70,
              color: Colors.grey,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          title: Padding(
            padding: const EdgeInsets.fromLTRB(0, 6, 0, 10),
            child: Text(
              header,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          subtitle: Text(
            article,
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
          ),
          isThreeLine: true,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 8, 4, 4),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Posted on ${dayFormatter.toString()} - ${dayAndTime.hour}:${dayAndTime.minute} GMT',
              style: TextStyle(fontSize: 11.9),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 20, 10),
          child: SizedBox(
            height: 1.2,
            child: Center(
              child: Container(
                margin: EdgeInsetsDirectional.only(start: 86.0, end: 1.0),
                height: 5.0,
                color: Colors.grey,
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: articleText.length,
      itemBuilder: _articleCards,
    );
  }
}
