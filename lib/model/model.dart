class FeedbackForm {
  String name;
  String email;
  String password;
  String numberphone;

  FeedbackForm(this.name, this.email, this.password, this.numberphone);

  factory FeedbackForm.fromJson(dynamic json) {
    return FeedbackForm(
      json['name'] as String,
      json['email'] as String,
      json['password'] as String,
      json['Numberphone'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'password': password,
        'numberphone': numberphone,
      };
}
