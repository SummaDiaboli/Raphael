import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yafe/Components/Community/detailedArticle.dart';
import 'package:yafe/Components/Community/imageDetailScreen.dart';
import 'package:yafe/Components/Drawer/uploadsVideoCard.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UploadsPage extends StatefulWidget {
  @override
  _UploadsPageState createState() => _UploadsPageState();
}

class _UploadsPageState extends State<UploadsPage> {
  String uid;

  getUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String userId = user.uid;
    setState(() {
      uid = userId;
    });
  }

  Future _buildErrorDialog(BuildContext context, _message) {
    return showDialog(
      builder: (context) {
        return AlertDialog(
          title: Text('Error Message'),
          content: Text(_message),
          actions: <Widget>[
            FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        );
      },
      context: context,
    );
  }

  Future<void> _buildConfirmation(
      BuildContext context, _message, DocumentSnapshot doc) {
    return showDialog<void>(
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text(_message),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "Delete Upload",
                style: TextStyle(color: Colors.red[800]),
              ),
              onPressed: () {
                _deleteUpload(doc);
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                "Close",
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
      context: context,
    );
  }

  _deleteUpload(DocumentSnapshot doc) {
    try {
      Firestore.instance.document(doc.reference.path).delete();
    } catch (e) {
      print(e);
      _buildErrorDialog(context, e.toString());
    }
  }

  getUploads(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents
        .map(
          (doc) => Card(
            // margin: EdgeInsets.all(0),
            // elevation: 0.2,
            child: doc['media'] == null
                ? createTextTile(doc)
                : createMediaTile(doc),
          ),
        )
        .toList();
  }

  Widget createTextTile(DocumentSnapshot doc) {
    return doc['textType'] == 'userPost'
        ? createUserPostTile(doc)
        : createArticleTile(doc);
  }

  Widget createUserPostTile(DocumentSnapshot doc) {
    return ListTile(
      trailing: PopupMenuButton(
        icon: Icon(Icons.more_horiz),
        itemBuilder: (BuildContext context) {
          return UploadActions.actions.map((String action) {
            return PopupMenuItem<String>(
                value: action,
                child: action == UploadActions.Delete
                    ? Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(1, 0, 4, 0),
                            child: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                          Text(action),
                        ],
                      )
                    : null);
          }).toList();
        },
        onSelected: (String choice) {
          if (choice == UploadActions.Delete) {
            _buildConfirmation(
                context, "Are you sure you want to delete this?", doc);
          }
        },
      ),
      subtitle: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              doc['postContents'],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 16, 4, 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Posted on ${DateFormat('EE, d MMMM yyyy hh:mm a').format(doc['date'])}',
                  style: TextStyle(fontSize: 11.9),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget createArticleTile(DocumentSnapshot doc) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DetailedArticle(
              url: doc['url'],
              // likes: doc['likes'],
              // dislikes: doc['dislikes'],
              // doc: doc,
            ),
          ),
        );
      },
      /* leading: Padding(
        padding: const EdgeInsets.fromLTRB(0, 9, 0, 0),
        child: doc['photoUrl'] == null
            ? Icon(
                Icons.account_circle,
                size: 45,
                color: Colors.grey,
              )
            : ClipOval(
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  height: 45,
                  width: 45,
                  imageUrl: doc['photoUrl'],
                  placeholder: (context, url) => CircleAvatar(
                    backgroundImage: NetworkImage("${doc['photoUrl']}"),
                    backgroundColor: Colors.grey,
                    radius: 20,
                  ),
                ),
              ),
      ), */
      // contentPadding: EdgeInsets.fromLTRB(16, 0, 20, 0),
      contentPadding: EdgeInsets.fromLTRB(10, 0, 15, 0),
      trailing: PopupMenuButton(
        icon: Icon(Icons.more_horiz),
        itemBuilder: (BuildContext context) {
          return UploadActions.actions.map((String action) {
            return PopupMenuItem<String>(
                value: action,
                child: action == UploadActions.Delete
                    ? Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(1, 0, 4, 0),
                            child: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                          Text(action),
                        ],
                      )
                    : null);
          }).toList();
        },
        onSelected: (String choice) {
          if (choice == UploadActions.Delete) {
            _buildConfirmation(
                context, "Are you sure you want to delete this?", doc);
          }
        },
      ),
      title: Padding(
        padding: const EdgeInsets.fromLTRB(0, 6, 0, 10),
        child: Text(
          doc['heading'],
          style: TextStyle(fontWeight: FontWeight.w500),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          // Fills in the article information
          Text(
            doc['description'],
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            softWrap: true,
            //textAlign: TextAlign.justify,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 16, 4, 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                // 'Posted on ${dayFormatter.toString()} - ${dayAndTime.hour}:${dayAndTime.minute} GMT',
                //'Posted on -- - -- GMT',
                'Posted on ${DateFormat('EE, d MMMM yyyy hh:mm a').format(doc['date'])}',
                style: TextStyle(fontSize: 11.9),
              ),
            ),
          ),
        ],
      ),
      isThreeLine: true,
    );
  }

  Widget createMediaTile(DocumentSnapshot doc) {
    return doc['mediaType'] == "image"
        ? imageTile(doc)
        : UploadsVideoPlayerCard(
            doc: doc,
          );
  }

  Widget imageTile(DocumentSnapshot doc) {
    final tag = 'imageHero';
    final imageUrl = doc['url'];

    return GestureDetector(
      child: ListTile(
        /* title: Row(
          children: <Widget>[
            doc['photoUrl'] == null
                ? Icon(
                    Icons.account_circle,
                    color: Colors.grey,
                    size: 44,
                  )
                : ClipOval(
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      height: 45,
                      width: 45,
                      imageUrl: doc['photoUrl'],
                      placeholder: (context, url) => CircleAvatar(
                        backgroundImage: NetworkImage("${doc['photoUrl']}"),
                        backgroundColor: Colors.grey,
                        radius: 20,
                      ),
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 6, 0, 10),
              child: Text(
                doc['userDisplayName'],
                style: TextStyle(fontWeight: FontWeight.w500),
                overflow: TextOverflow.clip,
                maxLines: 2,
              ),
            ),
          ],
        ), */
        trailing: PopupMenuButton(
          icon: Icon(Icons.more_horiz),
          itemBuilder: (BuildContext context) {
            return UploadActions.actions.map((String action) {
              return PopupMenuItem<String>(
                  value: action,
                  child: action == UploadActions.Delete
                      ? Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(1, 0, 4, 0),
                              child: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                            Text(action),
                          ],
                        )
                      : null);
            }).toList();
          },
          onSelected: (String choice) {
            if (choice == UploadActions.Delete) {
              _buildConfirmation(
                  context, "Are you sure you want to delete this?", doc);
            }
          },
        ),
        subtitle: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Hero(
                tag: tag,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
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
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 16, 4, 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Posted on ${DateFormat('EE, d MMMM yyyy hh:mm a').format(doc['date'])}',
                  style: TextStyle(fontSize: 11.9),
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) {
              return ImageDetailScreen(
                tag: tag,
                url: imageUrl,
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    getUser();
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('articles')
          .where("userId", isEqualTo: uid)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            centerTitle: true,
            title: Text(
              "Uploads",
              style: TextStyle(color: Colors.black),
            ),
          ),
          body: Container(
            child: !snapshot.hasData
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView(
                    children: getUploads(snapshot),
                  ),
          ),
        );
      },
    );
  }
}

class UploadActions {
  // static const String Edit = 'Edit';
  static const String Delete = 'Delete';

  static const List<String> actions = <String>[
    // Edit,
    Delete,
  ];
}
