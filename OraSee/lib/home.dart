import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:alan_voice/alan_voice.dart';
import 'package:swip_change/landing.dart';
import 'package:swip_change/model/user_model.dart';
import 'package:swip_change/screens/community.dart';
import 'package:swip_change/screens/setting.dart';
import 'package:swip_change/screens/test.dart';
import 'package:swip_change/screens/video_support.dart';
import 'package:swip_change/start_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loginUser = UserModel();
  FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoggedIn = FirebaseAuth.instance.currentUser != null ? true : false;

  _HomePageState() {
    AlanVoice.addButton(
      "fb5d55b648fe678389120f328019f6312e956eca572e1d8b807a3e2338fdd0dc/stage",
      buttonAlign: AlanVoice.BUTTON_ALIGN_LEFT,
    );

    /// Handle commands from Alan Studio
    AlanVoice.onCommand.add((command) => _handleCommand(command.data));
  }

  void _handleCommand(Map<String, dynamic> command) {
    switch (command['command']) {
      case "video":
        Navigator.pushNamed(context, '/videoPage');
        break;
      case "community":
        Navigator.pushNamed(context, '/communityPage');
        break;
      case "setting":
        Navigator.pushNamed(context, '/settingPage');
        break;
      case "Account Information":
        Navigator.pushNamed(context, '/SAccountInfo');
        break;
      case "Email Change":
        Navigator.pushNamed(context, '/SEmailChange');
        break;
      case "Password Change":
        Navigator.pushNamed(context, '/SPasswordChange');
        break;
      case "signout":
        SignOut(context);
        break;
      default:
        debugPrint("unknown command");
    }
  }

  Future<void> SignOut(BuildContext context) async {
    await _auth.signOut().then((value) => {
          // await FacebookAuth.instance.logOut();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => Landing(),
            ),
          )
        });
  }

  int _currentIndex = 0;

  PageController _pageController = PageController(initialPage: 0);

  final _bottomNavigationBarItem = [
    BottomNavigationBarItem(
      icon: Icon(
        Icons.video_call,
        color: Color(0xff9AA0A6),
      ),
      label: "Video Support",
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.group,
        color: Color(0xff9AA0A6),
      ),
      label: "Community",
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.settings,
        color: Color(0xff9AA0A6),
      ),
      label: "Setting",
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
        scrollDirection: Axis.horizontal,
        children: [
          VideoSupport(),
          Community(),
          Setting(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Color(0xff2F3033),
        unselectedItemColor: Color(0xff9AA0A6),
        showSelectedLabels: true,
        showUnselectedLabels: false,
        items: _bottomNavigationBarItem,
        onTap: (newIndex) {
          _pageController.animateToPage(
            newIndex,
            duration: Duration(milliseconds: 500),
            curve: Curves.ease,
          );
        },
      ),
    );
  }
}
