// lib/data/models/auth_response_model.dart
class AuthResponseModel {
  final String token;
  final String userId;
  final String username;
  final String email;
  final String avatar;

  AuthResponseModel({
    required this.token,
    required this.userId,
    required this.username,
    required this.email,
    required this.avatar,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      token: json['token'] ?? '',
      userId: json['userId'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'token': token,
    'userId': userId,
    'username': username,
    'email': email,
    'avatar': avatar,
  };
}
