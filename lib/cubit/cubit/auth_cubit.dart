import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:product_api_app/cubit/cubit/auth_state.dart';
import 'package:product_api_app/data/auth_api.dart';
import 'package:product_api_app/models/user_model.dart';
import 'package:product_api_app/models/profile_response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthData authData = AuthData();

  AuthCubit() : super(AuthInitial());
  static AuthCubit get(context) => BlocProvider.of(context);
  String? profileImage;
  File? image;
  ImagePicker imagePicker = ImagePicker();
  String? authToken; // Store authentication token
  User? currentUser; // Store current user data

  Future<void> saveImage() async {
    try {
      var photo = await imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (photo != null) {
        image = File(photo.path);
        var bytes = image!.readAsBytesSync();
        profileImage = "data:image/jpeg;base64,${base64Encode(bytes)}";
        emit(UpdateImage());
      } else {
        emit(AuthError('No image selected'));
      }
    } catch (e) {
      emit(AuthError('Failed to pick image: ${e.toString()}'));
    }
  }

  Future<void> saveImageFromGallery() async {
    try {
      var photo = await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (photo != null) {
        image = File(photo.path);
        var bytes = image!.readAsBytesSync();
        profileImage = "data:image/jpeg;base64,${base64Encode(bytes)}";
        emit(UpdateImage());
      } else {
        emit(AuthError('No image selected'));
      }
    } catch (e) {
      emit(AuthError('Failed to pick image: ${e.toString()}'));
    }
  }

  void clearImage() {
    image = null;
    profileImage = null;
    emit(UpdateImage());
  }

  bool get hasImage => image != null;

  Future<void> registerCubit({
    required String name,
    required String email,
    required String phone,
    required String nationalId,
    required String gender,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      var response = await authData.register(
        name: name,
        email: email,
        phone: phone,
        nationalId: nationalId,
        gender: gender,
        password: password,
        profileImage: profileImage ?? '',
      );

      if (response != null) {
        // Check if message indicates success (regardless of status field)
        bool isSuccess =
            response.status ||
            response.message.toLowerCase().contains('success') ||
            response.message.toLowerCase().contains('registered successfully');

        if (isSuccess) {
          // Store user data if provided
          if (response.user != null) {
            currentUser = response.user;
          }
          emit(AuthAddSuccess(response));
        } else {
          emit(
            AuthError(
              response.message.isNotEmpty
                  ? response.message
                  : 'Registration failed. Please try again.',
            ),
          );
        }
      } else {
        emit(AuthError('Registration failed. Please try again.'));
      }
    } catch (e) {
      emit(AuthError('An error occurred: ${e.toString()}'));
    }
  }

  Future<void> loginCubit({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      var response = await authData.login(email: email, password: password);

      if (response != null) {
        // Check if message indicates success (regardless of status field)
        bool isSuccess =
            response.status ||
            response.message.toLowerCase().contains('success') ||
            response.message.toLowerCase().contains('login successful');

        if (isSuccess) {
          // Store the token if provided
          if (response.token != null) {
            authToken = response.token;
          }
          // Store user data if provided
          if (response.user != null) {
            currentUser = response.user;
          }
          emit(AuthLoginSuccess(response));
        } else {
          emit(
            AuthError(
              response.message.isNotEmpty
                  ? response.message
                  : 'Login failed. Please try again.',
            ),
          );
        }
      } else {
        emit(AuthError('Login failed. Please try again.'));
      }
    } catch (e) {
      emit(AuthError('An error occurred: ${e.toString()}'));
    }
  }

  Future<void> getProfileCubit() async {
    emit(ProfileLoading());
    try {
      // Always set the token before making the API call
      authData.setAuthToken(authToken);
      // Try to fetch from API first
      var response = await authData.getProfile(token: authToken);
      if (response != null) {
        bool isSuccess =
            response.status ||
            response.message.toLowerCase().contains('success');
        if (isSuccess && response.user != null) {
          // Store the user data for future use
          currentUser = response.user;
          emit(ProfileSuccess(response));
          return;
        } else {
          // Check if it's an authentication error or endpoint doesn't exist
          if (response.message.toLowerCase().contains('authentication') ||
              response.message.toLowerCase().contains('login') ||
              response.message.toLowerCase().contains('cannot access')) {}
        }
      }
      // If API fails, use stored user data
      if (currentUser != null) {
        var profileResponse = ProfileResponse(
          message: 'Profile data loaded from local storage',
          status: true,
          user: currentUser,
        );
        emit(ProfileSuccess(profileResponse));
      } else {
        emit(AuthError('No profile data available. Please login again.'));
      }
    } catch (e) {
      // Try to use stored data as fallback
      if (currentUser != null) {
        var profileResponse = ProfileResponse(
          message: 'Profile data loaded from local storage',
          status: true,
          user: currentUser,
        );
        emit(ProfileSuccess(profileResponse));
      } else {
        emit(AuthError('An error occurred: ${e.toString()}'));
      }
    }
  }

  Future<void> updateProfileCubit({
    required String name,
    required String email,
    required String phone,
    required String nationalId,
    required String gender,
  }) async {
    emit(AuthLoading());
    try {
      // Always set the token before making the API call
      authData.setAuthToken(authToken);
      var response = await authData.updateProfile(
        name: name,
        email: email,
        phone: phone,
        nationalId: nationalId,
        gender: gender,
        profileImage: profileImage,
        token: authToken,
      );
      if (response != null) {
        bool isSuccess =
            response.status ||
            response.message.toLowerCase().contains('success') ||
            response.message.toLowerCase().contains('updated');
        if (isSuccess) {
          // Update the stored user data only if API call is successful
          if (currentUser != null) {
            currentUser = User(
              id: currentUser!.id,
              name: name,
              email: email,
              phone: phone,
              nationalId: nationalId,
              gender: gender,
              profileImage: profileImage ?? currentUser!.profileImage,
            );
          }
          emit(ProfileUpdateSuccess(response));
        } else {
          emit(
            AuthError(
              response.message.isNotEmpty
                  ? response.message
                  : 'Failed to update profile. Please try again.',
            ),
          );
        }
      } else {
        emit(AuthError('Failed to update profile. Please try again.'));
      }
    } catch (e) {
      emit(AuthError('An error occurred: ${e.toString()}'));
    }
  }

  // Logout method to clear stored data
  void logout() {
    authToken = null;
    currentUser = null;
    profileImage = null;
    image = null;
    emit(AuthInitial());
  }
}
