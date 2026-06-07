import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart' hide Response;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tourism_app/core/network/api_client.dart';
import 'package:tourism_app/core/services/crowd_predictor_service.dart';
import 'package:tourism_app/core/services/location_service.dart';
import 'package:tourism_app/core/services/permission_service.dart';
import 'package:tourism_app/data/datasources/local/local_storage.dart';
import 'package:tourism_app/data/repositories/account_repository.dart';
import 'package:tourism_app/data/repositories/credit_repository.dart';
import 'package:tourism_app/data/repositories/payment_repository.dart';
import 'package:tourism_app/data/repositories/place_repository.dart';
import 'package:tourism_app/data/repositories/report_repository.dart';
import 'package:tourism_app/data/repositories/reservation_repository.dart';
import 'package:tourism_app/data/repositories/transport_repository.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Core infrastructure
    Get.lazyPut<ApiClient>(() => ApiClientImpl(), fenix: true);
    Get.lazyPut<LocationService>(() => LocationServiceImpl(), fenix: true);
    Get.lazyPut<PermissionService>(() => PermissionServiceImpl(), fenix: true);
    Get.lazyPut<LocalStorage>(() => LocalStorageImpl(), fenix: true);

    // Services
    Get.lazyPut<CrowdPredictorService>(() => CrowdPredictorService(), fenix: true);

    // Repositories
    Get.lazyPut<AccountRepository>(() => AccountRepository(), fenix: true);
    Get.lazyPut<CreditRepository>(() => CreditRepository(), fenix: true);
    Get.lazyPut<PlaceRepository>(() => PlaceRepository(), fenix: true);
    Get.lazyPut<ReservationRepository>(() => ReservationRepository(), fenix: true);
    Get.lazyPut<ReportRepository>(() => ReportRepository(), fenix: true);
    Get.lazyPut<TransportRepository>(() => TransportRepository(), fenix: true);
    Get.lazyPut<PaymentRepository>(() => PaymentRepository(), fenix: true);
  }
}

class ApiClientImpl implements ApiClient {
  final Dio _dio = Dio();

  @override
  Future<Response> get(String endpoint,
      {Map<String, dynamic>? queryParameters}) async {
    return await _dio.get(endpoint, queryParameters: queryParameters);
  }

  @override
  Future<Response> post(String endpoint, {dynamic data}) async {
    return await _dio.post(endpoint, data: data);
  }
}

class LocationServiceImpl implements LocationService {}

class PermissionServiceImpl implements PermissionService {}

class LocalStorageImpl implements LocalStorage {
  @override
  Future<String?> getIdToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) return await user.getIdToken();
    return null;
  }

  @override
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_token', token);
  }
}
