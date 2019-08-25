import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class UReportPage extends StatefulWidget {
  @override
  _UReportPageState createState() => _UReportPageState();
}

class _UReportPageState extends State<UReportPage> {
  String _articleDescription;
  String _articleTitle;
  // String _articleUrl;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading;

  @override
  void initState() {
    _isLoading = false;
    super.initState();
  }

  @override
  void dispose() {
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

  Future<void> _buildConfirmation(BuildContext context, _message) {
    return showDialog<void>(
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text(_message),
          actions: <Widget>[
            FlatButton(
              child: Text("Close"),
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

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  _submitArticle() async {
    if (_validateAndSave()) {
      setState(() {
        _isLoading = true;
      });
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      try {
        FirebaseUser user = await FirebaseAuth.instance.currentUser();
        String userId = user.uid;
        String displayName = user.displayName;
        String photoUrl = user.photoUrl;
        DateTime dateAndTime = DateTime.now();

        CollectionReference dbPending =
            Firestore.instance.collection('pending');
        await dbPending.add({
          "date": dateAndTime,
          "userDisplayName": displayName,
          "userId": userId,
          "photoUrl": photoUrl,
          // "url": _articleUrl,
          "description": _articleDescription,
          "heading": _articleTitle,
        });

        setState(() {
          _isLoading = false;
        });
        _formKey.currentState.reset();
        _buildConfirmation(context,
            "Your article has been uploaded. You will be contacted if any issues arise");
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        return _buildErrorDialog(
          context,
          e.toString(),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "U-Report",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 40, 20, 15),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        labelText: "Article Title",
                        labelStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          setState(() {
                            _isLoading = false;
                          });
                          return "Article Title cannot be empty";
                        }
                        return null;
                      },
                      onSaved: (value) => _articleTitle = value,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      maxLines: 5,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        labelText: "Article Description",
                        labelStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          setState(() {
                            _isLoading = false;
                          });
                          return 'Article Description can\'t be empty';
                        }
                        return null;
                      },
                      onSaved: (value) => _articleDescription = value,
                    ),
                  ),
                  /* Padding(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 18),
                    child: TextFormField(
                      keyboardType: TextInputType.url,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        labelText: "Article URL",
                        labelStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          setState(() {
                            _isLoading = false;
                          });
                          return "Article URL cannot be empty";
                        }

                        if (!value.contains(
                          RegExp(
                              r'[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)'),
                        )) {
                          return "This is not a valid URL";
                        }

                        return null;
                      },
                      onSaved: (value) => _articleUrl = value,
                    ),
                  ), */
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 18, 0, 10),
                    child: FlatButton(
                      padding: EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 15,
                      ),
                      child: Text(
                        "SUBMIT",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Colors.red[800],
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                        side: BorderSide(
                          color: Colors.red[800],
                        ),
                      ),
                      onPressed: _submitArticle,
                    ),
                  )
                ],
              ),
            ),
          ),
          _showCircularProgress(),
        ],
      ),
    );
  }
}
