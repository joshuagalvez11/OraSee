import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swip_change/model/user_model.dart';
import 'package:swip_change/screens/test.dart';
import 'dart:collection';

class VideoSupport extends StatefulWidget {
  const VideoSupport({Key? key}) : super(key: key);

  @override
  State<VideoSupport> createState() => _VideoSupportState();
}

class _VideoSupportState extends State<VideoSupport> {
  User? user = FirebaseAuth.instance.currentUser;
  // call user modal
  UserModel loginUser = UserModel();

  // @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) => {
              // pass data from db to modal
              this.loginUser = UserModel.fromJson(value.data()),
              setState(
                () {
                  print("loginUser.options:${loginUser.options}");
                  if ("${loginUser.options}" == "Seeker") {
                    setState(() {
                      // add user id into Queue for video call
                      loginUser.addSeekerToQueue(user!.uid);
                    });
                  } else {
                    setState(() {
                      // add user id into Queue for video call
                      loginUser.addVolunteerToQueue(user!.uid);
                    });
                  }
                  print("seekResult ${loginUser.seekerQueue?.elementAt(0)}");
                  print("volResult ${loginUser.volunteerQueue?.elementAt(0)}");
                },
              ),
            });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: TitleText(),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              GestureDetector(
                onVerticalDragUpdate: ((DragUpdateDetails details) {
                  if (details.delta.dy > 0) {
                    print("up");
                    print(details);
                  }
                  if (details.delta.dy < 0) {
                    print("down");
                    print(details);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => TestPage()));
                  }
                }),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: width,
                    height: height * 0.75,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff381BE9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                      onPressed: () {
                        print(
                            "seekResult ${loginUser.seekerQueue?.elementAt(0)}");
                        print(
                            "volResult ${loginUser.volunteerQueue?.elementAt(0)}");
                      },
                      child: ButtonText(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget TitleText() {
    if ("${loginUser.options}" == "Seeker") {
      return Text(
        "Get Live Video Help",
        style: TextStyle(
          color: Colors.white,
          fontSize: 36,
          fontWeight: FontWeight.bold,
        ),
      );
    } else {
      return Text(
        "Someone Needs You",
        style: TextStyle(
          color: Colors.white,
          fontSize: 36,
          fontWeight: FontWeight.bold,
        ),
      );
    }
  }

  Widget ButtonText() {
    if ("${loginUser.options}" == "Seeker") {
      return Text(
        "Call a Vounteer",
        style: TextStyle(
          color: Colors.white,
          fontSize: 36,
          fontWeight: FontWeight.bold,
        ),
      );
    } else {
      return Text(
        "Press to Receive",
        style: TextStyle(
          color: Colors.white,
          fontSize: 36,
          fontWeight: FontWeight.bold,
        ),
      );
    }
  }
}
