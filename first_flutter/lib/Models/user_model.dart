class UserData {
  String? email;
  String? username;
  String? token;
  List<String>? favorites;

  UserData({this.email, this.username, this.token, this.favorites});

  UserData.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    username = json['username'];
    token = json['token'];
    favorites = json['favorites'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['username'] = username;
    data['token'] = token;
    data['favorites'] = favorites;

    return data;
  }
}
