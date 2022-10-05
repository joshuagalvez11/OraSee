import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swip_change/model/user_model.dart';

class VideoSupport extends StatefulWidget {
  const VideoSupport({Key? key}) : super(key: key);

  @override
  State<VideoSupport> createState() => _VideoSupportState();
}

class _VideoSupportState extends State<VideoSupport> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loginUser = UserModel();
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) => {
              this.loginUser = UserModel.fromJson(value.data()),
              setState(
                () {},
              ),
            });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: height*0.03,),
            Center(
              child: TitleText(),
            ),
            SizedBox(
              height: height * 0.03,
            ),
            Padding(
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
                  onPressed: () {},
                  child: ButtonText(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget TitleText() {
    if ("${loginUser.options}" == "seeker") {
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
        "Someone Need You",
        style: TextStyle(
          color: Colors.white,
          fontSize: 36,
          fontWeight: FontWeight.bold,
        ),
      );
    }
  }

  Widget ButtonText() {
    if ("${loginUser.options}" == "seeker") {
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
