import 'dart:collection';
import 'dart:convert';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swip_change/model/user_model.dart';
import 'package:swip_change/screens/test.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:swip_change/video_calling/pages/call.dart';

import 'package:swip_change/video_calling/pages/index.dart';

class VideoSupport extends StatefulWidget {
  const VideoSupport({Key? key}) : super(key: key);

  @override
  State<VideoSupport> createState() => _VideoSupportState();
}

class _VideoSupportState extends State<VideoSupport> {
  User? user = FirebaseAuth.instance.currentUser;
  // call user modal
  UserModel loginUser = UserModel();

  ClientRole? _role = ClientRole.Broadcaster;

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
                      _role = ClientRole.Broadcaster;
                    });
                  } else {
                    setState(() {
                      // add user id into Queue for video call
                      loginUser.addVolunteerToQueue(user!.uid);
                      _role = ClientRole.Audience;
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
                        getToken(_role).then((res) {
                          setState(() {
                            onJoin(res[0], res[1]);
                          });
                        });
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

  // Get token
  Future<List<String>> getToken(ClientRole? role) async {
    int id = 0;

    // Is user volunteer or beneficiary
    String userRole = "v";
    if (role == ClientRole.Broadcaster) {
      userRole = "b";
    }

    final responseC = await http.get(
        Uri.parse(
            "https://orasee-token-server.herokuapp.com/gen_channel?id=$id&type=$userRole"),
        headers: {"Accept": "application/json"});
    String channelName = json.decode(responseC.body)["channelName"];
    print(channelName);

    final responseT = await http.get(
        Uri.parse(
            "https://orasee-token-server.herokuapp.com/access_token?channelName=$channelName&expireTime=86400"),
        headers: {"Accept": "application/json"});

    String token = json.decode(responseT.body)["token"];
    print(token);
    return [channelName, token];
  }

  Future<void> onJoin(String channel, String token) async {
    final res = await http.get(
        Uri.parse(
            "https://orasee-token-server.herokuapp.com/validate_channel?channel=$channel"),
        headers: {"Accept": "application/json"});
    bool isValid = json.decode(res.body)["is_valid"];

    // if channel has been invalidated, generate new channel
    if (!isValid) {
      getToken(_role).then((res) {
        setState(() {
          onJoin(res[0], res[1]);
        });
      });
      return;
    }

    if (channel.isNotEmpty) {
      // await for camera and mic permissions before pushing video page
      await _handleCameraAndMic(Permission.camera);
      await _handleCameraAndMic(Permission.microphone);
      // push video page with given channel name
      // ignore: use_build_context_synchronously
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallPage(
            channelName: channel,
            role: _role,
            token: token,
          ),
        ),
      );
    }
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }
}
