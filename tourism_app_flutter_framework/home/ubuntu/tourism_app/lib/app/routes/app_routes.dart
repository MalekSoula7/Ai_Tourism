part of 'app_pages.dart';

abstract class Routes {
  static const SPLASH = '/splash';
  static const LOGIN = '/login';
  static const SIGNUP = '/signup';
  static const HOME = '/home';
  static const MAP = '/map';
  static const PASSPORT_SCAN = '/passport/scan';
  static const PASSPORT_MANAGE = '/passport/manage';
  static const CREDIT_HISTORY = '/credits/history';
  static const REDEMPTION = '/credits/redemption';
  static const PROFILE = '/profile';
  static const SIGNUP_STEPPER = '/signup-stepper';
  static const UNDER_VERIFICATION = '/under-verification';
  static const REJECTED = '/rejected';
  static const FORGOT_PASSWORD = '/forgot-password';

  // Phase 1 – Admin
  static const ADMIN_DASHBOARD = '/admin/dashboard';

  // Phase 2 – Reports
  static const SUBMIT_REPORT = '/reports/submit';

  // Phase 3 – Places
  static const PLACES_LIST = '/places';
  static const PLACE_DETAIL = '/places/detail';

  // Phase 5 – Reservations
  static const RESERVATIONS = '/reservations';
  static const CREATE_RESERVATION = '/reservations/create';

  // Phase 6 – Transport
  static const TRANSPORT = '/transport';
  static const TICKET_PURCHASE = '/transport/ticket';
}
