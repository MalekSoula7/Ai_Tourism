import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:tourism_app/core/network/api_client.dart'; // Placeholder
import 'package:tourism_app/core/services/location_service.dart'; // Placeholder
import 'package:tourism_app/core/services/permission_service.dart'; // Placeholder
import 'package:tourism_app/data/datasources/local/local_storage.dart'; // Placeholder
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

// This binding sets up core services and dependencies needed globally
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Core Services
    Get.lazyPut<ApiClient>(() => ApiClientImpl(), fenix: true); // Placeholder Impl
    Get.lazyPut<LocationService>(() => LocationServiceImpl(), fenix: true); // Placeholder Impl
    Get.lazyPut<PermissionService>(() => PermissionServiceImpl(), fenix: true); // Placeholder Impl
    Get.lazyPut<LocalStorage>(() => LocalStorageImpl(), fenix: true); // Placeholder Impl

    // TODO: Initialize other core services (e.g., AI models, DB Helper)
  }
}

// Placeholder implementations for core services
class ApiClientImpl implements ApiClient {
  final Dio _dio = Dio();

  @override
  Future<Response> get(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    return await _dio.get(endpoint, queryParameters: queryParameters);
  }

  @override
  Future<Response> post(String endpoint, {dynamic data}) async {
    return await _dio.post(endpoint, data: data);
}}

class LocationServiceImpl implements LocationService {}
class PermissionServiceImpl implements PermissionService {}
class LocalStorageImpl implements LocalStorage {
  @override
  Future<String?> getIdToken() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return await user.getIdToken();
    }
    return null;
  }
  
  @override
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_token', token);
  }

  // @override
  // Future<void> clearData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   // await prefs.clear(); if i want to clear all data
  //   await prefs.remove('user_token'); // Clear only the token
  // }
  
}

