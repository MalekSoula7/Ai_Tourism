import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tourism_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Only allow access to login, signup, or forgot password
      if (route == Routes.LOGIN ||
          route == Routes.SIGNUP ||
          route == Routes.SIGNUP_STEPPER ||
          route == Routes.FORGOT_PASSWORD) {
        return null;
      }
      return const RouteSettings(name: Routes.LOGIN);
    }

    if (route == Routes.LOGIN ||
        route == Routes.SIGNUP ||
        route == Routes.SIGNUP_STEPPER ||
        route == Routes.FORGOT_PASSWORD) {
      return const RouteSettings(name: Routes.HOME);
    }

    return null;
  }
}
