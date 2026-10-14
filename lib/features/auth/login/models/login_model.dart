class loginModel {
  String? accessToken;
  String? refreshToken;

  loginModel({this.accessToken, this.refreshToken});

  loginModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    refreshToken = json['refresh_token'];
  }
}
