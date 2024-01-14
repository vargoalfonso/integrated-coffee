class FeedbackForm {
  String _name;
  String _email;
  String _mobileNo;
  String _feedback;
  String _password;

  FeedbackForm(
      this._name, this._email, this._mobileNo, this._feedback, this._password);

  // Method to make GET parameters.
  String toParams() =>
      "?name=$_name&email=$_email&mobileNo=$_mobileNo&feedback=$_feedback&password=$_password";
}
