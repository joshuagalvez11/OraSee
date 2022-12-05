import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:orasee/email_login.dart';

class PasswordSetting extends StatefulWidget {
  const PasswordSetting({super.key});

  @override
  State<PasswordSetting> createState() => _PasswordSettingState();
}

class _PasswordSettingState extends State<PasswordSetting> {
  User? user = FirebaseAuth.instance.currentUser;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final cPasswordController = TextEditingController();
  final nPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final AccountContainer = Container(
      width: width,
      height: height * 0.2,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 8.0, top: 8),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            TextFormField(
              obscureText: true,
              controller: cPasswordController,
              textInputAction: TextInputAction.next,
              // validator: (){},
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: "Current Password",
                hintStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white70,
                    width: 2,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              obscureText: true,
              controller: nPasswordController,
              textInputAction: TextInputAction.done,
              // validator: (){},
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: "New Password",
                hintStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white70,
                    width: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Color(0xff381BE9),
        ),
        title: Text(
          "Change Password",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () async {
              if (cPasswordController.value.text.isNotEmpty &&
                  nPasswordController.value.text.isNotEmpty) {
                user!
                    .updatePassword(nPasswordController.text)
                    .then((value) => {
                          Fluttertoast.showToast(msg: "Update successful"),
                          _auth.signOut(),
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EmailLoginPage(option: "")))
                        })
                    .catchError((onError) {
                  Fluttertoast.showToast(
                      msg: "Something went wrong ${onError}");
                });
              }
            },
            child: Text(
              "Save",
              style: TextStyle(
                color: Color(0xff381BE9),
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(
                height: height * 0.03,
              ),
              AccountContainer,
            ],
          ),
        ),
      ),
    );
  }
}
