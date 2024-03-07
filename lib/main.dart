import 'package:flutter/material.dart';
import 'package:masrafi/gateway/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Masrafi',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFD584C2))
            .copyWith(
                brightness: Brightness.light,
                primary: const Color(0xFFD584C2),
                onPrimary: const Color(0xff1B1C22),
                background: const Color(0xffFCF0DA),
                secondary: const Color(0xff16BAC5),
                surface: const Color(0xffFCF0DA),
                onBackground: const Color(0xff1B1C22),
                onSurface: const Color(0xff1B1C22)),
        appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xff1B1C22),
            foregroundColor: Color(0xffFCF0DA)),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xff1B1C22),
          selectedItemColor: Color(0xffd584c2),
          unselectedItemColor: Color(0xffFCF0DA),
        ),
        useMaterial3: true,
      ),
      home: const Directionality(
          textDirection: TextDirection.rtl, child: LoginPage()),
    );
  }
}
