import 'dart:convert' as convert;
import 'package:flutter_application_3/model/Cmodel.dart';
import 'package:http/http.dart' as http;

class FormController {
  // Callback function to give response of status of the current request.
  final void Function(String) callback;

  // Google App Script Web URL
  static const String URL =
      "https://script.google.com/macros/s/AKfycbxAc4z7d-L1Rto05qw8V0-8RXZnuLLEgM_KVdTtyeIs1ExcA59Rs7OMhUp-RXs-U2nG/exec";

  static const STATUS_SUCCESS = "SUCCESS";

  FormController(this.callback);

  void submitForm(FeedbackForm feedbackForm) async {
    try {
      Uri uri = Uri.parse(URL + feedbackForm.toParams());
      await http.get(uri).then(
        (response) {
          callback(convert.jsonDecode(response.body)['status']);
        },
      );
    } catch (e) {
      print(e);
    }
  }
}
