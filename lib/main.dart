import 'package:benin_num_auto/pages/home_page.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  //await Hive.initFlutter();
  //Hive.registerAdapter(ContactAdapter()); // Adapter pour vos objets Contact

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
            // This is the theme of your application.
            //
            // TRY THIS: Try running your application with "flutter run". You'll see
            // the application has a purple toolbar. Then, without quitting the app,
            // try changing the seedColor in the colorScheme below to Colors.green
            // and then invoke "hot reload" (save your changes or press the "hot
            // reload" button in a Flutter-supported IDE, or press "r" if you used
            // the command line to start the app).
            //
            // Notice that the counter didn't reset back to zero; the application
            // state is not lost during the reload. To reset the state, use hot
            // restart instead.
            //
            // This works for code too, not just values: Most code changes can be
            // tested with just a hot reload.
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
