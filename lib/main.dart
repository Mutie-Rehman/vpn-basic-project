import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vpn_basic_project/controllers/theme_controller.dart';
import 'package:vpn_basic_project/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize ThemeController before running the app
  Get.put(ThemeController());

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((v) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'OpenVpn Demo',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 3,
            color: Colors.blue,
          ),
          primaryColor: Colors.blue,
          primaryIconTheme: const IconThemeData(color: Colors.white),
          primarySwatch: Colors.blue,
          primaryTextTheme:
              const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 3,
            color: Colors.blue,
          ),
        ),
        themeMode:
            themeController.themeMode.value, // ✅ Load theme from controller
        home: SplashScreen(),
      ),
    );
  }
}

extension AppTheme on ThemeData {
  Color get lightText => Get.isDarkMode ? Colors.white70 : Colors.black54;
}
