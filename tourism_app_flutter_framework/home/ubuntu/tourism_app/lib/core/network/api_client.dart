// Placeholder interface for API client
import 'package:dio/dio.dart';
abstract class ApiClient {
  
  Future<Response> get(String endpoint, {Map<String, dynamic>? queryParameters});
  Future<Response> post(String endpoint, {dynamic data});
}

