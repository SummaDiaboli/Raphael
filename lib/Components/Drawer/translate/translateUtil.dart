/* import 'package:android_intent/android_intent.dart';
import 'package:url_launcher/url_launcher.dart';

/// Leaving this in, just in case we want to send user to Google Translate App.
/// For now we are just using a web view to open GoogleTranslate.
class TranslateUtils {
  static openTranslate() async {
    try {
      AndroidIntent intent = AndroidIntent(
        action: "action_send",
        package: "com.google.android.apps.translate",
        componentName: "com.google.android.apps.translate.TranslateActivity",
        arguments: {
          "key_text_input": "hello",
          "key_language_from": "en",
          "key_language_to": "ha"
        },
      );
      await intent.launch();
    } catch (err) {
      const url =
          "https://translate.google.com/#view=home&op=translate&sl=en&tl=ha";
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }
}
 */