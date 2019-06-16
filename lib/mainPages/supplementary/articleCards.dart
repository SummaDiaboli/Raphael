import 'package:flutter/material.dart';
import 'package:yafe/mainPages/detailPages/detailedArticles.dart';

// This is used for the Date and Time formatting
import 'package:intl/intl.dart';

class HomeArticleCards extends StatefulWidget {
  @override
  _HomeArticleCardsState createState() => _HomeArticleCardsState();
}

class _HomeArticleCardsState extends State<HomeArticleCards> {
  /*
    This generates an array containing the lorem ipsum 20 times
    It is used for the text inside the list tiles
  */

  final articleText = List<String>.generate(
    20,
    (i) =>
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi augue tellus, semper ut auctor ac, egestas ac mauris. Morbi id risus imperdiet, tristique nibh sed, dignissim arcu. Cras volutpat dolor sit amet dapibus dignissim",
  );

  /*
    Generates an array containing the ipsum 20 times
    This is used to set the article titles
  */

  final articleHeading = List<String>.generate(
    20,
    (i) => "Pellentesque vel sapien neque",
  );

  /*
    Scamming the system by setting the date and time to
    when the app is opened
  */
  final dayAndTime = DateTime.now();

  /*
    The format below is used for the date and time
    This is appreviated day, the day number, full month and full year
  */
  final dayFormatter = DateFormat('EE, d MMMM yyyy').format(DateTime.now());

  Widget _articleCards(BuildContext context, int index) {
    final article = articleText[index];
    final header = articleHeading[index];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Creates the account image icon at the side
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
            child: Text(
              header,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // Fills in the article information
              Text(
                article,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                softWrap: true,
                //textAlign: TextAlign.justify,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 8, 4, 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Posted on ${dayFormatter.toString()} - ${dayAndTime.hour}:${dayAndTime.minute} GMT',
                    style: TextStyle(fontSize: 11.9),
                  ),
                ),
              ),
            ],
          ),
          isThreeLine: true,
        ),

        // Made a custom divider that's easier to manipulate
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
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

  void _push() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetailedArticle(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    /*
      Creates the listview using the length of 20 from the array of
      article text and uses the articleCards widget to build the
      contents of the listview
    */
    return ListView.builder(
      itemCount: articleText.length,
      itemBuilder: _articleCards,
    );
  }
}
