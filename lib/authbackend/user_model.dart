class UserModel {
  String? username;
  String? useremail;
  String? phone;
  String? password;
  String? id;
  String? ref;
  bool? purchased;
  String? tokens;
  String? timeagoe;
  String? package;
  String? messages;
  int? remin;

  UserModel(
      {this.useremail,
      this.messages,
      this.username,
      this.phone,
      this.id,
      this.ref,
      this.password,
      this.package,
      this.purchased,
      this.timeagoe,
      this.remin,
      this.tokens});

  factory UserModel.tojson(Map<String, dynamic> json) {
    return UserModel(
        messages: json["messages"],
        id: json["id"],
        useremail: json["useremail"],
        phone: json["phone"],
        username: json["username"],
        ref: json['ref'],
        password: json["password"],
        purchased: json['purchased'],
        tokens: json['tokens'],
        remin: json['remain'],
        timeagoe: json["timeagoe"],
        package: json['package']);
  }

  Map<String, dynamic> fromjson() => {
        "username": username,
        "messages": messages,
        "useremail": useremail,
        "phone": phone,
        "id": id,
        'ref': ref,
        "password": password,
        'purchased': purchased,
        'tokens': tokens,
        'remain': remin,
        'timeagoe': timeagoe,
        'package': package,
      };
}
