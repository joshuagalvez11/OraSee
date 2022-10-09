import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:swip_change/home.dart';
import 'package:swip_change/landing.dart';
import 'package:swip_change/start_page.dart';

import 'email_login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: Landing(),
    );
  }
}
