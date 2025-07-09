import 'package:dio/dio.dart';
import 'package:product_api_app/models/lap_models.dart';

Future<List<LapModel>> fetchFavoriteData({
  required String nationalId,
  required String productId,
}) async {
  try {
    var dio = Dio();
    final response = await dio.post(
      "https://elwekala.onrender.com/favorite",
      data: {"nationalId": nationalId, "productId": productId},
    );

    print('Response data: ${response.data}'); // طباعة البيانات المستلمة

    if (response.data is List) {
      return (response.data as List)
          .map((json) => LapModel.fromJson(json))
          .toList();
    } else if (response.data['product'] is List) {
      return (response.data['product'] as List)
          .map((json) => LapModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Unexpected data format: ${response.data}');
    }
  } on DioException catch (dioError) {
    print(
      'Dio error: ${dioError.response?.data ?? dioError.message}',
    ); // طباعة الخطأ
    throw Exception(
      'Failed to fetch data: ${dioError.response?.data ?? dioError.message}',
    );
  } catch (e) {
    print('General error: $e'); // طباعة الأخطاء العامة
    throw Exception('An error occurred: $e');
  }
}
