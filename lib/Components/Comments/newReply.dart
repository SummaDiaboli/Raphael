import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewReply extends StatefulWidget {
  NewReply({this.doc});
  final DocumentSnapshot doc;

  @override
  _NewReplyState createState() => _NewReplyState();
}

class _NewReplyState extends State<NewReply> {
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
                })
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
        FirebaseUser user = await FirebaseAuth.instance.currentUser();
        String userId = user.uid;
        String photoUrl = user.photoUrl;
        String displayName = user.displayName;
        // String documentId = widget.doc.documentID;
        DateTime dateCreated = DateTime.now();

        await Firestore.instance
            .document(widget.doc.reference.path)
            .collection('replies')
            .document('$displayName$dateCreated')
            .setData({
          "comment": _comment,
          "userId": userId,
          "dateCreated": dateCreated,
          "displayName": displayName,
          "photoUrl": photoUrl,
        });

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
          "Reply",
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
                      maxLines: null,
                      minLines: 5,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        hintText: "Reply to comment",
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Reply cannot be empty';
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
                  child: Container(
                    width: 130,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                        side: BorderSide(
                          color: Colors.red[800],
                        ),
                      ),
                      onPressed: _validateAndSubmit,
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Submit Reply",
                            style: TextStyle(
                                color: Colors.red[800],
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          ),
                          /* Icon(
                            Icons.forward,
                            color: Colors.red[800],
                          ), */
                        ],
                      ),
                    ),
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
