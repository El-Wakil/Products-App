import 'package:dio/dio.dart';
import 'package:product_api_app/models/lap_models.dart';

class LapData {
  final Dio dio = Dio();

  Future<List<LapModel>> getLapData() async {
    try {
      final response = await dio.get(
        "https://elwekala.onrender.com/product/Laptops",
      );

      // التحقق من نوع البيانات المستلمة
      if (response.data is List) {
        return (response.data as List)
            .map((json) => LapModel.fromJson(json))
            .toList();
      } else if (response.data is Map && response.data['product'] is List) {
        return (response.data['product'] as List)
            .map((json) => LapModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Unexpected data format: ${response.data}');
      }
    } on DioException catch (dioError) {
      // معالجة أخطاء Dio
      throw Exception(
        'Dio error: ${dioError.response?.data ?? dioError.message}',
      );
    } catch (e) {
      // معالجة الأخطاء العامة
      throw Exception('An error occurred while fetching data: $e');
    }
  }
}
