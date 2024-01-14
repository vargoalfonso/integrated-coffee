import 'dart:convert' as convert;
import 'package:flutter_application_3/model/model.dart';
import 'package:http/http.dart' as http;

/// FormController is a class which does the work of saving FeedbackForm in Google Sheets
/// using HTTP GET request on Google App Script Web URL and parses the response and sends a result callback.
class FormController {
  // Google App Script Web URL.
  static const String URL =
      "https://script.google.com/macros/s/AKfycbyvnDcrNBhn23OBYAmrWOdwpFLdI1KBJyJ4F7vb8yO5fye52n4_wnLzU18Krei5qsMB/exec";

  // Success Status Message
  static const STATUS_SUCCESS = "SUCCESS";

  /// Async function which saves feedback, parses [feedbackForm] parameters
  /// and sends an HTTP GET request on [URL]. On successful response, [callback] is called.
  void submitForm(
      FeedbackForm feedbackForm, void Function(String) callback) async {
    try {
      final Uri url = Uri.parse(URL); // Convert the URL string to a Uri object
      final http.Response response =
          await http.post(url, body: feedbackForm.toJson());

      if (response.statusCode == 302) {
        var redirectUrl = response.headers['location'];
        if (redirectUrl != null) {
          final Uri newUrl = Uri.parse(
              redirectUrl); // Convert the redirect URL string to a Uri object
          final http.Response newResponse = await http.get(newUrl);
          callback(convert.jsonDecode(newResponse.body)['status']);
        } else {
          callback("Error: Redirect URL is null");
        }
      } else {
        callback(convert.jsonDecode(response.body)['status']);
      }
    } catch (e) {
      print(e);
    }
  }
}
