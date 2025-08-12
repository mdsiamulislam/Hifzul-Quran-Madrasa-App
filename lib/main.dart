import 'package:flutter/material.dart';
import 'package:hifzul_quran_madrasa/features/dashboard/views/home_page.dart';
import 'package:hifzul_quran_madrasa/theme/dark_theme.dart';
import 'package:hifzul_quran_madrasa/theme/light_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}
