import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailedArticle extends StatefulWidget {
  @override
  _DetailedArticleState createState() => _DetailedArticleState();
}

enum MenuItems {
  settings,
}

class _DetailedArticleState extends State<DetailedArticle> {
  MenuItems _selection;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Detailed Article"),
        backgroundColor: Colors.grey[700],
        actions: <Widget>[
          PopupMenuButton<MenuItems>(
            onSelected: (MenuItems result) {
              setState(
                () {
                  _selection = result;
                  // Add code to navigate to user selection
                },
              );
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuItems>>[
                  PopupMenuItem<MenuItems>(
                    value: MenuItems.settings,
                    child: Text("Settings"),
                  )
                ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 202,
              child: Image.asset(
                'assets/images/logo.jpg',
                fit: BoxFit.contain,
                alignment: Alignment.centerLeft,
              ),
            ),
            ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 5),
                    child: Text(
                      "Pellentesque vel sapien neque",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: Text(
                      "Posted on ${dayFormatter.toString()} - ${dayAndTime.hour}:${dayAndTime.minute} GMT",
                      style: TextStyle(fontSize: 11.9),
                    ),
                  ),

                  // Divider

                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: SizedBox(
                      height: 1.2,
                      child: Center(
                        child: Container(
                          margin:
                              EdgeInsetsDirectional.only(start: 1.0, end: 0.0),
                          height: 5.0,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),

                  // Article Text
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 3, 0, 6),
                          child: Text(
                            "Nam scelerisque felis eu sollicitudin maximus. Sed vel tempus nibh. Pellentesque consectetur, nisl id vulputate vestibulum, justo urna gravida ligula, fermentum interdum nibh tortor a tellus. In hac habitasse platea dictumst.",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
                          child: Text(
                            "Curabitur tincidunt lectus turpis. Morbi nibh leo, vestibulum nec hendrerit in, imperdiet in neque. Maecenas ante arcu, imperdiet et rutrum sed, bibendum vel lacus. Quisque sit amet suscipit nisl, id molestie odio.",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
                          child: Text(
                            "Ut venenatis ipsum volutpat ultricies dapibus. Integer dignissim mattis ligula, interdum facilisis leo condimentum venenatis.",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
                          child: Text(
                            "Maecenas id semper enim. In aliquet non sem dapibus mollis. Duis ultrices ante at blandit iaculis. Fusce risus ex, aliquam sed aliquet vel, tristique vel augue. Cras egestas elit sit amet leo varius, sit amet tristique libero sollicitudin.",
                            style: TextStyle(fontSize: 14),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
