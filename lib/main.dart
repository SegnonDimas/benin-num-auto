import 'package:benin_num_auto/pages/home_page.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Bénin Num Auto',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade800),
            useMaterial3: true,
            textTheme: const TextTheme(
              displayLarge: TextStyle(fontFamily: 'PoppinsMedium'),
              displayMedium: TextStyle(fontFamily: 'PoppinsMedium'),
              displaySmall: TextStyle(fontFamily: 'PoppinsMedium'),
              headlineLarge: TextStyle(fontFamily: 'PoppinsMedium'),
              headlineMedium: TextStyle(fontFamily: 'PoppinsMedium'),
              headlineSmall: TextStyle(fontFamily: 'PoppinsMedium'),
              titleLarge: TextStyle(fontFamily: 'PoppinsMedium'),
              titleMedium: TextStyle(fontFamily: 'PoppinsMedium'),
              titleSmall: TextStyle(fontFamily: 'PoppinsMedium'),
              bodyLarge: TextStyle(fontFamily: 'PoppinsMedium'),
              bodyMedium: TextStyle(fontFamily: 'PoppinsMedium'),
              bodySmall: TextStyle(fontFamily: 'PoppinsMedium'),
              labelLarge: TextStyle(fontFamily: 'PoppinsMedium'),
              labelMedium: TextStyle(fontFamily: 'PoppinsMedium'),
              labelSmall: TextStyle(fontFamily: 'PoppinsMedium'),
            )),
        home: const ContactUpdaterPage()
        //const MyHomePage(title: 'Flutter Demo Home Page'),
        );
  }
}
