import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:swip_change/email_login.dart';
import 'package:swip_change/model/user_model.dart';

class EmailSetting extends StatefulWidget {
  const EmailSetting({super.key});

  @override
  State<EmailSetting> createState() => _EmailSettingState();
}

class _EmailSettingState extends State<EmailSetting> {
  final nEmailController = TextEditingController();
  final emailController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loginUser = UserModel();
  FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance.collection("users").doc(user!.uid).get().then(
          (value) => {
            this.loginUser = UserModel.fromJson(value.data()),
            setState(() {}),
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final AccountContainer = Container(
      width: width,
      height: height * 0.24,
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
              style: TextStyle(
                color: Colors.white,
              ),
              controller: nEmailController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value!.isEmpty) {
                  return ("Please Enter your Email");
                }
                // reg experssion
                if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                    .hasMatch(value)) {
                  return ("Please Enter a Vaild email");
                }

                if (value == loginUser.email) {
                  return ("Please Enter a New email");
                }

                return null;
              },
              onSaved: (value) {
                nEmailController.text = value!;
              },
              decoration: InputDecoration(
                hintText: "New Email",
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
              height: 20,
            ),
            TextFormField(
              style: TextStyle(
                color: Colors.white,
              ),
              controller: emailController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value!.isEmpty) {
                  return ("Please Enter your Email");
                }
                // reg experssion
                if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                    .hasMatch(value)) {
                  return ("Please Enter a Vaild email");
                }
                if (value != loginUser.email) {
                  return ("Please Enter your current Email");
                }
                return null;
              },
              onSaved: (value) {
                emailController.text = value!;
              },
              decoration: InputDecoration(
                hintText: "Old Email",
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
          "Change Email",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                if (nEmailController.text != emailController.text) {
                  user!.updateEmail(nEmailController.text).then((value) => {
                        FirebaseFirestore.instance
                            .collection("users")
                            .doc(user!.uid)
                            .update({"email": nEmailController.text})
                            .then((value) => {
                                  Fluttertoast.showToast(
                                      msg: "Update successful"),
                                  setState(() {}),
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EmailLoginPage(
                                              option: loginUser.options)))
                                })
                            .catchError((e) {
                              Fluttertoast.showToast(
                                  msg: "Update Error" + e.toString());
                            }),
                      });
                }
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
          child: Form(
            key: _formKey,
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
      ),
    );
  }
}
