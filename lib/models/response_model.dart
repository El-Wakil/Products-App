import 'user_model.dart';

class ResponseModel {
  final String message;
  final bool status;
  final String? token;
  final User? user;

  ResponseModel({
    required this.message,
    required this.status,
    this.token,
    this.user,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      message: json['message'] ?? '',
      status: _parseBoolFromDynamic(json['status']),
      token: json['token'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  // Helper method to handle both String and bool status values from API
  static bool _parseBoolFromDynamic(dynamic value) {
    if (value is bool) {
      return value;
    }
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    return false; // Default fallback
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status,
      if (token != null) 'token': token,
      if (user != null) 'user': user!.toJson(),
    };
  }
}
