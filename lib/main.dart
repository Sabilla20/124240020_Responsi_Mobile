import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controllers/favorite_controller.dart';
import 'pages/login_page.dart';
import 'pages/main_page.dart';
import 'services/favorite_service.dart';

const Color kAccent = Color(0xFFFF5A1F);

/// Binding yang dijalankan tepat saat GetMaterialApp pertama kali build.
class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<FavoriteController>(FavoriteController(), permanent: true);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox(FavoriteService.boxName);
  final prefs = await SharedPreferences.getInstance();
  final loggedIn = prefs.getBool('isLoggedIn') ?? false;
  runApp(KeripikrollApp(loggedIn: loggedIn));
}

class KeripikrollApp extends StatelessWidget {
  final bool loggedIn;
  const KeripikrollApp({super.key, required this.loggedIn});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Keripikroll',
      debugShowCheckedModeBanner: false,
      // Controller diregistrasi di sini — dijamin sudah ada sebelum
      // widget manapun memanggil Get.find<FavoriteController>().
      initialBinding: AppBinding(),
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(primary: kAccent),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: kAccent,
          unselectedItemColor: Colors.grey,
        ),
      ),
      home: loggedIn ? const MainPage() : const LoginPage(),
    );
  }
}
