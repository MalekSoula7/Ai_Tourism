import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tourism_app/app/bindings/initial_binding.dart';
import 'package:tourism_app/app/routes/app_pages.dart';
import 'package:tourism_app/app/themes/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyArW90_vdTRB91eQ2JrK_jVUl1lUFgkv34",
        authDomain: "tourism-ai-app.firebaseapp.com",
        projectId: "flutterapp101-e41e5",
        storageBucket: "flutterapp101-e41e5.firebasestorage.app",
        messagingSenderId: "808445010348",
        appId: "1:808445010348:android:3b126fa344c95e64c35a09",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'AI Nomad Assistant App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme, // Optional dark theme
      themeMode: ThemeMode.system, // Or ThemeMode.light, ThemeMode.dark
      initialRoute: FirebaseAuth.instance.currentUser == null
          ? Routes.LOGIN
          : Routes.HOME,
      getPages: AppPages.routes, // Define all routes in AppPages
      initialBinding: InitialBinding(), // Setup initial dependencies
      debugShowCheckedModeBanner: false,
      // TODO: Add localization delegates if needed
      // locale: Get.deviceLocale,
      fallbackLocale: Locale('en', 'US'),
      // translations: AppTranslations(), // Your translation class
    );
  }
}
