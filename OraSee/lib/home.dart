import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:swip_change/screens/community.dart';
import 'package:swip_change/screens/setting.dart';
import 'package:swip_change/screens/video_support.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
