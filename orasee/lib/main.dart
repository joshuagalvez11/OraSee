import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:orasee/home.dart';
import 'package:orasee/landing.dart';
import 'package:orasee/screens/community.dart';
import 'package:orasee/screens/setting.dart';
import 'package:orasee/screens/settings_screens/setting_account.dart';
import 'package:orasee/screens/settings_screens/setting_email.dart';
import 'package:orasee/screens/settings_screens/setting_password.dart';
import 'package:orasee/screens/test.dart';
import 'package:orasee/start_page.dart';

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
    bool isLoggedIn = FirebaseAuth.instance.currentUser != null ? true : false;

    if (!isLoggedIn) {
      return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.black,
        ),
        home: Landing(),
        routes: {
          "/videoPage": (context) => HomePage(),
          "/communityPage": (context) => Community(),
          "/settingPage": (context) => Setting(),
          "/SAccountInfo": (context) => SettingAccount(),
          "/SEmailChange": (context) => EmailSetting(),
          "/SPasswordChange": (context) => PasswordSetting()
        },
      );
    } else {
      return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.black,
        ),
        home: HomePage(),
        routes: {
          "/videoPage": (context) => HomePage(),
          "/communityPage": (context) => Community(),
          "/settingPage": (context) => Setting(),
          "/SAccountInfo": (context) => SettingAccount(),
          "/SEmailChange": (context) => EmailSetting(),
          "/SPasswordChange": (context) => PasswordSetting()
        },
      );
    }
  }
}
