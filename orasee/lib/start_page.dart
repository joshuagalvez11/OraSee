import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:orasee/home.dart';
import 'package:orasee/email_login.dart';
import 'package:orasee/login_phone/phone_login_page.dart';
import 'package:orasee/model/user_model.dart';

class StartPage extends StatefulWidget {
  final String option;
  final bool? logOut;
  StartPage({super.key, required this.option, required this.logOut});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String email = '';
  String name = '';
  // facebook sign in
  Map<String, dynamic>? _userData;
  AccessToken? _accessToken;

  _login() async {
    final LoginResult result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success) {
      _accessToken = result.accessToken;

      final userData = await FacebookAuth.instance.getUserData();
      _userData = userData;

      print(_userData);
    } else {
      print(result.status);
      print(result.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Column(
            children: [
              (widget.logOut == true)
                  ? Container()
                  : Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(Icons.arrow_back),
                          color: Color(0xff381BE9),
                        ),
                        Text(
                          "back",
                          style: TextStyle(
                            color: Color(0xff381BE9),
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
              SizedBox(
                height: height * 0.1,
              ),
              Text(
                "Get Started",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: height * 0.1,
              ),
              Column(
                children: [
                  SizedBox(
                    width: width,
                    height: height * 0.1,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF381BE9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          )),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return EmailLoginPage(
                            option: widget.option,
                          );
                        }));
                      },
                      child: Text(
                        "Continue with Email",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: width,
                    height: height * 0.1,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          )),
                      onPressed: () {
                        SignInWithGoogle();
                      },
                      child: Text(
                        "Continue with Google",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: width,
                    height: height * 0.1,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          )),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PhoneLoginPage(
                                      option: widget.option,
                                    )));
                      },
                      child: Text(
                        "Continue with Phone",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: width,
                    height: height * 0.1,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF381BE9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          )),
                      onPressed: () {
                        signInWithFacebook();
                      },
                      child: Text(
                        "Continue with FaceBook",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void SignInWithGoogle() async {
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn(scopes: <String>['email']).signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    await _auth
        .signInWithCredential(credential)
        .then((uid) => {
              postDetailsToFirestore(),
            })
        .catchError((e) {
      Fluttertoast.showToast(msg: "Something Went Wrong" + e!.toString());
    });
  }

  void signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance
        .login(permissions: ['email', 'public_profile', 'user_birthday']);

    if (loginResult.status == LoginStatus.success) {
      final AuthCredential facebookCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      final userData = await FacebookAuth.instance.getUserData();
      _userData = userData;

      name = _userData!['name'];
      email = _userData!['email'];

      await _auth
          .signInWithCredential(facebookCredential)
          .then((uid) => {FacebookPostDetailsToFirestore()})
          .catchError((e) {
        print(e.toString());
      });

      print(name);
      print(email);
    } else {
      print(loginResult.status);
      print(loginResult.message);
    }
  }

  postDetailsToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    final Name = user?.displayName?.split(" ");
    final firstname = Name![0];
    final lastname = Name[1];

    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.firstName = firstname;
    userModel.lastName = lastname;
    userModel.options = widget.option;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toJson());

    Fluttertoast.showToast(msg: "Account Create Successful");

    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => HomePage()), (route) => false);
  }

  FacebookPostDetailsToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    final Name = name.split(" ");
    final firstname = Name[0];
    final lastname = Name[1];

    userModel.email = email;
    userModel.uid = user!.uid;
    userModel.firstName = firstname;
    userModel.lastName = lastname;
    userModel.options = widget.option;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toJson());

    Fluttertoast.showToast(msg: "Account Create Successful");

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }
}
