import 'package:flutter/material.dart';
import 'package:yafe/Utils/Language/language.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool pushNotification = true;
  bool surveyPollOptIn = true;
  String _value;
  String language;

  @override
  void initState() {
    super.initState();
    checkLanguage();
  }

  Future<void> checkLanguage() async {
    language = await getCurrentLanguage();
    switch (language) {
      case "en":
        setState(() {
          _value = "English";
        });
        break;
      case "ha":
        setState(() {
          _value = "Hausa";
        });
        break;
      case "ig":
        setState(() {
          _value = "Igbo";
        });
        break;
      case "yo":
        setState(() {
          _value = "Yoruba";
        });
        break;
    }
  }

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 0, 0),
                child: Text(
                  "Language",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 14, 0),
                child: DropdownButton<String>(
                  underline: null,
                  value: _value,
                  items: LanguageOptions.actions.map((String language) {
                    return DropdownMenuItem<String>(
                      value: language,
                      child: Text(language),
                    );
                  }).toList(),
                  onChanged: (String choice) {
                    switch (choice) {
                      case LanguageOptions.English:
                        setNewLanguage("en");
                        setState(() {
                          _value = choice;
                        });
                        break;
                      case LanguageOptions.Hausa:
                        setNewLanguage("ha");
                        setState(() {
                          _value = choice;
                        });
                        break;
                      case LanguageOptions.Igbo:
                        setNewLanguage("ig");
                        setState(() {
                          _value = choice;
                        });
                        break;
                      case LanguageOptions.Yoruba:
                        setNewLanguage("yo");
                        setState(() {
                          _value = choice;
                        });
                        break;
                    }
                  },
                ),
              ),
            ],
          ),
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

class LanguageOptions {
  static const String English = 'English';
  static const String Hausa = 'Hausa';
  static const String Igbo = 'Igbo';
  static const String Yoruba = 'Yoruba';

  static const List<String> actions = <String>[
    English,
    Hausa,
    Igbo,
    Yoruba,
  ];
}
