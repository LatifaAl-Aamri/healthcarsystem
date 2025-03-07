import 'package:flutter/material.dart';
import 'package:healthcarsystem/homepage.dart';
import 'package:healthcarsystem/splashpage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

import 'menu_drawer_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Online Healthcare System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashPage(),
      debugShowCheckedModeBanner: false,
      initialRoute: 'splashpage',
      routes: {
        'splashpage':(context)=> const SplashPage(),
        'tabpage':(context)=> const MenuDrawerPage(),
      },
    );
  }
}
