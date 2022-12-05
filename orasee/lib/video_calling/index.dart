import 'dart:async';
import 'dart:convert';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

//import './call.dart';
import 'package:orasee/video_calling/call.dart';

class IndexPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => IndexState();
}

class IndexState extends State<IndexPage> {
  ClientRole? _role = ClientRole.Broadcaster;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agora Video Call Test Page'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: 400,
          child: Column(
            children: <Widget>[
              Column(
                children: [
                  ListTile(
                    title: const Text("Blind/Low Vision User"),
                    leading: Radio(
                      value: ClientRole.Broadcaster,
                      groupValue: _role,
                      onChanged: (ClientRole? value) {
                        setState(() {
                          _role = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text("Sighted Volunteer"),
                    leading: Radio(
                      value: ClientRole.Audience,
                      groupValue: _role,
                      onChanged: (ClientRole? value) {
                        setState(() {
                          _role = value;
                        });
                      },
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => {
                          getToken(_role).then((res) {
                            setState(() {
                              onJoin(res[0], res[1]);
                            });
                          })
                        },
                        child: Text('Join Call'),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blueAccent),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white)),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
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
