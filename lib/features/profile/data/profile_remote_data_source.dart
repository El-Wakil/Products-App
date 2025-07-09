import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';

class ProfileRemoteDataSource {
  final ApiClient apiClient;

  ProfileRemoteDataSource(this.apiClient);

  Future<Map<String, dynamic>> updateUser({
    required String token,
    required Map<String, dynamic> userData,
  }) async {
    apiClient.setAuthToken(token);
    print('UPDATE USER REQUEST:');
    print('Endpoint: https://elwekala.onrender.com/user/update');
    print('Token: $token');
    print('Body: $userData');
    try {
      final response = await apiClient.put(
        'https://elwekala.onrender.com/user/update',
        data: userData,
      );
      print('UPDATE USER RESPONSE:');
      print('Status code: ${response.statusCode}');
      print('Data: ${response.data}');
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      print('DioException in updateUser: ${e.toString()}');
      if (e.response != null) {
        print('Error response data: ${e.response!.data}');
        print('Error response status: ${e.response!.statusCode}');
      }
      rethrow;
    } catch (e) {
      print('General exception in updateUser: $e');
      rethrow;
    }
  }

  // There is no supported endpoint for fetching user info directly.
  // Use the user info returned from login/register/update responses instead.
  // Future<Map<String, dynamic>> fetchUser({
  //   required String token,
  // }) async {
  //   throw UnimplementedError('No user info fetch endpoint available.');
  // }
}
