import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class EditComment extends StatefulWidget {
  EditComment({/* this.doc, */ this.comment});
  // final DocumentSnapshot doc;
  final DocumentSnapshot comment;

  @override
  _EditCommentState createState() => _EditCommentState();
}

class _EditCommentState extends State<EditComment> {
  final commentKey = GlobalKey<FormState>();
  String _comment;
  bool _isLoading;

  @override
  void initState() {
    super.initState();
    _isLoading = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Container(
        color: Colors.white70,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
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
              },
            )
          ],
        );
      },
      context: context,
    );
  }

  bool _validateAndSave() {
    final form = commentKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  _validateAndSubmit() async {
    if (_validateAndSave()) {
      setState(() {
        _isLoading = true;
      });
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      try {
        // FirebaseUser user = await FirebaseAuth.instance.currentUser();
        /* String userId = user.uid;
        String displayName = user.displayName;
        String documentId = widget.doc.documentID; */
        // DateTime dateCreated = DateTime.now();'

        await Firestore.instance
            .document(widget.comment.reference.path)
            .updateData(
          {"comment": _comment},
        );

        /* await Firestore.instance
            .collection('articles')
            .document('$documentId')
            .collection('comments')
            .document('$displayName${widget.comment['dateCreated']}')
            .updateData({
          "comment": _comment,
          "userId": userId,
          "dateCreated": "${widget.comment['dateCreated']}",
          "displayName": displayName,
        }); */

        setState(() {
          _isLoading = (false);
        });
        Navigator.pop(context);
      } catch (e) {
        print("Error: $e");
        setState(() {
          _isLoading = false;
        });
        return _buildErrorDialog(
            context, "Sorry, something went wrong trying to post your comment");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Write your comment",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: commentKey,
                    child: TextFormField(
                      initialValue: "${widget.comment['comment']}",
                      maxLines: null,
                      minLines: 10,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        hintText: "Comment on this",
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Comment cannot be empty';
                        }

                        return null;
                      },
                      onSaved: (value) => _comment = value,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        // alignment: ,
                        // width: 185,
                        child: FlatButton(
                          color: Colors.red[800],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                            side: BorderSide(
                              color: Colors.red[800],
                            ),
                          ),
                          onPressed: _validateAndSubmit,
                          child: Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            _showCircularProgress()
          ],
        ),
      ),
    );
  }
}
