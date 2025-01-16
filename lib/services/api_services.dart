import 'package:dio/dio.dart';

class APIService {
  static Future<void> fetchDataFromAPI() async {
    try {
      final response = await Dio().get('https://your-api-endpoint.com');
      print('API Response: ${response.data}');
    } catch (e) {
      print('API Error: $e');
    }
  }
}
