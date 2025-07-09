import 'package:dio/dio.dart';
import 'package:product_api_app/models/response_model.dart';
import 'package:product_api_app/models/profile_response.dart';

class AuthData {
  final Dio dio = Dio();

  // Set authorization header if token is available
  void setAuthToken(String? token) {
    if (token != null) {
      dio.options.headers['Authorization'] = 'Bearer $token';
    } else {
      dio.options.headers.remove('Authorization');
    }
  }

  Future<ResponseModel?> register({
    required String name,
    required String email,
    required String phone,
    required String nationalId,
    required String gender,
    required String password,
    required String profileImage,
  }) async {
    try {
      var response = await dio.post(
        "https://elwekala.onrender.com/user/register",
        data: {
          "name": name,
          "email": email,
          "phone": phone,
          "nationalId": nationalId,
          "gender": gender,
          "password": password,
          "profileImage": profileImage,
        },
      );
      var data = response.data;
      var model = ResponseModel.fromJson(data);
      return model;
    } on DioException catch (e) {
      if (e.response != null) {
        var error = e.response!.data;
        var modelError = ResponseModel.fromJson(error);
        return modelError;
      }
      return null; // Return null if there's no response data
    }
  }

  Future<ResponseModel?> login({
    required String email,
    required String password,
  }) async {
    try {
      var response = await dio.post(
        "https://elwekala.onrender.com/user/login",
        data: {"email": email, "password": password},
      );
      var data = response.data;
      var model = ResponseModel.fromJson(data);
      return model;
    } on DioException catch (e) {
      if (e.response != null) {
        var error = e.response!.data;
        var modelError = ResponseModel.fromJson(error);
        return modelError;
      }
      return null; // Return null if there's no response data
    }
  }

  Future<ProfileResponse?> getProfile({String? token}) async {
    try {
      // Set auth token if provided
      if (token != null) {
        setAuthToken(token);
      }

      var response = await dio.get(
        "https://elwekala.onrender.com/user/profile",
      );
      var data = response.data;
      print('Profile API Response: $data');
      print('Response type: ${data.runtimeType}');

      // Check if we got HTML instead of JSON
      if (data is String && data.contains('<!DOCTYPE html>')) {
        print('Received HTML error response instead of JSON');
        return ProfileResponse(
          message: 'Authentication required. Please login again.',
          status: false,
          user: null,
        );
      }

      var model = ProfileResponse.fromJson(data);
      return model;
    } on DioException catch (e) {
      print('DioException in getProfile: ${e.toString()}');
      if (e.response != null) {
        print('Error response data: ${e.response!.data}');
        print('Error response status: ${e.response!.statusCode}');

        var error = e.response!.data;

        // Handle HTML error responses
        if (error is String && error.contains('<!DOCTYPE html>')) {
          return ProfileResponse(
            message: 'Authentication required. Please login again.',
            status: false,
            user: null,
          );
        }

        // Handle 401 Unauthorized
        if (e.response!.statusCode == 401) {
          return ProfileResponse(
            message: 'Authentication expired. Please login again.',
            status: false,
            user: null,
          );
        }

        var modelError = ProfileResponse.fromJson(error);
        return modelError;
      }
      return ProfileResponse(
        message: 'Network error. Please check your connection.',
        status: false,
        user: null,
      );
    } catch (e) {
      print('General exception in getProfile: ${e.toString()}');
      return ProfileResponse(
        message: 'An error occurred: ${e.toString()}',
        status: false,
        user: null,
      );
    }
  }

  Future<ResponseModel?> updateProfile({
    required String name,
    required String email,
    required String phone,
    required String nationalId,
    required String gender,
    String? profileImage,
    String? token,
  }) async {
    try {
      // Set auth token if provided
      if (token != null) {
        setAuthToken(token);
      }

      var response = await dio.put(
        "https://elwekala.onrender.com/user/profile",
        data: {
          "name": name,
          "email": email,
          "phone": phone,
          "nationalId": nationalId,
          "gender": gender,
          if (profileImage != null) "profileImage": profileImage,
        },
      );
      var data = response.data;
      var model = ResponseModel.fromJson(data);
      return model;
    } on DioException catch (e) {
      if (e.response != null) {
        var error = e.response!.data;
        var modelError = ResponseModel.fromJson(error);
        return modelError;
      }
      return null;
    }
  }
}
