import 'package:get/get.dart';
import 'package:tourism_app/app/middleware/auth_middleware.dart';
import 'package:tourism_app/features/admin/presentation/bindings/admin_binding.dart';
import 'package:tourism_app/features/admin/presentation/screens/admin_dashboard_screen.dart';
import 'package:tourism_app/features/auth/presentation/bindings/auth_binding.dart';
import 'package:tourism_app/features/auth/presentation/controllers/signup_stepper_controller.dart';
import 'package:tourism_app/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:tourism_app/features/auth/presentation/screens/login_screen.dart';
import 'package:tourism_app/features/auth/presentation/screens/rejected_screen.dart';
import 'package:tourism_app/features/auth/presentation/screens/signup_stepper_screen.dart';
import 'package:tourism_app/features/auth/presentation/screens/under_verification_screen.dart';
import 'package:tourism_app/features/credits/presentation/bindings/credit_binding.dart';
import 'package:tourism_app/features/credits/presentation/screens/credit_history_screen.dart';
import 'package:tourism_app/features/credits/presentation/screens/redemption_screen.dart';
import 'package:tourism_app/features/home/presentation/bindings/home_binding.dart';
import 'package:tourism_app/features/home/presentation/screens/home_screen.dart';
import 'package:tourism_app/features/map/presentation/bindings/map_binding.dart';
import 'package:tourism_app/features/map/presentation/screens/map_screen.dart';
import 'package:tourism_app/features/passport/presentation/bindings/passport_binding.dart';
import 'package:tourism_app/features/passport/presentation/screens/passport_manage_screen.dart';
import 'package:tourism_app/features/passport/presentation/screens/passport_scan_screen.dart';
import 'package:tourism_app/features/places/presentation/bindings/place_binding.dart';
import 'package:tourism_app/features/places/presentation/screens/place_detail_screen.dart';
import 'package:tourism_app/features/places/presentation/screens/places_list_screen.dart';
import 'package:tourism_app/features/profile/presentation/bindings/profile_binding.dart';
import 'package:tourism_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:tourism_app/features/reports/presentation/bindings/report_binding.dart';
import 'package:tourism_app/features/reports/presentation/screens/submit_report_screen.dart';
import 'package:tourism_app/features/reservations/presentation/bindings/reservation_binding.dart';
import 'package:tourism_app/features/reservations/presentation/screens/create_reservation_screen.dart';
import 'package:tourism_app/features/reservations/presentation/screens/reservations_screen.dart';
import 'package:tourism_app/features/transport/presentation/bindings/transport_binding.dart';
import 'package:tourism_app/features/transport/presentation/screens/ticket_purchase_screen.dart';
import 'package:tourism_app/features/transport/presentation/screens/transport_screen.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.LOGIN;

  static final routes = [
    // ── Auth ──────────────────────────────────────────────
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginScreen(),
      middlewares: [AuthMiddleware()],
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.SIGNUP,
      page: () => SignupStepperScreen(),
      middlewares: [AuthMiddleware()],
      binding: BindingsBuilder(() {
        Get.put(SignupStepperController());
      }),
    ),
    GetPage(
      name: Routes.SIGNUP_STEPPER,
      page: () => SignupStepperScreen(),
      binding: BindingsBuilder(() {
        Get.put(SignupStepperController());
      }),
    ),
    GetPage(
      name: Routes.FORGOT_PASSWORD,
      page: () => ForgotPasswordScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.UNDER_VERIFICATION,
      page: () => UnderVerificationScreen(),
      middlewares: [AuthMiddleware()],
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.REJECTED,
      page: () => const RejectedScreen(),
      middlewares: [AuthMiddleware()],
      binding: AuthBinding(),
    ),

    // ── Home ──────────────────────────────────────────────
    GetPage(
      name: Routes.HOME,
      page: () => const HomeScreen(),
      middlewares: [AuthMiddleware()],
      binding: HomeBinding(),
    ),

    // ── Map ───────────────────────────────────────────────
    GetPage(
      name: Routes.MAP,
      page: () => MapScreen(),
      middlewares: [AuthMiddleware()],
      bindings: [MapBinding(), PlaceBinding()],
    ),

    // ── Passport ──────────────────────────────────────────
    GetPage(
      name: Routes.PASSPORT_SCAN,
      page: () => const PassportScanScreen(),
      middlewares: [AuthMiddleware()],
      binding: PassportBinding(),
    ),
    GetPage(
      name: Routes.PASSPORT_MANAGE,
      page: () => const PassportManageScreen(),
      middlewares: [AuthMiddleware()],
      binding: PassportBinding(),
    ),

    // ── Credits ───────────────────────────────────────────
    GetPage(
      name: Routes.CREDIT_HISTORY,
      page: () => const CreditHistoryScreen(),
      middlewares: [AuthMiddleware()],
      binding: CreditBinding(),
    ),
    GetPage(
      name: Routes.REDEMPTION,
      page: () => const RedemptionScreen(),
      middlewares: [AuthMiddleware()],
      binding: CreditBinding(),
    ),

    // ── Profile ───────────────────────────────────────────
    GetPage(
      name: Routes.PROFILE,
      page: () => ProfileScreen(),
      middlewares: [AuthMiddleware()],
      binding: ProfileBinding(),
    ),

    // ── Admin (Phase 1) ───────────────────────────────────
    GetPage(
      name: Routes.ADMIN_DASHBOARD,
      page: () => const AdminDashboardScreen(),
      middlewares: [AuthMiddleware()],
      binding: AdminBinding(),
    ),

    // ── Reports (Phase 2) ─────────────────────────────────
    GetPage(
      name: Routes.SUBMIT_REPORT,
      page: () => const SubmitReportScreen(),
      middlewares: [AuthMiddleware()],
      binding: ReportBinding(),
    ),

    // ── Places (Phase 3) ──────────────────────────────────
    GetPage(
      name: Routes.PLACES_LIST,
      page: () => const PlacesListScreen(),
      middlewares: [AuthMiddleware()],
      binding: PlaceBinding(),
    ),
    GetPage(
      name: Routes.PLACE_DETAIL,
      page: () => const PlaceDetailScreen(),
      middlewares: [AuthMiddleware()],
      binding: PlaceBinding(),
    ),

    // ── Reservations (Phase 5) ────────────────────────────
    GetPage(
      name: Routes.RESERVATIONS,
      page: () => const ReservationsScreen(),
      middlewares: [AuthMiddleware()],
      bindings: [ReservationBinding(), PlaceBinding()],
    ),
    GetPage(
      name: Routes.CREATE_RESERVATION,
      page: () => const CreateReservationScreen(),
      middlewares: [AuthMiddleware()],
      bindings: [ReservationBinding(), PlaceBinding()],
    ),

    // ── Transport (Phase 6) ───────────────────────────────
    GetPage(
      name: Routes.TRANSPORT,
      page: () => const TransportScreen(),
      middlewares: [AuthMiddleware()],
      binding: TransportBinding(),
    ),
    GetPage(
      name: Routes.TICKET_PURCHASE,
      page: () => const TicketPurchaseScreen(),
      middlewares: [AuthMiddleware()],
      binding: TransportBinding(),
    ),
  ];
}
