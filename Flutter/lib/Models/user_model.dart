class UserData {
  String? email;
  String? username;
  String? token;

  UserData({this.email, this.username, this.token});

  UserData.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    username = json['username'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['username'] = username;
    data['token'] = token;

    return data;
  }
}
