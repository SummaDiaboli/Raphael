// import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class UploadsVideoPlayerCard extends StatefulWidget {
  UploadsVideoPlayerCard({this.doc});

  final DocumentSnapshot doc;

  @override
  _UploadsVideoPlayerCardState createState() => _UploadsVideoPlayerCardState();
}

class _UploadsVideoPlayerCardState extends State<UploadsVideoPlayerCard> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    _controller = VideoPlayerController.network(widget.doc['url']);
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        setState(
          () {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          },
        );
      },
      /* title: Row(
        children: <Widget>[
          widget.doc['photoUrl'] == null
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
                    imageUrl: widget.doc['photoUrl'],
                    placeholder: (context, url) => CircleAvatar(
                      backgroundImage:
                          NetworkImage("${widget.doc['photoUrl']}"),
                      backgroundColor: Colors.grey,
                      radius: 20,
                    ),
                  ),
                ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 6, 0, 10),
            child: Text(
              widget.doc['userDisplayName'],
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
                context, "Are you sure you want to delete this?", widget.doc);
          }
        },
      ),
      subtitle: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If the VideoPlayerController has finished initialization, use
                  // the data it provides to limit the aspect ratio of the video.
                  return AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    // Use the VideoPlayer widget to display the video.
                    child: Chewie(
                      controller: ChewieController(
                        showControls: false,
                        videoPlayerController: _controller,
                        aspectRatio: _controller.value.aspectRatio,
                        autoPlay: false,
                        looping: true,
                      ),
                      // showControls: true,
                    ),
                  );
                } else {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 80),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 16, 4, 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Posted on ${DateFormat('EE, d MMMM yyyy hh:mm a').format(widget.doc['date'])}',
                style: TextStyle(fontSize: 11.9),
              ),
            ),
          ),
        ],
      ),
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
