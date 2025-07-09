import 'package:dio/dio.dart';

class FavoriteRepository {
  final String baseUrl = 'https://elwekala.onrender.com/favorite';
  final Dio _dio = Dio();

  Future<List<int>> getFavoriteProductIds() async {
    try {
      final response = await _dio.post(
        baseUrl,
        data: {'nationalId': '01009876567876'},
      );

      if (response.statusCode == 200) {
        final dynamic jsonResponse = response.data;

        // Check if response is a Map (JSON object)
        if (jsonResponse is Map<String, dynamic>) {
          // Check for error status
          if (jsonResponse['status'] == 'failure') {
            // For now, return empty list if user not found
            // instead of throwing an error
            print('API Error: ${jsonResponse['message']}');
            return [];
          }

          // Check for different possible data structures
          if (jsonResponse.containsKey('favorites')) {
            final List<dynamic> data = jsonResponse['favorites'];
            return data.map((e) => e['product_id'] as int).toList();
          } else if (jsonResponse.containsKey('data')) {
            final List<dynamic> data = jsonResponse['data'];
            return data.map((e) => e['product_id'] as int).toList();
          } else if (jsonResponse.containsKey('products')) {
            final List<dynamic> data = jsonResponse['products'];
            return data.map((e) => e['product_id'] as int).toList();
          } else {
            // Return empty list if no favorites found
            return [];
          }
        }
        // If response is directly a List
        else if (jsonResponse is List<dynamic>) {
          return jsonResponse.map((e) => e['product_id'] as int).toList();
        } else {
          print('Unexpected response format');
          return [];
        }
      } else {
        print('Failed to load favorites: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching favorites: $e');
      return [];
    }
  }

  Future<void> addFavorite(int productId) async {
    try {
      final response = await _dio.post(
        baseUrl,
        data: {
          'nationalId': '01009876567876',
          'product_id': productId, // Changed from productId to product_id
        },
      );

      print('Add favorite response status: ${response.statusCode}');
      print('Add favorite response body: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Check if the response indicates success
        final dynamic jsonResponse = response.data;
        if (jsonResponse is Map<String, dynamic>) {
          if (jsonResponse['status'] == 'failure') {
            print('API returned failure: ${jsonResponse['message']}');
            // Don't throw exception, just log it
            return;
          }
          // If no error status, consider it successful
          print('Successfully added favorite');
        }
      } else {
        print('HTTP Error ${response.statusCode}: ${response.data}');
      }
    } catch (e) {
      print('Error adding favorite: $e');
      // Don't throw the exception, just log it for now to prevent crashes
    }
  }

  Future<void> removeFavorite(int productId) async {
    try {
      final response = await _dio.delete(
        baseUrl,
        data: {
          'nationalId': '01009876567876',
          'product_id': productId, // Changed from productId to product_id
        },
      );

      print('Remove favorite response status: ${response.statusCode}');
      print('Remove favorite response body: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Check if the response indicates success
        final dynamic jsonResponse = response.data;
        if (jsonResponse is Map<String, dynamic>) {
          if (jsonResponse['status'] == 'failure') {
            print('API returned failure: ${jsonResponse['message']}');
            // Don't throw exception, just log it
            return;
          }
          // If no error status, consider it successful
          print('Successfully removed favorite');
        }
      } else {
        print('HTTP Error ${response.statusCode}: ${response.data}');
      }
    } catch (e) {
      print('Error removing favorite: $e');
      // Don't throw the exception, just log it for now to prevent crashes
    }
  }
}
