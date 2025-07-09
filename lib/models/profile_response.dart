import 'user_model.dart';

class ProfileResponse {
  final String message;
  final bool status;
  final User? user;

  ProfileResponse({required this.message, required this.status, this.user});

  factory ProfileResponse.fromJson(dynamic json) {
    try {
      // Handle both Map and String responses
      if (json is String) {
        // Check if it's an HTML error response
        if (json.contains('<!DOCTYPE html>') || json.contains('<html')) {
          return ProfileResponse(
            message:
                'API endpoint not available. Please check your authentication.',
            status: false,
            user: null,
          );
        }
        return ProfileResponse(message: json, status: false, user: null);
      }

      if (json is Map<String, dynamic>) {
        return ProfileResponse(
          message: json['message'] ?? 'Unknown response',
          status: _parseBoolFromDynamic(json['status']),
          user: json['user'] != null ? User.fromJson(json['user']) : null,
        );
      }

      return ProfileResponse(
        message: 'Invalid response format: ${json.runtimeType}',
        status: false,
        user: null,
      );
    } catch (e) {
      return ProfileResponse(
        message: 'Error parsing response: ${e.toString()}',
        status: false,
        user: null,
      );
    }
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
}
