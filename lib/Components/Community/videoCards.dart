import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chewie/chewie.dart';
import 'package:share/share.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:yafe/Pages/Comments/commentsPage.dart';
// import 'package:custom_chewie/custom_chewie.dart';

class VideoPlayerCard extends StatefulWidget {
  VideoPlayerCard({this.doc});

  final DocumentSnapshot doc;

  @override
  _VideoPlayerCardState createState() => _VideoPlayerCardState();
}

class _VideoPlayerCardState extends State<VideoPlayerCard> {
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
    // chewieController.dispose();
    super.dispose();
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
      /* leading: Padding(
        padding: const EdgeInsets.fromLTRB(0, 9, 0, 0),
        child: Icon(
          Icons.account_circle,
          size: 70,
          color: Colors.grey,
        ),
      ),
      contentPadding: EdgeInsets.fromLTRB(10, 0, 15, 0), */
      title: Row(
        children: <Widget>[
          Icon(
            Icons.account_circle,
            color: Colors.grey,
            size: 44,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 6, 0, 10),
            child: Text(
              widget.doc['heading'],
              style: TextStyle(fontWeight: FontWeight.w500),
              overflow: TextOverflow.clip,
              maxLines: 2,
            ),
          ),
        ],
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
                      _controller,
                      aspectRatio: _controller.value.aspectRatio,
                      autoPlay: false,
                      looping: true,
                      // showControls: true,
                    ),
                  );
                } else {
                  // If the VideoPlayerController is still initializing, show a
                  // loading spinner.
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton.icon(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                icon: Icon(Icons.comment),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CommentsPage(
                        doc: widget.doc,
                      ),
                    ),
                  );
                },
                label: Text(""),
                textColor: Colors.grey[800],
              ),
              FlatButton.icon(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                icon: Icon(Icons.share),
                label: Text(""),
                onPressed: () {
                  Share.share(widget.doc["url"]);
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
