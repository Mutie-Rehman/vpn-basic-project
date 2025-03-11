import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:vpn_basic_project/screens/splash_screen.dart';

void main() {
  // Initialize the binding before using SystemChrome
  WidgetsFlutterBinding.ensureInitialized();

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
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OpenVpn Demo',
      //theme
      theme: ThemeData(
        appBarTheme:
            AppBarTheme(centerTitle: true, elevation: 3, color: Colors.blue),
        primaryColor: Colors.blue,
        primaryIconTheme: IconThemeData(color: Colors.blue),
        primarySwatch: Colors.blue,
        primaryTextTheme: TextTheme(bodyMedium: TextStyle(color: Colors.white)),
      ),
      home: SplashScreen(),
    );
  }
}
