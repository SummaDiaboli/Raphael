import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool pushNotification = true;
  bool surveyPollOptIn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text(
          "Settings",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView(
        children: <Widget>[
          SwitchListTile.adaptive(
            title: Text("Push Notifications"),
            value: pushNotification,
            onChanged: (bool) {
              setState(() {
                pushNotification = !pushNotification;
              });
            },
          ),
          SwitchListTile.adaptive(
            title: Text("Opt in to surveys and polls"),
            value: surveyPollOptIn,
            onChanged: (bool) {
              setState(() {
                surveyPollOptIn = !surveyPollOptIn;
              });
            },
          )
        ],
      ),
    );
  }
}
