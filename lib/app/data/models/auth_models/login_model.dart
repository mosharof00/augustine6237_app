class LoginModel {
  LoginModel({this.success, this.message, this.data});

  final bool? success;
  final String? message;
  final LoginData? data;

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    return LoginModel(
      success: json['success'] ?? (json['statusCode'] == null || json['statusCode'] == 200),
      message: json['message'],
      data: LoginData.fromJson(rawData),
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data?.toJson(),
  };
}

class LoginData {
  LoginData({this.userId, this.type, this.accessToken, this.refreshToken});

  final String? userId;
  final String? type;
  final String? accessToken;
  final String? refreshToken;

  factory LoginData.fromJson(Map<String, dynamic> json) {
    final auth = json['authorization'] is Map<String, dynamic>
        ? json['authorization'] as Map<String, dynamic>
        : null;

    return LoginData(
      userId: json['userId'] ?? json['userid'] ?? json['id'],
      type: json['type'],
      accessToken: json['accessToken'] ??
          json['access_token'] ??
          auth?['access_token'],
      refreshToken: json['refreshToken'] ??
          json['refresh_token'] ??
          auth?['refresh_token'],
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'type': type,
    'accessToken': accessToken,
    'refreshToken': refreshToken,
  };
}
