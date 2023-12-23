import 'package:finder/pages/Login.dart';
import 'package:finder/pages/mapbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MainPage());
}

final Map<String, Widget Function(BuildContext)> routes = {
  '/': (BuildContext context) => const Login(),
  '/main': (BuildContext context) => const MapBoxPage(),
};

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return MaterialApp(
            themeMode: ThemeMode.light,
            initialRoute: '/',
            debugShowCheckedModeBanner: false,
            routes: routes,
          );
        });
  }
}
