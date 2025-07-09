import 'package:product_api_app/models/response_model.dart';
import 'package:product_api_app/models/profile_response.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {}

final class AuthAddSuccess extends AuthState {
  final ResponseModel responseModel;

  AuthAddSuccess(this.responseModel);
}

final class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}

final class AuthLoginSuccess extends AuthState {
  final ResponseModel responseModel;

  AuthLoginSuccess(this.responseModel);
}

final class ProfileLoading extends AuthState {}

final class ProfileSuccess extends AuthState {
  final ProfileResponse profileData;

  ProfileSuccess(this.profileData);
}

final class ProfileUpdateSuccess extends AuthState {
  final ResponseModel responseModel;

  ProfileUpdateSuccess(this.responseModel);
}

final class UpdateImage extends AuthState {}
