  import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
  import 'package:get/get.dart';
  import 'package:hifzul_quran_madrasa/features/dashboard/views/home_page.dart';
  import 'package:hifzul_quran_madrasa/theme/dark_theme.dart';
  import 'package:hifzul_quran_madrasa/theme/light_theme.dart';

  import 'core/localization/translations.dart';

  void main(){
    runApp(const MyApp());
  }

  class MyApp extends StatelessWidget {
    const MyApp({super.key});
    @override
    Widget build(BuildContext context) {
      return GetMaterialApp(
        title: 'Flutter Demo',
        translations: AppTranslations(),
        locale: const Locale('bn', 'BD'), // Initial locale
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
      );
    }
  }
