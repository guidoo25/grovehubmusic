// To parse this JSON data, do
//
//     final authResponse = authResponseFromJson(jsonString);

import 'dart:convert';

AuthResponse authResponseFromJson(String str) =>
    AuthResponse.fromJson(json.decode(str));

String authResponseToJson(AuthResponse data) => json.encode(data.toJson());

class AuthResponse {
  bool success;
  Data data;

  AuthResponse({
    required this.success,
    required this.data,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
        success: json["success"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
      };
}

class Data {
  String token;
  User user;

  Data({
    required this.token,
    required this.user,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        token: json["token"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "user": user.toJson(),
      };
}

class User {
  String id;
  String email;
  String username;
  String role;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        email: json["email"],
        username: json["username"],
        role: json["role"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "username": username,
        "role": role,
      };
}
