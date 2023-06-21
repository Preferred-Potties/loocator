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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['username'] = this.username;
    data['token'] = this.token;

    return data;
  }
}
